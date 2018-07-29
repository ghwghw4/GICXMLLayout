# 开发工具

`gic`提供了一个远程的开发工具，支持动态加载远程的xml文件，达到边写xml，边预览UI的目的。目前工具还是比较简陋，不过凑合着还算能用。步骤如下：

1. 首先下载git中的源码，进入`tools`目录，将目录下的文件拷贝到你实际的项目中。

2. 修改`dev-tools.sh`内容。你可以修改http 端口，以及将目录映射到你的项目目录。

3. 启动工具。执行如下命令。

   ```bash
   bash dev-tools.sh
   ```

    这时候你可以打开浏览器，输入地址就能看到目录中的文件了。

   这样本地的一个建议的http服务器就弄好了。

4. 在pod 中添加如下：

   ```bash
   pod 'GICXMLLayout/dev'
   ```

   然后执行pod install

5. 在项目中创建一个用来远程调试的xml文件

6. 然后在项目中添加如下代码：

   ```objective-c
    UIViewController *page = [GICXMLLayoutDevTools loadXMLFromUrl:[NSURL URLWithString:@"http://localhost:8080/xxxx.xml"]];
           UINavigationController *nav =[[UINavigationController alloc] initWithRootViewController:page];
           [UIApplication sharedApplication].delegate.window.rootViewController =nav;
   ```

   这里面解释下.

   >  使用`GICXMLLayoutDevTools`从远程加载刚才你创建的xml文件。

7. 启动模拟器或者真机，当代码执行到第6步的代码的时候就会自动去加载了。

8. 在电脑上编写xml文件。

9. 在app中点击右下角的`reload`按钮，这时候`gic`就会从新加载xml文件，并且刷新界面。



注意点：

1. 在调试的时候，xml中的root元素必须是UI元素或者是panel。不能是`page`或者其他的非UI元素。
2. 调试的时候你可以直接以json字符串作为某个元素的数据源来显示数据。等调试完了以后再使用真实的ViewModel作为数据源。
3. 由于XCode对于XML编辑实在不是很友好，因此推荐使用专门用来开发前端的IDE来写xml，这里推荐下`intellij IDEA`这个ide工具，它会自动缓存xml节点，只要xml文件中某个节点、属性出现了一次，那么在这个xml中第二次写这个属性或者节点的时候，ide会有自动提示功能，因此写起来较为方便。事实上这样一来，配合工具的使用，使得写iOS的UI变得是一件异常简单、轻松的事情。