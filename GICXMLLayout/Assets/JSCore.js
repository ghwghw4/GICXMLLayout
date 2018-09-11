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
  /******/ 	return __webpack_require__(__webpack_require__.s = 0);
  /******/ })
/************************************************************************/
/******/ ([
  /* 0 */
  /***/ (function(module, exports, __webpack_require__) {

    "use strict";


    Object.defineProperty(exports, "__esModule", {
      value: true
    });

    var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

    function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

    var GIC = function () {
      function GIC() {
        _classCallCheck(this, GIC);
      }

      _createClass(GIC, null, [{
        key: '_elementInit',

        /**
         * 元素初始化
         * 1. 动态添加obj的getter 、setter 方法
         * @param obj
         * @param ps
         * @returns {*}
         * @private
         */
        value: function _elementInit(obj, ps) {
          var _this = this;

          // 1.属性
          ps.split(',').forEach(function (key) {
            var propertyName = _this._elAttributeNameToPropertyName(key);
            Object.defineProperty(obj, propertyName, {
              get: function get() {
                return this.getAttValue(key);
              },
              set: function set(val) {
                this.setAttValue(key, val);
              }
            });
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
        }

        /**
         * 首字母转大写
         * @param strO
         * @returns {string}
         * @private
         */

      }, {
        key: '_capitalizedString',
        value: function _capitalizedString(strO) {
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

      }, {
        key: '_elAttributeNameToPropertyName',
        value: function _elAttributeNameToPropertyName(attName) {
          var strs = attName.split('-');
          var pName = strs[0];
          for (var i = 1; i < strs.length; i++) {
            pName += this._capitalizedString(strs[i]);
          }
          return pName;
        }
      }]);

      return GIC;
    }();

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

    window.GIC = GIC;
    exports.default = GIC;

    /***/ })
  /******/ ]);