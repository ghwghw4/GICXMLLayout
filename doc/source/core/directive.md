# 指令

`directive`的设计参考了`vue`中的设计，不过在实现的时候是有点不一样的。在`gic`中，`directive`其实也是`behavior`的一种。`directive`在功能上的划分其实不能算是绝对的划分，应该说是一种比较抽象的划分，不像`动画`、`模板`有明确的功能定义，但是`directive`在功能上的其实比较模糊的。`gic`中目前提供了两种`directive`，分别是`for `、`if、if-else`,这两种指令主要集中在元素的动态`创建`、`删除`上面。下面一一介绍下两种指令的使用场景。

## for

for指令是一个可以根据数据源数组，动态的创建、删除元素。for指令会根据当前的数据源做出适当的选择，比如当前数据源如果是数组那么会自动根据数据内容循环创建for包含的子元素，然后将这些子元素添加到for指令的父元素之中。如果数据源是一个可变数组(`NSMutableArray `)，那么会自动使用`rac`监听如下5个方法：

1. `addObject: `
2. `addObjectsFromArray: `
3. `removeObject: `
4. `removeAllObjects `
5. `removeObjectsInArray: `
6. `insertObjects:atIndexes:` --- **0.4.2 新增**

也就是说，当你对数据源调用上面5种方法的时候，for指令会自动做出相应的反应。(目前暂时不支持插入,后续会考虑加入)。**除了上面的6中方法以外对`NSMutableArray `进行操作`for`指令是不会有任何反应的，切忌。**

for指令可以添加到任何支持多个子元素的节点中。

### 例子

```xml
<stack-panel is-horizon="1" wrap="1" background-color="black" space="10" line-space="10">
    <for data-path="listDatas">
        <ratio-panel background-color="yellow" width="30%">
            <dock-panel>
                <lable text="{{}}"/>
            </dock-panel>
        </ratio-panel>
    </for>
</stack-panel>
```

这里你可以看到，for指令设置了一个`data-path`的属性，这样一来，for的数据源就绑定到了for父节点的数据源中的`listDatas`，而`listDatas`正是一个数组。





## if

if指令跟vue中的一样，动态显示、隐藏某个元素。事实上，UI元素有一个`hidden `属性，也是用来设置显示、隐藏某个元素的 ，但是`if`指令和`hidden `属性是有本质区别的.

1. `if`指令是以动态创建、删除某个元素来实现的，同时会影响布局系统，让布局系统重新布局。
2. `hidden`属性，并不会动态创建、删除元素，而是直接设置类似UIView的hidden属性实现的，哪怕hidden为true，但是仍然会占用布局空间以及内存空间，只是在渲染的时候不显示而已。不像if是彻底的删除某个元素

### 属性

| 名称      | 数据类型 | 介绍                              | 是否支持绑定 | 是否支持动画 |
| --------- | -------- | --------------------------------- | ------------ | ------------ |
| condition | bool     | 条件，也就是说true显示，false隐藏 | 是           | 是           |



### 例子

1. if

   ```xml
   <if condition="{{ exp=isShow,mode=1 }}">
       <panel background-color="black" size="50" space-before="10" space-after="10"/>
   </if>
   ```

   这里面只要isShow是true，那么就会显示，如果是false那么隐藏。

2. if-else

   ```xml
   <if condition="{{ exp=isShow,mode=1 }}">
       <panel background-color="red" size="50" space-before="10" space-after="10"/>
       <else>
           <panel background-color="blue" size="50" space-before="10" space-after="10"/>
       </else>
   </if>
   ```

   这里面多了一个else条件。具体的可以参考项目自带的sample。