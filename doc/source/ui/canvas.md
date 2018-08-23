# canvas

`canvas`是`0.2.0`版本新增的UI元素。功能类似于`h5`中的canvas功能,而在底层的实现上其实就是对`CoreGraphics`的封装。因此`canvas`能实现的功能范围就是`CoreGraphics`提供的功能。然而`gic`天生就支持`动画`，因此`canvas`也能支持动画。

`canvas`可以理解为一块画布，`path`是画布的唯一组成元素,但是你可以在`path`中添加如下5中元素。

1. `point`：单个点，作用仅仅是将当前点移动到该点。
2. `line`：线条，你可以通过添加point的方式添加N调线条。
3. `arc`:弧线，你可以利用`arc`画出扇形、圆形
4. `rectangle`:矩形，支持圆角。甚至支持为四个圆角单独设置。
5. `bezier`:贝塞尔曲线。

## path

`path`代表的是一组图形的路径，可以设置线条的颜色、线条的宽度、是否自动闭合线条、还有填充色。

### 属性

| 名称                | 数据类型 | 介绍                                                         | 是否支持绑定 | 是否支持动画 |
| ------------------- | -------- | ------------------------------------------------------------ | ------------ | ------------ |
| line-color          | UIColor  | 线条颜色                                                     | 是           | 是           |
| line-width          | Float    | 线条宽度，默认0.5                                            | 是           | 是           |
| close-lines         | bool     | 是否闭合线条。                                               | 是           | 是           |
| fill-color          | UIColor  | 填充色。如果不设置，那么不填充                               | 是           | 是           |
| dash(**0.2.2新增**) | String   | 虚线宽度和间距，以空格分隔。比如：4 1。那么表示虚线宽度为4，间隔为1 | 是           | 否           |

## point

`point`以单独的点出现在`path`中的时候，只是用来将当前点移动到该位置的作用。而当作为`line`的子元素出现的时候就可以组成线条,依次连接各个点

### 属性

| 名称 | 数据类型 | 介绍                  | 是否支持绑定 | 是否支持动画 |
| ---- | -------- | --------------------- | ------------ | ------------ |
| x    | Float    | 支持百分比，比如：20% | 是           | 是           |
| y    | Float    | 支持百分比，比如：20% | 是           | 是           |

## line

`line`本身没有任何的属性，完全是通过`point`子元素来实现组成线条的。

## arc

弧线。

### 属性

| 名称        | 数据类型 | 介绍                                                         | 是否支持绑定 | 是否支持动画 |
| ----------- | -------- | ------------------------------------------------------------ | ------------ | ------------ |
| center      | Size     | 中心点。支持百分比,比如50%                                   | 是           | 是           |
| radius      | Float    | 半径。支持百分比,比如50%，在设置百分的时候，`gic`是按照宽度的百分比计算的。 | 是           | 是           |
| start-angle | Float    | 起始的度数。比如：360、180                                   | 是           | 是           |
| end-angle   | Float    | 结束的度数。比如：360、180                                   | 是           | 是           |
| clockwise   | Bool     | 是否顺时针方向。默认false                                    | 是           | 是           |

## rectangle 

矩形。支持圆角

### 属性

| 名称          | 数据类型             | 介绍                                                         | 是否支持绑定 | 是否支持动画 |
| ------------- | -------------------- | ------------------------------------------------------------ | ------------ | ------------ |
| x             | Float                | 起始的x点。支持百分比                                        | 是           | 是           |
| y             | Float                | 起始的y点。支持百分比                                        | 是           | 是           |
| width         | Float                | 宽度。支持百分比                                             | 是           | 是           |
| height        | Float                | 高度。支持百分比                                             | 是           | 是           |
| corner-types  | Integer  array(枚举) | 圆角的枚举。默认支持四个圆角。你可以使用空格分隔的方式添加对多个圆角的支持，类似于 `|`运算 | 是           | 是           |
| corner-radius | size                 | 圆角大小。支持百分比                                         | 是           | 是           |

###  corner-types 枚举

| 枚举值 | 对应枚举                | 说明       |
| ------ | ----------------------- | ---------- |
| 0      | UIRectCornerTopLeft     | 左上角圆角 |
| 1      | UIRectCornerTopRight    | 右上角圆角 |
| 2      | UIRectCornerBottomLeft  | 左下角圆角 |
| 3      | UIRectCornerBottomRight | 右下角圆角 |



 

##bezier

贝塞尔曲线。

| 名称           | 数据类型 | 介绍                | 是否支持绑定 | 是否支持动画 |
| -------------- | -------- | ------------------- | ------------ | ------------ |
| control-point  | Point    | 控制点1。支持百分比 | 是           | 是           |
| control-point2 | Point    | 控制点2。支持百分比 | 是           | 是           |
| point          | point    | 点。支持百分比      | 是           | 是           |

## 例子

1. 基础

   ```xml
   <canvas height="100" background-color="yellow">
       <path>
           <!--线条-->
           <line>
               <point x="0" y="0"/>
               <point x="50%" y="50%"/>
               <point x="100%" y="50%"/>
           </line>
           <!--弧线-->
           <arc center="50%" radius="40" start-angle="0" end-angle="180" />
   
           <!--贝塞尔曲线-->
           <!--1个控制点的贝塞尔曲线-->
           <!--添加一个单独point点，相当于将当前的point移动到这个点-->
           <point x="10" y="50"/>
           <bezier control-point="50 100" point="80 100"/>
   
           <!--2个控制点的贝塞尔曲线-->
           <!--添加一个单独point点，相当于将当前的point移动到这个点-->
           <point x="5" y="50"/>
           <bezier control-point="35 0" control-point2="35 100" point="65 50"/>
       </path>
       <path fill-color="red" line-width="0">
           <!--画一个有圆角的矩形(左上、右下圆角)-->
           <rectangle x="50%" y="0" width="50%" height="20%" corner-radius="50%"  corner-types="0 3"/>
       </path>
   </canvas>
   ```

   ![16](../images/16.jpg)

2. 带动画的矩形报表(效果看下图)

   ```xml
   <canvas height="100" background-color="yellow">
       <data-context>
           [{
           "x": 0,
           "y": 0,
           "width": 40,
           "height": 100,
           "color": "blue"
           },
           {
           "x": 50,
           "y": 20,
           "width": 40,
           "height": 80,
           "color": "red"
           },
           {
           "x": 100,
           "y": 50,
           "width": 40,
           "height": 50,
           "color": "black"
           },
           {
           "x": 150,
           "y": 30,
           "width": 40,
           "height": 70,
           "color": "7EC0EE"
           },
           {
           "x": 200,
           "y": 10,
           "width": 40,
           "height": 90,
           "color": "EEC900"
           }
           ]
       </data-context>
       <for>
           <path fill-color="{{color}}" line-width="0">
               <rectangle x="{{x}}"  width="{{width}}" height="{{height+'%'}}">
                   <animations>
                       <anim-attribute attribute-name="y" on="1" from="100%" to="{{y+'%'}}" duration=".6"/>
                   </animations>
               </rectangle>
           </path>
       </for>
   </canvas>
   ```

3. 吃豆人(效果看下图)

   ```xml
   <canvas height="100" background-color="yellow">
       <!--吃豆人-->
       <path fill-color="black" line-width="0">
           <point x="50%" y="50%">
               <animations>
                   <anim-attribute attribute-name="x" on="1" from="0%" to="100%" autoreverses="1" duration="3" repeat="-1"/>
               </animations>
           </point>
   
           <arc center="50%" radius="20" end-angle="360" start-angle="45" >
               <animations>
                   <anim-attribute attribute-name="end-angle" on="1" from="315" to="360" autoreverses="1" duration="0.3" repeat="-1"/>
                   <anim-attribute attribute-name="start-angle" on="1" from="45" to="0" autoreverses="1" duration="0.3" repeat="-1"/>
                   <anim-attribute attribute-name="center" on="1" from="0% 50%" to="100% 50%" autoreverses="1" duration="3" repeat="-1"/>
               </animations>
           </arc>
       </path>
   </canvas>
   ```

   ![canvas1](../images/canvas1.gif)

