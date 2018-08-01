//
//  GICDirectiveIf.h
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/24.
//

#import "GICDirective.h"

/**
 if指令
 */
@interface GICDirectiveIf : GICDirective{
    GDataXMLDocument *xmlDoc;
    GDataXMLDocument *elseXmlDoc;
    __weak id addedElement;
    __weak id elseElement;
}
@property (nonatomic,assign)BOOL condition;
@end
