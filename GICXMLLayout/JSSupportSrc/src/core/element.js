
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