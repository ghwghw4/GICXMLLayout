# router

`router`提供了对整个app的管理。提供了`app`、`nav`、`page`、`nav-bar`、`bev-router-link `等元素。

如果要使用`router`功能，你需要在podfile中添加如下代码。

```python
pod 'GICXMLLayout/Router'
```

然后执行 `pod install`或者`pod update`命令。

当前`router`提供的路由功能还有限，只是提供了基本的`导航+传参`功能。

## app

`app`元素其实是一个`空元素`，或者你可以理解为`UIWindow`,单独使用的时候没有作用的。必须搭配子元素使用，并且使用`GICRouter `的`loadAPPFromPath:`方法来解析才有用。当解析完毕后就会自动将当前的windowd的rootViewController 设置为`app`的子元素。

`app`的子元素是可以任意从`UIViewController`继承过来的自定义元素。这也就意味着，你可以将你项目中任意一个`UIViewController`直接封装成自定义元素，然后就可以直接在xml中使用了，改造非常的简单。

## nav

`nav`元素其实就是对`UINavigationController`的封装，因为也是继承自`UIViewController`，因为可以直接作为`app`的子元素。

目前`router`模块提供的导航功能，基本都是由`nav`元素来实现的，因此，如果项目中需要使用导航功能的，那么`nav`元素是必不可少的。

### 属性

| 名称             | 数据类型 | 介绍     | 是否支持绑定 | 是否支持动画 |
| ---------------- | -------- | -------- | ------------ | ------------ |
| background-color | UIColor  | 背景色。 | 是           | 是           |

`nav`当前只提供了一个`background-color `的属性，其实就是对`UINavigationController`的`view`设置背景色。



由于`UINavigationController`需要一个`rootViewController`，因此`nav`也提供了两种方式来设置`rootViewController`。

1. `root-page `子元素。通过`root-page `的`path`属性，你可以设置`rootViewController`对应的路径。这样在`gic`解析的时候就会自动加载`path`对应的xml文件作为`rootViewController`。如下面代码：

   ```xml
   <app>
       <nav>
           <root-page path="IndexPage.xml"/>
       </nav>
   </app>
   ```

2. 直接以`page`元素作为`nav`的子元素，你可以添加多个自定义`page`元素，`nav`会依次将自定义`page`元素添加到`nav`的viewControllers中。

   ```xml
   <app>
       <nav background-color="white">
           <chats-page/>
       </nav>
   </app>
   ```

   这里直接将一个聊天页面作为`rootViewController`添加到`nav`元素中。



## page

`page`元素顾名思义，代表的就是`页面`，而在实现的时候其实就是一个`UIViewController`的自定义元素。

### 属性

| 名称  | 数据类型 | 介绍 | 是否支持绑定 | 是否支持动画 |
| ----- | -------- | ---- | ------------ | ------------ |
| title | String   | 标题 | 是           | 否           |

`page`元素可以将任意一种UI元素作为子元素，**但是只能将一个UI元素作为子元素。**

## nav-bar(beta)

`nav-bar`在当前的`router`模块中还处于`beta`阶段，目前只是提供了简单的`title`、`buttons`的设置，无法提供复杂的功能，比如：拉下切换导航栏、导航栏背景色等。虽然`router`不提供，但并不能说就无法实现了，而是因为在实际的项目中`nav-bar`的自定义有很多的需求，`router`模块不可能完全提供，但是你可以通过自定义元素的方式自己来实现。

`nav-bar`当前只能作为`page`的子元素存在。

### 属性

| 名称  | 数据类型 | 介绍 | 是否支持绑定 | 是否支持动画 |
| ----- | -------- | ---- | ------------ | ------------ |
| title | String   | 标题 | 是           | 否           |

`nav-bar`自身也提供了两个子元素。`right-buttons `和`left-buttons `，这两个子元素主要是用来设置导航栏左边按钮和导航栏右边按钮的。按钮可以是任意UI元素。

```xml
<nav-bar title="模拟头条feeds">
    <templates>
        <template t-name="nav-bar-button">
            <dock-panel size="40">
                <lable text="{{}}" font-size="17" font-color="FF3F0A"/>
            </dock-panel>
        </template>
    </templates>
    <right-buttons>
        <template-ref t-name="nav-bar-button" data-context="全选" event-tap="btnSelectAll"/>
    </right-buttons>

    <left-buttons>
        <template-ref t-name="nav-bar-button" data-context="关闭" event-tap="btnClose"/>
    </left-buttons>
</nav-bar>
```

![17](images/17.jpg)

## bev-router-link 

`bev-router-link `是一个`behavior`，用来提供点击跳转的功能。`bev-router-link `有两个属性。

### 属性

| 名称   | 数据类型 | 介绍                                                      | 是否支持绑定 | 是否支持动画 |
| ------ | -------- | --------------------------------------------------------- | ------------ | ------------ |
| path   | String   | 跳转路径                                                  | 是           | 否           |
| params | string   | 跳转所需的参数。支持json字符串，ViewModel、字符串三种方式 | 是           | 否           |

```xml
<behaviors>
    <bev-router-link path="{{pagePath}}"/>
</behaviors>
```

或者

```xml
<behaviors>
    <bev-router-link path="app/Detial.xml" params='{"url":"http://www.baidu.com"}'/>
</behaviors>
```

这里面设置一个json字符串的params。





## 导航+传参

`router`中有两种方式来实现导航+传参。一种是通过`bev-router-link`来添加一个`behavior`来获得点击的跳转的能力。另外，`router`也提供了直接以代码的方式来导航的能力。你可以在你的ViewModel中以如下代码来获取`router`实例：

```objective-c
[self gic_Router] 
```

前提是你必须要引入`GICRouter.h `头文件。

`gic_Router`获取到的其实是一个`GICRouterProtocol `，该协议提供了多个方法用来导航

```xml
@protocol GICRouterProtocol <NSObject>
@required
/**
 返回上一页
 */
-(void)goBack;
-(void)goBackWithParams:(id)paramsData;

/**
 根据path导航到下一页。需要事先设置GICXMLLayout 的 RootUrl
 
 @param path 
 */
-(void)push:(NSString *)path;

/**
 根据path导航到下一页,并且带有参数。需要事先设置GICXMLLayout 的 RootUrl
 
 @param path 
 @param paramsData 
 */
-(void)push:(NSString *)path withParamsData:(id)paramsData;


- (void)pushViewController:(UIViewController *)viewController;
@end
```



## 获取参数

上面介绍了如果导航+传参。现在介绍下如何获取传过来的参数。

当前`router`只能通过native代码的方式来获取参数。

在您的ViewModel中实现`GICPageRouterProtocol `协议。协议定义如下:

```objective-c
@protocol GICPageRouterProtocol <NSObject>

/**
 导航到当前页面的回调

 @param params 导航带过来的参数
 */
-(void)navigationWithParams:(GICRouterParams *)params;
@optional

/**
 从前一页返回到当前页面的回调

 @param params 返回参数
 */
-(void)navigationBackWithParams:(GICRouterParams *)params;
@end
```

这里面需要注意的是。**ViewModel必须是`page`元素的直接数据源，否则将无法获得回调。**



目前，`rouert`模块的例子已经贯彻到整个`sample`中了。

