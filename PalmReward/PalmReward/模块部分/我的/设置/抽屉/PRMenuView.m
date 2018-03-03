//
//  PRMenuView.m
//  PalmReward
//
//  Created by Candy on 16/12/17.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import "PRMenuView.h"
#import "PRMenuTableViewCell.h"

#import "PRButton.h"
#import "PRImageButton.h"
#import "PRDrawerView.h"
#import "UIButton+WebCache.h"

#define CELL_INDENTIFIER  @"cellIdentifier"

@interface PRMenuView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView                   *tableView;
@property (nonatomic, strong) NSArray                       *dataSource;        //菜单列表

@property (nonatomic, strong) UIView                        *headView;          //头部视图
@property (nonatomic, strong) UIView                        *centerView;        //中部视图
@property (nonatomic, strong) PRImageButton                 *avatarButton;      //用户头像以及用户名
@property (nonatomic, strong) PRButton                      *logoutButton;      //退出登录

@end

@implementation PRMenuView{
    CGFloat _viewWidth;
    CGFloat _viewHeight;
    CGFloat _spaceX;
    CGFloat _spaceY;
    
}

//初始化侧边栏控件
- (instancetype)initWithFrame:(CGRect)frame
{
    
    if (self = [super initWithFrame:frame]) {
        //初始化布局
        [self setSomething];
        //注册通知
        [self registNotification];
        
    }
    return self;
}

-(void)setSomething {
    //获取 view 的宽高
    _viewWidth = self.frame.size.width;
    _viewHeight = self.frame.size.height;
    _spaceX = 50 *AAdaptionWidth();
    _spaceY = 100 *AAdaptionWidth();
    [self addSubview:self.headView];
    //将中间视图添加到主视图
    [self addSubview:self.centerView];
    [self addSubview:self.logoutButton];
    
}

- (void)registNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification:) name:@"setUserInfo" object:nil];
}

- (void)notification:(NSNotification *)notification {
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL, [[PRUserModel shareUserModel].user_avatar ReplaceSlash]]] ;
    [_avatarButton setImageWithURL:url forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"默认头像"]];
    [_avatarButton setTitle:[PRUserModel shareUserModel].user_nickname forState:UIControlStateNormal];
}

#pragma mark -- action

//退出登录
- (void)onLogotu {
    //[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLogin"];
    // 创建一个通知中心
    // 发送通知. 其中的Name填写第一界面的Name， 系统知道是第一界面来相应通知， object就是要传的值。 UserInfo是一个字典， 如果要用的话，提前定义一个字典， 可以通过这个来实现多个参数的传值使用。
    [[NSNotificationCenter defaultCenter] postNotificationName:@"logout" object:nil userInfo:@{@"isLogin":@NO}];
    
    
}


-(void)swichonClick:(UISwitch *)sender{
    if (sender.on==YES) {
        _isOpen=YES;
        [[NSUserDefaults standardUserDefaults] setBool:_isOpen forKey:@"yesandno"];
        UITabBarController *my = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        [my.viewControllers  enumerateObjectsUsingBlock:^(__kindof UINavigationController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.viewControllers[0].view.backgroundColor=[UIColor colorWithRed:26/255.0 green:26/255.0 blue:26/255.0 alpha:1];
            [obj.viewControllers[0].navigationController.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateSelected];
        }];
        my.view.alpha=0.6;
        my.tabBar.barTintColor=[UIColor colorWithRed:26/255.0 green:26/255.0 blue:26/255.0 alpha:1];
    }else{
        _isOpen=NO;
        [[NSUserDefaults standardUserDefaults] setBool:_isOpen forKey:@"yesandno"];
        UITabBarController *my = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        [my.viewControllers  enumerateObjectsUsingBlock:^(__kindof UINavigationController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.viewControllers[0].view.backgroundColor=[UIColor whiteColor];
            [obj.viewControllers[0].navigationController.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateSelected];
        }];
        my.view.alpha=1;
        my.tabBar.barTintColor=[UIColor whiteColor];
    }
}

#pragma mark --Toast

//自定义一个 Toast 弹框；
-(void)toastWithString:(NSString *)string View:(UIView *)view{
    
    UILabel *toastLabel = [[UILabel alloc]init];
    toastLabel.bounds = CGRectMake(0, 0, 160 *AAdaptionWidth(), 40 *AAdaptionWidth());
    toastLabel.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds)+100 *AAdaptionWidth());
    toastLabel.text = string;
    toastLabel.alpha = 0.0;
    toastLabel.textAlignment = NSTextAlignmentCenter;
    toastLabel.textColor = [UIColor whiteColor];
    toastLabel.backgroundColor = [UIColor blackColor];
    toastLabel.font = AAFont(14);
    toastLabel.layer.cornerRadius = 4;
    toastLabel.layer.masksToBounds = YES;
    [view addSubview:toastLabel];
    
    [UIView animateWithDuration:0.5 animations:^{
        toastLabel.alpha = 1.0;
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.5 animations:^{
                toastLabel.alpha = 0.0;
            } completion:^(BOOL finished) {
                [toastLabel removeFromSuperview];
            }];
        });
    }];
}

#pragma mark -- dataSource && delefate

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSource.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PRMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_INDENTIFIER forIndexPath:indexPath];
    cell.backgroundColor = COVERVIEW_BACKGROUND;
    cell.nameString = self.dataSource[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.pushViewDelegate respondsToSelector:@selector(pushViewController:)]) {
        //传入选择的下标
        [self.pushViewDelegate pushViewController:indexPath.row];
    }
}

#pragma mark -- getter


-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width,self.frame.size.height) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:@"PRMenuTableViewCell" bundle:nil] forCellReuseIdentifier:CELL_INDENTIFIER];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = 60 ;
        _tableView.backgroundColor = COVERVIEW_BACKGROUND;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

-(NSArray *)dataSource{
    if (!_dataSource) {
        _dataSource = @[@"个人设置", @"系统设置", @"清除缓存"];
    }
    return _dataSource;
}

- (UIView *)headView {
    if (!_headView) {
        _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _viewWidth, _viewHeight/3)];
        _headView.backgroundColor = COVERVIEW_BACKGROUND;
        //将 avatarButton 添加至头部视图
        [_headView addSubview:self.avatarButton];
        
    }
    return _headView;
}

- (UIView *)centerView {
    if (!_centerView) {
        _centerView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headView.frame), _viewWidth , _viewHeight / 2)];
        //将 tableView 添加至中间视图
        [_centerView addSubview:self.tableView];
    }
    return _centerView;
}

- (PRImageButton *)avatarButton {
    if (!_avatarButton) {
        CGFloat imageWidth = 90 *AAdaptionWidth();
        CGFloat imageSpace = (_viewWidth - imageWidth) / 2;
        _avatarButton = [[PRImageButton alloc] initWithTitleRect:CGRectMake(0, imageWidth, _viewWidth, _viewWidth - imageWidth) ImageRect:CGRectMake(imageSpace, 50 *AAdaptionWidth(), imageWidth, imageWidth)];
        _avatarButton.frame = CGRectMake(0, 0, _viewWidth, _viewWidth);
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL, [[PRUserModel shareUserModel].user_avatar ReplaceSlash]]] ;
        [_avatarButton setImageWithURL:url forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"默认头像"]];
        [_avatarButton setTitle:[PRUserModel shareUserModel].user_nickname forState:UIControlStateNormal];
        [_avatarButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_avatarButton.titleLabel setFont:AAFont(20)];
        _avatarButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        _avatarButton.imageView.layer.cornerRadius = imageWidth / 2;
        _avatarButton.imageView.layer.masksToBounds = YES;
        
        
    }
    return _avatarButton;
}

- (PRButton *)logoutButton {
    if (!_logoutButton) {
        CGFloat btnWidth = 120 *AAdaptionWidth();
        CGFloat btnHeight = 40 *AAdaptionWidth();
        _logoutButton = [[PRButton alloc] initWithFrame:CGRectMake((_viewWidth - btnWidth) / 2, _viewHeight - 2 * btnHeight, btnWidth, btnHeight) Title:@"退出登录" TitleColor:[UIColor whiteColor] titleFont:18  backColor:[UIColor clearColor] BackImage:nil Tag:102 radius:0.5 BorderWidth:1 BorderColor:[UIColor whiteColor] Block:^(id sender) {
            [self onLogotu];
            
        }];
        
    }
    return _logoutButton;
}
@end

