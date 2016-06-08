//
//  DetailViewController.m
//  LATViewControllerTransitionDemo
//
//  Created by Later on 16/6/8.
//  Copyright © 2016年 Later. All rights reserved.
//

#import "DetailViewController.h"
#import "UIViewController+LATTransitionCategory.h"
@implementation DetailViewController
- (instancetype)init {
    if (self = [super init]) {
        self.modalPresentationStyle = UIModalPresentationCustom;
        
        //设置present动画执行时间，默认0.5s
        self.presentAnimationTimeInterval = 0.5;
        //设置dismiss动画执行时间，默认0.5s
        self.dismissAnimationTomeInterval = 1;
        
        [self setPresentBlocks];
    }
    return self;
}
- (void)dealloc {
    //验证是否释放
    NSLog(@"Detail 释放");
}
- (void)setPresentBlocks {
    //设置present动画执行block
    [self setLATTransitionPresentAnimationBlock:^(id<UIViewControllerContextTransitioning> transitionContext) {
        UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        toVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        toVC.view.alpha = 0;
        
        UIView *containerView = [transitionContext containerView];
        [containerView addSubview:toVC.view];

        [UIView animateWithDuration:toVC.presentAnimationTimeInterval delay:0.0 usingSpringWithDamping:.85 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
            toVC.view.alpha = 1;
            toVC.view.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }];
    
    //设置dismiss动画执行block
    [self setLATTransitionDismissAnimationBlock:^(id<UIViewControllerContextTransitioning> transitionContext) {
        UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        [UIView animateWithDuration:fromVC.dismissAnimationTomeInterval animations:^{
            fromVC.view.alpha = 0;
        } completion:^(BOOL finished) {
            [fromVC.view removeFromSuperview];
            [transitionContext completeTransition:YES];
        }];
    }];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //dismiss need animated
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
