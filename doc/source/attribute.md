# 属性介绍

`gic`库是采用`xml`来描述UI的，因此element和attribute是两个重要的概念。attribute是描述各个元素属性的核心，比如我们对于一个view 设置`backgroundcolor`，那么在xml中，你直接使用

```xml
background-color="white"
```

来描述即可。

## 公共属性

`gic`库中`element`有`UI元素`以及`非UI元素`之分,下面先介绍下所有element都拥有的attribute。

`gic`库是一个以`数据绑定`为核心的库，理论上所有的属性都支持数据绑定，因此公共属性主要是以数据绑定为主。

| 名称           | 数据类型   | 介绍                                    | 是否支持绑定 | 是否支持动画 |
| ------------ | ------ | ------------------------------------- | ------ | ------ |
| name         | string | name类似于h5中的id，可以通过类库提供的方法根据name获取某个元素 | 是      | 否      |
| data-context | string | 数据源，直接指定当前元素以及当前元素子孙元素的数据源            | 否      | 否      |
| data-path    | string | 指定元素应该以父级数据源的哪个属性作为数据源。               | 否      | 否      |

`data-context`和`data-path`是两个互斥的属性，具体使用方法参考数据绑定一节

## 所有UI元素支持的属性

UI元素的属性较多，设计到布局属性以及显示属性。具体如下：

| 名称              | 数据类型      | 介绍                                                         | 是否支持绑定 | 是否支持动画 |
| ----------------- | ------------- | ------------------------------------------------------------ | ------------ | ------------ |
| background-color  | UIColor       | 背景色。                                                     | 是           | 是           |
| hidden            | bool          | 是否隐藏元素。**隐藏后依然会占据空间                         | 是           | 是           |
| alpha             | Float         | 元素的透明度。**(慎用，会引起离屏渲染)**                     | 是           | 是           |
| corner-radius     | Float         | 圆角。                                                       | 是           | 是           |
| shadow-color      | UIColor       | 阴影颜色。**(慎用，会引起离屏渲染)**                         | 是           | 是           |
| shadow-opacity    | Float         | 阴影透明度。**(慎用，会引起离屏渲染)**                       | 是           | 是           |
| shadow-radius     | Float         | 阴影半径。**(慎用，会引起离屏渲染)**                         | 是           | 是           |
| shadow-offset     | CGSize        | 阴影偏移。**(慎用，会引起离屏渲染)**                         | 是           | 是           |
| border-color      | UIColor       | 边框颜色                                                     | 是           | 是           |
| border-width      | Float         | 边框宽度                                                     | 是           | 是           |
| clips-bounds      | Bool          | 类似UIVIew的 clips-bounds                                    | 是           | 是           |
|                   |               |                                                              |              |              |
| height            | ASDimension   | 高度。比如：50、40%                                          | 是           | 是           |
| width             | ASDimension   | 宽度                                                         | 是           | 是           |
| size              | string        | 同时设置宽度和高度，以空格分隔                               | 是           | 否           |
| position          | CGPoint       | 位置，相当于UIView中frame的`origin`，以空格区分x、y 。该属性**只有在绝对布局(panel)中才会生效**。 | 是           | 是           |
| max-width         | ASDimension   | 最大宽度。                                                   | 是           | 是           |
| max-height        | ASDimension   | 最大高度                                                     | 是           | 是           |
| space-before      | Float         | 前-间隔。用来设置距离前面一个元素的间距，**只在`stack-panel`中生效** | 是           | 是           |
| space-after       | Float         | 后-间隔。用来设置距离后一个元素的间距，**只在`stack-panel`中生效** | 是           | 是           |
| flex-grow         | Integer       | felx布局的扩展比率，默认为0不扩展。**只在`stack-panel`中生效** | 是           | 是           |
| flex-shrink       | Integer       | flex布局中，元素的收缩规则，默认为0不收缩，**只在`stack-panel`中生效** | 是           | 是           |
| flex-basics       | ASDimension   | 用于设置该元素在flex布局中，伸缩基准值。**只在`stack-panel`中生效** | 是           | 是           |
| align-self        | integer(枚举) | 允许覆盖单个的 flex item（flex项）默认对齐方式。**只在`stack-panel`中生效** | 是           | 是           |
| dock-horizal      | integer(枚举) | 水平停靠位置。**只有在dock-panel中生效**                     | 是           | 是           |
| dock-vertical     | integer(枚举) | 垂直停靠位置。**只有在dock-panel中生效**                     | 是           | 是           |
| event-tap         | String        | 单击事件。可以直接绑定到ViewModel中的事件名称。              | 否           | 否           |
| event-double-tap  | String        | 双击事件。可以直接绑定到ViewModel中的事件名称。              | 否           | 否           |
| event-touch-begin | String        | 触摸开始事件。可以直接绑定到ViewModel中的事件名称。          | 否           | 否           |
| event-touch-move  | String        | 触摸移动事件。可以直接绑定到ViewModel中的事件名称。          | 否           | 否           |
| event-touch-end   | String        | 触摸结束事件。可以直接绑定到ViewModel中的事件名称。          | 否           | 否           |



### background-color

`background-color`支持简单的颜色名称、16进制RGB值、16进制RGBA值。

1. 直接设置颜色名称。支持的颜色名称如下：

   > `red`、`white`、`black`、`blue`、`dark-gray`、`light-gray`、`gray`、`green`、`cyan`、`yellow`、`magenta`、`orange`、`purple`、`brown`、`clear`

   ```
   background-color="white"
   ```

2. 16进制RGB值

   ```
   background-color="666666"
   background-color="ffffff"
   background-color="efefef"
   ```

3. 16进制RGBA值。多了一个alpha通道

   ```
   background-color="00000080"  // 50%透明度的黑色
   ```

### align-self  枚举

| 枚举值  | 对应枚举                          | 说明                        |
| ---- | ----------------------------- | ------------------------- |
| 0    | ASStackLayoutAlignSelfAuto    | 自动，也就是stack-panel设置什么就是什么 |
| 1    | ASStackLayoutAlignSelfStart   | 从主轴的开始位置开始排列              |
| 2    | ASStackLayoutAlignSelfEnd     | 从主轴的结束位置开始排列              |
| 3    | ASStackLayoutAlignSelfCenter  | 从主轴的中间位置开始排列              |
| 4    | ASStackLayoutAlignSelfStretch | 均匀分布在主轴上                  |

示例：强制主轴开始位置排列

```xml
align-self = "1"
```



###  dock-horizal

| 枚举值  | 对应枚举                            | 说明         |
| ---- | ------------------------------- | ---------- |
| 0    | GICDockPanelHorizalModel_Left   | 停靠在水平方向的左边 |
| 1    | GICDockPanelHorizalModel_Center | 停靠在水平方向的中间 |
| 2    | GICDockPanelHorizalModel_Right  | 停靠在水平方向的右边 |

示例：水平居中

```Xml
dock-horizal="1"
```

### dock-vertical

| 枚举值  | 对应枚举                             | 说明         |
| ---- | -------------------------------- | ---------- |
| 0    | GICDockPanelVerticalModel_Top    | 停靠在垂直方向的左边 |
| 1    | GICDockPanelVerticalModel_Center | 停靠在垂直方向的中间 |
| 2    | GICDockPanelVerticalModel_Bottom | 停靠在垂直方向的右边 |

示例：垂直居中

```Xml
dock-vertical="1"
```