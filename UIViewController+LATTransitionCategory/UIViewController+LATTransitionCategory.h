//
//  UIViewController+LATTrasitionCategory.h
//  Git:https://github.com/KKLater/LATViewControllerTransition.git
//
//  Created by Later on 16/6/7.
//  Copyright © 2016年 Later. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (LATTransitionCategory)
/**
 *  @author Later, 16-06-07 17:06
 *
 *  设置present动画时间 default 0.5s
 */
@property (assign, nonatomic) NSTimeInterval presentAnimationTimeInterval;

/**
 *  @author Later, 16-06-07 17:06
 *
 *  设置present动画的block
 */
@property (copy, nonatomic) void (^LATTransitionPresentAnimationBlock)(id<UIViewControllerContextTransitioning> transitionContext);
/**
 *  @author Later, 16-06-07 17:06
 *
 *  设置dismiss动画时间 default 0.5s
 */
@property (assign, nonatomic) NSTimeInterval dismissAnimationTomeInterval;
/**
 *  @author Later, 16-06-07 17:06
 *
 *  设置dismiss动画block
 */
@property (copy, nonatomic) void (^LATTransitionDismissAnimationBlock)(id<UIViewControllerContextTransitioning> transitionContext);
@end
