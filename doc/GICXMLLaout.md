# GICXMLLayout

## 支持元素标签介绍

### scroll-view 

在ios中映射为`UIScrollView`

一个提供滚动功能的组件。只提供滚动功能，不负责子元素的布局。因此对于子元素有严格的要求，必须是`panel`或者是从`panel`扩展出来的元素，比如：`stack-panel`,`panel`。

属性:

| attributeName   | 说明        | 例子                  |      |
| --------------- | --------- | ------------------- | ---- |
| show-ver-scroll | 是否显示垂直滚动条 | 0 表示不显示 1表示显示   默认1 |      |
| show-hor-scroll | 是否显示水平滚动条 | 0 表示不显示 1表示显示   默认1 |      |
|                 |           |                     |      |
|                 |           |                     |      |

例子:
```xml
<scroll-view margin="64 0 0 0" show-ver-scroll="0">
  <stack-panel>
  </stack-panel>
</scroll-view>
```





### list-item

`list-item`的子节点必须是某个`panel`，不支持其他类型的节点