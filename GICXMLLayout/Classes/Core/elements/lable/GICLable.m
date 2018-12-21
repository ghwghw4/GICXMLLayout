//
//  GICLable.m
//  GDataXMLNode_GIC
//
//  Created by 龚海伟 on 2018/7/2.
//

#import "GICLable.h"
#import "GICStringConverter.h"
#import "GICNumberConverter.h"
#import "GICColorConverter.h"
#import "GICTextAlignmentConverter.h"
#import "GICXMLLayout.h"
#import "NSObject+LayoutElement.h"
#import "NSMutableAttributedString+GICLableSubString.h"
#import "NSObject+GICDataBinding.h"
#import "GICFontConverter.h"

@implementation GICLable{
    GICEvent *linkTapEvent;
}

static NSArray *supportElementNames;
static NSDictionary<NSString *,GICAttributeValueConverter *> *propertyConverts = nil;
+(void)initialize{
    [super initialize];
    supportElementNames = @[@"s",@"img"];
    propertyConverts = @{
                         @"text":[[GICStringConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                             NSMutableAttributedString *att= ((GICLable *)target)->mutAttString;
                             [att deleteCharactersInRange:NSMakeRange(0, att.length)];
                             [att appendAttributedString:[[NSAttributedString alloc] initWithString:value]];
                             [(GICLable *)target updateString];
                         } withGetter:^id(id target) {
                             NSMutableAttributedString *att= ((GICLable *)target)->mutAttString;
                             return att.string;
                         }],
                         @"lines":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                             [(GICLable *)target setMaximumNumberOfLines:[value integerValue]];
                              [(GICLable *)target updateString];
                         }],
                         @"font-color":[[GICColorConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                             [((GICLable *)target)->attributes setValue:value forKey:NSForegroundColorAttributeName];
                              [(GICLable *)target updateString];
                         } withGetter:^id(id target) {
                             return [((GICLable *)target)->attributes objectForKey:NSForegroundColorAttributeName];
                         }],
                         @"font-size":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                              [((GICLable *)target)->attributes setValue:[UIFont systemFontOfSize:[value floatValue]] forKey:NSFontAttributeName];
                              [(GICLable *)target updateString];
                         } withGetter:^id(id target) {
                             UIFont *font = [((GICLable *)target)->attributes objectForKey:NSFontAttributeName];
                             if(!font){
                                 font =[UIFont preferredFontForTextStyle:UIFontTextStyleBody];
                             }
                             UIFontDescriptor *ctfFont = font.fontDescriptor;
                             return [ctfFont objectForKey:@"NSFontSizeAttribute"];
                         }],
                         @"font":[[GICFontConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                             [((GICLable *)target)->attributes setValue:value forKey:NSFontAttributeName];
                             [(GICLable *)target updateString];
                         }],
                         @"text-align":[[GICTextAlignmentConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                             NSMutableParagraphStyle * p = [[NSMutableParagraphStyle alloc] init];
                             p.alignment = [value integerValue];
                             [((GICLable *)target)->attributes setValue:p forKey:NSParagraphStyleAttributeName];
                             [(GICLable *)target updateString];
                         } withGetter:^id(id target) {
                             NSMutableParagraphStyle * p = [((GICLable *)target)->attributes objectForKey:NSParagraphStyleAttributeName];
                             return @(p.alignment);
                         }],
                         @"event-link-tap":[[GICStringConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                             GICLable *item = (GICLable *)target;
                             item->linkTapEvent =  [GICEvent createEventWithExpresion:value withEventName:@"event-link-tap" toTarget:target];
                         } withGetter:^id(id target) {
                             return [target gic_event_findWithEventName:@"event-link-tap"];
                         }],
                         @"underline-style":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                             [((GICLable *)target)->attributes setValue:value forKey:NSUnderlineStyleAttributeName];
                             [(GICLable *)target updateString];
                         } withGetter:^id(id target) {
                            return [((GICLable *)target)->attributes objectForKey:NSUnderlineStyleAttributeName];
                         }],
                         @"throughline-style":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                             [((GICLable *)target)->attributes setValue:value forKey:NSStrikethroughStyleAttributeName];
                             [(GICLable *)target updateString];
                         } withGetter:^id(id target) {
                             return [((GICLable *)target)->attributes objectForKey:NSStrikethroughStyleAttributeName];
                         }],
                         @"line-space":[[GICNumberConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                             NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                             [paragraphStyle setLineSpacing:[value integerValue]];//行间距
                             
                             [((GICLable *)target)->attributes setValue:paragraphStyle forKey:NSParagraphStyleAttributeName];
                             [(GICLable *)target updateString];
                         } withGetter:^id(id target) {
                             return @([(NSMutableParagraphStyle *)[((GICLable *)target)->attributes objectForKey:NSParagraphStyleAttributeName] lineSpacing]);
                         }],
                         };
}

+(NSString *)gic_elementName{
    return @"lable";
}

+(NSDictionary<NSString *,GICAttributeValueConverter *> *)gic_elementAttributs{
    return propertyConverts;
}

-(id)init{
    self = [super init];
    attributes = [NSMutableDictionary dictionary];
    mutAttString = [[NSMutableAttributedString alloc] init];
    attbuteStringArray = [NSMutableArray array];
    self.delegate = self;
    return self;
}

-(void)gic_parseElementCompelete{
    [super gic_parseElementCompelete];
    parseComplete = YES;
    [self updateString];
}

-(void)updateString{
    if(!parseComplete)
        return;
    if(attbuteStringArray.count>0){
        [self->mutAttString deleteCharactersInRange:NSMakeRange(0, self->mutAttString.length)];
        NSInteger offset = 0;
        NSMutableArray *linkArray = [NSMutableArray array];
        for(NSMutableAttributedString *att in attbuteStringArray){
            [self->mutAttString appendAttributedString:att];
            if(!att.gic_isImg){
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:attributes];
                if(att.gic_attributDict.count>0){
                    [dict addEntriesFromDictionary:att.gic_attributDict];
                }
                [self->mutAttString setAttributes:dict range:NSMakeRange(offset, att.length)];
            }
            offset +=att.length;
            NSURL *url = [att gic_linkUrl];
            if(url){
                [linkArray addObject:[url absoluteString]];
            }
        }
        
        if(linkArray.count>0){
            [self setUserInteractionEnabled:YES];
            self.linkAttributeNames = linkArray;
        }else{
            [self setUserInteractionEnabled:NO];
        }
    }else{
        if(attributes){
            [self->mutAttString setAttributes:self->attributes range:NSMakeRange(0, self->mutAttString.length)];
        }
    }
    self.attributedText = [self->mutAttString copy];
}

-(id)gic_willAddAndPrepareSubElement:(NSMutableAttributedString *)subElement{
    if([subElement isKindOfClass:[NSMutableAttributedString class]]){
        [attbuteStringArray addObject:subElement];
        if(subElement.gic_Bindings.count>0){
            @weakify(self)
            for(GICDataBinding *b in subElement.gic_Bindings){
                b.valueUpdate = ^(id value) {
                    @strongify(self)
                    [self updateString];
                };
            }
        }
    }
    return [super gic_willAddAndPrepareSubElement:subElement];
}

-(id)gic_parseSubElementNotExist:(GDataXMLElement *)element{
    if([supportElementNames containsObject:element.name]){
        NSMutableAttributedString *s =[[NSMutableAttributedString alloc] initWithXmlElement:element];
        return s;
    }
    return [super gic_parseSubElementNotExist:element];
}

#pragma mark ASTextNodeDelegate
- (void)textNode:(ASTextNode *)richTextNode tappedLinkAttribute:(NSString *)attribute value:(NSURL *)URL atPoint:(CGPoint)point textRange:(NSRange)textRange
{
    if(linkTapEvent){
        [linkTapEvent fire:URL.absoluteString];
    }
}
@end
