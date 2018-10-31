/******/ (function(modules) { // webpackBootstrap
/******/ 	// The module cache
/******/ 	var installedModules = {};
/******/
/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {
/******/
/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId]) {
/******/ 			return installedModules[moduleId].exports;
/******/ 		}
/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			i: moduleId,
/******/ 			l: false,
/******/ 			exports: {}
/******/ 		};
/******/
/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);
/******/
/******/ 		// Flag the module as loaded
/******/ 		module.l = true;
/******/
/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}
/******/
/******/
/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;
/******/
/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;
/******/
/******/ 	// define getter function for harmony exports
/******/ 	__webpack_require__.d = function(exports, name, getter) {
/******/ 		if(!__webpack_require__.o(exports, name)) {
/******/ 			Object.defineProperty(exports, name, {
/******/ 				configurable: false,
/******/ 				enumerable: true,
/******/ 				get: getter
/******/ 			});
/******/ 		}
/******/ 	};
/******/
/******/ 	// getDefaultExport function for compatibility with non-harmony modules
/******/ 	__webpack_require__.n = function(module) {
/******/ 		var getter = module && module.__esModule ?
/******/ 			function getDefault() { return module['default']; } :
/******/ 			function getModuleExports() { return module; };
/******/ 		__webpack_require__.d(getter, 'a', getter);
/******/ 		return getter;
/******/ 	};
/******/
/******/ 	// Object.prototype.hasOwnProperty.call
/******/ 	__webpack_require__.o = function(object, property) { return Object.prototype.hasOwnProperty.call(object, property); };
/******/
/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "";
/******/
/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(__webpack_require__.s = 2);
/******/ })
/************************************************************************/
/******/ ([
/* 0 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});

var _typeof = typeof Symbol === "function" && typeof Symbol.iterator === "symbol" ? function (obj) { return typeof obj; } : function (obj) { return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; };

exports.def = def;
exports.isReserved = isReserved;
exports.hasOwn = hasOwn;
exports.isPlainObject = isPlainObject;
exports.isObject = isObject;
/**
 * Define a property.
 */
function def(obj, key, val, enumerable) {
  Object.defineProperty(obj, key, {
    value: val,
    enumerable: !!enumerable,
    writable: true,
    configurable: true
  });
}

var hasProto = exports.hasProto = '__proto__' in {};

function isReserved(str) {
  var c = ('' + str).charCodeAt(0);
  return c === 0x24 || c === 0x5F;
}

var hasOwnProperty = Object.prototype.hasOwnProperty;
function hasOwn(obj, key) {
  return hasOwnProperty.call(obj, key);
}

/**
 * Get the raw type string of a value e.g. [object Object]
 */
var _toString = Object.prototype.toString;
/**
 * Strict object type check. Only returns true
 * for plain JavaScript objects.
 */
function isPlainObject(obj) {
  return _toString.call(obj) === '[object Object]';
}

/**
 * Quick object check - this is primarily used to tell
 * Objects from primitive values when we know the value
 * is a JSON-compliant type.
 */
function isObject(obj) {
  return obj !== null && (typeof obj === 'undefined' ? 'undefined' : _typeof(obj)) === 'object';
}

/***/ }),
/* 1 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});

var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

/**
 * 属性订阅器
 */
var Dep = function () {
  _createClass(Dep, [{
    key: "subs",

    /**
     *
     * @returns {Array.<Watcher>}
     */
    get: function get() {
      return this._subs;
    }
  }, {
    key: "id",
    get: function get() {
      return this._id;
    }
  }]);

  function Dep() {
    _classCallCheck(this, Dep);

    this._id = Dep.uid++;
    this._subs = [];
  }

  /**
   *
   * @param { Watcher }sub
   */


  _createClass(Dep, [{
    key: "addSub",
    value: function addSub(sub) {
      this.subs.push(sub);
    }
  }, {
    key: "depend",
    value: function depend() {
      if (Dep.target) {
        Dep.target.addDep(this);
      }
    }
  }, {
    key: "removeSub",
    value: function removeSub(sub) {
      var index = this.subs.indexOf(sub);
      if (index !== -1) {
        this.subs.splice(index, 1);
      }
    }
  }, {
    key: "notify",
    value: function notify() {
      var subs = this.subs.slice();
      for (var i = 0, l = subs.length; i < l; i++) {
        subs[i].update();
      }
    }
  }]);

  return Dep;
}();

Dep.uid = 0;
Dep.target = null;
exports.default = Dep;

/***/ }),
/* 2 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});

var _string = __webpack_require__(3);

Object.keys(_string).forEach(function (key) {
  if (key === "default" || key === "__esModule") return;
  Object.defineProperty(exports, key, {
    enumerable: true,
    get: function get() {
      return _string[key];
    }
  });
});

var _object = __webpack_require__(4);

Object.keys(_object).forEach(function (key) {
  if (key === "default" || key === "__esModule") return;
  Object.defineProperty(exports, key, {
    enumerable: true,
    get: function get() {
      return _object[key];
    }
  });
});

var _element = __webpack_require__(5);

Object.keys(_element).forEach(function (key) {
  if (key === "default" || key === "__esModule") return;
  Object.defineProperty(exports, key, {
    enumerable: true,
    get: function get() {
      return _element[key];
    }
  });
});

var _binding = __webpack_require__(6);

Object.keys(_binding).forEach(function (key) {
  if (key === "default" || key === "__esModule") return;
  Object.defineProperty(exports, key, {
    enumerable: true,
    get: function get() {
      return _binding[key];
    }
  });
});

/***/ }),
/* 3 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


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
  var reg = /^#([0-9a-fA-f]{3}|[0-9a-fA-f]{6})$/;
  var sColor = this.toLowerCase();
  if (sColor && reg.test(sColor)) {
    if (sColor.length === 4) {
      var sColorNew = '#';
      for (var i = 1; i < 4; i += 1) {
        sColorNew += sColor.slice(i, i + 1).concat(sColor.slice(i, i + 1));
      }
      sColor = sColorNew;
    }
    // 处理六位的颜色值
    var sColorChange = [];
    for (var _i = 1; _i < 7; _i += 2) {
      sColorChange.push(parseInt('0x' + sColor.slice(_i, _i + 2), 0));
    }
    return 'RGB(' + sColorChange.join(',') + ')';
  }
  return sColor;
};

/***/ }),
/* 4 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


/**
 * 在某个对象上执行动态脚本
 * @param script
 * @returns {*}
 */
Object.prototype.executeScript = function (script, value1, value2) {
  return new Function(script).call(this, value1, value2);
};

/**
 * 判断对象是否是数组
 * @returns {boolean}
 */
Object.prototype.isArray = function () {
  return this instanceof Array;
};

/***/ }),
/* 5 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


/**
 * 首字母转大写
 * @param strO
 * @returns {string}
 * @private
 */
function capitalizedString(strO) {
  var str = strO.toLowerCase();
  var reg = /\b(\w)|\s(\w)/g; //  \b判断边界\s判断空格
  return str.replace(reg, function (m) {
    return m.toUpperCase();
  });
}

/**
 * 元素的属性名称转对象的属性名，驼峰命名
 * @param attName
 * @returns {*}
 * @private
 */
function elAttributeNameToPropertyName(attName) {
  var strs = attName.split('-');
  var pName = strs[0];
  for (var i = 1; i < strs.length; i++) {
    pName += capitalizedString(strs[i]);
  }
  return pName;
}

/**
 * 初始化元素
 * @param props
 * @returns {*}
 * @private
 */
Object.prototype._elementInit = function (props) {
  if (this.__hasInit__) {
    console.log('inited');return false;
  }
  this.__hasInit__ = true;
  var obj = this;
  // 1.属性
  props.forEach(function (key) {
    var propertyName = elAttributeNameToPropertyName(key);
    if (propertyName !== 'dataContext') {
      Object.defineProperty(obj, propertyName, {
        get: function get() {
          return this.getAttValue(key);
        },
        set: function set(val) {
          this.setAttValue(key, val);
        }
      });
    }
  });
  // 2.事件
  // 点击事件
  Object.defineProperty(obj, 'onclick', {
    get: function get() {
      return this._onClick;
    },
    set: function set(val) {
      this._onClick = val;
      this.setEvent('event-tap', val);
    }
  });
  // 触摸移动事件
  Object.defineProperty(obj, 'onmove', {
    get: function get() {
      return this._onmove;
    },
    set: function set(val) {
      this._onmove = val;
      this.setEvent('event-touch-move', val);
    }
  });
  // 添加其他属性
  Object.defineProperty(obj, 'super', {
    get: function get() {
      return this.getSuperElement();
    }
  });
  return true;
};

// 提供给普通绑定作为数据源用的，主要是native的数据源转换而来
Object.prototype._elementInit2 = function (props) {
  var obj = this;
  // 1.属性
  props.forEach(function (key) {
    Object.defineProperty(obj, key, {
      get: function get() {
        return this.getAttValue(key);
      },
      set: function set(val) {
        this.setAttValue(key, val);
      }
    });
  });
};

/***/ }),
/* 6 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.Binding = Binding;

var _index = __webpack_require__(0);

var _Observer = __webpack_require__(7);

var _Watcher = __webpack_require__(9);

var _Watcher2 = _interopRequireDefault(_Watcher);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

/**
 * 对任意对象添加$watch 扩展
 * @param key
 * @param cb
 * @returns {Watcher}
 */
Object.prototype.$watch = function (key, cb) {
  return new _Watcher2.default(this, key, cb);
};

/**
 * 将array 转换成for指令
 * @param forTarget
 */
Array.prototype.toForDirector = function (forTarget) {
  var _this = this;

  for (var i = 0; i < this.length; i++) {
    forTarget.addItem(this[i], i);
  }
  // 监听数据改变事件
  var ob = (0, _Observer.observe)(this);
  var a = this.$watch('arrarchanged', function (methodname, args) {
    switch (methodname) {
      case 'push':
        args.forEach(function (item) {
          forTarget.addItem(item, _this.indexOf(item));
        });
        break;
      case 'unshift':
        // 向数组的开头添加一个或更多元素
        // TODO:暂不支持插入
        break;
      case 'shift':
        // 删除数组的第一个元素
        forTarget.deleteItemWithIndex(0);
        break;
      case 'pop':
        // 删除数组的最后一个元素
        forTarget.deleteItemWithIndex(_this.length); // 这里index 直接写length，因为已经将数据删除过了，而native还没有删除
        break;
      case 'reverse': // 反转数组
      case 'sort':
        // 对数组进行排序
        forTarget.deleteAllItems(); // 先删除所有的数据，然后再重新创建数据。
        for (var _i = 0; _i < _this.length; _i++) {
          forTarget.addItem(_this[_i], _i);
        }
        break;
      case 'splice':
        {
          var startIndex = args[0];
          var count = args[1];
          // const insertedItems = args[2];
          if (count > 0) {
            // 删除items
            if (startIndex >= 0) {
              // 从前往后删
              for (var _i2 = 0; _i2 < count; _i2++) {
                forTarget.deleteItemWithIndex(startIndex);
              }
            } else {// 从后往前删
              // TODO: 暂不支持.
            }
          } else if (count === 0) {// 添加items
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
  var _this2 = this;

  (0, _Observer.observe)(this);
  // 主要是用来判断哪些属性需要做监听
  Object.keys(this).forEach(function (key) {
    if (bindExp.indexOf(key) >= 0) {
      var watchers = obj.__watchers__;
      if (!watchers) {
        watchers = [];
        obj.__watchers__ = watchers;
      }

      var hasW = false;
      watchers.forEach(function (w) {
        if (w.expOrFn === key) {
          hasW = true;
        }
      });

      if (!hasW) {
        var watcher = new _Watcher2.default(_this2, key, function () {
          obj[cbName](_this2);
        });
        watchers.push(watcher);
      }

      // check path
      var value = _this2[key];
      if ((0, _index.isObject)(value)) {
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
  var jsStr = 'var dataContext = arguments[0];';
  if ((0, _index.isObject)(this)) {
    Object.keys(this).forEach(function (key) {
      jsStr += 'var ' + key + '=dataContext.' + key + ';';
    });
  }
  jsStr += expStr;
  if (!selfElement) {
    selfElement = this;
  }
  return new Function(jsStr).call(selfElement, this);
};

/**
 * 提供给普通绑定用的，数据源为native数据源
 * @param props
 * @param expStr
 * @returns {*}
 */
Object.prototype.executeBindExpression2 = function (props, expStr) {
  var jsStr = '';
  props.forEach(function (key) {
    jsStr += 'var ' + key + '=this.' + key + ';';
  });
  jsStr += expStr;
  return new Function(jsStr).call(this);
};

function Binding() {}

/***/ }),
/* 7 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.Observer = exports.shouldObserve = undefined;

var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

exports.observe = observe;

var _Dep = __webpack_require__(1);

var _Dep2 = _interopRequireDefault(_Dep);

var _Array = __webpack_require__(8);

var _index = __webpack_require__(0);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

var arrayKeys = Object.getOwnPropertyNames(_Array.arrayMethods);

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
  for (var i = 0, l = keys.length; i < l; i++) {
    var key = keys[i];
    (0, _index.def)(target, key, src[key]);
  }
}

/**
 * Collect dependencies on array elements when the array is touched, since
 * we cannot intercept array element access like property getters.
 */
function dependArray(value) {
  for (var e, i = 0, l = value.length; i < l; i++) {
    e = value[i];
    e && e.__ob__ && e.__ob__.dep.depend();
    if (Array.isArray(e)) {
      dependArray(e);
    }
  }
}

function defineReactive(data, key, val, customSetter, shallow) {
  var dep = new _Dep2.default();

  var property = Object.getOwnPropertyDescriptor(data, key);
  if (property && property.configurable === false) {
    return;
  }

  // cater for pre-defined getter/setters
  var getter = property && property.get;
  var setter = property && property.set;
  if ((!getter || setter) && arguments.length === 2) {
    val = data[key];
  }

  var childObj = !shallow && observe(val);

  Object.defineProperty(data, key, {
    enumerable: true, // 可枚举
    configurable: false, // 不能再define
    get: function get() {
      var value = getter ? getter.call(data) : val;
      if (_Dep2.default.target) {
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
    set: function set(newVal) {
      var value = getter ? getter.call(data) : val;
      if (newVal === value || newVal !== newVal && value !== value) {
        return;
      }

      if (setter) {
        setter.call(data, newVal);
      } else {
        val = newVal;
      }
      childObj = !shallow && observe(newVal);
      dep.notify();
    }
  });
}

var shouldObserve = exports.shouldObserve = true;
/**
 * 属性监听者
 */

var Observer = exports.Observer = function () {
  _createClass(Observer, [{
    key: 'data',
    get: function get() {
      return this._data;
    }
  }]);

  function Observer(value) {
    _classCallCheck(this, Observer);

    this._data = value;
    this.dep = new _Dep2.default();
    this.vmCount = 0;
    (0, _index.def)(value, '__ob__', this);

    if (Array.isArray(value)) {
      var augment = _index.hasProto ? protoAugment : copyAugment;
      augment(value, _Array.arrayMethods, arrayKeys);
      this.observeArray(value);
    } else {
      this._walk(value);
    }
  }

  _createClass(Observer, [{
    key: '_walk',
    value: function _walk(data) {
      var me = this;
      Object.keys(data).forEach(function (key) {
        me.convert(key, data[key]);
      });
    }
  }, {
    key: 'convert',
    value: function convert(key, val) {
      defineReactive(this.data, key, val);
    }

    /**
     * Observe a list of Array items.
     */

  }, {
    key: 'observeArray',
    value: function observeArray(items) {
      for (var i = 0, l = items.length; i < l; i++) {
        observe(items[i]);
      }
    }
  }]);

  return Observer;
}();

/**
 * 已经做了去重复observe的处理了
 * @param value
 * @param asRootData
 * @returns {*}
 */


function observe(value, asRootData) {
  if (!(0, _index.isObject)(value)) {
    return;
  }
  var ob = void 0;
  if ((0, _index.hasOwn)(value, '__ob__') && value.__ob__ instanceof Observer) {
    ob = value.__ob__;
  } else if (shouldObserve && (Array.isArray(value) || (0, _index.isPlainObject)(value)) && Object.isExtensible(value)) {
    ob = new Observer(value);
  }
  if (asRootData && ob) {
    ob.vmCount++;
  }
  return ob;
}

/***/ }),
/* 8 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.arrayMethods = undefined;

var _index = __webpack_require__(0);

var arrayProto = Array.prototype;
var arrayMethods = exports.arrayMethods = Object.create(arrayProto);

var methodsToPatch = ['push', 'pop', 'shift', 'unshift', 'splice', 'sort', 'reverse'];

methodsToPatch.forEach(function (method) {
  // cache original method
  var original = arrayProto[method];
  (0, _index.def)(arrayMethods, method, function mutator() {
    for (var _len = arguments.length, args = Array(_len), _key = 0; _key < _len; _key++) {
      args[_key] = arguments[_key];
    }

    var result = original.apply(this, args);
    var ob = this.__ob__;
    var inserted = void 0;
    switch (method) {
      case 'push':
      case 'unshift':
        inserted = args;
        break;
      case 'splice':
        inserted = args[2];
        break;
      default:
        break;
    }
    if (inserted) ob.observeArray(inserted);
    // notify change
    // ob.dep.notify(method, args);
    var subs = ob.dep.subs.slice();
    for (var i = 0, l = subs.length; i < l; i++) {
      var sub = subs[i];
      if (sub.expOrFn === 'arrarchanged') {
        sub.cb(method, args);
      }
    }
    return result;
  });
});

/***/ }),
/* 9 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});

var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

var _Dep = __webpack_require__(1);

var _Dep2 = _interopRequireDefault(_Dep);

var _index = __webpack_require__(0);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

/**
 * 属性观察者
 */
var Watcher = function () {
  function Watcher(vm, expOrFn, cb) {
    _classCallCheck(this, Watcher);

    this.cb = cb;
    this.vm = vm;
    this.expOrFn = expOrFn;
    this.depIds = {};

    if (typeof expOrFn === 'function') {
      this.getter = expOrFn;
    } else {
      this.getter = Watcher.parseGetter(expOrFn);
    }

    this.value = this.get();
  }

  _createClass(Watcher, [{
    key: 'update',
    value: function update() {
      this.run();
    }
  }, {
    key: 'run',
    value: function run() {
      var value = this.get();
      var oldVal = this.value;
      if (value !== oldVal || (0, _index.isObject)(value)) {
        this.value = value;
        this.cb.call(this.vm, value, oldVal);
      }
    }
  }, {
    key: 'addDep',
    value: function addDep(dep) {
      // 1. 每次调用run()的时候会触发相应属性的getter
      // getter里面会触发dep.depend()，继而触发这里的addDep
      // 2. 假如相应属性的dep.id已经在当前watcher的depIds里，说明不是一个新的属性，仅仅是改变了其值而已
      // 则不需要将当前watcher添加到该属性的dep里
      // 3. 假如相应属性是新的属性，则将当前watcher添加到新属性的dep里
      // 如通过 vm.child = {name: 'a'} 改变了 child.name 的值，child.name 就是个新属性
      // 则需要将当前watcher(child.name)加入到新的 child.name 的dep里
      // 因为此时 child.name 是个新值，之前的 setter、dep 都已经失效，如果不把 watcher 加入到新的 child.name 的dep中
      // 通过 child.name = xxx 赋值的时候，对应的 watcher 就收不到通知，等于失效了
      // 4. 每个子属性的watcher在添加到子属性的dep的同时，也会添加到父属性的dep
      // 监听子属性的同时监听父属性的变更，这样，父属性改变时，子属性的watcher也能收到通知进行update
      // 这一步是在 this.get() --> this.getVMVal() 里面完成，forEach时会从父级开始取值，间接调用了它的getter
      // 触发了addDep(), 在整个forEach过程，当前wacher都会加入到每个父级过程属性的dep
      // 例如：当前watcher的是'child.child.name', 那么child, child.child, child.child.name这三个属性的dep都会加入当前watcher
      if (!this.depIds.hasOwnProperty(dep.id)) {
        dep.addSub(this);
        this.depIds[dep.id] = dep;
      }
    }
  }, {
    key: 'get',
    value: function get() {
      if (!this.getter) {
        return;
      }
      _Dep2.default.target = this;
      var value = this.getter.call(this.vm, this.vm);
      _Dep2.default.target = null;
      return value;
    }
  }], [{
    key: 'parseGetter',
    value: function parseGetter(exp) {
      if (!exp) {
        return;
      }
      if (/[^\w.$]/.test(exp)) return;

      var exps = exp.split('.');
      return function (obj) {
        for (var i = 0, len = exps.length; i < len; i++) {
          if (!obj) return;
          obj = obj[exps[i]];
        }
        return obj;
      };
    }
  }]);

  return Watcher;
}();

exports.default = Watcher;

/***/ })
/******/ ]);