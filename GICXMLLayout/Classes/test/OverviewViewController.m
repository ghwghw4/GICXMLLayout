//
//  OverviewViewController.m
//  Texture
//
//  Copyright (c) 2014-present, Facebook, Inc.  All rights reserved.
//  This source code is licensed under the BSD-style license found in the
//  LICENSE file in the /ASDK-Licenses directory of this source tree. An additional
//  grant of patent rights can be found in the PATENTS file in the same directory.
//
//  Modifications to this file made after 4/13/2017 are: Copyright (c) 2017-present,
//  Pinterest, Inc.  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//

#import "OverviewViewController.h"
#import "LayoutExampleNodes.h"
#import "LayoutExampleViewController.h"
#import "OverviewCellNode.h"

@interface OverviewViewController ()
@property (nonatomic, strong) ASDisplayNode *displayNode;
@end

@implementation OverviewViewController

+(NSString *)gic_elementName{
    return @"pagea";
}

#pragma mark - Lifecycle Methods
-(id)initWithXmlElement:(GDataXMLElement *)element{
    [self gic_parseElement:element];
    self =[self init];
    return self;
}
- (instancetype)init
{
  self = [super initWithNode:_displayNode];
  return self;
}

-(void)gic_addSubElement:(id)subElement{
    if([subElement isKindOfClass:[ASDisplayNode class]]){
        NSAssert(_displayNode == nil, @"page 只允许添加一个子元素");
        _displayNode =subElement;
    }else{
        [super gic_addSubElement:subElement];
    }
}
@end
