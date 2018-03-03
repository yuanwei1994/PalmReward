//
//  PRDetailViewController.m
//  PalmReward
//
//  Created by Gilgamesh丶 on 2016/12/21.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import "PRDetailViewController.h"
#import "PRButton.h"
#import "PRTaskModel.h"
#import "PRUserModel.h"
#import "UIImageView+WebCache.h"
#import "PRLogInViewController.h"
#import "PRAlertController.h"
@interface PRDetailViewController () <UIScrollViewDelegate> {
    
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
@property (nonatomic, strong) UIImageView *headImageView; // 头像
@property (nonatomic, strong) PRButton *acceptButton; // 接受按钮
@property (nonatomic, strong) PRButton *shareButton; // 分享按钮
@property (nonatomic, copy) NSString * detailsString;
@property (nonatomic, copy) NSString * string;
@property (nonatomic, strong) UILabel * successLabel;
@property (nonatomic, strong) UILabel * failLable;
@property (nonatomic, strong) UILabel * sayLogin;
@property (nonatomic, strong) UILabel * noSelf;
@property (nonatomic, strong) NSMutableArray * imageArray;
@end

@implementation PRDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setController];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    if (_taskModel.task_image_id.length > 0) {
        NSArray *idArray = [_taskModel.task_image_id componentsSeparatedByString:@","];
        for (int i = 0; i<idArray.count; i++) {
            [PRBaseRequest starRequest:REWARDIMAGE_URL parameters:@{@"image_id" : idArray[i]} completionHandler:^(PRResponse *response) {
                if (response.success) {
                    NSString * str = [NSString stringWithFormat:@"%@%@",BASE_URL,[(NSString*)response.resultVaule ReplaceSlash]];
                    NSLog(@"%@",str);
                    [self onDetailAction:str];
                    NSLog(@"++++++%@",idArray);
                    NSLog(@"======%@",self.imageArray);
                }else{
                    NSLog(@"%@",response.resultDesc);
                }
            }];
        }
        
    }if (_taskModel.task_image_id.length == 0) {
        [self onDetailAction:@"image2"];
    }

}

- (void) setController {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回"] style:UIBarButtonItemStyleDone target:self action:@selector(onLeftItemBtn)];
    self.navigationItem.title = @"悬 赏 详 情";
    self.navigationItem.leftBarButtonItem.tintColor = RGBCOLOR(96, 0, 7);
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
    _detailsString = _taskModel.reward_content;
    _string = _taskModel.reward_task_id;
    _userWidth = 120 *AAdaptionWidth();
    _usernameLabelHeight = 17*AAdaptionWidth() ;
    _dateLabelHeight = 13 *AAdaptionWidth();
    _headImageViewWidth = 30 *AAdaptionWidth();
    _titleHeight = 35 *AAdaptionWidth();
    _space = 20 *AAdaptionWidth();
    _nameAndDateWidth = 135 *AAdaptionWidth();
    _detailLabelHeight = [self getHeightWithString:_detailsString].size.height;
    _maxHeight = self.scrollView.frame.size.height + self.titleLabel.frame.size.height + _detailLabelHeight + 130 ;
    [self.view addSubview:self.mainScrollView];
    [self.mainScrollView addSubview:self.sayLogin];
    [self.mainScrollView addSubview:self.noSelf];
    [self.mainScrollView addSubview:self.successLabel];
    [self.mainScrollView addSubview:self.failLable];
    [self.mainScrollView addSubview:self.scrollView];
    [self.mainScrollView addSubview:self.titleLabel];
    [self.mainScrollView addSubview:self.detailLabel];
    [self.mainScrollView addSubview:self.usernameLabel];
    [self.mainScrollView addSubview:self.dateLabel];
    [self.mainScrollView addSubview:self.coinLabel];
    [self.mainScrollView addSubview:self.headImageView];
    [self.mainScrollView addSubview:self.acceptButton];
    [self.mainScrollView addSubview:self.shareButton];

}


#pragma mark -- 网络请求
- (void)onAcceptButton {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:_string forKey:@"task_id"];
    [parameters setValue:[PRUserModel shareUserModel].user_token forKey:@"token"];
    [PRBaseRequest starRequest:ACCEPT_TASK_URL parameters:parameters completionHandler:^(PRResponse *response) {
        if (response.success) {
            [self show:self.successLabel];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        } else {
            [self show:self.failLable];
            PRLog(@"%@",response.resultDesc);
        }
    }];
}



#pragma mark -- Action
-(void)show:(UILabel *)label{
    [UIView animateWithDuration:1 animations:^{
        label.alpha = 1;
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:1 animations:^{
            label.alpha = 0;
        }];
    });
}

-(void)onDetailAction:(NSString*)str{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.scrollView.bounds];
    [imageView setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"image2.jpg"]];
    [self.scrollView addSubview:imageView];
    
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(UIImageView *imageView, NSUInteger index, BOOL *stop) {
        CGRect frame = imageView.frame;
        frame.origin.x = index * frame.size.width;
        imageView.frame = frame;
    }];
}

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
        
        
    }
    return _scrollView;
}


- (UILabel *)titleLabel {
    if (!_titleLabel) {
        //[PRTaskModel shareTaskModel].reward_title
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_space, CGRectGetMaxY(self.scrollView.frame), PRwidth - 2 * _space, _titleHeight)];
        _titleLabel.text = _taskModel.reward_title;
        _titleLabel.font = AAFont(20);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        //PRwidth - [self getHeightWithString:_detailsString].size.width) / 2
        _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(_space, CGRectGetMaxY(self.titleLabel.frame), PRwidth - 2 * _space, [self getHeightWithString:_detailsString].size.height)];
        _detailLabel.text = _detailsString;
        _detailLabel.numberOfLines = 0;
        _detailLabel.font = AAFont(14);
        _detailLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _detailLabel;
}

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

- (UILabel *)coinLabel {
    if (!_coinLabel) {
        _coinLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_detailLabel.frame), CGRectGetMaxY(_detailLabel.frame) + _space, _nameAndDateWidth, _headImageViewWidth)];
        _coinLabel.text = [NSString stringWithFormat:@"%@ C币",_taskModel.reward_coin];
        _coinLabel.textAlignment = NSTextAlignmentCenter;
        _coinLabel.textColor = [UIColor redColor];
    }
    return _coinLabel;
}

- (UIImageView *)headImageView {
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(_dateLabel.frame) - _headImageViewWidth, CGRectGetMaxY(_dateLabel.frame) - _headImageViewWidth, _headImageViewWidth, _headImageViewWidth)];
        NSURL *avatarUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,[_taskModel.user_avatar ReplaceSlash]]];
        [_headImageView setImageWithURL:avatarUrl placeholderImage:[UIImage imageNamed:@"默认头像"]];
        _headImageView.layer.masksToBounds = YES;
        _headImageView.layer.cornerRadius = _headImageViewWidth / 2;
    }
    return _headImageView;
}

- (PRButton *)acceptButton {
    if (!_acceptButton) {
        
        
        _acceptButton = [[PRButton alloc] initWithFrame:CGRectMake(CGRectGetMidX(_coinLabel.frame), CGRectGetMaxY(_coinLabel.frame) + _titleHeight,_userWidth, _titleHeight) Title:@"接 受" TitleColor:[UIColor blackColor] titleFont:15 backColor:[UIColor whiteColor] BackImage:nil Tag:12345 radius:0.5 BorderWidth:2 BorderColor:[UIColor blackColor] Block:^(id sender) {
            

            
            if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"]) {
                [self show:self.sayLogin];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self presentViewController:[PRLogInViewController new] animated:YES completion:nil];
                });
            } else {
                if ([[PRUserModel shareUserModel].user_id integerValue] == [self.taskModel.promoter_user_id integerValue]) {
                    
                    [self show:self.noSelf];
                    return ;
                }
                [self onAcceptButton];
                
            }
        }];
    }
    return _acceptButton;
}

- (PRButton *)shareButton {
    if (!_shareButton) {
        _shareButton = [[PRButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(_headImageView.frame), CGRectGetMaxY(_headImageView.frame) + _titleHeight, _userWidth, _titleHeight) Title:@"分 享" TitleColor:[UIColor blackColor] titleFont:15 backColor:[UIColor whiteColor] BackImage:nil Tag:123456 radius:0.5 BorderWidth:2 BorderColor:[UIColor blackColor] Block:^(id sender) {
            
            [self onAlertController];
            
        }];
    }
    return _shareButton;
}

-(UILabel *)successLabel{
    if (!_successLabel) {
        CGFloat labelW = 90*AAdaptionWidth();
        _successLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, labelW, 21*AAdaptionWidth())];
        _successLabel.center = CGPointMake(self.view.center.x, self.view.center.y + 150*AAdaptionWidth());
        _successLabel.text = @"接 受 成 功";
        _successLabel.textAlignment = NSTextAlignmentCenter;
        _successLabel.textColor = [UIColor blackColor];
        _successLabel.backgroundColor = [UIColor whiteColor];
        _successLabel.font = AAFont(17);
        _successLabel.alpha = 0;
        
    }
    return _successLabel;
}

-(UILabel *)failLable{
    if (!_failLable) {
        CGFloat labelW = 90*AAdaptionWidth() ;
        _failLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, labelW, 21*AAdaptionWidth())];
        _failLable.center = CGPointMake(self.view.center.x, self.view.center.y + 150*AAdaptionWidth());
        _failLable.text = @"接 受 失 败";
        _failLable.textAlignment = NSTextAlignmentCenter;
        _failLable.textColor = [UIColor blackColor];
        _failLable.backgroundColor = [UIColor whiteColor];
        _failLable.font = AAFont(17);
        _failLable.alpha = 0;
        
    }
    return _failLable;
}

-(UILabel *)sayLogin{
    if (!_sayLogin) {
        _sayLogin = [[UILabel alloc] init];
        _sayLogin.bounds = CGRectMake(0, 0, 120 *AAdaptionWidth(), 30 *AAdaptionWidth());
        _sayLogin.center = CGPointMake(self.view.center.x, self.view.center.y + 150*AAdaptionWidth());
         _sayLogin.text = @"请 登 录";
        _sayLogin.textAlignment = NSTextAlignmentCenter;
        _sayLogin.font = AAFont(17);
        _sayLogin.backgroundColor = [UIColor whiteColor];
        _sayLogin.alpha = 0;
    }
    return  _sayLogin;
}

- (UILabel *)noSelf{
    if (!_noSelf) {
        _noSelf = [[UILabel alloc] init];
        _noSelf.bounds = CGRectMake(0, 0, 200 *AAdaptionWidth(), 30 *AAdaptionWidth());
        _noSelf.center = CGPointMake(self.view.center.x, self.view.center.y + 150*AAdaptionWidth());
        _noSelf.text = @"不能接受自己发布的悬赏";
        _noSelf.textAlignment = NSTextAlignmentCenter;
        _noSelf.font = AAFont(17);
        _noSelf.backgroundColor = [UIColor whiteColor];
        _noSelf.alpha = 0;
    }
    return  _noSelf;
}


//-(NSMutableArray *)imageArray{
//    if (!_imageArray) {
//        _imageArray = [NSMutableArray array];
//    }
//    return _imageArray;
//}
@end
