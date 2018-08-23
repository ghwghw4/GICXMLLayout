# GICXMLLayout

[![CI Status](https://img.shields.io/travis/ghwghw4/GICXMLLayout.svg?style=flat)](https://travis-ci.org/ghwghw4/GICXMLLayout)
[![Version](https://img.shields.io/cocoapods/v/GICXMLLayout.svg?style=flat)](https://cocoapods.org/pods/GICXMLLayout)
[![License](https://img.shields.io/cocoapods/l/GICXMLLayout.svg?style=flat)](https://cocoapods.org/pods/GICXMLLayout)
[![Platform](https://img.shields.io/cocoapods/p/GICXMLLayout.svg?style=flat)](https://cocoapods.org/pods/GICXMLLayout)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

# 介绍

`GICXMLLayout`以下简称`gic`，是一个以XML来描述UI的一个库，同时兼有MVVM的功能。`gic`能够做什么？

1. 以XML来描述UI、动画等。
2. 纯粹的MVVM
3. 支持`数据绑定`,类似h5中`Vue`提供的数据绑定能力
4. 支持`模板功能`类似于h5中的模板功能。
5. 强大的布局系统，甚至提供flex等复杂高效的布局
6. 强大的自定义能力，能够使得开发者按照自己的意愿扩展出能够直接使用XML来描述的任意功能。
7. 具有局部替换能力，可以对现有项目进行局部替换，使得局部功能具备MVVM+XML的能力。
8. 由于是直接采用XML来描述，因此天生具备实时更新的能力
9. `gic`的布局系统以及UI系统是基于`Texture`开发的，因此天生具有强大的性能优势

# 在线文档

[在线文档链接](http://gicxmllayout.gonghaiwei.cn/index.html)

## Installation

GICXMLLayout is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'GICXMLLayout'
```



## Swift支持

从`0.2.1`版本开始，`GICXMLLayout`可以支持swift语言。但是由于`GICXMLLayout`本身是基于OC开发的，因此在Swift中使用的时候需要使用桥接。步骤如下：

1. 创建一个头文件。比如：`Bridging-Header.h`

2. 在头文件中添加如下头文件引用。

   ```objective-c
   #ifndef Bridging_Header_h
   #define Bridging_Header_h
   #import <GICXMLLayout/GICXMLLayout.h>
   #endif /* Bridging_Header_h */
   ```

3. 进入项目的`build settings`。然后找到`Objective-C Bridging Header`选项，将头文件的路劲添加上去。比如：

   ![18](doc/source/images/18.jpg)

这样就可以在`Swift`中使用`GICXMLLayout`。

**另外一个需要注意点：**

1. 所有的ViewModel都必须继承自`NSObject`

2. 由于在Swfit4中， 继承自NSObject的Swift class 不再默认 BRIDGE 到 OC了，因此需要在class前面加上`@objcMembers` 这么一个关键字。比如

   ```swift
   @objcMembers class ViewModel: NSObject {
       ...
   }
   ```

3. 不支持对Int? Float?等值类型的可空解析。因此在定义swift class 的时候避免使用 值类型的可空类型。但是String、Array、Dictionary是可以定义成可空类型的。

   

> 事实上，不只是ViewModel需要遵循以上的规则，所有在ViewModel中使用到的class，都必须遵循上述规则。



## 更新日志

### 0.1.1

1. 新增样式(style)功能。[文档](http://gicxmllayout.gonghaiwei.cn/core/style.html)

   > 您现在可以为您的UI元素添加样式了，您也可以将样式定义在单独的XML文件中，这样您可以为你的APP添加类似主题(theme)的功能了

### 0.2.0

1. 增加`canvas`元素,当前处于`beta`阶段，但已经可以使用。[canvas文档](http://gicxmllayout.gonghaiwei.cn/ui/canvas.html)

   > 你现在可以直接使用`xml`来实现类似`Core Graphics`那样的功能了。你甚至可以直接使用`canvas`来实现一个报表，还支持动画哦。

2. 对`inpute`元素增加`keyboard-type `的支持。[文档](http://gicxmllayout.gonghaiwei.cn/ui/input.html)

3. 增加`control`元素。[文档](http://gicxmllayout.gonghaiwei.cn/ui/control.html)

   > `control`的功能类似`UIControl`，提供`enable`、`highlight`、`selected`等状态管理。

4. 增加`data-context`元素。[文档](http://gicxmllayout.gonghaiwei.cn/core/databingding.html)

   > 现在可以直接将一大段json 字符串作为数据源添加到`data-context`中了。

5. 增加`router`模块。[文档](http://gicxmllayout.gonghaiwei.cn/router.html)

### 0.2.1

增加对Swift的支持

### 0.2.2

1. `lable`元素增加对`font`属性的支持，现在可以为`lable`指定字体了。
2. `canvas`元素中的`path`新增`dash`属性，现在可以为线条添加虚线的设置了。



## Author

海伟, 693963124@qq.com

## License

GICXMLLayout is available under the MIT license. See the LICENSE file for more info.
