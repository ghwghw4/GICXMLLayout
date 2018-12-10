# script

从0.3.0版本开始，gic支持js来操作元素的各种属性，以及绑定事件。

> 暂时还没有实现类似JSPatch那样直接访问native code的能力，事实上这一功能对于gic来说并不显得特别重要。因为gic中UI部分本身就支持热更新，而对于元素的属性以及事件你都可以直接使用js来操作，因此相对于原来那种纯native code的方式来说并不是很急需，但是类似JSPatch的功能会在后续的版本中加入。

目前gic中的js支持如下功能：

1. 支持直接修改元素的属性值。(只能修改元素本身提供的的属性)
2. 支持将元素的事件绑定到js中的某个方法，甚至可以直接在事件中执行简短的js代码。

在使用script之前，你需要明白几个概念。





1. `RootDataContext`:

   > 根数据源的意思就是页面中第一个被作为数据源的ViewModel，因此在实际的开发过程中，尽可能的将数据源直接在页面的根节点的`script`元素中设置。这样整个页面都能直接访问该根数据源。

2. `this`指针：

   >this指针需要特别注意的，如果你是想在xml中的数据绑定表达式、事件表达式中使用this指针的话，this指针表示的是`RootDataContext`，但是如果你是在`js`文件中使用了`this`指针的话那么还是按照`JS`本身的`this`指针规范使用，也就是谁调用，指向谁。

3. `脚本作用域`。

   > 这个作用域的概念针对的是`script`元素中的js代码而言的。默认是全局作用域，也就是说`script`中出现的变量、方法都是可以全局访问的，也就是说你可以在任何可以使用js的地方来访问。如果多个script中出现相同名称的变量、方法，那么后解析的会替换前面的。而在全局作用域的js代码中this指针对应的是window对象，这时候其实this指针已经失去意义了。
   >
   > 你可以通过将`script`元素的`private `属性设为`true`来显式指定该js是私有的，这时候js中出现的变量、方法只能在该script中访问，其他地方就不能访问了。**对于私有作用域你可以理解为是在一个单独的function中运行script中的代码**

4. 访问属性

   > 如果你需要在`script`中访问元素的属性，那么首先需要将该script的`private `属性设为`true`。然后按照驼峰命名的规则来访问元素的属性。在gic中，xml的属性名称是以横杠`-`来分隔单词的，但是这样的名称无法直接在js中使用，因为js不支持这样的变量名，因此gic在后台会将属性名称转换成驼峰命名的方法，比如：在xml中的属性名称为`data-context`，而在js中访问，那么你就需要如下方式访问:`$element.dataContext`
   >
   > 元素的属性定义在文档中已经明确列出，你可以直接查看文档。
   >
   > **在私有作用域下，你也可以通过`$element.super`来访问当前元素的的父级元素，这样你就可以对父级元素做属性设置。你甚至可以使用`$element.super.super`来访问父级的父级元素...**

5. 事件绑定

   >在前面[事件](http://gicxmllayout.gonghaiwei.cn/core/event.html)一节中介绍过，你可以直接将一个事件回调绑定到ViewModel中的某个方法。而现在为了支持绑定到js方法，因此事件的绑定也做了相应的修改。如果你想要绑定到js方法，那么你就需要在前面加一个`js:`前缀，这样gic就会知道你是绑定js中的方法。
   >

6. script的执行顺序

   > 同一个元素支持多个`script`，而脚本的执行顺序是跟在XML中的顺序是一致的。目前是同步加载并且执行的，因此如果涉及到依赖的，那么就得考虑好script在xml中的顺序。否则会出现无法访问的问题。
   >
   > **脚本的执行是在整个页面都解析完成后才去执行脚本**

7. 元素和脚本

   > 元素和脚本的关系是独立的，没有任何关系，gic在实现支持脚本的过程中，使用了`behavior`来实现的，因此，你可以理解为，脚本是额外附加到元素上的，并且能够访问元素而已。



使用JS以后，也是支持数据绑定的，而且数据绑定的方式跟原来的一样，当让也同样支持三种绑定模式。



**当前iOS9.0以下的版本不支持ES6规范，因此如果要在JS中使用ES6有两种途径，一种是运行在iOS9.0以上的版本，另外一个是使用babel 等工具转码。**

## 通用变量

`通用变量`意味着你可以直接在xml文件中来访问这些变量，不同的场合变量指向的实际value 可能会不一样。

目前GIC提供了如下几个`通用变量`：

1. `$el`：(element的简写)

   > 表示元素本身，也就是说你在哪个元素中引用该变量，那么该变量就指向该元素本身。有一个特殊的地方，那就是在`script`元素中使用$el变量，并不是指向script元素本身，而是`script`父元素。

2. `$item`:

   > $item变量永远指向当前元素的数据源，也就是`dataContext`属性。
   >
   > `for`指令的子元素中使用该变量的话，$item变量指向当前循环的数组item，类似vue中的用法。
   >
   > 如果在非`for`指令下使用的话，那么就是直接获取该元素的dataContext 属性。

3. `$index`:

   > $index变量只会在`for`指令中生效，表示当前元素在数组中的索引。用法类似vue中的用法。

### 补充

gic的对JS的支持的实现是通过`JSContext`来实现的，因此有些JS的常用API是没有的，比如`console`、`XMLHttpRequest`、`setTimeout `等API是没有的，而gic为了方便开发，对`JSContext`进行了方法扩展，使得可以使用相应的API。目前支持的API如下：

1. setTimeout

2. alert 

3. XMLHttpRequest 

4. console 

5. setInterval 、clearInterval  

   > 0.3.1新增

6. require()

   > 0.4.0新增，用来引用其他js文件。

7. document.rootElement 、document.getElementsByName()

   > 0.4.0新增，用来访问根元素，以及通过name 来寻找元素的方法。

## 属性

| 名称    | 数据类型 | 介绍                                                        | 是否支持绑定 | 是否支持动画 |
| ------- | -------- | ----------------------------------------------------------- | ------------ | ------------ |
| path    | string   | 脚本路径。同步加载该路径下的脚本。也方便将脚本跟xml文件分离 | 否           | 否           |
| private | Bool     | 是否私有作用域，默认false。                                 | 否           | 否           |

## 例子

1. 访问属性。

   ```xml
   <lable>
       <behaviors>
           <script private="1">
               $el.text = '我是通过js设置的文本';
               $el.fontColor = '999999';
               $el.fontSize = 18;
           </script>
       </behaviors>
   </lable>
   ```

   同上面介绍的，想要访问元素的属性需要将脚本的作用域设为`私有作用域`，这样使用`$el`指针来设置属性。并且属性的名称采用驼峰命名方式。

2. 直接使用js来设置数据源进行数据绑定

   ```xml
   <lable text="{{text}}" font-size="{{fontSize}}" font-color="{{fontColor}}">
       <behaviors>
           <script private="1">
               $el.dataContext = {text:'我是通过数据源绑定的',fontSize:20,fontColor:'red'}
           </script>
       </behaviors>
   </lable>
   ```

   数据源的设置其实就是为元素的`data-context`属性赋值，然后gic会自动将数据绑定到属性中。

3. 双向绑定

   ```xml
   <stack-panel>
       <behaviors>
           <script private="1">
               $el.dataContext = {name:''}
           </script>
       </behaviors>
       <input font-color="blue" font-size="16" border-color="black" border-width="0.5" text="{{ exp=name,mode=2}}" placehold="请输入用户名" placehold-color="red" placehold-size="16" height="31">
       </input>
       <lable text="{{exp='您的用户名：'+name,mode=1}}"/>
   </stack-panel>
   ```

   这里写了一个当用户输入用户名的时候，`lable`同步显示用户名的例子。**在数据绑定的语法上面其实跟非JS版本是一致的，只是这里面把数据源改成JS的数据源而已。**

4. 绑定事件(1)。

   直接使用js表达式来执行。

   ```xml
   <lable text="点我改变文字" font-size="18" event-tap="js:$el.text = '已经点击了';"/>
   ```

   这里直接在tap事件上绑定了一段JS代码，这样，当点击事件发生的时候就会修改当前元素的`text`属性。上面也提到了，事件的js作用域是私有的，因此你可以通过`this`指针来访问元素本身。

5. 绑定事件(2)。

   调用全局方法。

   ```xml
   <lable text="点我改变颜色" font-size="18" event-tap="js:changeColor($el);">
       <behaviors>
           <!--注意这里没有设置private属性,意味着方法可以全局访问-->
           <script>
               function changeColor(el){
                   var r = parseInt(Math.random()*255+1,10);
                   var g = parseInt(Math.random()*255+1,10);
                   var b = parseInt(Math.random()*255+1,10);
                   el.fontColor = r.toString(16) + g.toString(16) + b.toString(16);
               }
           </script>
       </behaviors>
   </lable>
   ```

   上面的概念说明中提到，由于事件中的js作用域是私有的，因此想要访问某个外部定义的js方法，那么这个方法必须是全局作用域的，因此，这里面定义了一个全局作用域的`changeColor`方法，这样你可以直接在事件中访问该方法了。

   **这里给一个建议，就是你大可以将所有的全局作用域的JS代码写到一个`script`中，甚至你可以写到外部的js文件中，然后通过设置`path`属性来导入。**

6. 绑定事件(3)

   直接通过js来访问元素的onclick事件。当前仅支持`onclick`事件可以直接通过js来绑定触发。onclick事件是在私有作用域中实现的

   ```xml
   <lable text="点我改变颜色(onclick事件绑定的)" font-size="18">
       <behaviors>
           <!--js直接绑定的事件当前仅支持onclick事件-->
           <script private="1">
               $el.onclick = ()=>{
               var r = parseInt(Math.random()*255+1,10);
               var g = parseInt(Math.random()*255+1,10);
               var b = parseInt(Math.random()*255+1,10);
               $el.fontColor = r.toString(16) + g.toString(16) + b.toString(16);
               };
           </script>
       </behaviors>
   </lable>
   ```

7. 使用`XMLHttpRequest`来实现异步请求网络数据。

   ```xml
   <lable text="正在加载..." font-size="18">
       <behaviors>
           <!--注意这里没有设置private属性,意味着方法可以全局访问-->
           <script private="1">
               var xmlhttp = new XMLHttpRequest();
               xmlhttp.onreadystatechange = ()=>
               {
                   if (xmlhttp.status===200)
                   {
                       // 将结果在lable中显示出来
                       $el.text = xmlhttp.responseText;
                   }
               }
               xmlhttp.open("GET","https://www.sojson.com/open/api/lunar/json.shtml",true);
               xmlhttp.send();
           </script>
       </behaviors>
   </lable>
   ```

   这里的例子是使用`XMLHttpRequest`来请求一个json格式的数据，然后显示出来的例子。这个是原始的一种方式，在实际的项目中你可以进行进一步的封装，将数据请求单独封装起来。





## 其他

如果你想在调试的时候在遇到JS执行异常的时候弹出提示，那么你可以在启动的时候添加如下代码即可：

```objective-c
    // 启用JS异常提示(release下请关闭)
    [GICJSAPIManager enableJSExceptionNotify];
```

这样，当js执行过程中遇到异常，那么会在页面顶部弹出一个提示栏，5秒后自动消息。



JSAPI的扩展参考如下文档：

[JSAPI的扩展](http://gicxmllayout.gonghaiwei.cn/js-extension.html)





## JSRouter（导航相关）

有一点需要注意的是：每个页面都有独立的`JSContext`，因此页面之间传参数只能传字符串。不能直接传对象。

### API介绍

1. Router.push(path,data)

   > 导航到下一页

2. Router.params

   > 获取当前页面的参数，也就是获取从上一页传过来的参数

3. Router.goBack(data)

   > 返回上一页。你也可以在返回的时候同时传参数

4. Router.goBackWithCount(count)

   > 返回到指定层级数的页面。-1：表示返回到根页面。

5. Router.onNavgateBackFrom 

   > 从前一页返回事件。当从前一页返回的时候触发。

   ```xml
   <lable text="" font-size="18">
       <behaviors>
           <script private="1">
               Router.onNavgateBackFrom = (params)=>{
               	$el.text = params.name;
               }
           </script>
       </behaviors>
   </lable>
   ```

具体使用方式参考项目自带的Sample。

