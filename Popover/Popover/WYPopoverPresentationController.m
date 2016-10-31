//
//  WYPopoverPresentationController.m
//  Popover
//
//  Created by iosci on 2016/10/28.
//  Copyright © 2016年 secoo. All rights reserved.
//

#import "WYPopoverPresentationController.h"

static inline UIColor * WYPopoverBackgroundPresentedColor() {
    return [UIColor colorWithWhite:0 alpha:0.6];
}

static inline UIColor * WYPopoverBackgroundDismissColor() {
    return [UIColor clearColor];
}

@interface UIBarButtonItem(Frame)

- (CGRect)_frameInView:(UIView *)v;

@end

@interface WYPopoverPresentationController ()

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *arrowView;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@end

@implementation WYPopoverPresentationController

- (void)containerViewDidLayoutSubviews {
    [super containerViewDidLayoutSubviews];
    self.arrowView.frame = [self sourceViewFrameInContainerView];
    self.backgroundView.frame = self.containerView.bounds;
    self.presentedView.frame = self.frameOfPresentedViewInContainerView;
    [self _configArrowViewRotation];
}

- (void)presentationTransitionWillBegin {
    [self.containerView insertSubview:self.arrowView atIndex:0];
    [self.containerView insertSubview:self.backgroundView atIndex:0];
    [self.backgroundView addGestureRecognizer:self.tapGesture];
    self.arrowView.alpha = 0;
    __weak typeof(self) weakSelf = self;
    [self.presentingViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.backgroundView.backgroundColor = WYPopoverBackgroundPresentedColor();
        strongSelf.arrowView.alpha = 1;
    } completion:nil];
}

- (void)presentationTransitionDidEnd:(BOOL)completed {
    if (!completed) {
        [self.backgroundView removeFromSuperview];
        [self.arrowView removeFromSuperview];
    }
}

- (void)dismissalTransitionWillBegin {
    __weak typeof(self) weakSelf = self;
    [self.presentingViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.backgroundView.backgroundColor = WYPopoverBackgroundDismissColor();
        strongSelf.arrowView.alpha = 0;
    } completion:nil];
}

- (void)dismissalTransitionDidEnd:(BOOL)completed {
    if (completed) {
        [self.backgroundView removeFromSuperview];
        [self.arrowView removeFromSuperview];
    }
}

- (CGRect)frameOfPresentedViewInContainerView {
    if (!self.containerView) { return CGRectZero; }
    switch (self.permittedArrowDirections) {
        case UIPopoverArrowDirectionUp:
        case UIPopoverArrowDirectionDown:
        case UIPopoverArrowDirectionLeft:
        case UIPopoverArrowDirectionRight:
            return [self _frameOfPresentedViewInContainerViewWithArrowDirection:self.permittedArrowDirections];
            break;
        default:
            return [self _frameOfPresentedViewInContainerViewWithArrowDirection:[self _realArrowDirection]];
            break;
    }
    return CGRectZero;
}

- (UIView *)presentedView {
    UIView *v = self.presentedViewController.view;
    v.backgroundColor = self.backgroundColor;
    v.layer.cornerRadius = 5;
    v.clipsToBounds = YES;
    return v;
}

#pragma mark - Private Methods

- (void)_configArrowViewRotation {
    switch (self.permittedArrowDirections) {
        case UIPopoverArrowDirectionUp:
        case UIPopoverArrowDirectionDown:
        case UIPopoverArrowDirectionLeft:
        case UIPopoverArrowDirectionRight:
            [self _configArrowViewRotationWithArrowDirection:self.permittedArrowDirections];
            break;
        default:
            [self _configArrowViewRotationWithArrowDirection:[self _realArrowDirection]];
            break;
    }
}

- (CGRect)_frameOfPresentedViewInContainerViewWithArrowDirection:(UIPopoverArrowDirection)permittedArrowDirections {
    switch (permittedArrowDirections) {
        case UIPopoverArrowDirectionUp:
            return [self _downframeOfPresentedViewInContainerView];
            break;
        case UIPopoverArrowDirectionDown:
            return [self _upframeOfPresentedViewInContainerView];
            break;
        case UIPopoverArrowDirectionLeft:
            return [self _rightframeOfPresentedViewInContainerView];
            break;
        case UIPopoverArrowDirectionRight:
            return [self _leftframeOfPresentedViewInContainerView];
            break;
        default:
            return CGRectZero;
            break;
    }
}

- (UIPopoverArrowDirection)_realArrowDirection {
    CGFloat width = self.presentedViewController.preferredContentSize.width;
    CGFloat height = self.presentedViewController.preferredContentSize.height;
    CGRect sourceViewFrameInContainerView = [self sourceViewFrameInContainerView];
    CGFloat up = CGRectGetMinY(sourceViewFrameInContainerView);
    CGFloat down = CGRectGetHeight(self.containerView.bounds) - CGRectGetMaxY(sourceViewFrameInContainerView);
    CGFloat left = CGRectGetMinX(sourceViewFrameInContainerView);
    CGFloat right = CGRectGetWidth(self.containerView.bounds) - CGRectGetMaxX(sourceViewFrameInContainerView);
    if (down >= height) {
        return UIPopoverArrowDirectionUp;
    } else if (up >= height) {
        return UIPopoverArrowDirectionDown;
    } else if (right >= width) {
        return UIPopoverArrowDirectionLeft;
    } else if (left >= width) {
        return UIPopoverArrowDirectionRight;
    }
    return UIPopoverArrowDirectionUp;
}

- (CGRect)_upframeOfPresentedViewInContainerView {
    CGFloat width = self.presentedViewController.preferredContentSize.width;
    CGFloat height = self.presentedViewController.preferredContentSize.height;
    CGRect sourceViewFrameInContainerView = [self sourceViewFrameInContainerView];
    width = MIN(width, CGRectGetWidth(self.containerView.bounds));
    height = MIN(height, CGRectGetMinY(sourceViewFrameInContainerView));
    CGFloat x = sourceViewFrameInContainerView.origin.x + sourceViewFrameInContainerView.size.width / 2.0 - width / 2.0;
    x = MAX(x, 0);
    x = MIN(x, CGRectGetWidth(self.containerView.bounds) - width);
    CGFloat y = CGRectGetMinY(sourceViewFrameInContainerView) - height;
    return CGRectMake(x, y, width, height);
}

- (CGRect)_downframeOfPresentedViewInContainerView {
    CGFloat width = self.presentedViewController.preferredContentSize.width;
    CGFloat height = self.presentedViewController.preferredContentSize.height;
    CGRect sourceViewFrameInContainerView = [self sourceViewFrameInContainerView];
    width = MIN(width, CGRectGetWidth(self.containerView.bounds));
    height = MIN(height, CGRectGetHeight(self.containerView.bounds) - CGRectGetMaxY(sourceViewFrameInContainerView));
    CGFloat x = sourceViewFrameInContainerView.origin.x + sourceViewFrameInContainerView.size.width / 2.0 - width / 2.0;
    x = MAX(x, 0);
    x = MIN(x, CGRectGetWidth(self.containerView.bounds) - width);
    CGFloat y = CGRectGetMaxY(sourceViewFrameInContainerView);
    return CGRectMake(x, y, width, height);
}

- (CGRect)_leftframeOfPresentedViewInContainerView {
    CGFloat width = self.presentedViewController.preferredContentSize.width;
    CGFloat height = self.presentedViewController.preferredContentSize.height;
    CGRect sourceViewFrameInContainerView = [self sourceViewFrameInContainerView];
    width = MIN(width, CGRectGetMinX(sourceViewFrameInContainerView));
    height = MIN(height, CGRectGetHeight(self.containerView.bounds));
    CGFloat x = CGRectGetMinX(sourceViewFrameInContainerView) - width;
    CGFloat y = sourceViewFrameInContainerView.origin.y + sourceViewFrameInContainerView.size.width / 2.0 - height / 2.0;
    y = MAX(y, 0);
    y = MIN(y, CGRectGetHeight(self.containerView.bounds) - height);
    return CGRectMake(x, y, width, height);
}

- (CGRect)_rightframeOfPresentedViewInContainerView {
    CGFloat width = self.presentedViewController.preferredContentSize.width;
    CGFloat height = self.presentedViewController.preferredContentSize.height;
    CGRect sourceViewFrameInContainerView = [self sourceViewFrameInContainerView];
    width = MIN(width, CGRectGetWidth(self.containerView.bounds) - CGRectGetMaxX(sourceViewFrameInContainerView));
    height = MIN(height, CGRectGetHeight(self.containerView.bounds));
    CGFloat x = CGRectGetMaxX(sourceViewFrameInContainerView);
    CGFloat y = sourceViewFrameInContainerView.origin.y + sourceViewFrameInContainerView.size.width / 2.0 - height / 2.0;
    y = MAX(y, 0);
    y = MIN(y, CGRectGetHeight(self.containerView.bounds) - height);
    return CGRectMake(x, y, width, height);
}

- (void)_handleTapGestureAction:(UITapGestureRecognizer *)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (CGRect)sourceViewFrameInContainerView {
    if (self.barButtonItem) {
        return [self.barButtonItem _frameInView:self.containerView];
    }
    return [self.containerView convertRect:self.sourceRect fromView:self.sourceView];
}

- (void)_configArrowViewRotationWithArrowDirection:(UIPopoverArrowDirection)permittedArrowDirections {
    switch (permittedArrowDirections) {
        case UIPopoverArrowDirectionUp:
            self.arrowView.transform = CGAffineTransformIdentity;
            break;
        case UIPopoverArrowDirectionDown:
            self.arrowView.transform = CGAffineTransformMakeRotation(M_PI);
            break;
        case UIPopoverArrowDirectionLeft:
            self.arrowView.transform = CGAffineTransformMakeRotation(-M_PI_2);
            break;
        case UIPopoverArrowDirectionRight:
            self.arrowView.transform = CGAffineTransformMakeRotation(M_PI_2);
            break;
        default:
            self.arrowView.transform = CGAffineTransformIdentity;
            break;
    }
}

- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] init];
        _backgroundView.backgroundColor = WYPopoverBackgroundDismissColor();
    }
    return _backgroundView;
}

- (UIView *)arrowView {
    if (!_arrowView) {
        UIImage *image = [[UIImage imageNamed:@"img_arrow_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeBottom;
        imageView.tintColor = self.backgroundColor;
        imageView.image = image;
        _arrowView = imageView;
    }
    return _arrowView;
}

- (UITapGestureRecognizer *)tapGesture {
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_handleTapGestureAction:)];
    }
    return _tapGesture;
}

@end

@implementation UIBarButtonItem(Frame)

- (CGRect)_frameInView:(UIView *)v {
    UIView *theView = self.customView;
    if (!theView.superview && [self respondsToSelector:@selector(view)]) {
        theView = [self performSelector:@selector(view)];
    }
    if (theView) {
        UIView *parentView = theView.superview;
        CGRect rect = theView.bounds;
        rect.size.height = parentView.bounds.size.height - theView.frame.origin.y;
        return [theView convertRect:rect toView:v];
    } else {
        return CGRectZero;
    }
}

@end
