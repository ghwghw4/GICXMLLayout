# 模板

`template`只是适用与xml中，顾名思义，`template`可以将元素作为模板定义起来，然后在需要使用的地方直接应用这个模板即可。所有的`template`你必须要定义在`templates`下面，`templates`可以接受N个模板，你需要对每个模板设置一个`t-name`的属性，这个属性表示该模板名称，在引用的时候使用名称来引用。

具体不多说了，如果你做过h5开发的话，你就知道template的妙用了。下面直接上例子：

## 例子

1. 普通模板定义

   ```xml
   <template t-name="desc">
       <lable text="{{ }}" space-after="5" space-before="5" font-size="25" font-color="666666"/>
   </template>
   ```

   引用模板

   ```xml
   <template-ref t-name="desc" data-context="我是模板1"/>
   ```

2. 模板插槽。如果你用过vue的话，那么你肯定对里面的component很熟悉了，里面有一个slot(插槽)功能，你可以理解为占位符，什么意思呢？就是你在引用模板的时候，可以将其他元素插入模板的占位符中。并且所有的属性可继承，只需要将该元素设置`slot-name`的属性，用来标识该替换到哪个插槽即可。当然你可以在模板中添加N个slot

   ```xml
   <template t-name="t3">
       <stack-panel space-after="5" space-before="5">
           <lable text="{{}}" font-size="20" font-color="red"/>
           <template-slot slot-name = "content" space-before="10"/>
       </stack-panel>
   </template>
   ```

   引用模板

   ```xml
   <template-ref t-name="t3" data-context="我是模板3,具有模板替换功能">
       <lable text="我是slot" font-size="14" slot-name = "content" font-color="red"/>
   </template-ref>
   ```

   ![13](../images/13.jpg)

3. 嵌套模板。嵌套模板你可以理解为从一个基类派生出N多的子类。每个子类都带有父类的功能，但是又自带有自己的功能。嵌套模板其实也是采用模板插槽来实现的。

   ```xml
   <template t-name="t3">
       <stack-panel space-after="5" space-before="5">
           <lable text="{{}}" font-size="20" font-color="red"/>
           <template-slot slot-name = "content" space-before="10"/>
       </stack-panel>
   </template>
   
   <template t-name="t4">
   <template-ref t-name="t3">
       <lable text="我是slot2,模板嵌套" font-size="14" slot-name = "content" font-color="red"/>
   </template-ref>
   </template>
   ```

   引用模板

   ```xml
   <template-ref t-name="t4" data-context="我是嵌套模板"/>
   ```

   ![14](../images/14.jpg)



## 总结

模板技术可以为你省去很多的重复代码，这个其实相当于代码中的重构。而嵌套模板对于Feeds类的应用尤其有用。`template-ref`元素的`t-name`属性是支持绑定的，因此可以根据数据源的直接绑定到不同的模板上。比如我定义了两个不同的模板

```xml
<templates>
    <template t-name="template1">
    ...
    </template>

    <template t-name="template2">
    ...
    </template>

    <template t-name="template3">
    ...
    </template>
</templates>
```

然后你可以在引用的时候使用绑定来引用不同的模板。

```xml
<list separator-style="1">
    <for data-path="listDatas">
        <list-item>
            <template-ref t-name="{{ 'template' + type }}"/>
        </list-item>
    </for>
</list>
```

是不是非常简单，相对于我们在iOS中采用老方法吭哧吭哧一个cell一个cell去写，而且还要手动去计算cell高度，等等一些复杂的实现，采用模板技术可以说是异常的简单，这将省去你大把的开发时间。这可以使得你有更多的时间放在业务逻辑上。