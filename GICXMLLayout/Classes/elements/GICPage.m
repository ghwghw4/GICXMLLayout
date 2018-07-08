//
//  GICPage.m
//  GICXMLLayout
//
//  Created by gonghaiwei on 2018/7/8.
//

#import "GICPage.h"
#import "GICStringConverter.h"

@interface GICPage ()

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
             @"view-model":[[GICStringConverter alloc] initWithPropertySetter:^(NSObject *target, id value) {
                 Class class = NSClassFromString(value);
                 if(class){
                     ((GICPage *)target)->_viewModel = [class new];
                 }
             }],
             };
}

-(void)gic_addSubElement:(NSObject *)subElement{
    if([subElement isKindOfClass:[UIView class]]){
        NSAssert(self.view.subviews.count==0, @"page 只允许添加一个子元素");
        [self.view addSubview:(UIView *)subElement];
        [self.view gic_LayoutSubView:(UIView *)subElement];
    }
}

-(NSArray *)gic_subElements{
    return self.view.subviews;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}


-(void)gic_elementParseCompelte{
    if(self->_viewModel){
        self.gic_DataContenxt = self->_viewModel;
        self->_viewModel = nil;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
