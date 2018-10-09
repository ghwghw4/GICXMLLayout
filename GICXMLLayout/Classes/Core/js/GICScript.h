//
//  GICScript.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/9/5.
//

#import <Foundation/Foundation.h>
// beta 阶段
@interface GICScript : GICBehavior{
    NSString *jsScript;
}

// 是否是私有作用域，默认false。
// 在private 模式下，script中的内容会封装到一个方法中指行，并且this指针表示当前元素
// 默认是public模式，也就是script中的内容全局可访问.这时候this指针表示window，也就是没意义
// NOTE:这里开始考虑了两种设计，还有一种设计是，没有私有、共有之分，全部是私有作用域，每个script按照元素的树状解析方法来决定作用域。但是这种实现方式过于复杂，因此暂时放弃了。等想象到了更好的实现方式后在考虑替换。
@property (nonatomic,readonly)BOOL isPrivate;
@end
