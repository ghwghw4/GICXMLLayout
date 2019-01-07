# 附加属性

`附加属性`系统是`0.5.0`版本新增的功能，区别于`普通属性`，`附加属性`是专门提供给`子元素`设置的。

比如：`grid-panel`提供了一个`column-span`的附加属性，如果子元素设置了该属性，那么在显示的时候就能跨列显示。

```xml
<grid-panel columns="3" column-spacing="10" row-spacing="10">
    <!-- grid-panel.column-span="2" -->
    <dock-panel height="30" background-color="red" grid-panel.column-span="2">
        <lable text="1" />
    </dock-panel>
</grid-panel>
```

`附加属性`在设置属性的时候有一个特点，那就是在属性之前必须添加父元素的名称并且加上`.`来连接。比如上面的`grid-panel.column-span`，意味着设置了一个由`grid-panel`提供的`column-span`属性。



## 注意点：

`附加属性`支持数据绑定，但是只支持`once`模式(默认绑定模式)，这也就意味着`附加属性`不支持`动画`。





## 自定义元素添加附加属性

首先自定义元素需要实现`GICLayoutElementProtocol`协议中的`gic_elementAttachAttributs`方法。而且该自定义元素必须显示使用`GICElementsCache`来注册，否则`GIC`无法识别。



实现代码如下：

```objective-c
+(NSArray<GICAttributeValueConverter *>*)gic_elementAttachAttributs{
    return @[[[GICNumberConverter alloc] initWithName:GridPanelAttachColumnSpanKey withSetter:^(NSObject *target, id value) {
                 [[target gic_ExtensionProperties] setAttachValue:value withAttributeName:GridPanelAttachColumnSpanKey];
             }]];
}
```



由于该属性是提供给子元素使用的，因此需要将该value保存到子元素中。也就是通过如下代码设置value。

```objective-c
[[target gic_ExtensionProperties] setAttachValue:value withAttributeName:GridPanelAttachColumnSpanKey];
```

使用如下方法来获取属性。

```objective-c
[[target gic_ExtensionProperties] attachValueWithAttributeName:GridPanelAttachColumnSpanKey];
```



