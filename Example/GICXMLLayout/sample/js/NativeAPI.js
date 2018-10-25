// 定义NSUserDefaults 方便后续API使用
GICDefineClass('NSUserDefaults',null,[{setValue:'setValue:forKey:'},{valueForKey:'valueForKey:'}],[{standardUserDefaults:'standardUserDefaults'}]);

// 定义UIDevice
GICDefineClass('UIDevice',['name','systemName','model','systemVersion'],null,[{currentDevice:'currentDevice'}]);


// 其实直接调用native API 对于GIC来说，并不是一件必须的事情，因为你可以直接通过JS来操作元素，并且写业务逻辑，因此native api尽量只做一些辅助类的事情
// 通过native aPI 直接操作View 这样的事情并不明智，你大可以自定义一个元素，然后再去操作