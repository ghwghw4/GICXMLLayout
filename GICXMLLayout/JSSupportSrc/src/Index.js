import Watcher from './observe/Watcher';
import { observe } from './observe/Observer';
import { isObject } from './util/index';

/**
 * 首字母转大写
 * @param strO
 * @returns {string}
 * @private
 */
function capitalizedString(strO) {
  const str = strO.toLowerCase();
  const reg = /\b(\w)|\s(\w)/g; //  \b判断边界\s判断空格
  return str.replace(reg, m => m.toUpperCase());
}

/**
 * 元素的属性名称转对象的属性名，驼峰命名
 * @param attName
 * @returns {*}
 * @private
 */
function elAttributeNameToPropertyName(attName) {
  const strs = attName.split('-');
  let pName = strs[0];
  for (let i = 1; i < strs.length; i++) {
    pName += capitalizedString(strs[i]);
  }
  return pName;
}


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
 * 判断对象是否是数组
 * @returns {boolean}
 */
Object.prototype.isArray = function () {
  return this instanceof Array;
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
  const a = this.$watch(null, (methodname, args) => {
    switch (methodname) {
      case 'push':
        args.forEach((item) => {
          forTarget.addItem(args, this.indexOf(item));
        });
        break;
      case 'unshift':// 向数组的开头添加一个或更多元素
        // TODO:暂不支持插入
        break;
      case 'shift':// 删除数组的第一个元素
        forTarget.deleteItemWithIndex(0);
        break;
      case 'pop': // 删除数组的最后一个元素
        forTarget.deleteItemWithIndex(this.length);// 这里index 直接写length，因为已经将数据删除过了，而native还没有删除
        break;
      case 'reverse': // 反转数组
      case 'sort':// 对数组进行排序
        forTarget.deleteAllItems();// 先删除所有的数据，然后再重新创建数据。
        for (let i = 0; i < this.length; i++) {
          forTarget.addItem(this[i], i);
        }
        break;
      case 'splice': {
        const startIndex = args[0];
        const count = args[1];
        // const insertedItems = args[2];
        if (count > 0) { // 删除items
          if (startIndex >= 0) { // 从前往后删
            for (let i = 0; i < count; i++) {
              forTarget.deleteItemWithIndex(startIndex);
            }
          } else { // 从后往前删
            // TODO: 暂不支持.
          }
        } else if (count === 0) { // 添加items
          // TODO:插入不支持
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
      new Watcher(this, key, () => {
        obj[cbName](this);
      });
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
  let jsStr = 'var dataContext = arguments[0];';
  if (isObject(this)) {
    Object.keys(this).forEach((key) => {
      jsStr += `var ${key}=dataContext.${key};`;
    });
  }
  jsStr += expStr;
  if (!selfElement) { selfElement = this; }
  return (new Function(jsStr)).call(selfElement, this);
};

/**
 * 在某个对象上执行动态脚本
 * @param script
 * @returns {*}
 */
Object.prototype.executeScript = function (script) {
  return (new Function(script)).call(this);
};

/**
 * 初始化元素
 * @param ps
 * @returns {*}
 * @private
 */
Object.prototype._elementInit = function (ps) {
  const obj = this;
  // 1.属性
  ps.split(',').forEach((key) => {
    const propertyName = elAttributeNameToPropertyName(key);
    if (propertyName !== 'dataContext') {
      Object.defineProperty(obj, propertyName, {
        get() {
          return this.getAttValue(key);
        },
        set(val) {
          this.setAttValue(key, val);
        },
      });
    }
  });
  // 2.事件
  // 点击事件
  Object.defineProperty(obj, 'onclick', {
    get() {
      return this._onClick;
    },
    set(val) {
      this._onClick = val;
      this.setEvent('event-tap', val);
    },
  });
  // 触摸移动事件
  Object.defineProperty(obj, 'onmove', {
    get() {
      return this._onmove;
    },
    set(val) {
      this._onmove = val;
      this.setEvent('event-touch-move', val);
    },
  });
  // 添加其他属性
  Object.defineProperty(obj, 'super', {
    get() {
      return this.getSuperElement();
    },
  });
};
// 为string 添加扩展函数，主要用来做属性转换

/**
 * 转成int
 * @returns {Number}
 */
String.prototype.toInt = function () {
  return parseInt(this, 0);
};

/**
 * 转成float
 * @returns {Number}
 */
String.prototype.toFloat = function () {
  return parseFloat(this);
};


String.prototype.toColor = function () {
  const reg = /^#([0-9a-fA-f]{3}|[0-9a-fA-f]{6})$/;
  let sColor = this.toLowerCase();
  if (sColor && reg.test(sColor)) {
    if (sColor.length === 4) {
      let sColorNew = '#';
      for (let i = 1; i < 4; i += 1) {
        sColorNew += sColor.slice(i, i + 1).concat(sColor.slice(i, i + 1));
      }
      sColor = sColorNew;
    }
    // 处理六位的颜色值
    const sColorChange = [];
    for (let i = 1; i < 7; i += 2) {
      sColorChange.push(parseInt(`0x${sColor.slice(i, i + 2)}`, 0));
    }
    return `RGB(${sColorChange.join(',')})`;
  }
  return sColor;
};
export default GIC;