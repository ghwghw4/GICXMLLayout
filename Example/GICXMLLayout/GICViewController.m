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
	// Do any additional setup after loading the view, typically from a nib.
    NSData *xmlData = [NSData dataWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/template2.xml"]];
    UIView *p = [GICXMLLayout parseLayout:xmlData];
    //    [p parseAttributes:[self convertAttributes:rootElement.attributes]];
    [self.view addSubview:p];
    [p mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
//    p.frame = self.view.bounds;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
