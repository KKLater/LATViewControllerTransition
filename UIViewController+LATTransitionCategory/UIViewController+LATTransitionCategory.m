
//
//  UIViewController+LATTrasitionCategory.m
//  Git:https://github.com/KKLater/LATViewControllerTransition.git
//
//  Created by Later on 16/6/7.
//  Copyright © 2016年 Later. All rights reserved.
//

#import "UIViewController+LATTransitionCategory.h"
#import <objc/runtime.h>

#pragma mark LATPresentViewControllerTransition
@interface LATPresentViewControllerTransition : NSObject<UIViewControllerAnimatedTransitioning>
@end
@implementation LATPresentViewControllerTransition
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    return toVC.presentAnimationTimeInterval;
}
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    [self presentAnimateTransition:transitionContext];
}
- (void)presentAnimateTransition:(id<UIViewControllerContextTransitioning>)transitionContext  {
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    !toVC.LATTransitionPresentAnimationBlock ?: toVC.LATTransitionPresentAnimationBlock(transitionContext);
}
@end
#pragma mark LATDismissViewControllerTransition
@interface LATDismissViewControllerTransition : NSObject<UIViewControllerAnimatedTransitioning>
@end
@implementation LATDismissViewControllerTransition
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    return fromVC.dismissAnimationTomeInterval;
}
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    [self dismissAnimateTransition:transitionContext];
}
- (void)dismissAnimateTransition:(id<UIViewControllerContextTransitioning>)transitionContext  {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    !fromVC.LATTransitionDismissAnimationBlock ?: fromVC.LATTransitionDismissAnimationBlock(transitionContext);
}
@end
#pragma mark LATViewControllerTransitionDelegate
@interface LATViewControllerTransitionDelegate : NSObject<UIViewControllerTransitioningDelegate>
@end
@implementation LATViewControllerTransitionDelegate
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    LATPresentViewControllerTransition *presentTransition = [[LATPresentViewControllerTransition alloc] init];
    return presentTransition;
}
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    LATDismissViewControllerTransition *dismissTransition = [[LATDismissViewControllerTransition alloc] init];
    return dismissTransition;
}
@end
#pragma mark UIViewController+LATTransitionCategory
@interface UIViewController ()
@property (strong, nonatomic) LATViewControllerTransitionDelegate *latTransitionDelegate;
@end
@implementation UIViewController (LATTransitionCategory)
- (void (^)(id<UIViewControllerContextTransitioning>))LATTransitionPresentAnimationBlock {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setLATTransitionPresentAnimationBlock:(void (^)(id<UIViewControllerContextTransitioning>))LATTransitionPresentAnimationBlock {
    if (!self.transitioningDelegate) {
        self.transitioningDelegate = self.latTransitionDelegate;
    }
    objc_setAssociatedObject(self, @selector(LATTransitionPresentAnimationBlock), LATTransitionPresentAnimationBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSTimeInterval)presentAnimationTimeInterval {
    NSTimeInterval time = [objc_getAssociatedObject(self, _cmd) floatValue];
    if (time <= 0) {
        time = 0.5;
        objc_setAssociatedObject(self, _cmd, @(time), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return time;
}
- (void)setPresentAnimationTimeInterval:(NSTimeInterval)presentAnimationTimeInterval {
    if (presentAnimationTimeInterval <= 0) {
        return;
    }
    objc_setAssociatedObject(self, @selector(presentAnimationTimeInterval), @(presentAnimationTimeInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void (^)(id<UIViewControllerContextTransitioning>))LATTransitionDismissAnimationBlock {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setLATTransitionDismissAnimationBlock:(void (^)(id<UIViewControllerContextTransitioning>))LATTransitionDismissAnimationBlock {
    if (!self.transitioningDelegate) {
        self.transitioningDelegate = self.latTransitionDelegate;
    }
    objc_setAssociatedObject(self, @selector(LATTransitionDismissAnimationBlock), LATTransitionDismissAnimationBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSTimeInterval)dismissAnimationTomeInterval {
    NSTimeInterval time = [objc_getAssociatedObject(self, _cmd) floatValue];
    if (time <= 0) {
        time = 0.5;
        objc_setAssociatedObject(self, _cmd, @(time), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return time;
}
- (void)setDismissAnimationTomeInterval:(NSTimeInterval)dismissAnimationTomeInterval {
    if (dismissAnimationTomeInterval <= 0) {
        return;
    }
    objc_setAssociatedObject(self, @selector(dismissAnimationTomeInterval), @(dismissAnimationTomeInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (LATViewControllerTransitionDelegate *)latTransitionDelegate {
    LATViewControllerTransitionDelegate *delegate = objc_getAssociatedObject(self, _cmd);
    if (!delegate) {
        delegate = [LATViewControllerTransitionDelegate new];
        objc_setAssociatedObject(self, _cmd, delegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return delegate;
}
- (void)setLAtTransitionDelegate:(LATViewControllerTransitionDelegate *)latTransitionDelegate {
    objc_setAssociatedObject(self, @selector(latTransitionDelegate), latTransitionDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
