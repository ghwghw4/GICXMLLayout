import { isObject } from '../util/index';
import { observe } from '../observe/Observer';
import Watcher from '../observe/Watcher';

/**
 * 对任意对象添加$watch 扩展
 * @param key
 * @param cb
 * @returns {Watcher}
 */
Object.prototype.$watch = function (key, cb) {
  return new Watcher(this, key, cb);
};

/**
 * 将array 转换成for指令
 * @param forTarget
 */
Array.prototype.toForDirector = function (forTarget) {
  for (let i = 0; i < this.length; i++) {
    forTarget.addItem(this[i], i);
  }
  // 监听数据改变事件
  const ob = observe(this);
  const a = this.$watch('arrarchanged', (methodname, args) => {
    switch (methodname) {
      case 'push':
        args.forEach((item) => {
          forTarget.addItem(item);
        });
        break;
      case 'unshift':// 向数组的开头添加一个或更多元素
        args.forEach((item) => {
          forTarget.insertItem(item);
        });
        break;
      case 'shift':// 删除数组的第一个元素
        forTarget.deleteItem(0, 1);
        break;
      case 'pop': // 删除数组的最后一个元素
        forTarget.deleteItem(this.length, 1);// 这里index 直接写length，因为已经将数据删除过了，而native还没有删除
        break;
      case 'reverse': // 反转数组
      case 'sort':// 对数组进行排序
        forTarget.deleteAllItems();// 先删除所有的数据，然后再重新创建数据。
        for (let i = 0; i < this.length; i++) {
          forTarget.addItem(this[i]);
        }
        break;
      case 'splice': {
        const startIndex = args[0];
        const count = args[1];
        // step 1 先处理删除
        if (count > 0) { // 删除items
          forTarget.deleteItem(startIndex, count);
        }
        // step2 处理插入
        if (args.length > 2) {
          for (let i = 2; i < args.length; i++) {
            forTarget.insertItem(args[i]);
          }
        }
        break;
      }
      default:
        break;
    }
  });
  a.addDep(ob.dep);
};


/**
 * 添加元素数据绑定
 * @param obj
 * @param bindExp 绑定到某个属性
 * @param cbName
 * @returns {Watcher}
 */
Object.prototype.addElementBind = function (obj, bindExp, cbName) {
  observe(this);
  // 主要是用来判断哪些属性需要做监听
  Object.keys(this).forEach((key) => {
    if (bindExp.indexOf(key) >= 0) {
      let watchers = obj.__watchers__;
      if (!watchers) {
        watchers = [];
        obj.__watchers__ = watchers;
      }

      let hasW = false;
      watchers.forEach((w) => {
        if (w.expOrFn === key) {
          hasW = true;
        }
      });

      if (!hasW) {
        const watcher = new Watcher(this, key, () => {
          obj[cbName](this);
        });
        watchers.push(watcher);
      }

      // check path
      const value = this[key];
      if (isObject(value)) {
        value.addElementBind(obj, bindExp, cbName);
      }
    }
  });
};

/**
 * 执行绑定表达式(主要是为了解决在表达式中没有添加this，无法访问属性的问题。这个问题其实也可以通过后期编译的方式来解决，类似vue的做法，但是暂时先这样吧。)
 * 这样做可能会有性能问题，但是问题不大。
 * @param expStr 表达式
 * @param selfElement 方法内部this 指针指向的对象
 */
Object.prototype.executeBindExpression = function (expStr, selfElement) {
  /**
   * if($item.__index__) var $index = $item.__index__(); 这行代码其实是有问题的。应该说是利用了var 变量的一个小漏洞。
   * 实际的开发过程中不应该这么使用
   */
  let jsStr = 'var $item = arguments[0]; if($item.__index__) var $index = $item.__index__();var $el = arguments[1];';
  if (isObject(this)) {
    Object.keys(this).forEach((key) => {
      jsStr += `var ${key}=$item.${key};`;
    });
  }
  jsStr += expStr;
  if (!selfElement) { selfElement = this; }
  return (new Function(jsStr)).call(__rootDataContext__, this, selfElement);
};

/**
 * 提供给普通绑定用的，数据源为native数据源
 * @param props
 * @param expStr
 * @returns {*}
 */
Object.prototype.executeBindExpression2 = function (props, expStr) {
  let jsStr = '';
  props.forEach((key) => {
    jsStr += `var ${key}=this.${key};`;
  });
  jsStr += expStr;
  return (new Function(jsStr)).call(this);
};

export function Binding() {
}