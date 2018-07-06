#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "LayoutElementProtocol.h"
#import "NSObject+LayoutElement.h"
#import "UIView+GICExtension.h"
#import "UIView+LayoutView.h"
#import "GICDataBinding.h"
#import "NSObject+GICDataBinding.h"
#import "NSObject+GICDataContext.h"
#import "GICDirective.h"
#import "GICDirectiveFor.h"
#import "NSObject+GICDirective.h"
#import "GICImageView.h"
#import "GICInpute.h"
#import "GICScrollView.h"
#import "GICLable.h"
#import "NSMutableAttributedString+GICLableSubString.h"
#import "GICPanel.h"
#import "GICStackPanel.h"
#import "GICXMLLayout.h"
#import "GICUtils.h"
#import "UIColor+Extension.h"
#import "GICColorConverter.h"
#import "GICEdgeConverter.h"
#import "GICFloatConverter.h"
#import "GICNumberConverter.h"
#import "GICStringConverter.h"
#import "GICTextAlignmentConverter.h"
#import "GICURLConverter.h"
#import "GICValueConverter.h"

FOUNDATION_EXPORT double GICXMLLayoutVersionNumber;
FOUNDATION_EXPORT const unsigned char GICXMLLayoutVersionString[];

