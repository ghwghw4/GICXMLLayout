# ratio-panel

`ratio-panel`是一种比例布局。比如以4:3的宽高比显示一张图片，那么直接设置`ratio-panel`的`ratio`属性为`0.75`即可。`ratio-panel`只支持单个的UI子元素。子元素的大小根据ratio的设置会自动按照比例计算出来。



## 属性

| 名称    | 数据类型  | 介绍                      | 是否支持绑定 | 是否支持动画 |
| ----- | ----- | ----------------------- | ------ | ------ |
| ratio | Float | 高宽比例。**注意是高宽比例，而非宽高比例** | 是      | 是      |



## 例子

1. 宽高 2:1,并且限定宽度200

   ```xml
   <ratio-panel ratio="0.5" width="200">
       <image url="http://img5.duitang.com/uploads/item/201204/01/20120401222440_eEjyC.thumb.700_0.jpeg"/>
   </ratio-panel>
   ```

   ![8](../images/8.jpg)

2. 宽高 2:1,并且限定高度100

   ```xml
   <ratio-panel ratio="0.5" height="100">
       <image url="http://img5.duitang.com/uploads/item/201204/01/20120401222440_eEjyC.thumb.700_0.jpeg"/>
   </ratio-panel>
   ```

   ![8](../images/8.jpg)