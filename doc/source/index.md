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

`gic`主要是解决了在iOS上开发UI费时费力的问题，而在使用`gic`的时候，你无需费心计算UI的frame，也无需使用autolayout布局。你可以看下sample中的一个模拟头条Feeds的例子，里面模拟了头条的8个模板，而实际用来描述UI的xml代码只需要100多行就能搞定，你无需计算cell的高度，也无需设置cell的identifystring，这个如果你采用autolayout、或者frame布局的情况下是不可能做到的(虽然底层还是iOS的frame那一套)，而且`gic`得益于`Texture`，在性能已经有了大幅度的优化，你可以在真机上跑下看看，滑动的时候没有卡顿的情况，用instrument的coreAnimation测试也不会有性能问题。你也可以横屏试试，横屏的时候会自动重新布局，而且没有任何的性能问题，在模拟头条feeds那个例子中，图片使用的是比例布局，你如果横屏的话，图片也会按照比例重新布局。

`gic`在布局系统上采用的是`Texture`布局系统，因此可以完整的支持`flex布局`,还有`比例布局`,`停靠布局`等一些常用的布局。通过不同的布局组合，可以实现很多复杂的布局。

使用gic，你可以使用纯粹的`MVVM模式`来开发，在`viewmodel`中你无需直接跟UI打交道，全部使用`数据绑定`来实现,就像h5中使用`vue`开发那样的简单。 

除看之下，您可能会觉得跟RN、weex等比较像，但是`gic`库的开发初衷并不是去替代`RN`、`weex`，`gic`的开发初衷就是简化`iOS`的开发，由于使用xml来写界面，因此顺带着具备远程更新UI的能力。如果您仔细看了例子中的`模拟头条Feeds`这个例子，您就会发现，写一个Feeds类的界面是多么的方便、高效率。而且依托于`Texture`，在性能上也有较大的优势。

您可以直接运行项目中的sample，直观的感受下`gic`库的优势。

事实上，`gic`也是有跨平台的潜力的，因为最起码对于UI层来说，`gic`就是一个元素、属性的map工具，因此在安卓上也能实现。

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