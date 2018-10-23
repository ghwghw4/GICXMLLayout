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
@property (readonly)id rootElement;
// 私有API，用于GIC库内部的api调用。
-(id)_getRootElement;

//-(id)createElement:(NSString *)elmentName;
@end

@interface GICJSDocument : NSObject<GICJSDocument>{
    __weak id rootElement;
}
-(id)initRootElement:(id)root;
@end
