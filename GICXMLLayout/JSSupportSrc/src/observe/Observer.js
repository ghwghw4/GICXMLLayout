import Dep from './Dep';

/**
 * 属性监听者
 */
class Observer {
  get data() {
    return this._data;
  }
  constructor(data) {
    this._data = data;
    this._walk(data);
  }

  _walk(data) {
    const me = this;
    Object.keys(data).forEach((key) => {
      me.convert(key, data[key]);
    });
  }

  convert(key, val) {
    Observer.defineReactive(this.data, key, val);
  }

  static defineReactive(data, key, val) {
    const dep = new Dep();
    // let childObj = Observer.observe(val);

    Object.defineProperty(data, key, {
      enumerable: true, // 可枚举
      configurable: false, // 不能再define
      get() {
        if (Dep.target) {
          dep.depend();
        }
        return val;
      },
      set(newVal) {
        if (newVal === val) {
          return;
        }
        val = newVal;
        // 新的值是object的话，进行监听
        // childObj = Observer.observe(newVal);
        // 通知订阅者
        dep.notify();
      },
    });
  }

  static observe(value) {
    if (!value || typeof value !== 'object') {
      return;
    }

    return new Observer(value);
  }
}

export default Observer;