# 动画

你现在可以直接使用xml来写动画了，`gic`动画的实现是依赖`pop`这个库实现的 ，因此，大多数的属性都支持动画。`gic`中的动画目前分为两种。当然你也可以自己来扩展动画。反正都是以元素的形式表达的。

1. 属性动画(`anim-attribute`)。也就是各个元素的属性。属性是否支持动画文档中已经列出。使用的时候直接看下即可。
2. 形变动画(`anim-transforms`)。这个形变动画对应iOS中的`transform `动画，形变动画其实是多个动画的统称，分为:位移动画(`anim-move `)、旋转动画(`anim-rotate `)、缩放动画(`anim-scale `)

在`gic`中要实现动画，那真是相当的容易。直接在元素的`animations`子元素下添加相应动画即可，你可以添加多个动画，每个动画都可以分别设置动画时长、触发条件、是否重复等属性。

## 动画通用属性。

通用属性指的是所有动画都支持的属性，这个你可以理解为基类的属性。

| 名称              | 数据类型      | 介绍                                                         | 是否支持绑定 | 是否支持动画 |
| :---------------- | ------------- | ------------------------------------------------------------ | ------------ | ------------ |
| duration          | Float         | 动画时长。单位是秒                                           | 是           | 否           |
| repeat            | Integer       | 动画重复次数。-1表示永远                                     | 是           | 否           |
| autoreverses      | Bool          | 是否反向动画。如果设为yes，那么整个动画的时长*2              | 是           | 否           |
| on                | integer(枚举) | 动画触发条件。下面细说                                       | 是           | 否           |
| event-name        | string        | 触发动画的事件名称。如果没有设置，那么默认为`event-tab`。**0.3.2新增** | 是           | 否           |
| ease-mode         | Integer(枚举) | 动画时间计算方式。                                           | 是           | 否           |
| spring-bounciness | Float         | 弹力,越大则震动幅度越大,0~20之间                             | 是           | 否           |
| spring-speed      | Float         | 速度 越大则动画结束越快，0~20之间                            | 是           | 否           |

### on 枚举

当前动画触发条件只有两种。

| 枚举值 | 对应枚举                       | 说明                                                     |
| ------ | ------------------------------ | -------------------------------------------------------- |
| 0      | GICAnimationTriggerType_None   | 不触发动画                                               |
| 1      | GICAnimationTriggerType_attach | 当附加到元素上的时候立马触发动画                         |
| 2      | GICAnimationTriggerType_event  | 事件触发。如果没有设置`event-name`属性，那么默认单击事件 |

当前`gic`暂时只提供两种触发方式，后续会考虑加入更多的触发方式。

###  ease-mode枚举

| 枚举值 | 对应枚举                           | 说明         |
| ------ | ---------------------------------- | ------------ |
| 0      | GICAnimationEaseMode_Linear        | 线性动画     |
| 1      | GICAnimationEaseMode_EaseIn        | 加速动画     |
| 2      | GICAnimationEaseMode_EaseOut       | 减速动画     |
| 3      | GICAnimationEaseMode_EaseInEaseOut | 先加速后减速 |

## 属性动画支持的属性

| 名称           | 数据类型 | 介绍                    | 是否支持绑定 | 是否支持动画 |
| :------------- | -------- | ----------------------- | ------------ | ------------ |
| attribute-name | String   | 动画对应的属性名称。    | 是           | 否           |
| from           | String   | 动画开始的时候属性value | 是           | 否           |
| to             | String   | 动画结束的时候属性value | 是           | 否           |

## 形变动画支持的属性

### 位移动画(anim-move )的属性

| 名称 | 数据类型 | 介绍                 | 是否支持绑定 | 是否支持动画 |
| :--- | -------- | -------------------- | ------------ | ------------ |
| from | CGPoint  | 动画开始的时候的位置 | 是           | 否           |
| to   | CGPoint  | 动画结束的时候的位置 | 是           | 否           |

### 旋转动画(anim-rotate)的属性

| 名称 | 数据类型 | 介绍                                    | 是否支持绑定 | 是否支持动画 |
| :--- | -------- | --------------------------------------- | ------------ | ------------ |
| from | Float    | 动画开始的时候的弧度。比如:180、360、90 | 是           | 否           |
| to   | Float    | 动画结束的时候的弧度                    | 是           | 否           |

### 缩放动画(anim-scale" )的属性

| 名称 | 数据类型 | 介绍                                 | 是否支持绑定 | 是否支持动画 |
| :--- | -------- | ------------------------------------ | ------------ | ------------ |
| from | CGSize   | 动画开始的时候对应高宽方向的缩放比例 | 是           | 否           |
| to   | CGSize   | 动画结束的时候对应高宽方向的缩放比例 | 是           | 否           |

## 例子

1. 背景色过度动画,背景色从红色过度到黄色，无限重复动画。触发条件：点击

   ```xml
   <dock-panel height="50">
       <animations>
           <anim-attribute attribute-name="background-color" on="2" from="red" to="yellow" autoreverses="1" duration="1" repeat="-1"/>
       </animations>
       <lable text="点我启动动画"/>
   </dock-panel>
   ```

2. 透明度从0.5到1的动画。触发条件：附加到元素上立即触发

   ```xml
   <dock-panel height="50" background-color="black">
       <animations>
           <anim-attribute attribute-name="alpha" on="1" from="1" to="0.5" autoreverses="1" duration="1" repeat="-1"/>
       </animations>
   </dock-panel>
   ```

3. 位移动画，从原点开始，位移到x:40,y:30的地方，开始和结束的点是相对点，相对于元素开始动画的位置。

   ```xml
   <dock-panel height="50" background-color="black">
       <animations>
           <anim-transforms autoreverses="1" duration="1" repeat="-1" on="1" ease-mode="1">
               <anim-move  from="0" to="40 30" />
           </anim-transforms>
       </animations>
   </dock-panel>
   ```

4. 位移((0,0) 位移到(100,30))、旋转(180度旋转)、缩放(高宽方向同时放大1.5倍)混合动画。

   ```xml
   <dock-panel size="50" background-color="black" >
       <animations>
           <anim-transforms autoreverses="1" duration="1" repeat="-1" on="1">
               <anim-scale from="1" to="1.5" />
               <anim-move  from="0" to="100 30" />
               <anim-rotate from="0" to="180" />
           </anim-transforms>
       </animations>
   </dock-panel>
   ```

5. 形变、属性混合动画。在例子4的基础上，同时添加透明度、背景色的动画。

   ```xml
   <dock-panel size="50" background-color="black" >
       <animations>
           <anim-attribute attribute-name="alpha" on="1" from="1" to="0.5" autoreverses="1" duration="1" repeat="-1"/>
           <anim-attribute attribute-name="background-color" on="1" from="red" to="yellow" autoreverses="1" duration="1" repeat="-1"/>
           <anim-transforms autoreverses="1" duration="1" repeat="-1" on="1">
               <anim-scale from="1" to="1.5" />
               <anim-move  from="0" to="100 30" />
               <anim-rotate from="0" to="180" />
           </anim-transforms>
       </animations>
   </dock-panel>
   ```


目前`gic`中的动画暂时只提供了这些，但是应该已经可以应付大多数的动画了，后续会添加更多的动画支持，当然，你也可以自定义一个自己的动画。只需要继承自基类`GICAnimation `就可以了。



0.3.2新增支持任意事件触发动画。举个例子，当触摸事件发生的时候触发动画。具体该元素支持哪些事件请参考文档，而所有的UI元素都会支持如下几个事件：`event-tap`、`event-double-tap`、`event-touch-begin`、`event-touch-move`、`event-touch-end`

```xml
<!--首先将on属性设为2，即事件触发。然后设置event-name属性为event-touch-begin-->
<anim-transforms on="2" duration="0.05" event-name="event-touch-begin">
    <anim-scale  from="1" to="0.95"/>
</anim-transforms>
```



0.4.3新增spring 动画

```xml
<!--spring 动画，只要设置了spring-speed 或者 spring-bounciness 任意属性就能启用spring动画-->
<animations>
    <anim-transforms duration="1" repeat="-1" on="1" ease-mode="1" spring-speed="4" spring-bounciness="12">
        <anim-move  from="0" to="20 20" />
    </anim-transforms>
</animations>
```

