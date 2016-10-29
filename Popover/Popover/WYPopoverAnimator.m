//
//  WYPopoverAnimator.m
//  Popover
//
//  Created by iosci on 2016/10/28.
//  Copyright © 2016年 secoo. All rights reserved.
//

#import "WYPopoverAnimator.h"

typedef NS_ENUM(NSInteger, WYPopoverTransitionType) {
    WYPopoverTransitionTypePresent,
    WYPopoverTransitionTypeDismiss
};
@interface WYPopoverTransition : NSObject<UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) WYPopoverTransitionType transitionType;

@end

@interface WYPopoverAnimator ()

@property (nonatomic, strong) WYPopoverPresentationController *popover;

@end

@implementation WYPopoverAnimator


#pragma mark - UIViewControllerTransitioningDelegate

- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source {
    WYPopoverPresentationController *popover = [[WYPopoverPresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
    popover.backgroundColor = self.popover.backgroundColor;
    popover.sourceView = self.popover.sourceView;
    popover.sourceRect = self.popover.sourceRect;
    popover.permittedArrowDirections = self.popover.permittedArrowDirections;
    self.popover = popover;
    return self.popover;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    WYPopoverTransition *transition = [[WYPopoverTransition alloc] init];
    return transition;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    WYPopoverTransition *transition = [[WYPopoverTransition alloc] init];
    transition.transitionType = WYPopoverTransitionTypeDismiss;
    return transition;
}

#pragma mark - setter & getter

- (WYPopoverPresentationController *)popover {
    if (!_popover) {
        _popover = [[WYPopoverPresentationController alloc] initWithPresentedViewController:[[UIViewController alloc] init] presentingViewController:nil];
    }
    return _popover;
}

@end


#pragma mark - WYPopover -

@implementation UIViewController (WYPopover)

- (WYPopoverPresentationController *)wy_popoverPresentationController {
    if ([self.transitioningDelegate isKindOfClass:[WYPopoverAnimator class]]) {
        WYPopoverAnimator *popoverAnimator = (WYPopoverAnimator *)self.transitioningDelegate;
        return popoverAnimator.popover;
    }
    return nil;
}

@end

#pragma mark - WYPopoverTransition -

@implementation WYPopoverTransition

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.25;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    switch (self.transitionType) {
        case WYPopoverTransitionTypePresent: {
            toView.alpha = 0;
            [[transitionContext containerView] addSubview:toView];
            [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
                toView.alpha = 1;
            } completion:^(BOOL finished) {
                [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            }];
            break;
        }
        case WYPopoverTransitionTypeDismiss: {
            [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
                fromView.alpha = 0;
            } completion:^(BOOL finished) {
                [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            }];
            break;
        }
            
        default:
            break;
    }
    
}

@end
