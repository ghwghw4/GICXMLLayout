import Watcher from './observe/Watcher';
import Observer from './observe/Observer';

class GIC {
  static Test() {
    const data = { name: { bbb: 10 }, bbb: '10' };
    Observer.observe(data);
    const a = new Watcher(data, 'name.bbb', (name) => {
      console.log(`nnnnn${name}`);
    });
    console.log(a);
    data.name.bbb = 10;
  }
  /**
   * 元素初始化
   * 1. 动态添加obj的getter 、setter 方法
   * @param obj
   * @param ps
   * @returns {*}
   * @private
   */
  static _elementInit(obj, ps) {
    // 1.属性
    ps.split(',').forEach((key) => {
      const propertyName = this._elAttributeNameToPropertyName(key);
      Object.defineProperty(obj, propertyName, {
        get() {
          return this.getAttValue(key);
        },
        set(val) {
          this.setAttValue(key, val);
        },
      });
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
  }

  /**
   * 首字母转大写
   * @param strO
   * @returns {string}
   * @private
   */
  static _capitalizedString(strO) {
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
  static _elAttributeNameToPropertyName(attName) {
    const strs = attName.split('-');
    let pName = strs[0];
    for (let i = 1; i < strs.length; i++) {
      pName += this._capitalizedString(strs[i]);
    }
    return pName;
  }
}

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

window.GIC = GIC;
export default GIC;