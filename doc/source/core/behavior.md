# 行为

虽然`gic`中很多核心功能都是通过`behavior`来实现的，但是单独的`behavior`却一个也没有。这个不是说`behavior`不重要，而是因为`behavior`太灵活了，而且自定义也很简单，因此直接将`behavior`交给你自己来实现。

所以这里不能直接讲`gic`中的`behavior`，因为没有，而是直接说下如何自定义`behavior`。

先来说个需求，`UITableView`本身并不提供`下拉刷新`的功能，如果需要下拉刷新的功能，我们要么自定义，要么直接使用第三方库，比如`MJRefresh `。这里就以`下拉刷新`为例，看下如何封装一个具有`下拉刷新`功能的`behavior`。详细的实现流程可以直接查看sample中`行为`的例子。



你要自定义`behavior`，那么你必须先创建一个继承自`GICBehavior `的类,这里就以`PullRefreshBehavior`来命名，然后实现`gic_elementName `方法返回这个`behavior`在XML的元素名称。

```objective-c
@implementation PullRefreshBehavior
+(NSString *)gic_elementName{
    return @"bev-pullrefresh";
}
@end
```



然后实现`attachTo `方法，这个方法是在`behavior`被附加到某个元素上的时候调用的，方法传过来的`target`参数，就是被附加的目标对象。由于`behavior`可以被附加到任何元素上，而像`下拉刷新`这样的`behavior`有特定的附加目标的，比如必须被附加到list元素上，list元素在`gic`中的实现是`GICListView `,因此在`attachTo `方法里面我们需要先判断下目标是否是我们预先设计的目标。如果是`GICListView `，那么我们就开始对`GICListView `添加一个下拉刷新的功能，这里下拉刷新功能使用`MJRefresh `来实现。具体代码如下：

```objective-c
-(void)attachTo:(GICListView *)target{
    [super attachTo:target];
    if([target isKindOfClass:[GICListView class]]){
        // 必须在UI线程访问view
        dispatch_async(dispatch_get_main_queue(), ^{
            target.view.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(onRefresh)];
        });
    }
}
```

`GICListView`是从`Texture`库的`ASTableNode `继承过来的，而考虑到解析又可能在后台进行解析的情况，因此在访问`ASTableNode `的`view`属性的时候必须确保是在主线程上访问的，因此这里使用GCD调度到主线程实现。

到这里，其实已经自定义了一个具有`下拉刷新`的`behavior`了。

定义好了，别忘了将整个`behavior`注册到`gic`的缓存中。调用如下方法注册：

```objective-c
[GICElementsCache registBehaviorElement:[PullRefreshBehavior class]];
```

现在你就可以在XML中写了。

```xml
<list>
    <behaviors>
        <bev-pullrefresh/>
    </behaviors>
</list>
```

但是仅仅是这样的话，其实并没什么卵用。因为没有事件啊，因此我们需要在自定义的`behavior`添加一个事件，在`gic`中事件是以属性的形式定义的，时间的通常以`event`作为前缀，因此这里我们可以定义一个叫做`event-refresh `的事件

```objective-c
@interface PullRefreshBehavior : GICBehavior
@property (nonatomic,strong)GICEvent *refreshEvent;
@end

@implementation PullRefreshBehavior  
+(NSString *)gic_elementName{
    return @"bev-pullrefresh";
}
+(NSDictionary<NSString *,GICAttributeValueConverter *> *)gic_elementAttributs{
    return @{
             @"event-refresh":[[GICStringConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 PullRefreshBehavior *item = (PullRefreshBehavior *)target;
                 item.refreshEvent = [[GICEvent alloc] initWithExpresion:value];
                 [item.refreshEvent attachTo:target];
             }],
             };
}

-(void)attachTo:(GICListView *)target{
    [super attachTo:target];
    if([target isKindOfClass:[GICListView class]]){
        // 必须在UI线程访问view
        dispatch_async(dispatch_get_main_queue(), ^{
            target.view.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(onRefresh)];
        });
    }
}

-(void)onRefresh{
    [self.refreshEvent fire:nil];
}
@end
```

`gic_elementAttributs`是`GICLayoutElementProtocol `协议的一个方法，用来告知`gic`解析的时候如何解析xml中属性的。而事件，本身也算是`behavior`的一种，因此用户绑定事件的时候，你就需要将整个事件附加目标上，这里附加的目标就是`PullRefreshBehavior`本身。

而当`MJRefresh`触发刷新的时候，我们直接调用我们自定义的事件的`fire`方法就行了。这样事件定义完了，下一步就是在XML中绑定事件，以及实现事件的回调了。

```objective-c
<bev-pullrefresh event-refresh="onRefreshData"/>
```

这里在xml中绑定了一个事件，事件的回调名称是`onRefreshData`，这个方法需要你在`ViewModel`中定义。



现在事件回调也有了，但是运行的时候你会发现，加入load完了，怎么通知`PullRefreshBehavior`load完了，然后结束动画呢，依然还是通过定义个属性来实现，这里添加一个`loading`的属性，用来指示是否在加载数据。



```objective-c
+(NSDictionary<NSString *,GICAttributeValueConverter *> *)gic_elementAttributs{
    return @{
             @"event-refresh":[[GICStringConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 PullMoreBehavior *item = (PullMoreBehavior *)target;
                 item.refreshEvent = [[GICEvent alloc] initWithExpresion:value];
                 [item.refreshEvent attachTo:target];
             }],
             @"loading":[[GICBoolConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 PullMoreBehavior *item = (PullMoreBehavior *)target;
                 item.isLoading = [value boolValue];
             }],
             };
}

-(void)setIsLoading:(BOOL)isLoading{
    _isLoading = isLoading;
    if(isLoading){
        dispatch_async(dispatch_get_main_queue(), ^{
            MJRefreshFooter *header = ((GICListView *)self.target).view.mj_footer;
            if(!header.isRefreshing){
                [header beginRefreshing];
            }
        });
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [((GICListView *)self.target).view.mj_footer endRefreshing];
        });
    }
}
```

```xml
<bev-pullrefresh event-refresh="onRefreshData" loading="{{exp=isRefreshing,mode=1}}"/>
```

这样，一个完整的具有下来刷新功能的`behavior`就完成了。



## 总结

事实上，你可以将任何功能都可以`behavior`的形式进行封装，然后直接在xml中附加到任何元素上面。这样一来可以使得在项目的架构设计的时候，尽可能的将功能单一化，将项目解耦。

但是如果在实际的项目中，将所有的单一功能都以`behavior`的形式进行封装，那么势必也会造成一定的`behavior`碎片化，因此这时候你可以考虑将一些功能直接封装成自定义元素好了。