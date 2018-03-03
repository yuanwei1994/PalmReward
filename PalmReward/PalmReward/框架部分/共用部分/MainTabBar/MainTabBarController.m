//
//  MainTabBarController.m
//  项目二
//
//  Created by rimi on 16/11/2.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import "MainTabBarController.h"
//#import "NetEasyViewController.h"
#import "PRHomeViewController.h"
#import "PRWantedViewController.h"
#import "PRMessagesViewController.h"
#import "PRMineViewController.h"
#import "PRLogInViewController.h"

@interface MainTabBarController ()<UITabBarControllerDelegate>

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *viewControllers = @[[[PRHomeViewController alloc]init],[[PRWantedViewController alloc]init],[[PRMessagesViewController alloc]init],[[PRMineViewController alloc]init]];
    
    NSArray *tabBarItemTitle = @[@"首 页",@"悬 赏",@"消 息",@"我 的"];
    
    NSArray *tabBarItemImage = @[[UIImage imageNamed:@"PR-首页-none"],[UIImage imageNamed:@"PR-悬赏-none"],[UIImage imageNamed:@"PR-消息-none"],[UIImage imageNamed:@"PR-我的-none"]];
    
    NSArray *tabBarItemSelectedImage = @[[UIImage imageNamed:@"PR-首页-select"],[UIImage imageNamed:@"PR-悬赏-select"],[UIImage imageNamed:@"PR-消息-select"],[UIImage imageNamed:@"PR-我的-select"]];
    
    _VCArray = [NSMutableArray array];
    
    for (int i = 0; i<viewControllers.count; i++) {
//        if (i == 2 ) {
//            NSArray * array=@[@"头条", @"娱乐", @"热点", @"科技", @"金融", @"图片", @"时尚", @"军事", @"历史", @"电影", @"体育"];
//            NetEasyViewController * newVC = [[NetEasyViewController  alloc] initWithTitles:array viewControllers:nil];
//            UITabBarItem * item = [[UITabBarItem alloc] initWithTitle:tabBarItemTitle[i] image:tabBarItemImage[i] selectedImage:tabBarItemSelectedImage[i]];
//            newVC.tabBarItem = item;
//            [VCArray addObject:newVC];
//        }else{
        UIViewController * vc = viewControllers[i];
        UITabBarItem * item = [[UITabBarItem alloc] initWithTitle:tabBarItemTitle[i] image:tabBarItemImage[i] selectedImage:tabBarItemSelectedImage[i]];
        vc.tabBarItem = item;
        vc.title = tabBarItemTitle[i];
        UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:vc];
        nav.navigationBar.barTintColor = COLOR_RGB(235, 235, 235, 0.2);
        nav.view.backgroundColor = COLOR_RGB(235, 235, 235, 0.9);
        [_VCArray addObject:nav];
//        }
    }
    self.tabBar.tintColor = [UIColor whiteColor];
    self.tabBar.barTintColor = [UIColor blackColor];//[UIColor colorWithRed:234/255.0 green:225/255.0 blue:198/255.0 alpha:1];
    self.delegate = self;
    self.viewControllers = _VCArray;
}
//
//- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController;
//{
//    if (tabBarController.selectedIndex == 2) {
//        if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"]) {
//            self.tabBarController.tabBar.hidden = YES;
//            [self presentViewController:[PRLogInViewController new]  animated:YES completion:nil];
//        }
//    }
//}



@end
