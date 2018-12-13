# scroll-view

`scroll-view`提供的功能类似`UIScrollView`。内置了一个`stack-panel`布局面板。



## 属性

| 名称                   | 数据类型      | 介绍                          | 是否支持绑定 | 是否支持动画 |
| ---------------------- | ------------- | ----------------------------- | ------------ | ------------ |
| is-horizon             | Bool          | 是否水平显示内容              | 是           | 是           |
| show-ver-scroll        | Bool          | 是否显示垂直滚动条            | 是           | 是           |
| show-hor-scroll        | Bool          | 是否显示水平滚动条            | 是           | 是           |
| content-inset          | UIEdgeInsets  | 内容边距                      | 是           | 是           |
| content-inset-behavior | Integer(枚举) | 内容边距行为。iOS11.0以上生效 | 是           | 否           |

### content-inset-behavior 枚举

| 枚举值 | 对应枚举                                         | 说明 |
| ------ | ------------------------------------------------ | ---- |
| 0      | UIScrollViewContentInsetAdjustmentAutomatic      |      |
| 1      | UIScrollViewContentInsetAdjustmentScrollableAxes |      |
| 2      | UIScrollViewContentInsetAdjustmentNever          |      |
| 3      | UIScrollViewContentInsetAdjustmentAlways         |      |



## 例子

1. 垂直滚动

   ```xml
   <scroll-view height="100">
       <stack-panel height="200" background-color="blue">
           <dock-panel height="30">
               <lable text="垂直滚动" font-size="18" font-color="white" />
           </dock-panel>
       </stack-panel>
   </scroll-view>
   ```

2. 水平滚动

   ```xml
   <scroll-view height="50" is-horizon="1">
       <dock-panel width="500" background-color="blue">
           <lable text="水平滚动" font-size="18" font-color="white" />
       </dock-panel>
   </scroll-view>
   ```
