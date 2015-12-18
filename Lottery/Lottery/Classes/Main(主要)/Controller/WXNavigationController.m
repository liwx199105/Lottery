//
//  WXNavigationController.m
//  35-我的彩票
//
//  Created by 李伟雄 on 15/12/15.
//  Copyright © 2015年 小码哥. All rights reserved.
//

#import "WXNavigationController.h"
#import "UIImage+Image.h"

@interface WXNavigationController () <UINavigationControllerDelegate, UIGestureRecognizerDelegate>

// 用来记录系统的手势代理
@property (nonatomic, strong) id popDelegate;

@end

@implementation WXNavigationController

// 当加载类的时候调用,把类加载到内存,存放在代码区
// 当程序启动的时候调用
//+ (void)load
//{
//
//}

// 第一次使用当前类或者它的子类的时候调用
+ (void)initialize
{
    if (self == [WXNavigationController class]) {
        
        // 方式一
        // 一次性设置导航条的样式
        // 设置程序所有导航条样式,应用程序所有导航条都会改变
        // UINavigationBar *navBar = [UINavigationBar appearance];

        // 取出当前导航控制器的导航条appearanceWhenContainedIn:方法已过期
        UINavigationBar *navBar = [UINavigationBar appearanceWhenContainedIn:self, nil];
        
        // 设置导航条的背景图片
        [navBar setBackgroundImage:[UIImage imageNamed:@"NavBar64"] forBarMetrics:UIBarMetricsDefault];
        
        // 设置导航控制器的导航条的标题样式
        NSDictionary *attrDict = @{
                                   NSFontAttributeName : [UIFont boldSystemFontOfSize:20],
                                   NSForegroundColorAttributeName : [UIColor whiteColor]
                                   };
        [navBar setTitleTextAttributes:attrDict];
        
        // 方式二 iOS9新增appearanceWhenContainedInInstancesOfClasses方法
        // 一次性设置导航条的样式
//        [[UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[[WXNavigationController class]]] setBackgroundImage:[UIImage imageNamed:@"NavBar64"] forBarMetrics:UIBarMetricsDefault];
//        
//        // 设置导航控制器的导航条的标题样式
//        NSDictionary *attrDict = @{
//                                   NSFontAttributeName : [UIFont boldSystemFontOfSize:20],
//                                   NSForegroundColorAttributeName : [UIColor whiteColor]
//                                   };
//        [[UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[[WXNavigationController class]]] setTitleTextAttributes:attrDict];
        
        
        
        // 使用投机小技巧,将导航条的主题改成白色的,并把文字移除屏幕
//        [navBar setTintColor:[UIColor whiteColor]];
        
        // 导航条的内容由UIBarButtonItem决定
        // ???: 不明白以下方法如何获取所有UIBarButtonItem
        // 获取当前类所有的UIBarButtonItem, 将返回按钮的标题移除显示区域
//        UIBarButtonItem *barButtonItem = [UIBarButtonItem appearanceWhenContainedIn:self, nil];
//        [barButtonItem setBackButtonTitlePositionAdjustment:UIOffsetMake(-1000, 0) forBarMetrics:UIBarMetricsDefault];
        
    
    }
  
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 1.系统的手势类型:UIScreenEdgePanGestureRecognizer,是边缘拖动手势,不能全屏滑动
    UIScreenEdgePanGestureRecognizer *gesture = (UIScreenEdgePanGestureRecognizer *)self.interactivePopGestureRecognizer;
    // 取消系统的滑动功能
    gesture.enabled = NO;
    
    // 2.target:_UINavigationInteractiveTransition
    // 取出导航控制器系统边缘滑动手势监听的target
    NSMutableArray *targets = [gesture valueForKeyPath:@"_targets"];
    id gestureTarget = [targets firstObject];
    id target = [gestureTarget valueForKeyPath:@"_target"];
    
    // 3.action:(滑动返回功能)handleNavigationTransition:
    // 根据观察,导航控制器系统边缘滑动手势调用 target的handleNavigationTransition:方法
    // 自定义手势也直接调用系统滑动手势调用的方法handleNavigationTransition:,实现全屏都可滑动
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
    
    // 设置拖动手势代理,目的是为了让导航控制器的根控制器不能拖动
    pan.delegate = self;
    
    // 系统手势的view上
    [gesture.view addGestureRecognizer:pan];
    
}

// 判断是否允许触发手势
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    // 设置根控制器不能滑动 如果是根控制器,返回NO
    return self.childViewControllers.count > 1;
}

// 重写pushViewController方法,通过该方法实现统一修改导航栏左边的返回按钮
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // 判断是否是导航控制器的根控制器,如果是根控制器,则不添加导航条左边返回按钮
    if (self.childViewControllers.count != 0) {
        // 设置跳转的目标控制器的返回按钮为白色箭头的图片
        // 以下操作覆盖了导航条系统自带的返回按钮,系统的边缘滑动功能失效,不会是自定义手势失效
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithOriginalImageName:@"NavBack"] style:UIBarButtonItemStyleDone target:self action:@selector(leftBarButtonClick)];
        
        // 导航控制器子控制器跳转,隐藏底部TabBar, 也可以在storyboard中设置子控制器的hidesBottomBarWhenPushed属性
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    // 执行跳转操作
    [super pushViewController:viewController animated:animated];
}

// 点击左边的按钮,执行popViewControllerAnimated操作
- (void)leftBarButtonClick
{
    // 点击左边返回按钮,执行pop操作
    [self popViewControllerAnimated:YES];
}





@end
