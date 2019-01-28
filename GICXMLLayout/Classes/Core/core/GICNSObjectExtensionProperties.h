//
//  GICNSObjectExtensionProperties.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/10.
//

#import <Foundation/Foundation.h>
@interface GICNSObjectExtensionProperties : NSObject
@property (nonatomic,copy)NSString *name;
// 临时的数据源
@property (nonatomic,strong)id tempDataContext;

@property (nonatomic,weak)id superElement;
@property (nonatomic,readonly)NSArray *subElements;

/**
 在xml中的节点的顺序。这个直接决定元素的排序。固定的
 */
@property (nonatomic,assign)CGFloat elementOrder;
// 是否从for指令中生成的
@property (nonatomic,assign)BOOL isFromDirectiveFor;

-(void)addSubElement:(id)subElement;

-(NSInteger)indexOfSubElement:(id)subElement;

-(void)insertSubElement:(id)subElement atIndex:(NSInteger)index;

-(void)removeSubElements:(NSArray *)subElments;

-(void)removeAllSubElements;

#pragma mark 附加属性
/**
 设置附加属性
 */
-(void)setAttachValue:(id)value withAttributeName:(NSString *)attName;

/**
 获取附加属性
 */
-(id)attachValueWithAttributeName:(NSString *)attName;
@end
