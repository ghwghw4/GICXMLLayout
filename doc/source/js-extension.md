# JS API扩展

gic中的js脚本执行是基于`JavaScriptCore`开发的，而`JavaScriptCore`对JS的api支持是有限的，因此一些常用的API可能需要开发者自己去扩展。在此基础上，你甚至可以扩展出属于自己的一套独有的API。

而gic中要实现扩展，只需要实现`GICJSAPIRegisterProtocl `协议即可，然后在app启动的时候通过`GICJSAPIManager `中的`addJSAPIRegisterClass `方法将实现该协议的class添加到缓存中。另外，实现扩展是直接对`JSContext`进行扩展，因此具体的教程参考官方文档：

教程：这里以实现一个AlertView弹出框为例

## Step1  实现`GICJSAPIRegisterProtocl `协议

```objective-c
@interface JSAPIExtension : NSObject<GICJSAPIRegisterProtocl>
@end
@implementation JSAPIExtension
+(void)registeJSAPIToJSContext:(JSContext*)context{
    context[@"AlertView"] = [JSAlert class];
}
@end

@protocol JSAlert <JSExport>
@property NSString* message;
@property NSString* title;

-(instancetype)init;
-(void)show;

JSExportAs(addButton, - (void)addButton:(NSString *)buttonName clicked:(JSValue *)callback);
@end



@interface JSAlert : NSObject<JSAlert>

@end


@implementation JSAlert{
    UIAlertController *alertVC;
}

@synthesize title;

-(id)init{
    self = [super init];
    alertVC = [UIAlertController alertControllerWithTitle:@"" message:nil preferredStyle:UIAlertControllerStyleAlert];
    return self;
}

-(void)setTitle:(NSString *)title{
    alertVC.title = title;
}

-(NSString *)title{
    return alertVC.title;
}

-(void)setMessage:(NSString *)message{
    alertVC.message = message;
}

-(NSString *)message{
    return alertVC.message;
}


- (void)addButton:(NSString *)buttonName clicked:(JSValue *)callback {
    [alertVC addAction:[UIAlertAction actionWithTitle:buttonName style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [callback callWithArguments:nil];
    }]];
}

- (void)show {
    [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:alertVC animated:YES completion:nil];
}

@end
```

## Step2 注册

在app启动的时候注册扩展

```objective-c
 // 注册JSAPI扩展
 [GICJSAPIManager addJSAPIRegisterClass:[JSAPIExtension class]];
```

## Step3 JS代码中调用

```xml
<lable text="点我弹出提示框" font-size="18">
    <behaviors>
        <script private="1">
            $el.onclick = function(){
            var alertView = new AlertView();
            alertView.title = '标题';
            alertView.message = '内容';
            alertView.addButton('取消',function(){console.log('点击了取消')});
            alertView.addButton('确定',function(){console.log('点击了确定')});
            alertView.show();
            }
        </script>
    </behaviors>
</lable>
```

