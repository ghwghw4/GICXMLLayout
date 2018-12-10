//
//  GICNav.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/8/1.
//

#import "GICNav.h"
#import "GICColorConverter.h"
#import "GICRouter.h"
#import "GICRouterJSAPIExtension.h"

@interface GICNav(){
    NSString *rootPagePath;
}

@end

@implementation GICNav
+(NSString *)gic_elementName{
    return @"nav";
}

+(NSDictionary<NSString *,GICAttributeValueConverter *> *)gic_elementAttributs{
    return @{
             @"background-color":[[GICColorConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 [GICUtils mainThreadExcu:^{
                     ((GICNav *)target).view.backgroundColor = value;
                 }];
             }],
             };
}

-(id)gic_willAddAndPrepareSubElement:(id)subElement{
    if([subElement isKindOfClass:[UIViewController class]]){
        [self pushViewController:subElement];
        return subElement;
    }
    return [super gic_willAddAndPrepareSubElement:subElement];
}

-(id)gic_parseSubElementNotExist:(GDataXMLElement *)element{
    if([element.name isEqualToString:@"root-page"]){
        rootPagePath = [element attributeForName:@"path"].stringValue;
        return rootPagePath;
    }
    return [super gic_parseSubElementNotExist:element];
}

-(void)gic_parseElementCompelete{
    [super gic_parseElementCompelete];
    if(rootPagePath){
        [self push:rootPagePath];
    }
}



#pragma mark router
-(void)goBack:(NSInteger)count{
    if(count == 1){
        [self goBackWithParams:nil];
    }else if (count == -1){
        [self popToRootViewControllerAnimated:YES];
    }else if (count > 1){
        NSInteger index = self.viewControllers.count - count -1;
        if(index>=0){
            UIViewController *vc = self.viewControllers[index];
            [self popToViewController:vc animated:YES];
        }
    }
}

-(void)goBackWithParams:(id)paramsData{
    UIViewController *from = [self visibleViewController];
    [self popViewControllerAnimated:YES];
    UIViewController *page = [self visibleViewController];
    id viewModel = [page gic_DataContext];
    if([viewModel conformsToProtocol:@protocol(GICPageRouterProtocol)]){
        if([viewModel respondsToSelector:@selector(navigationBackWithParams:)]){
            [viewModel navigationBackWithParams:[[GICRouterParams alloc] initWithData:paramsData from:from]];
        }
    }
    
    // JSRouter
    if([page isKindOfClass:[GICPage class]]){
        [GICRouterJSAPIExtension goBackFromPage:(GICPage *)page];
    }
}

-(void)push:(NSString *)path{
    [self push:path withParamsData:nil];
}

-(void)push:(NSString *)path withParamsData:(id)paramsData{
    [GICRouter loadPageFromPath:path withParseCompelete:^(GICPage *page) {
        page.gic_ExtensionProperties.superElement = self;
        // 传参数
        id viewModel = [page gic_DataContext];
        if([viewModel conformsToProtocol:@protocol(GICPageRouterProtocol)]){
            if([viewModel respondsToSelector:@selector(navigationWithParams:)]){
                [viewModel navigationWithParams:[[GICRouterParams alloc] initWithData:paramsData from:[self visibleViewController]]];
            }
        }
//        // JSRouter
//        if([page isKindOfClass:[GICPage class]] && page.jsRouter && paramsData){
//            //
//            [GICRouterJSAPIExtension setJSParamsData:paramsData withPage:page];
//        }
        [self pushViewController:page animated:YES];
    }];
}

-(void)pushViewController:(UIViewController *)viewController{
    [super pushViewController:viewController animated:YES];
}
@end
