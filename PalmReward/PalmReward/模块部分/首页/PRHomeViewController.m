//
//  PRHomeViewController.m
//  PalmReward
//
//  Created by rimi on 16/12/7.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import "PRHomeViewController.h"
#import "PRHomeAllViewController.h"
#import "PRHomeFristViewController.h"
@interface PRHomeViewController ()<VTMagicViewDataSource, VTMagicViewDelegate>

@property(nonatomic, strong)NSArray *menuList;


@end

@implementation PRHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;

    _menuList = @[@"全部愿望",@"超级愿望",@"最新悬赏",@"完成悬赏"];
//    [self addChildViewController:self.magicController];
//    [self.view addSubview:_magicController.view];
//    [_magicController.magicView reloadData];
//    
    self.magicView.navigationHeight = 44;
    self.magicView.againstStatusBar = YES;
    self.magicView.headerView.backgroundColor = [UIColor blackColor];
    //RGBCOLOR(243, 40, 47);
    self.magicView.layoutStyle = VTLayoutStyleDivide;
    //类似网易导航栏颜色
    self.magicView.navigationColor = COLOR_RGB(255, 255, 255, 0.2);
    //COLOR_RGB(242, 235, 217, 1);
    self.magicView.sliderStyle = VTSliderStyleDefault;
    self.magicView.sliderColor = [UIColor blackColor];
    //COLOR_RGB(234, 225, 198, 1);
    self.magicView.bubbleInset = UIEdgeInsetsMake(2, 7, 2, 7);
    self.magicView.bubbleRadius = 10;
    self.magicView.sliderHeight = 2;
    self.magicView.separatorHeight = 0;
    [self.magicView reloadData];
}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = NO;
    [super viewWillAppear:animated];
}

#pragma delegate
- (NSArray<NSString *> *)menuTitlesForMagicView:(VTMagicView *)magicView
{
    return _menuList;
}

- (UIButton *)magicView:(VTMagicView *)magicView menuItemAtIndex:(NSUInteger)itemIndex
{
    static NSString *itemIdentifier = @"itemIdentifier";
    UIButton *menuItem = [magicView dequeueReusableItemWithIdentifier:itemIdentifier];
    if (!menuItem) {
        menuItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [menuItem setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [menuItem setTitleColor:[UIColor blackColor]/*RGBCOLOR(96, 0, 7)*/ forState:UIControlStateSelected];
        menuItem.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:16.f];
    }
    return menuItem;
}

- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerAtPage:(NSUInteger)pageIndex
{
    switch (pageIndex) {
        case 0:
        {
            PRHomeFristViewController* recomViewController = [[PRHomeFristViewController alloc] init];
            
            return recomViewController;
        }
            break;
        case 1:
        {
            PRHomeAllViewController* recomViewController = [[PRHomeAllViewController alloc] init];
            recomViewController.index = 1;
            return recomViewController;
            
        }
            break;
        case 2:
        {
            PRHomeAllViewController* recomViewController = [[PRHomeAllViewController alloc] init];
            recomViewController.index = 2;
            return recomViewController;
            
        }
            break;
        case 3:
        {
            PRHomeAllViewController* recomViewController = [[PRHomeAllViewController alloc] init];
            recomViewController.index = 3;
            return recomViewController;
            
        }
            break;
        default:
            break;
    }
    return nil;
}


- (void)magicView:(VTMagicView *)magicView didSelectItemAtIndex:(NSUInteger)itemIndex{

}

@end
