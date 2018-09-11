// var GICElement = {};
// 定义一个基类，用来定义元素类
// function GICElement() {
//
// }


var GIC = {
  /**
   * 元素初始化
   * 1. 动态添加obj的getter 、setter 方法
   * @param obj
   * @param ps
   * @private
   */
  _elementInit:function(obj,ps){
    // 1.属性
    ps.split(",").forEach(key=>{
      var propertyName = this._elAttributeNameToPropertyName(key);
      Object.defineProperty(obj,propertyName,{
        get:function(){
          return this.getAttValue(key);
        },
        set:function (val) {
          this.setAttValue(key,val);
        }
      });
    });
    // 2.事件
    // 点击事件
    Object.defineProperty(obj,'onclick',{
      get:function(){
        return this._onClick;
      },
      set:function (val) {
        this._onClick = val;
        this.setEvent('event-tap',val);
      }
    });
    // 触摸移动事件
    Object.defineProperty(obj,'onmove',{
      get:function(){
        return this._onmove;
      },
      set:function (val) {
        this._onmove = val;
        this.setEvent('event-touch-move',val);
      }
    });
  },
  /**
   * 首字母转大写
   * @param str
   * @returns {string}
   * @private
   */
  _capitalizedString:function(str){
    str = str.toLowerCase();
    var reg = /\b(\w)|\s(\w)/g; //  \b判断边界\s判断空格
    return str.replace(reg,function(m){
      return m.toUpperCase()
    });
  },
  /**
   * 元素的属性名称转对象的属性名，驼峰命名
   * @param attName
   * @private
   */
  _elAttributeNameToPropertyName:function (attName) {
    var strs = attName.split("-");
    var pName = strs[0];
    for(i=1;i<strs.length;i++){
      pName +=this._capitalizedString(strs[i]);
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
  return parseInt(this);
}

/**
 * 转成float
 * @returns {Number}
 */
String.prototype.toFloat = function () {
  return parseFloat(this);
}


String.prototype.toColor = function () {
  var reg = /^#([0-9a-fA-f]{3}|[0-9a-fA-f]{6})$/;
  var sColor = this.toLowerCase();
  if (sColor && reg.test(sColor)) {
    if (sColor.length === 4) {
      var sColorNew = "#";
      for (var i = 1; i < 4; i += 1) {
        sColorNew += sColor.slice(i, i + 1).concat(sColor.slice(i, i + 1));
      }
      sColor = sColorNew;
    }
    //处理六位的颜色值
    var sColorChange = [];
    for (var i = 1; i < 7; i += 2) {
      sColorChange.push(parseInt("0x" + sColor.slice(i, i + 2)));
    }
    return "RGB(" + sColorChange.join(",") + ")";
  } else {
    return sColor;
  }
}