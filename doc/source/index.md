title: GICXMLLayout
---

# GICXMLLayout

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

想要查看`gic`提供的sample可以直接将项目pull下来，然后在模拟器中运行查看，或者在真机上运行。模拟器中运行`动画`会自动停止，请以真机为准。

[项目地址](https://github.com/ghwghw4/GICXMLLayout)

[待开发功能列表](feature-list.html)

## 安装

1. 在项目的podfile中添加如下代码:

```ruby
pod 'GICXMLLayout'
```

2. 然后执行

```Ruby
pod update
```

3. 在AppDelegate 的`didFinishLaunchingWithOptions `方法下，注册所有元素。所有元素包括UI元素以及核心元素

   ```objective-c
   // 注册gic类库默认所有元素
   [GICXMLLayout regiterAllElements];
   ```

   或者你可以只注册核心元素即可。

   ```objective-c
   [GICXMLLayout regiterCoreElements];
   ```

   但是这样一来UI元素就必须全部使用你自定义的元素才行。

4. 解析xml文件。通过`GICXMLLayout`的`parseLayoutPage`直接解析一个页面

   ```objective-c
   NSData *xmlData = [NSData dataWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/IndexPage.xml"]];
       [GICXMLLayout parseLayoutPage:xmlData withParseCompelete:^(UIViewController *page) {
           UINavigationController *nav =[[UINavigationController alloc] initWithRootViewController:page];
           self.window.rootViewController =nav;
       }];
   ```

   或者你可以通过`GICXMLLayout`的`parseLayoutView `解析一个view，然后将该view替换到已有的view之中。