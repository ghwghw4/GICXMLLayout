# 数据绑定

`gic`中的`数据绑定`以两对`{}`表示，支持两种方式。



1. 直接以 `exp`形式表达。这样默认是以once来实现绑定，也就是一次性绑定。比如：

   ```xml
   text="{{ '姓名：' + name }}"
   ```

   如果`exp`为空，那么直接数据源的desc属性作为value，这种直接为空的的绑定方式在数据源是字符串的时候尤其方便。

2. 以`exp=exp,mode=1,cvt=converter`的形式来写。事实上这种方式才是一种比较完整的数据绑定的写法，exp:表示绑定的表达式，支持一小段简单的js代码。mode:表示绑定模式，下面会讲。cvt:转换器，也就是将经过exp中的表达式运算过后得到的字符串转换成其他的数据。

   ```xml
   text="{{ exp=timeStamp,mode=1,cvt=TimestampConverter }}"
   ```
   
## exp(表达式)

绑定表达式支持一小段js代码，也支持以单个的数据源属性的名称进行绑定。



## mode(绑定模式)

数据绑定有三种模式，分别是：`once(一次性)`、`oneway(单向)`、`towway(双向)`。默认是once，这个主要考虑了性能问题，另外一个也是考虑了大多数绑定的数据不会发生变更。

| 枚举值 | 对应枚举               | 说明                                                         |
| ------ | ---------------------- | ------------------------------------------------------------ |
| 0      | GICBingdingMode_Once   | 只会绑定一次，数据的改变不会再次更新                         |
| 1      | GICBingdingMode_OneWay | 单向绑定，每次数据源改变，都会更新绑定                       |
| 2      | GICBingdingMode_TowWay | 双向绑定，在单向绑定的基础上，增加了反向绑定，也就是说当本身某个数据改变的时候也会影响数据源本身的数据 。目前`gic`本身的类库中支持双向绑定的，只有`input`、`intput-view`中的`text`属性支持双向绑定。你也可以在自己的自定义元素中对某些属性进行双向绑定的支持，只要实现`GICLayoutElementProtocol `协议中的`gic_createTowWayBindingWithAttributeName `方法即可。**双向绑定的表达式只能是单个的属性，不支持js表达式。** |


## cvt(转换器)

转换器其实类似于`angularjs`中的`piple`，也即是将表达式的值转换成其他的数据。`转换器`必须是继承自`GICDataBingdingValueConverter `的某个类，实现里面的`convert`方法即可,返回值就是对应的属性数据类型，具体某个属性对应的数据类型可以参考文档。

这里以实现将时间戳转换成年月日为例：

```objective-c
@interface TimestampConverter : GICDataBingdingValueConverter
@end
@implementation TimestampConverter
-(id)convert:(NSString *)stringValue{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[stringValue doubleValue]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy MM dd HH:mm:ss"];
    return [formatter stringFromDate:date];
}
@end
```

然后在xml如下写：

```xml
text="{{ exp=timeStamp,mode=1,cvt=TimestampConverter }}"
```


## 数据源(data-context)

绑定需要数据源，有数据源才能将绑定的表达式根据数据源的属于计算出对应的value。在xml中可以有三种方式来设置数据源，数据源可以在任何元素上设置。

1. 直接以一个字符串作为数据源，这种数据源没有属性的概念，因此只能以空的表达式绑定。比如：

   ```xml
    <lable text="{{}}" font-color="black" data-context="我是直接绑定字符串"/>
   ```

2. 以json字符串作为数据源。比如：

   ```xml
   <stack-panel data-context='{"name":"海伟","age":"20"}'>
       <lable text="{{ '姓名：' + name }}" font-color="black" />
       <lable text="{{ '年龄：'+age+'岁' }}" font-color="black" />
   </stack-panel>
   ```

3. 以某个`ViewModel`的类作为数据源。`gic`可以说是一个`MVVM`框架，UI跟ViewModel是分离的，而`ViewModel`可以是任何一个NSObject的子类。

   ```xml
   <stack-panel data-context='DataBindingUserInfo'>
       <lable text="{{ '姓名：' + name }}" font-color="black" />
       <lable text="{{ '年龄：'+age+'岁' }}" font-color="black" />
   </stack-panel>
   ```

   ```objective-c
   @interface DataBindingUserInfo : NSObject
   @property (nonatomic,strong)NSString *name;
   @property (nonatomic,assign)NSInteger age;
   @end
   @implementation DataBindingUserInfo
   -(id)init{
       self = [super init];
       _name = @"海伟1";
       _age = 22;
       return self;
   }
   @end
   ```

上面三种方式虽然在xml中是以字符串的形式设置，但是`gic`在解析的时候，会按照`json`、`ViewModel`、`字符串`的顺序依次解析。

**而且你也无需为每个元素都设置数据源，所有的子孙元素都共享离该元素最近的数据源，因此，你如果xml中的根元素上设置了一个数据源，那么所有的元素都共享该数据源。**

你也可以直接通过OC代码来设置数据源。代码如下：

```objective-c
el.gic_DataContenxt = [DataBindingUserInfo new];
```

也就是对该元素的`gic_DataContenxt`属性赋值即可。





这里对于双向绑定的数据源有几个点需要注意下：

1. 对于需要双向绑定的数据源，必须确保绑定的数据源属性是可写的。在iOS中也就是意味着该属性必须是可以通过`setValue:forKey:`方法设置的。而`NSDictionay`就不支持了，`NSMutbleDictionay`是支持的。

## data-path

`data-path`跟`data-context`其实是同级的，两个属性是互斥的，你不应该在同一个节点上同时设置这两个属性。`data-path`也是用来设置当前元素的数据源的，但是跟`data-context`不一样的地方在于，`data-context`是直接设置当前元素的数据源，而`data-path`是将当前元素的数据源绑定到父元素数据源的某个属性上面。举个例子：

有两个类A、B，A有个属性的实例是B，也就是说A包含B。这时候我在XML中希望将某个元素的数据源设置为B，那么这时候只要直接将该元素的`data-path`设置为B就行了。

而实现这一点的原理其实很简单，`gic`直接通过`valueForKey:`的方法获取b的实例，然后再将B设置为该元素的data-context。

当然设计`data-path`的目的其实也是为了弥补当前数据绑定不支持按照path获取value的问题。**也就是说你无法通过path那样的方式实现单向、双向数据绑定，但是once绑定是可以支持path的。**
