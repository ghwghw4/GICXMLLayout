// /**
//  * 继承class
//  * @param subClass
//  * @param superClass
//  * @private
//  */
// function _inherits(subClass, superClass) {
//   if (typeof superClass !== 'function' && superClass !== null) {
//     throw new TypeError(`Super expression must either be null or a function, not ${typeof superClass}`);
//   }
//
//   subClass.prototype = Object.create(superClass && superClass.prototype, {
//     constructor: {
//       value: subClass, enumerable: false, writable: true, configurable: true,
//     },
//   });
//   if (superClass) {
//     Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass;
//   }
// }
//
// const _createClass = (function () {
//   function defineProperties(target, props) {
//     for (let i = 0; i < props.length; i++) {
//       const descriptor = props[i];
//       descriptor.enumerable = descriptor.enumerable || false;
//       descriptor.configurable = true;
//       if ('value' in descriptor) { descriptor.writable = true; }
//       Object.defineProperty(target, descriptor.key, descriptor);
//     }
//   } return function (Constructor, protoProps, staticProps) {
//     if (protoProps) { defineProperties(Constructor.prototype, protoProps); }
//     if (staticProps) defineProperties(Constructor, staticProps);
//     return Constructor;
//   };
// }());

// 缓存的clss元数据
const _cachedClassMeta = {};

/**
 * 定义一个class(元数据)
 * @param className
 * @param propertys
 * @param methods
 * @param staticMethods
 * @constructor
 */
function GICDefineClass(className, propertys, methods, staticMethods) {
    // 编译
    if (!_cachedClassMeta[className]) {
        _cachedClassMeta[className] = {
        cls: className, propertys: propertys || [], methods: methods || [], staticMethods: staticMethods || [],
        };
        const metaClass = _native_.defineClass(className);
        if (staticMethods) {
            staticMethods.forEach((method) => {
                                  const key = Object.keys(method)[0];
                                  metaClass[key] = function () {
                                  return _native_.callMethodStatic(className, method[key], arguments);
                                  };
                                  });
        }
    }
}
// 创建对象
function _GICCreateObject(className) {
    const obj = _native_.createObject(className);
    if (obj) {
        _ApplyClassMetaInfoToNativeObject(obj, className);
        return obj;
    }
}

function _ApplyClassMetaInfoToNativeObject(obj, className) {
    if (obj && className) {
        if (!obj.__hasApplyed__) {
            const metaInfo = _cachedClassMeta[className];
            if (metaInfo) {
                metaInfo.propertys.forEach((key) => {
                                           Object.defineProperty(obj, key, {
                                                                 get() {
                                                                 return _native_.callMethod(this, key);
                                                                 },
                                                                 set(value) {
                                                                 _native_.setProperty(this, key, value);
                                                                 },
                                                                 });
                                           });
                
                metaInfo.methods.forEach((method) => {
                                         const key = Object.keys(method)[0];
                                         obj[key] = function () {
                                         return _native_.callMethod(this, method[key], arguments);
                                         };
                                         });
            }
            obj.__hasApplyed__ = true;
        }
    }
}
