//
//  PRMoneyViewController.m
//  PalmReward
//
//  Created by Candy on 16/12/17.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import "PRMoneyViewController.h"
#import "PRImageButton.h"


@interface PRMoneyViewController () {
    
    CGFloat _btnW;
    CGFloat _btnH;
    CGFloat _spaceY;
    CGFloat _spaceX;
}

@property (nonatomic, strong) UIButton      *balanceButton;         //余额按钮
@property (nonatomic, strong) UIButton      *rechargeButton;        //充值按钮
@property (nonatomic, strong) PRImageButton *incomeButton;          //收入按钮
@property (nonatomic, strong) PRImageButton *expenditureButton;     //支出按钮
@property (nonatomic, strong) UILabel       *balanceLabel;          //余额标签

@property (nonatomic, strong) UIView        *topView;               //头部视图
@property (nonatomic, strong) UIView        *centerView;            //中视图
@property (nonatomic, strong) UITableView   *tableView;             //列表视图

@property (nonatomic, strong) UIView        *leftLineView;          //左边横线视图
@property (nonatomic, strong) UIView        *rightLineView;         //右边横线视图




@end


@implementation PRMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setSomething];
}


- (void)setSomething {
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"我的钱袋";
    CGFloat btnWidth = 25.0 * AAdaptionWidth();
    _btnW = 80.0 *AAdaptionWidth();
    _btnH = 30.0 *AAdaptionWidth();
    _spaceX = 20.0 *AAdaptionWidth();
    _spaceY = 40.0 *AAdaptionWidth();
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"我的钱袋";
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.tag = 101;
    [backButton setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    backButton.frame = CGRectMake(0, 0, btnWidth, btnWidth);
    [backButton addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.tag = 102;
    [rightButton setTitle:@"提现" forState:UIControlStateNormal];
    rightButton.frame = CGRectMake(0, 0, 50 *AAdaptionWidth(), btnWidth);
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightButton.titleLabel setFont:AAFont(17)];
    [rightButton addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    [self.view addSubview:self.topView];
    [self.view addSubview:self.centerView];
    //self.navigationController.navigationBar.barTintColor = APP_MAIN_COLOR;
    
    
}

#pragma mark -- action

- (void)onButton:(UIButton *)sender {
    //返回按钮
    if (sender.tag == 101) {
        [self.navigationController popViewControllerAnimated:YES];

    }
    //提现按钮
    if (sender.tag == 102) {
        NSLog(@"提现按钮--->>>");
    }
    //充值按钮
    if (sender.tag == 103) {
        NSLog(@"充值按钮--->>>");

    }
    //收入按钮
    if (sender.tag == 104) {
        NSLog(@"收入按钮--->>>");
        self.leftLineView.hidden = NO;
        self.rightLineView.hidden = YES;
    }
    //支出按钮
    if (sender.tag == 105) {
        NSLog(@"支出按钮--->>>");
        self.leftLineView.hidden = YES;
        self.rightLineView.hidden = NO;
    }
    
}

#pragma mark -- getter
- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, PRwidth, 200 * AAdaptionWidth())];
        _topView.backgroundColor = [UIColor whiteColor];
        [_topView addSubview:self.rechargeButton];
        [_topView addSubview:self.balanceButton];
        [_topView addSubview:self.balanceLabel];
    }
    return _topView;
}

- (UIButton *)balanceButton {
    if (!_balanceButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(_spaceX, _spaceY, _btnW, _btnH);
        [button setTitle:@"钱袋余额" forState:UIControlStateNormal];
        [button.titleLabel setFont:AAFont(18)];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _balanceButton = button;
    }
    return _balanceButton;
}


- (UIButton *)rechargeButton {
    if (!_rechargeButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 103;
        button.frame = CGRectMake(PRwidth - _spaceX - _btnW, _spaceY, _btnW, _btnH);
        [button setTitle:@"立即充值" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
        [button.titleLabel setFont:AAFont(18)];
        _rechargeButton = button;
    }
    return _rechargeButton;
}

- (UILabel *)balanceLabel {
    if (!_balanceLabel) {
        CGFloat labelHeight = 30.0 * AAdaptionWidth();
        _balanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_spaceX, CGRectGetHeight(self.topView.frame) - labelHeight * 2 , PRwidth - 2 * _spaceX, labelHeight)];
        _balanceLabel.text = @"999999";
        _balanceLabel.textAlignment = NSTextAlignmentCenter;
        [_balanceLabel setFont:AAFont(22)];
        [_balanceLabel setTextColor:[UIColor blackColor]];
    }
    return _balanceLabel;
}

- (UIView *)centerView {
    if (!_centerView) {
        _centerView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topView.frame), PRwidth, 100 *AAdaptionWidth())];
        CGFloat lineHeight = 2 *AAdaptionWidth();
        CGFloat imageWidth = 80 *AAdaptionWidth();
        CGFloat imageHeight = 40 *AAdaptionWidth();
        CGFloat btnWidth = PRwidth / 2;
        CGFloat btnHeight = CGRectGetHeight(_centerView.frame) - lineHeight ;
        CGFloat labelWidth = 50.0 *AAdaptionWidth();
        //收入按钮
        _incomeButton = [[PRImageButton alloc] initWithTitleRect:CGRectMake(_spaceX + imageWidth, (btnHeight - imageHeight) / 2, labelWidth, imageHeight) ImageRect:CGRectMake(_spaceX, (btnHeight - imageHeight) / 2, imageWidth, imageHeight)];
        _incomeButton.frame = CGRectMake(0, 0, btnWidth, btnHeight);
        _incomeButton.tag = 104;
        [_incomeButton setTitle:@"收入" forState:UIControlStateNormal];
        [_incomeButton setImage:[UIImage imageNamed:@"收入信息"] forState:UIControlStateNormal];
        [_incomeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_incomeButton.titleLabel setFont:AAFont(17)];
        [_incomeButton addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
        
        //支出按钮
        _expenditureButton = [[PRImageButton alloc] initWithTitleRect:CGRectMake(_spaceX + imageWidth, (btnHeight - imageHeight) / 2, labelWidth, imageHeight) ImageRect:CGRectMake(_spaceX, (btnHeight - imageHeight) / 2, imageWidth, imageHeight)];
        _expenditureButton.frame = CGRectMake(btnWidth, 0, btnWidth, btnHeight);
        _expenditureButton.tag = 105;
        [_expenditureButton setTitle:@"支出" forState:UIControlStateNormal];
        [_expenditureButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_expenditureButton setImage:[UIImage imageNamed:@"支出信息"] forState:UIControlStateNormal];
        [_expenditureButton.titleLabel setFont:AAFont(17)];

        [_expenditureButton addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];

        //左边横线
        _leftLineView = [[UIView alloc] initWithFrame:CGRectMake(0, btnHeight, btnWidth, lineHeight)];
        _leftLineView.backgroundColor = COLOR_RGB(81, 81, 81, 1);
        //右边横线
        _rightLineView = [[UIView alloc] initWithFrame:CGRectMake(btnWidth, btnHeight, btnWidth, lineHeight)];
        _rightLineView.backgroundColor = COLOR_RGB(81, 81, 81, 1);
        //默认右边横线隐藏
        _rightLineView.hidden = YES;

        //添加到中部视图
        [_centerView addSubview:_incomeButton];
        [_centerView addSubview:_expenditureButton];
        [_centerView addSubview:_leftLineView];
        [_centerView addSubview:_rightLineView];
        
    }
    
    return _centerView;
}



@end
