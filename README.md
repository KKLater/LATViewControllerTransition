# LATViewControllerTransition

* 封装一个遵守`UIViewControllerTransitioningDelegate`、`UIViewControllerAnimatedTransitioning`协议对象，用于简化界面转场实现的`UIViewController`类的扩展。

## 开始使用

### 【能做什么】

* block方式设置`push`、`pop`、`present`、`dismiss`转场动画。
* 属性方式设置`push`、`pop`、`present`、`dismiss`转场动画时间。

### 【导入】

* 目前仅支持手动导入。直接将`UIViewController+LATTransitionCategory.h`和`UIViewController+LATTransitionCategory.m`文件直接引入到项目中。

### 【事例】

#### present/dismiss

##### 1.模态过渡时间设置

在控制器被模态显示之前，直接通过设置`presentAnimationTimeInterval`属性进行设置模态转场时间。设置类型为`NSTimeInterval`。设置值必须大于0s，否则设置不成功，调用时会使用默认值：0.5s。

```objective-c
//设置present转场动画执行时间，默认0.5s
self.presentAnimationTimeInterval = 0.5;
```

##### 2.模态过渡block设置

必须在控制器被模态显示之前设置。设置类型为block方式。

设置可以为空，但为空时模态转场过渡不执行任何操作。无法达到模态转场过渡的效果。

block执行过程在设置的`presentAnimationTimeInterval`时间内执行结束。

```objective-c
//设置present转场动画执行block
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

##### 3.设置`dismiss`转场过渡时间

同样通过设置`dismissAnimationTomeInterval`属性直接设置。设置类型为`NSTimeInterval`，设置值必须大于0s，否则设置时间将不起作用，调用时使用默认值0.5s。

```objective-c
//设置dismiss转场动画执行时间，默认0.5s
self.dismissAnimationTomeInterval = 1;
```

##### 4.设置`dismiss`转场过渡block

设置类型为block方式。

设置可以为空，但为空时模态转场过渡不执行任何操作。无法达到模态转场过渡的效果。

block执行过程在设置的`dismissAnimationTomeInterval`时间内执行结束。

```objective-c
//设置dismiss转场动画执行block
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

#### push/pop

##### 1.push转场过渡时间设置

属性设置。

```objective-c
//设置push转场过渡时间
self.pushAnimationTimeInterval = 0.5;
```

##### 2.push转场过渡执行block

block方式设置，可以为空，执行push时，将不执行任何操作。

```objective-c
//设置push转场动画执行block
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
```

##### 3.pop转场过渡执行时间设置

设置`popAnimationTimeInterval`属性。数据类型`NSTimeInterval`。必须大于0，否则设置失败，按默认0.5s执行过渡。

```objective-c
//设置pop过渡时间
self.popAnimationTimeInterval = 1;
```

##### 4.pop转场过渡执行block

block方式设置pop转场过渡执行。可以为空，将不执行任何操作。

```objective-c
//设置pop转场动画执行block
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
```

##### 5.转场相关block

`UINavigationControllerDelegate`存在视图将要显示和视图已经显示的代理方法。

```objective-c
//willShow
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated;
//diShow
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated;
```

我们可以通过设置block来实现代理相关方法。

```objective-c
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
```



### 【注意】

1、`present/dismiss`是对`toVC`进行设置;

`push/pop`相关设置是对`fromVC`进行设置。

`willShowBlock\didShowBlock`可以对`toVC\fromVC`进行独立设置，仅在`push\pop`时有效。

2、以下相关类似方法调用时的animated必须为YES，否则不执行相关界面切换过渡

```objective-c
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (nullable UIViewController *)popViewControllerAnimated:(BOOL)animated;
- (void)presentViewController:(UIViewController *)viewControllerToPresent animated: (BOOL)flag completion:(void (^ __nullable)(void))completion;
- (void)dismissViewControllerAnimated: (BOOL)flag completion: (void (^ __nullable)(void))completion;
```



### 【期望】

* 1、此次封装对于present\dismiss、push\pop各种block设置比较繁琐，后期将给予简化。


* 2、这次封装没有涉及到交互动画，期望后期会加入交互动画的设置

  ​

### 【联系方式】

如有疑问，请联系Later：lshxin89@126.com。

欢迎交流学习！