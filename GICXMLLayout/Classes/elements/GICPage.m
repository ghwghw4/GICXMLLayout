//
//  GICPage.m
//  GICXMLLayout
//
//  Created by gonghaiwei on 2018/7/8.
//

#import "GICPage.h"
#import "GICStringConverter.h"
#import "UIView+GICExtension.h"
#import "GICColorConverter.h"
#import "GICPanel.h"
#import "GICStackPanel.h"

@interface GICPage (){
    GICPanel *viewNode;
}
@property (nonatomic, strong) id customNode;
@end

@implementation GICPage

+(NSString *)gic_elementName{
    return @"page";
}

+(NSDictionary<NSString *,GICValueConverter *> *)gic_propertySetters{
    return @{
             @"title":[[GICStringConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 [(GICPage *)target setTitle:value];
             }],
//             @"background-color":[[GICColorConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
//                 [((GICPage *)target)->viewNode setBackgroundColor:value];
//             }],
             };
}

-(id)initWithXmlElement:(GDataXMLElement *)element{
    [self gic_parseElement:element];
    self =[super initWithNode:viewNode];
    return self;
}

-(void)gic_addSubElement:(id)subElement{
    if([subElement isKindOfClass:[GICPanel class]]){
        NSAssert(viewNode == nil, @"page 只允许添加一个子元素");
        viewNode =subElement;
    }else{
        [super gic_addSubElement:subElement];
    }
}

-(NSObject *)gic_getSuperElement{
    return nil;
}

-(NSArray *)gic_subElements{
    return self.view.subviews;
}


//
//-(void)gic_elementParseCompelte{
//    if(self->_viewModel){
//        self.gic_DataContenxt = self->_viewModel;
//        self->_viewModel = nil;
//    }
//
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
