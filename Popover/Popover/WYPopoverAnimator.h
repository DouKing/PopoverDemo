//
//  WYPopoverAnimator.h
//  Popover
//
//  Created by iosci on 2016/10/28.
//  Copyright © 2016年 secoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WYPopoverPresentationController.h"

NS_ASSUME_NONNULL_BEGIN


@interface WYPopoverAnimator : NSObject<UIViewControllerTransitioningDelegate>

@end

@interface UIViewController (WYPopover)

// 需要先设置UIViewController的transitioningDelegate为WYPopoverAnimator，该属性才会有值
@property (nonatomic, weak, nullable, readonly) WYPopoverPresentationController *wy_popoverPresentationController;

@end


NS_ASSUME_NONNULL_END
