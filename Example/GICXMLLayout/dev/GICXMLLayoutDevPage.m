//
//  GICXMLLayoutDevPage.m
//  GICXMLLayout
//
//  Created by 龚海伟 on 2018/7/29.
//

#import "GICXMLLayoutDevPage.h"
#import "GICXMLLayout.h"

@interface GICXMLLayoutDevPage (){
    NSURL *pageUrl;
    
    UIButton *btnReload;
    
    UIView *currentView;
}

@end

@implementation GICXMLLayoutDevPage

-(id)initWithUrl:(NSURL *)url{
    self = [super init];
    pageUrl = url;
    return self;
}

-(void)loadPage{
    NSMutableURLRequest *mutRerequest=[NSMutableURLRequest requestWithURL:pageUrl cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:15];
    mutRerequest.HTTPMethod = @"GET";
    [[[NSURLSession sharedSession] dataTaskWithRequest:mutRerequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSInteger code = [httpResponse statusCode];
        if(code==200){
            @try {
                [GICXMLLayout parseLayoutView:data toView:self.view withParseCompelete:^(UIView *view) {
                    if(self->currentView){
                        [self->currentView removeFromSuperview];
                    }
                    self->currentView = view;
                    [self.view bringSubviewToFront:self->btnReload];
                }];
            } @catch (NSException *exception) {
                NSLog(@"%@",exception);
            }
            
        }else{
            
        }
    }] resume];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadPage];
    btnReload = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-60 -15, self.view.frame.size.height-44-40, 60, 44)];
    [btnReload setTitle:@"reload" forState:UIControlStateNormal];
    [btnReload setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btnReload.layer.borderColor = [UIColor blackColor].CGColor;
    btnReload.layer.borderWidth = 1;
    [self.view addSubview:btnReload];
    [btnReload addTarget:self action:@selector(loadPage) forControlEvents:UIControlEventTouchUpInside];
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
