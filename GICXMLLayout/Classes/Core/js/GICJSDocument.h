//
//  GICJSDocument.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/10/18.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>
@protocol GICJSDocument <JSExport>
-(NSArray *)getElementsByName:(NSString *)name;
@property (nonatomic,readonly)JSValue *rootElement;
@end

@interface GICJSDocument : NSObject<GICJSDocument>{
    __weak id rootElement;
}
-(id)initRootElement:(id)root;
@end
