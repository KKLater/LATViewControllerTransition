//
//  ViewController.m
//  LATViewControllerTransitionDemo
//
//  Created by Later on 16/6/8.
//  Copyright © 2016年 Later. All rights reserved.
//

#import "ViewController.h"
#import "DetailViewController.h"
#import "UIViewController+LATTransitionCategory.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pushAnimationTimeInterval = 0.5;
    self.popAnimationTimeInterval = 1;
    [self setPushAndPopBlocks];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)pushNewViewController:(id)sender {
    DetailViewController *detail = [[DetailViewController alloc] init];
    //push
    [self.navigationController pushViewController:detail animated:YES];
}
- (IBAction)presentNewViewController:(id)sender {
    //init need set presentBlocks
    DetailViewController *detail = [[DetailViewController alloc] init];
    //present must be animated
    [self presentViewController:detail animated:YES completion:nil];
}
- (void)setPushAndPopBlocks {
    //设置push动画执行block
    [self setLATTransitionPushAnimationBlock:^(id<UIViewControllerContextTransitioning> transitionContext) {
        UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        toVC.view.alpha = 0;
        
        UIView *containerView = [transitionContext containerView];
        [containerView addSubview:toVC.view];
        [UIView animateWithDuration:toVC.pushAnimationTimeInterval delay:0.0 usingSpringWithDamping:.85 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
            toVC.view.alpha = 1;
            toVC.view.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }];
    
    //设置pop动画执行block
    [self setLATTransitionPopAnimationBlock:^(id<UIViewControllerContextTransitioning> transitionContext) {
        UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        UIView *containerView = [transitionContext containerView];
        [containerView addSubview:toVC.view];
        toVC.view.alpha = 0;
        UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        [UIView animateWithDuration:fromVC.popAnimationTimeInterval animations:^{
            fromVC.view.alpha = 0;
            toVC.view.alpha = 1;
        } completion:^(BOOL finished) {
            [fromVC.view removeFromSuperview];
            [transitionContext completeTransition:YES];
        }];
    }];
    
    [self setLATNavigationControllerWillShowBlock:^(UINavigationController *nav, UIViewController *vc, BOOL animated) {
        NSLog(@"viewControllerClass = %@ 将要显示",NSStringFromClass([vc class]));
    }];
    [self setLATNavigationControllerDidShowBlock:^(UINavigationController *nav, UIViewController *vc, BOOL animated) {
        NSLog(@"viewControllerClass = %@ 已经显示",NSStringFromClass([vc class]));
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
