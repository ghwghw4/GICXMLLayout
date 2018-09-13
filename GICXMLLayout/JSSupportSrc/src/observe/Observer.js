import Dep from './Dep';
import { arrayMethods } from './Array';
import { def, hasProto, hasOwn, isPlainObject, isObject } from '../util/index';

const arrayKeys = Object.getOwnPropertyNames(arrayMethods);

/**
 * Augment an target Object or Array by intercepting
 * the prototype chain using __proto__
 */
function protoAugment(target, src) {
  /* eslint-disable no-proto */
  target.__proto__ = src;
}

/**
 * Augment an target Object or Array by defining
 * hidden properties.
 */
/* istanbul ignore next */
function copyAugment(target, src, keys) {
  for (let i = 0, l = keys.length; i < l; i++) {
    const key = keys[i];
    def(target, key, src[key]);
  }
}

/**
 * Collect dependencies on array elements when the array is touched, since
 * we cannot intercept array element access like property getters.
 */
function dependArray(value) {
  for (let e, i = 0, l = value.length; i < l; i++) {
    e = value[i];
    e && e.__ob__ && e.__ob__.dep.depend();
    if (Array.isArray(e)) {
      dependArray(e);
    }
  }
}

function defineReactive(data, key, val, customSetter, shallow) {
  const dep = new Dep();

  const property = Object.getOwnPropertyDescriptor(data, key);
  if (property && property.configurable === false) {
    return;
  }

  // cater for pre-defined getter/setters
  const getter = property && property.get;
  const setter = property && property.set;
  if ((!getter || setter) && arguments.length === 2) {
    val = data[key];
  }


  let childObj = !shallow && observe(val);

  Object.defineProperty(data, key, {
    enumerable: true, // 可枚举
    configurable: false, // 不能再define
    get() {
      const value = getter ? getter.call(data) : val;
      if (Dep.target) {
        if (childObj) {
          childObj.dep.depend();
          if (Array.isArray(value)) {
            dependArray(value);
          }
        }
        dep.depend();
      }
      return value;
    },
    set(newVal) {
      const value = getter ? getter.call(data) : val;
      if (newVal === value || (newVal !== newVal && value !== value)) {
        return;
      }

      if (setter) {
        setter.call(data, newVal);
      } else {
        val = newVal;
      }
      childObj = !shallow && observe(newVal);
      dep.notify();
    },
  });
}


export const shouldObserve = true;
/**
 * 属性监听者
 */
export class Observer {
  get data() {
    return this._data;
  }
  constructor(value) {
    this._data = value;
    this.dep = new Dep();
    this.vmCount = 0;
    def(value, '__ob__', this);

    if (Array.isArray(value)) {
      const augment = hasProto
        ? protoAugment
        : copyAugment;
      augment(value, arrayMethods, arrayKeys);
      this.observeArray(value);
    } else {
      this._walk(value);
    }
  }

  _walk(data) {
    const me = this;
    Object.keys(data).forEach((key) => {
      me.convert(key, data[key]);
    });
  }

  convert(key, val) {
    defineReactive(this.data, key, val);
  }

  /**
   * Observe a list of Array items.
   */
  observeArray(items) {
    for (let i = 0, l = items.length; i < l; i++) {
      observe(items[i]);
    }
  }
}

/**
 * 已经做了去重复observe的处理了
 * @param value
 * @param asRootData
 * @returns {*}
 */
export function observe(value, asRootData) {
  if (!isObject(value)) {
    return;
  }
  let ob;
  if (hasOwn(value, '__ob__') && value.__ob__ instanceof Observer) {
    ob = value.__ob__;
  } else if (
    shouldObserve &&
      (Array.isArray(value) || isPlainObject(value)) &&
      Object.isExtensible(value)
  ) {
    ob = new Observer(value);
  }
  if (asRootData && ob) {
    ob.vmCount++;
  }
  return ob;
}