# control

`control`主要一种具有状态管理的ui元素，提供了`正常`、`高亮`、`禁用`、`选中`四种状态。你可以为每一种状态添加特定的UI显示。如果没有添加的话，`gic`提供了默认的状态管理。

默认状态

> 高亮：将整个control设为0.8的透明度。
>
> 禁用：将整个control设为0.5的透明度。
>
> 选中：无变化

你可以使用`control`来实现button的功能。

## 属性

| 名称     | 数据类型 | 介绍                                                   | 是否支持绑定 | 是否支持动画 |
| -------- | -------- | ------------------------------------------------------ | ------------ | ------------ |
| enable   | Bool     | 是否启用。默认true，如果false，那么control进入禁用状态 | 是           | 是           |
| selected | Bool     | 是否选中状态。默认false                                | 是           | 是           |





## 例子

```xml
<control background-color="black" height="44">
    <dock-panel>
        <lable text="普通状态" font-color="white"/>
    </dock-panel>
    <!--高亮状态-->
    <highlight>
        <dock-panel>
            <lable text="高亮状态" font-color="red"/>
        </dock-panel>
    </highlight>
    <!--禁用状态-->
    <disable>
        <dock-panel>
            <lable text="禁用了" font-color="gray"/>
        </dock-panel>
    </disable>
    <!--选中状态-->
    <selected>
        <dock-panel>
            <lable text="选中状态" font-color="gray"/>
        </dock-panel>
    </selected>
</control>
```

