# transforms(形变)

`transforms`对应iOS中的`CATransform3D`,可以对`layer`进行形变。当前`GIC`提供了三种变换方式:

1. `rotate`:旋转变形
2. `scale`：缩放变形
3. `translate`:位移

上述的三种形变方式，都是封装自iOS本身的`CATransform3D`。并且在实际的开发过程中，可以将多个方式组合在一起使用。

## rotate

| 名称 | 数据类型 | 介绍          | 是否支持绑定 | 是否支持动画 |
| ---- | -------- | ------------- | ------------ | ------------ |
| x    | Float    | x轴旋转的角度 | 是           | 是           |
| y    | Float    | y轴旋转的角度 | 是           | 是           |
| z    | Float    | z轴旋转的角度 | 是           | 是           |

## scale

| 名称 | 数据类型 | 介绍                 | 是否支持绑定 | 是否支持动画 |
| ---- | -------- | -------------------- | ------------ | ------------ |
| x    | Float    | x轴缩放的倍数。默认1 | 是           | 是           |
| y    | Float    | y轴缩放的倍数。默认1 | 是           | 是           |
| z    | Float    | z轴缩放的倍数。默认1 | 是           | 是           |

## translate

| 名称 | 数据类型 | 介绍            | 是否支持绑定 | 是否支持动画 |
| ---- | -------- | --------------- | ------------ | ------------ |
| x    | Float    | x轴移动的距离。 | 是           | 是           |
| y    | Float    | y轴移动的距离。 | 是           | 是           |
| z    | Float    | z轴移动的距离。 | 是           | 是           |

## 示例

1. rotate: 沿Z轴旋转45度

   ```xml
   <panel size="60" background-color="black">
       <transforms>
           <rotate z="45"/>
       </transforms>
   </panel>
   ```

2. scale： X方向和Y方向缩小为0.5倍

   ```xml
   <panel size="60" background-color="black">
       <transforms>
           <scale x="0.5" y="0.5"/>
       </transforms>
   </panel>
   ```

3. translate：沿X轴方向位移20像素

   ```xml
   <panel size="60" background-color="black">
       <transforms>
           <translate x="20"/>
       </transforms>
   </panel>
   ```

4. 综合多个形变：

   ```xml
   <panel size="60" background-color="black">
       <transforms>
           <rotate z="45"/>
           <translate x="20"/>
           <scale x="0.5" y="0.5"/>
       </transforms>
   </panel>
   ```
