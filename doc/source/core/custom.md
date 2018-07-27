# 自定义

`gic`提供了强大的自定义能力，而且自定义也非常的简单你可以，`gic`提供了如下的自定义能力：

1. 自定义元素。包括UI元素、Panel
2. 对已有元素进行属性扩展。
3. 自定义`behavior`
4. 自定义动画
5. 自定义事件
6. 自定义指令

通过以上的自定义能力，可以不夸张的说，你可以实现任何你想要的功能。事实上，如果是对已有的项目进行改造，自定义过程其实是一个简单对已有功能封装的过程。



## 自定义元素

其实只要是在XML中能写出来的，都属于元素，也就是说你可以自定义任何的元素。这里举一个自定义一个`switch-button`元素的例子。`switch-button`属于UI元素，而在`gic`中，所有的UI元素都必须是继承自`ASDisplayNode `的，这是因为`gic`的布局系统是基于`Texture`开发的，那么UI势必也要是`ASDisplayNode `了。

因此首先是创建一个继承自`ASDisplayNode `的类,命名为`SwitchButton `,然后是实现`gic_elementName `方法，返回元素名称。

```objective-c
@interface SwitchButton : ASDisplayNode<GICLayoutElementProtocol>
@end

@implementation SwitchButton
+(NSString *)gic_elementName{
    return @"switch-button";
}
-(id)init{
    self = [super init];
    __weak typeof (self) wself = self;
    [self setViewBlock:^UIView * _Nonnull{
        UISwitch *swicth= [[UISwitch alloc] init];
        [swicth sizeToFit];
        wself.style.width = ASDimensionMake(swicth.frame.size.width);
        wself.style.height = ASDimensionMake(swicth.frame.size.height);
        return swicth;
    }];
    self.backgroundColor = [UIColor clearColor];
    return self;
}
@end
```

这里面注意init方法，在init方法里面调用了`setViewBlock`的方法，在block里面创建一个`UISwitch`并且初始化自身的高宽。其实这完全是`ASDisplayNode `的一套规则，具体的可以参考如下链接。

[ASDisplayNode 参考](http://texturegroup.org/docs/display-node.html)

下一步就是将该元素注册到元素池里面，

```objective-c
// 注册自定义元素
[GICElementsCache registElement:[SwitchButton class]];
```

然后就可以直接在xml中使用了。

```xml
<switch-button />
```

但是仅仅是这样话，就没意思了。因为点击了又不会产生数据上的交互，因为我们需要添加一个属性，可以用来绑定数据。这里面就添加一个`checked `的属性，用来表示这个是否打开。另外`switch-button`本身自己就可以改变是否选中的状态，因此我们需要对这个属性做双向绑定的支持，以便在用户点击了按钮以后将是否选中的状态反向更新到数据源。

```objective-c
@implementation SwitchButton
+(NSString *)gic_elementName{
    return @"switch-button";
}

+(NSDictionary<NSString *,GICAttributeValueConverter *> *)gic_elementAttributs{
    return @{
             @"checked":[[GICBoolConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [((SwitchButton *)target).view setOn:[value boolValue]];
                 });
             }],
             };
}

-(id)init{
    self = [super init];
    __weak typeof (self) wself = self;
    [self setViewBlock:^UIView * _Nonnull{
        UISwitch *swicth= [[UISwitch alloc] init];
        [swicth sizeToFit];
        wself.style.width = ASDimensionMake(swicth.frame.size.width);
        wself.style.height = ASDimensionMake(swicth.frame.size.height);
        return swicth;
    }];
    self.backgroundColor = [UIColor clearColor];
    return self;
}

-(void)gic_createTowWayBindingWithAttributeName:(NSString *)attributeName withSignalBlock:(void (^)(RACSignal *))signalBlock{
    signalBlock([self.view rac_newOnChannel]);
}
@end
```

`gic_createTowWayBindingWithAttributeName`这个方式是`GICLayoutElementProtocol `协议的一部分，专门用来实现双向绑定的协议。这里面使用`ARC`来实现，因此需要你返回一个`RACSignal`。

好了，这样一个支持双向绑定的`switch-button`就完成了。然后在xml中写如下代码即可：

```xml
<switch-button checked="{{ exp=isShow,mode=2 }}"/>
```



### 属性转换器。

在上面的例子中，你有没有注意到自定义属性的那个地方`gic_elementAttributs`。`gic_elementAttributs`方法也是协议的一部分，告知解析器该元素支持哪些属性，由于xml中的value全部是字符串的，因此需要将字符串转换成不同的value，比如上面例子中，将字符串转换成Bool值,那么就需要使用`GICBoolConverter`，`gic`本身已经自带了很多的转换器了，针对不同的数据类型，你可以使用不同的转换器。而`gic`对于动画的支持也是通过属性转换器来实现的。你也可以在自定义的过程中实现自己的转换器，是需要创建一个继承自`GICAttributeValueConverter`的类并且实现里面的convert方法即可，当然如果你自定义的属性需要支持动画，那么还需要实现里面的`convertAnimationValue `方法。



##对已有元素进行属性扩展。

对已有的元素进行属性扩展也是简单之级，直接调用`GICElementsCache `的`injectAttributes:forElementName:`方法即可。比如，对`scorll-view`进行属性扩展。

```objective-c
// 对scroll-view注入扩展属性
    [GICElementsCache injectAttributes:@{ @"inset-behavior":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
        if (@available(iOS 11.0, *)) {
            // 考虑到解析的时候有可能是非UI线程解析的，这里使用GCD在主线程上访问view
            dispatch_async(dispatch_get_main_queue(), ^{
                [(UIScrollView *)((ASDisplayNode *)target).view setContentInsetAdjustmentBehavior:[value integerValue]];
            });
        }
    }]} forElementName:@"scroll-view"];
```

## 自定义`behavior`

自定义`behavior`在`behavior`一节已经介绍过了，直接去看就行了。

## 自定义动画

自定义动画的方式可以直接参考源码中的`GICAttributeAnimation `，这是`gic`实现属性动画的类，代码比较少，实现方式也很简单，相信你一看就能明白的。

## 自定义事件

事件的自定义在介绍自定义behavior一节也已经提到过了，可以直接看`behavior`那一节



## 自定义指令

自定义指令，你可以参考源码中的`GICDirectiveIf `实现，也很简单，相信你能一看就懂。你也可以试着自定义一个`switch`指令