//
//  UIViewController+LATTrasitionCategory.h
//  Git:https://github.com/KKLater/LATViewControllerTransition.git
//
//  Created by Later on 16/6/7.
//  Copyright © 2016年 Later. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (LATTransitionCategory)
#pragma mark present/dismiss
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
#pragma mark push/pop
/**
 *  @author Later, 16-06-07 17:06
 *
 *  设置push动画时间 default 0.5s
 */
@property (assign, nonatomic) NSTimeInterval pushAnimationTimeInterval;
/**
 *  @author Later, 16-06-07 17:06
 *
 *  设置push动画的block
 */
@property (copy, nonatomic) void (^LATTransitionPushAnimationBlock)(id<UIViewControllerContextTransitioning> transitionContext);
/**
 *  @author Later, 16-06-07 17:06
 *
 *  设置pop动画时间 default 0.5s
 */
@property (assign, nonatomic) NSTimeInterval popAnimationTimeInterval;
/**
 *  @author Later, 16-06-07 17:06
 *
 *  设置pop动画的block
 */
@property (copy, nonatomic) void (^LATTransitionPopAnimationBlock)(id<UIViewControllerContextTransitioning> transitionContext);
/**
 *  @author Later, 16-06-09 09:06
 *
 *  将要显示视图的block
 */
@property (copy, nonatomic) void (^LATNavigationControllerWillShowBlock)(UINavigationController *navigationController, UIViewController *viewController, BOOL animated);
/**
 *  @author Later, 16-06-09 09:06
 *
 *  已经显示视图的block
 */
@property (copy, nonatomic) void (^LATNavigationControllerDidShowBlock)(UINavigationController *navigationController, UIViewController *viewController, BOOL animated);

@end
