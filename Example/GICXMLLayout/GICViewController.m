//
//  GICViewController.m
//  GICXMLLayout
//
//  Created by ghwghw4 on 07/02/2018.
//  Copyright (c) 2018 ghwghw4. All rights reserved.
//

#import "GICViewController.h"
#import <GDataXMLNode_GIC/GDataXMLNode.h>
#import "GICXMLLayout.h"
#import <Masonry/Masonry.h>

@interface GICViewController ()

@end

@implementation GICViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [GICXMLLayout regiterAllElements];
    
    NSDictionary *data = @{@"obj":@{@"name":@"hello word 111",@"loc1":@"西湖",@"loc2":@"青园小区哈哈",@"clickCount":@(20),@"url":@"http://ppt.downhot.com/d/file/p/2014/07/24/afd8b2135086cc9f2787d114bd73005a.png"}};
    
	// Do any additional setup after loading the view, typically from a nib.
    NSData *xmlData = [NSData dataWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/template2.xml"]];
    UIView *v = [GICXMLLayout parseLayout:xmlData toView:self.view];
    v.gic_DataContenxt = data;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
