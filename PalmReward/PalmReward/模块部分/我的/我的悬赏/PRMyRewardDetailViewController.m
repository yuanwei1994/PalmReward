//
//  PRMyRewardDetailViewController.m
//  PalmReward
//
//  Created by Gilgamesh丶 on 2016/12/22.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import "PRMyRewardDetailViewController.h"
#import "PRButton.h"
#import "PRAlertController.h"

@interface PRMyRewardDetailViewController () <UIScrollViewDelegate> {
    
    CGFloat _userWidth;
    CGFloat _usernameLabelHeight;
    CGFloat _dateLabelHeight;
    CGFloat _nameAndDateWidth;
    CGFloat _headImageViewWidth;
    CGFloat _titleHeight;
    CGFloat _space;
    CGFloat _maxHeight;
    CGFloat _detailLabelHeight;
}


@property (nonatomic, strong) UIScrollView *scrollView; // 轮播图
@property (nonatomic, strong) UIScrollView *mainScrollView; //主滑动


@property (nonatomic, strong) UILabel *titleLabel; // 标题
@property (nonatomic, strong) UILabel *detailLabel; // 详情
@property (nonatomic, strong) UILabel *usernameLabel; // 用户名
@property (nonatomic, strong) UILabel *dateLabel; // 日期
@property (nonatomic, strong) UILabel *coinLabel; // 赏金
@property (nonatomic, strong) UILabel *statusLabel;

@property (nonatomic, strong) UIImageView *headImageView; // 头像

@property (nonatomic, strong) PRButton *shareButton; // 分享按钮

@property (nonatomic, copy) NSString * detailsString;

@end

@implementation PRMyRewardDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setController];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
}

- (void) setController {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回"] style:UIBarButtonItemStyleDone target:self action:@selector(onLeftItemBtn)];
    self.navigationItem.title = @"悬 赏 详 情";
    self.navigationItem.leftBarButtonItem.tintColor = RGBCOLOR(96, 0, 7);
    
    _detailsString = _taskModel.reward_content;;
    _userWidth = 120*AAdaptionWidth();
    _usernameLabelHeight = 17 *AAdaptionWidth();
    _dateLabelHeight = 13 *AAdaptionWidth();
    _headImageViewWidth = 30 *AAdaptionWidth();
    _titleHeight = 35 *AAdaptionWidth();
    _space = 20*AAdaptionWidth();
    _nameAndDateWidth = 135 *AAdaptionWidth();
    _detailLabelHeight = [self getHeightWithString:_detailsString].size.height;
    _maxHeight = self.scrollView.frame.size.height + self.titleLabel.frame.size.height + _detailLabelHeight + 130 ;
    
    [self.view addSubview:self.mainScrollView];
    [self.mainScrollView addSubview:self.scrollView];
    [self.mainScrollView addSubview:self.titleLabel];
    [self.mainScrollView addSubview:self.detailLabel];
    [self.mainScrollView addSubview:self.usernameLabel];
    [self.mainScrollView addSubview:self.dateLabel];
    [self.mainScrollView addSubview:self.statusLabel];
    [self.mainScrollView addSubview:self.headImageView];
    [self.mainScrollView addSubview:self.shareButton];
  
}

#pragma mark -- Action
- (void)onLeftItemBtn{
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGRect)getHeightWithString:(NSString *)string {
    
    return [string boundingRectWithSize:CGSizeMake(PRwidth - 2 * _space, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:AAFont(14)} context:nil];
}


- (void) onAlertController {
    PRAlertController *alertController = [PRAlertController alertControllerWithTitle:@"温馨提示" message:@"该功能还未实现" preferredStyle:UIAlertControllerStyleAlert hanler:^(PRAlertController *alertController, NSInteger buttonIndex) {
    } cancleButtonTitle:@"确定" ohterButtonTitle:nil];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark -- Getter
- (UIScrollView *)mainScrollView {
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, PRwidth, PRheight - 64)];
        _mainScrollView.contentSize = CGSizeMake(0, _maxHeight);
    }
    return _mainScrollView;
}


- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake( 0, 0, PRwidth,200 *AAdaptionWidth())];
        _scrollView.bounces = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.contentSize = CGSizeMake(3 * PRwidth, 200 *AAdaptionWidth());
        _scrollView.delegate = self;
        
        for (int i = 0; i < 3; i ++) {
            NSString *imageName = [NSString stringWithFormat:@"image%d.jpg",i + 1];
            UIImage *image = [UIImage imageNamed:imageName];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.scrollView.bounds];
            imageView.image = image;
            [self.scrollView addSubview:imageView];
        }
        
        [self.scrollView.subviews enumerateObjectsUsingBlock:^(UIImageView *imageView, NSUInteger index, BOOL *stop) {
            CGRect frame = imageView.frame;
            frame.origin.x = index * frame.size.width;
            imageView.frame = frame;
        }];
    }
    return _scrollView;
}


- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_space, CGRectGetMaxY(self.scrollView.frame), PRwidth - (2 * _space), _titleHeight)];
        _titleLabel.text = _taskModel.reward_title;
        _titleLabel.font = AAFont(20);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        //PRwidth - [self getHeightWithString:_detailsString].size.width) / 2
        _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(_space, CGRectGetMaxY(self.titleLabel.frame), PRwidth - (2 * _space), [self getHeightWithString:_detailsString].size.height)];
        _detailLabel.text = _detailsString;
        _detailLabel.numberOfLines = 0;
        _detailLabel.font = AAFont(14);
        _detailLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _detailLabel;
}
// 18583813251
- (UILabel *)usernameLabel {
    if (!_usernameLabel) {
        _usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake( CGRectGetMaxX(_detailLabel.frame) - _nameAndDateWidth, CGRectGetMaxY(_detailLabel.frame) + _space, _nameAndDateWidth, _usernameLabelHeight)];
        _usernameLabel.text = _taskModel.user_nickname;
        _usernameLabel.textAlignment = NSTextAlignmentCenter;
        [_usernameLabel setFont:AAFont(12)];
    }
    return _usernameLabel;
}

- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_usernameLabel.frame) - _nameAndDateWidth, CGRectGetMaxY(_usernameLabel.frame), _nameAndDateWidth, _dateLabelHeight)];
        _dateLabel.text = _taskModel.reward_commit_time;
        _dateLabel.textAlignment = NSTextAlignmentCenter;
        [_dateLabel setFont:AAFont(10)];
    }
    return _dateLabel;
}

- (UILabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_detailLabel.frame), CGRectGetMaxY(_detailLabel.frame) + _space, _nameAndDateWidth, _headImageViewWidth)];
        if ([_taskModel.reward_task_stauts isEqualToString:@"0"]) {
            _statusLabel.text = @"待 接 受";
        } else if([_statusString isEqualToString:@"已完成"]){
            _statusLabel.text = @"已 完 成";
        } else {
            _statusLabel.text = @"已 接 受";
        }
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        _statusLabel.textColor = [UIColor redColor];
    }
    return _statusLabel;
}

- (UIImageView *)headImageView {
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(_dateLabel.frame) - _headImageViewWidth, CGRectGetMaxY(_dateLabel.frame) - _headImageViewWidth, _headImageViewWidth, _headImageViewWidth)];
        _headImageView.image = [UIImage imageNamed:@"欢迎界面"];
        _headImageView.layer.masksToBounds = YES;
        _headImageView.layer.cornerRadius = _headImageViewWidth / 2;
    }
    return _headImageView;
}


- (PRButton *)shareButton {
    if (!_shareButton) {
        _shareButton = [[PRButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headImageView.frame) - _userWidth, CGRectGetMaxY(_headImageView.frame) + _titleHeight, _userWidth, _titleHeight) Title:@"分 享" TitleColor:[UIColor blackColor] titleFont:15 backColor:[UIColor whiteColor] BackImage:nil Tag:123456 radius:0.5 BorderWidth:1 BorderColor:[UIColor blackColor] Block:^(id sender) {
            [self onAlertController];
        }];
    }
    return _shareButton;
}

@end
