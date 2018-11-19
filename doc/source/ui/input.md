# input

`input`其实就是`UITextField`，也是`gic`库中两个支持双向绑定的元素之一，另外一个就是`input-view`。

input当前支持的属性有限，但是如果需要支持其他的属性，比如：对keyboard的支持，那么大可以对input直接注入新的属性来实现。

## 属性

| 名称            | 数据类型      | 介绍                         | 是否支持绑定     | 是否支持动画 |
| --------------- | ------------- | ---------------------------- | ---------------- | ------------ |
| placehold       | string        | 不解释                       | 否               | 否           |
| placehold-color | UIColor       |                              | 否               | 否           |
| placehold-size  | Float         | placehold字体大小            | 否               | 否           |
| font-color      | UIColor       |                              | 是               | 是           |
| font-size       | float         |                              | 是               | 是           |
| text            | string        |                              | 是(支持双向绑定) | 是           |
| secure          | bool          |                              | 是               | 是           |
| keyboard-type   | integer(枚举) | 键盘类型                     | 是               | 否           |
| event-return    | Event         | 点击回车事件                 | 否               | 否           |
| content-inset   | UIEdgeInsets  | 内容边距(只适用`input-view`) | 是               | 是           |

###  keyboard-type 枚举

| 枚举值 | 对应枚举                            | 说明 |
| ------ | ----------------------------------- | ---- |
| 0      | UIKeyboardTypeDefault               |      |
| 1      | UIKeyboardTypeASCIICapable          |      |
| 2      | UIKeyboardTypeNumbersAndPunctuation |      |
| 3      | UIKeyboardTypeURL                   |      |
| 4      | UIKeyboardTypeNumberPad             |      |
| 5      | UIKeyboardTypePhonePad              |      |
| 6      | UIKeyboardTypeNamePhonePad          |      |
| 7      | UIKeyboardTypeEmailAddress          |      |
| 8      | UIKeyboardTypeDecimalPad            |      |
| 9      | UIKeyboardTypeTwitter               |      |
| 10     | UIKeyboardTypeWebSearch             |      |
| 11     | UIKeyboardTypeASCIICapableNumberPad |      |





## 例子

```xml
<input font-color="blue" font-size="16" border-color="black" border-width="0.5" text="{{ exp=name,mode=2}}" placehold="请输入用户名" placehold-color="red" placehold-size="16" height="31"/>
```





# input-view

`input-view`就是`UITextView`，同样支持双向绑定。

`input-view`支持的属性跟`input`一样。



```Xml
<input-view font-color="yellow" font-size="16" border-color="black" border-width="0.5" text="你是input-view" placehold="请输入用户名" height="100"/>
```

