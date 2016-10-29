//
//  WYPopoverPresentationController.h
//  Popover
//
//  Created by iosci on 2016/10/28.
//  Copyright © 2016年 secoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYPopoverPresentationController : UIPresentationController

@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIView *sourceView;
@property (nonatomic, assign) CGRect sourceRect;
@property (nonatomic, assign) UIPopoverArrowDirection permittedArrowDirections;

@end
