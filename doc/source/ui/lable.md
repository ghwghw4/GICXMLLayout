# lable

`lable`可以显示文本，也可以显示富文本，甚至包括图标等，可以自动换行也可以限制行数。

如果要显示富文本内容。那么可以在lable元素下添加`s`、`img`等子元素。富文本也支持数据绑定，当数据源更新的时候，富文本内容也会一并更新。

## 属性

| 名称              | 数据类型      | 介绍                                                         | 是否支持绑定 | 是否支持动画 |
| :---------------- | ------------- | ------------------------------------------------------------ | ------------ | ------------ |
| text              | String        | 文本内容                                                     | 是           | 否           |
| lines             | Integer       | 文本行数。默认0，不限。                                      | 是           | 是           |
| font-color        | UIColor       | 文本颜色                                                     | 是           | 是           |
| font-size         | float         | 字体大小                                                     | 是           | 是           |
| text-align        | Integer(枚举) | 文本显示位置。**(慎用该属性，该属性在stack-panel中可能会因此显示异常，使用dock-panel依然可以达到text-align的效果)** | 是           | 是           |
| font              | string        | 字体名称。比如：Heiti SC。或者：Heiti SC,14                  | 是           | 否           |
| underline-style   | Integer(枚举) | 下划线样式。**(0.4.6新增)**                                  | 是           | 是           |
| throughline-style | Integer(枚举) | 删除线样式。**(0.4.6新增)**                                  | 是           | 是           |
| event-link-tap    | String        | 点击链接(link)事件。**(0.4.6新增)**                          | 是           | 否           |

###  text-align

| 枚举值  | 对应枚举                     | 说明   |
| ---- | ------------------------ | ---- |
| 0    | NSTextAlignmentLeft      | 不解释  |
| 1    | NSTextAlignmentCenter    | 不解释  |
| 2    | NSTextAlignmentRight     | 不解释  |
| 3    | NSTextAlignmentJustified | 不解释  |
| 4    | NSTextAlignmentNatural   | 不解释  |

### underline-style(同throughline-style)

| 枚举值 | 对应枚举                     | 说明                               |
| ------ | ---------------------------- | ---------------------------------- |
| 0x00   | NSUnderlineStyleNone         | 不解释                             |
| 0x01   | NSUnderlineStyleSingle       | 可单独使用                         |
| 0x02   | NSUnderlineStyleThick        | 可单独使用                         |
| 0x09   | NSUnderlineStyleDouble       | 可单独使用                         |
| 0x0000 | NSUnderlinePatternSolid      | 需配合前面四种类型进行 `|`运算使用 |
| 0x0100 | NSUnderlinePatternDot        | 需配合前面四种类型进行 `|`运算使用 |
| 0x0200 | NSUnderlinePatternDash       | 需配合前面四种类型进行 `|`运算使用 |
| 0x0300 | NSUnderlinePatternDashDot    | 需配合前面四种类型进行 `|`运算使用 |
| 0x0400 | NSUnderlinePatternDashDotDot | 需配合前面四种类型进行 `|`运算使用 |
| 0x8000 | NSUnderlineByWord            |                                    |



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

3. 字体设置。

   指定字体名称以及字体大小，以`,`分隔。例如：字体为`黑体-简`，字体大小为14

   ```xml
   <lable text="字体" font="Heiti SC,14"/>
   ```

   如果不指定字体大小，那么默认大小为**`12`**

4. 下划线:

   ```xml
   <!--由于gic 支持绑定的时候执行JS脚本，因此可以直接让JS计算 | -->
   <lable font-color="black" font-size="20" text="下划线2" underline-style="{{(0x01 | 0x0100)}}"/>
   ```

5. 删除线

   ```xml
   <!--由于gic 支持绑定的时候执行JS脚本，因此可以直接让JS计算 | -->
   <lable font-color="black" font-size="20" text="删除线2" throughline-style="{{(0x01 | 0x0100)}}"/>
   ```

6. 添加`link`

   > 当对`s`元素添加`link`属性后，就具备了触发`event-link-tap`事件的条件。

   ```xml
   <lable font-color="black" font-size="20" event-link-tap="js:alert($eventInfo)">
       <s text="链接1(点我)" font-color="gray" link="http://www.baidu.com" underline-style="{{(0x01 | 0x0100)}}"/>
       <s text="      "/>
       <s text="链接2(点我)" font-size="10" font-color="gray" link="http://ifeng.com" underline-style="{{(0x01)}}"/>
   </lable>
   ```


## 富文本

   从上面的例子中可以看到，lable提供了两种子元素来实现富文本。分别是`s`、`img`,`s`元素主要是用来显示文本的，而`img`主要是用来显示图标的，当前只能支持本地图标，不支持网络图标。**富文本也是支持数据绑定的**

   ## s元素属性

| 名称             | 数据类型 | 介绍                                                         | 是否支持绑定 | 是否支持动画 |
| ---------------- | -------- | ------------------------------------------------------------ | ------------ | ------------ |
| text             | String   | 文本内容                                                     | 是           | 否           |
| font-color       | UIColor  | 文本颜色                                                     | 是           | 否           |
| font-size        | float    | 字体大小                                                     | 是           | 否           |
| background-color | UIColor  | 文本背景色                                                   | 是           | 否           |
| link             | string   | 链接字符串。只有设置了link属性才能触发`lable`元素的`event-link-tap`事件。**(0.4.6新增)** | 是           | 否           |

   ## img 元素属性

| 名称       | 数据类型   | 介绍   | 是否支持绑定 | 是否支持动画 |
| -------- | ------ | ---- | ------ | ------ |
| img-name | String | 文本内容 | 是      | 否      |