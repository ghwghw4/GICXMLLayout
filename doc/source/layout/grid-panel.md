# Grid-panel



`grid-panel`布局类似于`collection-view`的布局，但是相比`collection-view`来说，没有header、footer、section等概念，只是单纯的一个布局面板。`grid-panel`会自动计算本身的高度，并且会**显示所有的子元素**，因此更适合在列表中作为宫格布局使用。`collection-view`并不会自动计算自身的高度，只是计算内部容器的高度，因此就不适合在列表中嵌套使用。

`grid-panel`目前只支持从做左到右、从上到下的布局，可以指定`colunms`，暂不支持指定`rows`，这个设定跟`collection-view`是一样的。

由于`grid-panel`会显示所有的子元素，因此不适合显示大量数据。如果需要显示大量数据的，那就使用`collection-view`来显示。

## 属性

| 名称           | 数据类型 | 介绍         | 是否支持绑定 | 是否支持动画 |
| -------------- | -------- | ------------ | ------------ | ------------ |
| columns        | Integer  | 列数，默认1. | 否           | 否           |
| column-spacing | flaot    | 列间距。     | 否           | 否           |
| row-spacing    | flaot    | 行间距。     | 否           | 否           |

## 附加属性

| 名称                   | 数据类型 | 介绍       |
| ---------------------- | -------- | ---------- |
| grid-panel.column-span | Integer  | 跨列数量。 |



## 例子

1. 简单的九宫格布局。

   ```xml
   <grid-panel columns="3" column-spacing="10" row-spacing="10">
       <data-context>
           [1,2,3,4,5,6,7,8,9]
       </data-context>
       <for>
           <!--使用比例布局来实现正方形宫格-->
           <ratio-panel background-color="red">
               <!--使用dock-panel来实现文字居中布局-->
               <dock-panel>
                   <lable text="{{}}"/>
               </dock-panel>
           </ratio-panel>
       </for>
   </grid-panel>
   ```

   > 九宫格布局使用`stack-panel`其实也能实现，但是`stack-panel`并没有`column`的概念，因此在列的实现上面将会比较麻烦。而使用`grid-panel`来布局是一件非常简单的事情。

   ![25](../images/25.jpg)

2. 瀑布流布局。

   ```xml
   <grid-panel columns="3" column-spacing="10" row-spacing="10">
       <data-context>
           [
           20, 30, 40, 50, 60, 70, 80, 90, 100,20,10
           ]
       </data-context>
       <for>
           <!--使用dock-panel来实现文字居中布局-->
           <!--dock-panel的height绑定到数据源-->
           <dock-panel height="{{}}" background-color="red">
               <lable text="{{}}"/>
           </dock-panel>
       </for>
   </grid-panel>
   ```

   ![24](../images/24.jpg)