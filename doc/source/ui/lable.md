# lable

`lable`可以显示文本，也可以显示富文本，甚至包括图标等，可以自动换行也可以限制行数。

如果要显示富文本内容。那么可以在lable元素下添加`s`、`img`等子元素。富文本也支持数据绑定，当数据源更新的时候，富文本内容也会一并更新。

## 属性

| 名称         | 数据类型        | 介绍                                       | 是否支持绑定 | 是否支持动画 |
| :--------- | ----------- | ---------------------------------------- | ------ | ------ |
| text       | String      | 文本内容                                     | 是      | 否      |
| lines      | Integer     | 文本行数。默认0，不限。                             | 是      | 是      |
| font-color | UIColor     | 文本颜色                                     | 是      | 是      |
| font-size  | float       | 字体大小                                     | 是      | 是      |
| text-align | Integer(枚举) | 文本显示位置。**(慎用该属性，该属性在stack-panel中可能会因此显示异常，使用dock-panel依然可以达到text-align的效果)** | 是      | 是      |

###  text-align

| 枚举值  | 对应枚举                     | 说明   |
| ---- | ------------------------ | ---- |
| 0    | NSTextAlignmentLeft      | 不解释  |
| 1    | NSTextAlignmentCenter    | 不解释  |
| 2    | NSTextAlignmentRight     | 不解释  |
| 3    | NSTextAlignmentJustified | 不解释  |
| 4    | NSTextAlignmentNatural   | 不解释  |



## 例子

1. 普通文本。

   ```xml
   <lable text="我是lable,居中显示" font-color="yellow" font-size="20" text-align="1"/>
   ```

   ![9](../images/9.jpg)

2. 富文本

   ```xml
   <lable font-color="yellow" font-size="20">
       <s text="富文本1 "/>
       <img img-name="location"/>
       <s text=" 富文本2" font-size="10" font-color="gray"/>
   </lable>
   ```

   ![10](../images/10.jpg)

## 富文本

   从上面的例子中可以看到，lable提供了两种子元素来实现富文本。分别是`s`、`img`,`s`元素主要是用来显示文本的，而`img`主要是用来显示图标的，当前只能支持本地图标，不支持网络图标。**富文本也是支持数据绑定的**

   ## s元素属性

| 名称               | 数据类型    | 介绍    | 是否支持绑定 | 是否支持动画 |
| ---------------- | ------- | ----- | ------ | ------ |
| text             | String  | 文本内容  | 是      | 否      |
| font-color       | UIColor | 文本颜色  | 是      | 否      |
| font-size        | float   | 字体大小  | 是      | 否      |
| background-color | UIColor | 文本背景色 | 是      | 否      |

   ## img 元素属性

| 名称       | 数据类型   | 介绍   | 是否支持绑定 | 是否支持动画 |
| -------- | ------ | ---- | ------ | ------ |
| img-name | String | 文本内容 | 是      | 否      |