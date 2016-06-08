# LATViewControllerTransition

* 封装一个遵守`UIViewControllerTransitioningDelegate`、`UIViewControllerAnimatedTransitioning`协议对象，用于简化界面跳转实现的`UIViewController`类的扩展。

## 开始使用

### 【能做什么】

* block方式设置`UIViewController`及其子类被模态出来的过程动画。
* 属性方式直接设置`UIViewController`及其子类被模态出来的过程动画时间。
* block方式设置模态出来的`UIViewController`及其子类`dismiss`的过程动画。
* 属性方式直接设置模态出来的`UIViewController`及其子类`dismiss`过程动画时间。

### 【导入】

* 目前仅支持手动导入。直接将`UIViewController+LATTransitionCategory.h`和`UIViewController+LATTransitionCategory.m`文件直接引入到项目中。

### 【事例】

#### 1.模态过程时间设置

在控制器被模态显示之前，直接通过设置`presentAnimationTimeInterval`属性进行设置模态时间。设置类型为`NSTimeInterval`。设置值必须大于0s，否则设置不成功，调用时会使用默认值：0.5s。

```objective-c
//设置present动画执行时间，默认0.5s
self.presentAnimationTimeInterval = 0.5;
```

#### 2.模态过程block设置

必须在控制器被模态显示之前设置。设置类型为block方式。

设置可以为空，但为空时模态过程不执行任何操作。无法达到模态显示的效果。

block执行过程在设置的`presentAnimationTimeInterval`时间内执行结束。

```objective-c
//设置present动画执行block
[self setLATTransitionPresentAnimationBlock:^(id<UIViewControllerContextTransitioning> transitionContext) {
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    toVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    toVC.view.alpha = 0;
        
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toVC.view];     
    [UIView animateWithDuration:toVC.presentAnimationTimeInterval
                          delay:0.0
         usingSpringWithDamping:.85
          initialSpringVelocity:1
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         toVC.view.alpha = 1;
                         toVC.view.transform = CGAffineTransformIdentity;
                     } completion:^(BOOL finished) {
                         [transitionContext completeTransition:YES];
                     }];
}];
```

#### 3.设置`dismiss`过程时间

同样通过设置`dismissAnimationTomeInterval`属性直接设置。设置类型为`NSTimeInterval`，设置值必须大于0s，否则设置时间将不起作用，调用时使用默认值0.5s。

```objective-c
//设置dismiss动画执行时间，默认0.5s
self.dismissAnimationTomeInterval = 1;
```

#### 4.设置`dismiss`过程block

设置类型为block方式。

设置可以为空，但为空时模态过程不执行任何操作。无法达到模态显示的效果。

block执行过程在设置的`dismissAnimationTomeInterval`时间内执行结束。

```objective-c
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
```

### 【知识扩展】

```objective-c
//通过遵守UIViewControllerContextTransitioning协议的对象transitionContext获取被模态出来的控制器的方法
UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
//通过遵守UIViewControllerContextTransitioning协议的对象transitionContext获取源控制器的方法
UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
//获取containerView的方法
UIView *containerView = [transitionContext containerView];
//block内，若要设置整个present或者dismiss过程的动画，可以直接使用属性的getter方法，设置动画时间
//present
NSTimeInterval presentDuration = toVC.presentAnimationTimeInterval;
//dismiss
NSTimeInterval dismissDuration = fromVC.dismissAnimationTimeInterval;
```

### 【注意】

* `-(void)presentViewController:(UIViewController *)viewControllerToPresent animated: (BOOL)flag completion:(void (^ __nullable)(void))completion;`方法调用时，animated必须为YES，否则不执行present过程。
* `-(void)dismissViewControllerAnimated: (BOOL)flag completion: (void (^ __nullable)(void))completion;`方法调用时，同样animated必须设置为YES，否则dismiss过程将不执行。

### 【联系方式】

如有疑问，请联系Later：lshxin89@126.com。

欢迎交流学习！