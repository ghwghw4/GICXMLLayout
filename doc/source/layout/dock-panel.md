# dock-panel

`dock-panel`是一种停靠布局，通过设置子元素的`dock-horizal`和`dock-vertical`两个属性可以将子元素停靠在panel的9个位置，如果不设置这两个属性，那么默认居中显示。如果子元素没有显示设置width 和 height，那么默认该子元素撑满整个`dock-panel`。



## 附加属性

| 名称                | 数据类型      | 介绍                                     |
| ------------------- | ------------- | ---------------------------------------- |
| dock-panel.horizal  | integer(枚举) | 水平停靠位置。**只有在dock-panel中生效** |
| dock-panel.vertical | integer(枚举) | 垂直停靠位置。**只有在dock-panel中生效** |

### dock-panel.horizal

| 枚举值 | 对应枚举                        | 说明                 |
| ------ | ------------------------------- | -------------------- |
| 0      | GICDockPanelHorizalModel_Left   | 停靠在水平方向的左边 |
| 1      | GICDockPanelHorizalModel_Center | 停靠在水平方向的中间 |
| 2      | GICDockPanelHorizalModel_Right  | 停靠在水平方向的右边 |

示例：水平居中

```Xml
dock-horizal="1"
```

### dock-panel.vertical

| 枚举值 | 对应枚举                         | 说明                 |
| ------ | -------------------------------- | -------------------- |
| 0      | GICDockPanelVerticalModel_Top    | 停靠在垂直方向的左边 |
| 1      | GICDockPanelVerticalModel_Center | 停靠在垂直方向的中间 |
| 2      | GICDockPanelVerticalModel_Bottom | 停靠在垂直方向的右边 |

示例：垂直居中

```Xml
dock-vertical="1"
```





## 例子

```xml
<dock-panel background-color="black" height="200" space-before="20">
    <template-ref t-name="p-child" data-context="左上" dock-panel.horizal="0" dock-panel.vertical="0" />
    <template-ref t-name="p-child" data-context="中上" dock-panel.horizal="1" dock-panel.vertical="0" />
    <template-ref t-name="p-child" data-context="右上" dock-panel.horizal="2" dock-panel.vertical="0" />
    <template-ref t-name="p-child" data-context="中左" dock-panel.horizal="0" dock-panel.vertical="1" />
    <template-ref t-name="p-child" data-context="居中" />
    <template-ref t-name="p-child" data-context="中右" dock-panel.horizal="2" dock-panel.vertical="1" />
    <template-ref t-name="p-child" data-context="下左" dock-panel.horizal="0" dock-panel.vertical="2" />
    <template-ref t-name="p-child" data-context="下中" dock-panel.horizal="1" dock-panel.vertical="2" />
    <template-ref t-name="p-child" data-context="下右" dock-panel.horizal="2" dock-panel.vertical="2" />
</dock-panel>
```



![5](../images/5.jpg)