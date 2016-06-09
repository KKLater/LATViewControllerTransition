
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

#pragma mark LATPushViewControllerTransition
@interface LATPushViewControllerTransition : NSObject<UIViewControllerAnimatedTransitioning>
@end
@implementation LATPushViewControllerTransition
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    return fromVC.pushAnimationTimeInterval;
}
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    !fromVC.LATTransitionPushAnimationBlock ?: fromVC.LATTransitionPushAnimationBlock(transitionContext);
}
@end
#pragma mark LATPopViewControllerTransition
@interface LATPopViewControllerTransition : NSObject<UIViewControllerAnimatedTransitioning>
@end
@implementation LATPopViewControllerTransition
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    return toVC.popAnimationTimeInterval;
}
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    !toVC.LATTransitionPopAnimationBlock ?: toVC.LATTransitionPopAnimationBlock(transitionContext);
}
@end
#pragma mark LATNavigationControllerDelegate
@interface LATNavigationControllerDelegate : NSObject<UINavigationControllerDelegate>
@end
@implementation LATNavigationControllerDelegate
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    switch (operation) {
        case UINavigationControllerOperationNone: {
            nil;
            break;
        }
        case UINavigationControllerOperationPush: {
            return [[LATPushViewControllerTransition alloc] init];
            break;
        }
        case UINavigationControllerOperationPop: {
            return [[LATPopViewControllerTransition alloc] init];
            break;
        }
    }
    return nil;
}
//- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
//    
//}
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    !viewController.LATNavigationControllerWillShowBlock ?: viewController.LATNavigationControllerWillShowBlock(navigationController, viewController, animated);
}
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    !viewController.LATNavigationControllerDidShowBlock ?: viewController.LATNavigationControllerDidShowBlock(navigationController, viewController, animated);
}
@end





#pragma mark UIViewController+LATTransitionCategory
@interface UIViewController ()
@property (strong, nonatomic) LATViewControllerTransitionDelegate *latTransitionDelegate;
@property (strong, nonatomic) LATNavigationControllerDelegate *latNavigationControllerDelegate;
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

#pragma mark push/pop
- (void (^)(id<UIViewControllerContextTransitioning>))LATTransitionPushAnimationBlock {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setLATTransitionPushAnimationBlock:(void (^)(id<UIViewControllerContextTransitioning>))LATTransitionPushAnimationBlock {
    if (!self.navigationController.delegate) {
        self.navigationController.delegate = self.latNavigationControllerDelegate;
    }
    objc_setAssociatedObject(self, @selector(LATTransitionPushAnimationBlock), LATTransitionPushAnimationBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSTimeInterval)pushAnimationTimeInterval {
    NSTimeInterval pushTime = [objc_getAssociatedObject(self, _cmd) floatValue];
    if (pushTime <= 0) {
        pushTime = 0.5;
        objc_setAssociatedObject(self, _cmd, @(pushTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return pushTime;
}
- (void)setPushAnimationTimeInterval:(NSTimeInterval)pushAnimationTimeInterval {
    if (pushAnimationTimeInterval <= 0) {
        return;
    }
    objc_setAssociatedObject(self, @selector(pushAnimationTimeInterval), @(pushAnimationTimeInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void (^)(id<UIViewControllerContextTransitioning>))LATTransitionPopAnimationBlock {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setLATTransitionPopAnimationBlock:(void (^)(id<UIViewControllerContextTransitioning>))LATTransitionPopAnimationBlock {
    if (!self.navigationController.delegate) {
        self.navigationController.delegate = self.latNavigationControllerDelegate;
    }
    objc_setAssociatedObject(self, @selector(LATTransitionPopAnimationBlock), LATTransitionPopAnimationBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSTimeInterval)popAnimationTimeInterval {
    NSTimeInterval popTime = [objc_getAssociatedObject(self, _cmd) floatValue];
    if (popTime <= 0) {
        popTime = 0.5;
        objc_setAssociatedObject(self, _cmd, @(popTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return popTime;
}
- (void)setPopAnimationTimeInterval:(NSTimeInterval)popAnimationTimeInterval {
    if (popAnimationTimeInterval <= 0) {
        return;
    }
    objc_setAssociatedObject(self, @selector(popAnimationTimeInterval), @(popAnimationTimeInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void (^)(UINavigationController *, UIViewController *, BOOL))LATNavigationControllerWillShowBlock {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setLATNavigationControllerWillShowBlock:(void (^)(UINavigationController *, UIViewController *, BOOL))LATNavigationControllerWillShowBlock {
    objc_setAssociatedObject(self, @selector(LATNavigationControllerWillShowBlock), LATNavigationControllerWillShowBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void (^)(UINavigationController *, UIViewController *, BOOL))LATNavigationControllerDidShowBlock {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setLATNavigationControllerDidShowBlock:(void (^)(UINavigationController *, UIViewController *, BOOL))LATNavigationControllerDidShowBlock {
    objc_setAssociatedObject(self, @selector(LATNavigationControllerDidShowBlock), LATNavigationControllerDidShowBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (LATNavigationControllerDelegate *)latNavigationControllerDelegate {
    LATNavigationControllerDelegate *navigationDelegate = objc_getAssociatedObject(self, _cmd);
    if (!navigationDelegate) {
        navigationDelegate = [LATNavigationControllerDelegate new];
        objc_setAssociatedObject(self, _cmd, navigationDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return navigationDelegate;
}
- (void)setLatNavigationControllerDelegate:(LATNavigationControllerDelegate *)latNavigationControllerDelegate {
    objc_setAssociatedObject(self, @selector(latNavigationControllerDelegate), latNavigationControllerDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
