//
//  ClipImageBehavior.m
//  GICXMLLayout_Example
//
//  Created by 龚海伟 on 2018/12/5.
//  Copyright © 2018年 ghwghw4. All rights reserved.
//

#import "ClipImageBehavior.h"
#import <GICXMLLayout/GICTapEvent.h>
#import <ReactiveObjC/ReactiveObjC.h>

@implementation ClipImageBehavior
+(NSString *)gic_elementName{
    return @"bev-clipimage";
}

-(void)attachTo:(ASDisplayNode *)target{
    [super attachTo:target];
    if([target isKindOfClass:[ASDisplayNode class]]){
        GICEvent * tap = [target gic_event_findFirstWithEventClassOrCreate:[GICTapEvent class]];
        @weakify(self)
        [tap.eventSubject subscribeNext:^(id  _Nullable x) {
            @strongify(self)
            [self clipImageAndSave];
        }];
    }
}

-(void)clipImageAndSave{
    ASDisplayNode *node = self.target;
    UIGraphicsBeginImageContextWithOptions(node.frame.size, NO, [UIScreen mainScreen].scale);
    [node.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // 保存到相册
     UIImageWriteToSavedPhotosAlbum(snapshotImage, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if(error){
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"保存失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }else{
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"保存成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}

@end
