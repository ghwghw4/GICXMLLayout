//
//  GICJSToast.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/11/22.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

typedef NS_ENUM(NSUInteger , GICJSToastShowPosition) {
    GICJSToastShowFromTop = 0,
    GICJSToastShowFromCenter = 1,
    GICJSToastShowFromBottom = 2,
};

@protocol GICJSToast <JSExport>
+(instancetype)create:(NSString *)templateName;
@property JSValue* ondismiss;
-(void)show:(JSValue *)data;
-(void)dismiss;
@end

@interface GICJSToast : NSObject<GICJSToast>{
    CGFloat duration;//默认两秒后消失
}
-(instancetype)initWithTemplateName:(NSString *)templateName;
@end
