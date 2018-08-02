# style

现在`gic`也支持style了，你甚至可以将style以单独的文件引入。这样你就可以很容易的为您的app制作主题了。

在`style`里面，你可以为各种元素定义不同的样式(设置不同的属性)，然后给该元素设置一个`style-name`属性，这样你就可以在后面的xml中直接以名字来引入样式。如果您没有为该元素设置`style-name`属性，那么该样式默认作用于所有同类元素上，该方式只有当您启用了默认样式以后才会生效，下面细说。在`style`里面，你也可以定义`模板`。

样式也是有`作用域`的概念的，只有在定义该样式的子孙节点才能引用，子孙节点也可以使用相同的`style-name`来覆盖父节点的样式，同样也是只能作用于该节点的子孙元素。

## 属性

| 名称 | 数据类型 | 介绍                          | 是否支持绑定 | 是否支持动画 |
| ---- | -------- | ----------------------------- | ------------ | ------------ |
| path | String   | 引入本地单独style文件的path。 | 是           | 否           |

## 例子

1. 以`style-name`来引用。

   > Step1:定义样式。为该样式设置一个`style-name`的属性

   ```xml
   <style>
       <lable font-size="25" font-color="red" style-name="red-lable"/>
   </style>
   ```

   > Step2:引用样式。在引用的地方添加一个`style`，属性，value即是上面定义的`style-name`的名称。

   ```xml
   <lable text="style lable" space-before="10" style="red-lable"/>
   ```

2. 元素的默认样式。

   由于考虑性能的问题(事实上，默认样式性能影响不大),`gic`默认是关闭默认样式的，因此你需要在启动的时候将默认样式启用。

   ```objective-c
       // 启用默认样式
       [GICXMLLayout enableDefualtStyle:YES];
   ```

   然后是定义样式。默认样式无需设置`style-name`。

   ```xml
   <style>
       <lable font-size="25" font-color="red"/>
   </style>
   ```

   引用样式的地方也无需设置`style`属性，所有在定了该样式的元素下的同类子元素，都默认使用该样式。

   ```xml
   <lable text="style lable" space-before="10"/>
   ```

## 引入样式

1. 你可以在单独的一个xml文件中定义样式。比如添加一个叫做`CommonStyle.xml`的样式文件

   ```xml
   <style>
       <lable font-size="25" font-color="red" style-name="red-lable"/>
   </style>
   ```

2. 然后在需要使用该样式文件的地方引入。

   ```xml
   <style path="CommonStyle.xml"/>
   ```

3. 使用的方法跟上面的一样，比如：

   ```xml
   <lable text="style lable" space-before="10" style="red-lable"/>
   ```

### 样式中添加模板

在样式文件中你也可以定义模板。里面定义的模板，在引入的时候会自动将样式中定义的模板添加到模板列表中。

1. 基于上面`CommonStyle.xml`，添加模板

   ```xml
   <style>
       <lable font-size="25" font-color="red" style-name="red-lable"/>
       <templates>
           <template t-name="desc">
               <lable text="{{ }}" space-after="5" space-before="5" font-size="25" font-color="666666"/>
           </template>
           <template t-name="title">
               <lable text="{{ }}" space-after="10" font-size="25" font-color="blue"/>
           </template>
       </templates>
   </style>
   ```

2. 引入样式表

   ```xml
   <style path="CommonStyle.xml"/>
   ```

3. 使用模板

   ```xml
   <template-ref t-name="desc" data-context="我是样式模板1"/>
   ```





灵活的使用样式，可以实现为APP添加主题的功能，在切换主题的时候，只需要将改变引入的样式表就可以了。不过样式不支持绑定，因此这时候在切换主题的时候需要重新reload下xml文件。