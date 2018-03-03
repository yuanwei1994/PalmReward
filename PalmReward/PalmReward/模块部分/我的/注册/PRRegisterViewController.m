//
//  PRRegisterViewController.m
//  PalmReward
//
//  Created by Gilgamesh丶 on 2016/12/12.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import "PRRegisterViewController.h"
#import "PRTextFieldAndImage.h"
#import "PRButton.h"
#import "PRLogInViewController.h"
#import "PRAlertController.h"
#import <SMS_SDK/SMSSDK.h>

@interface PRRegisterViewController (){
    CGFloat _spaceW;
    CGFloat _SpaceH;
    CGFloat _ImageWidth;
    CGFloat _ImageHeight;
    NSTimer *_timer;
    CGFloat _countdown;     // 倒计时时长

}

@property (nonatomic, strong) PRButton * registerButton;
@property (nonatomic, strong) PRButton * IDC;                           //验证码按钮
@property (nonatomic, strong) PRButton * backButton;
@property (nonatomic, strong) PRTextFieldAndImage *userTextField;
@property (nonatomic, strong) PRTextFieldAndImage *passWordTextField;
@property (nonatomic, strong) PRTextFieldAndImage *IDCTextField;

@property (nonatomic, strong) UILabel * successLabel;
@property (nonatomic, strong) UILabel * failLable;

//网络请求动画
@property (nonatomic, strong) DGActivityIndicatorView *requestAnimation;

@end

@implementation PRRegisterViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setControllers];
    
}

- (void)setControllers {
    
    _countdown = 60.0;

    _spaceW = 60 * AAdaptionWidth();
    _SpaceH = 160 * AAdaptionWidth();
    _ImageWidth = 20 *AAdaptionWidth();
    _ImageHeight = 20 *AAdaptionWidth();
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回"] style:UIBarButtonItemStyleDone target:self action:@selector(onleftItemBtn)];
    self.navigationItem.title = @"注 册";
    self.navigationItem.leftBarButtonItem.tintColor = RGBCOLOR(96, 0, 7);
    [self.view addSubview:self.userTextField];
    [self.view addSubview:self.passWordTextField];
    [self.view addSubview:self.IDCTextField];
    [self.view addSubview:self.registerButton];
    [self.view addSubview:self.IDC];
    [self.view addSubview:self.backButton];
    [self.view.layer addSublayer:self.shadowAsInverse];
    [self.view addSubview:self.requestAnimation];
    
    [self.view addSubview:self.successLabel];
    [self.view addSubview:self.failLable];
}


#pragma mark -- ButtonAction

- (void)onleftItemBtn{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onrigisterBtn{
    [self.requestAnimation startAnimating];
    [SMSSDK commitVerificationCode:self.IDCTextField.text phoneNumber:self.userTextField.text zone:@"86" result:^(SMSSDKUserInfo *userInfo, NSError *error) {
        if (!error) {
            NSLog(@"--------------------------YES");
            [PRBaseRequest starRequest:USER_REGIST_URL parameters:@{@"username":self.userTextField.text, @"password": self.passWordTextField.text} completionHandler:^(PRResponse *response) {
                if (response.success) {
                    [self.requestAnimation stopAnimating];
                    PRAlertController * alert = [PRAlertController alertControllerWithTitle:@"恭喜" message:@"注册成功" preferredStyle:UIAlertControllerStyleAlert hanler:^(PRAlertController *alertController, NSInteger buttonIndex) {
                        [self dismissViewControllerAnimated:YES completion:nil];
                    } cancleButtonTitle:@"确定" ohterButtonTitle:nil];
                    [self presentViewController:alert animated:YES completion:nil];
                    
                } else {
                    
                    [self.requestAnimation stopAnimating];
                    PRAlertController * alert = [PRAlertController alertControllerWithTitle:@"警告" message:@"注册失败" preferredStyle:UIAlertControllerStyleAlert hanler:^(PRAlertController *alertController, NSInteger buttonIndex) {
                        self.passWordTextField.text = @"";
                        self.IDCTextField.text = @"";
                    } cancleButtonTitle:@"确定" ohterButtonTitle:nil];
                    [self presentViewController:alert animated:YES completion:nil];
                }
                
            }];
            
        }else{
            NSLog(@"--------------------------NO%@",error);
            PRAlertController * alert = [PRAlertController alertControllerWithTitle:@"警告" message:@"验证码错误" preferredStyle:UIAlertControllerStyleAlert hanler:^(PRAlertController *alertController, NSInteger buttonIndex) {
                self.IDCTextField.text = @"";
            } cancleButtonTitle:@"确定" ohterButtonTitle:nil];
            [self presentViewController:alert animated:YES completion:nil];
            [self.requestAnimation stopAnimating];
        }
    }];
}


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


#pragma mark -- VerifyCode --- Begining
- (void)onIDCBtn{
    //关闭用户交互
    self.IDC.userInteractionEnabled = NO;

    PRLog(@"获取验证码中...");
    NSString *mobile = self.userTextField.text;
    if (mobile.length <= 0) {
        PRLog(@"手机号不能为空");
        self.IDC.userInteractionEnabled = YES;
        PRAlertController *alertController = [PRAlertController alertControllerWithTitle:@"警告" message:@"手机号格式错误" preferredStyle:UIAlertControllerStyleAlert hanler:^(PRAlertController *alertController, NSInteger buttonIndex) {
            self.IDC.userInteractionEnabled = YES;
        } cancleButtonTitle:@"确定" ohterButtonTitle:nil];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    //每秒执行一次
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(setCountdown) userInfo:nil repeats:YES];
    PRLog(@"开始发送验证码");
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.userTextField.text zone:@"86" customIdentifier:nil result:^(NSError *error) {
        //打开用户交互
        if (error) {
            PRLog(@"验证码发送失败");

            [self show:self.failLable];
            
        } else {
            [self show:self.successLabel];
            PRLog(@"验证码发送成功");
        }
        
    }];
}


//移除计时器
- (void)stopTimer {
    [_timer invalidate];
    _timer = nil;
}

//倒计时
- (void)setCountdown {
    //开始倒计时
    [self setBeginingCountdown];
    if (_countdown <= 0) {
        //结束倒计时
        [self setDidCountdown];
        return;
    }
}

//验证码倒计时开始后
- (void)setBeginingCountdown {
    _countdown --;
    //把按钮颜色重置为最初的灰色
    [self setNormalColor];
    //将倒计时赋值给按钮的title
    [self.IDC setTitle:[NSString stringWithFormat:@"%.f S",_countdown] forState:UIControlStateNormal];
}


//验证码倒计时结束后
- (void)setDidCountdown {
    //重置倒计时 时间
    _countdown = 60.0;
    //移除计时器
    [self stopTimer];
    //改变按钮颜色
    [self setChangeButtonColor];
    //开启用户交互
    self.IDC.userInteractionEnabled = YES;
    //重置按钮title
    [self.IDC setTitle:@"获取验证码" forState:UIControlStateNormal];
}


//改变按钮字体以及边框颜色
- (void)setChangeButtonColor{
    if (self.IDCTextField.text.length > 0) {
        [self setChangeColor];
    } else {
        [self setNormalColor];
    }
    
    
//    if (self.userTextField.text.length > 0 && self.passWordTextField.text.length > 0 && self.IDCTextField.text.length > 0) {
//        self.registerButton.backgroundColor = APP_MAIN_COLOR;
//    } else {
//        self.registerButton.backgroundColor = COLOR_RGB(154, 154, 154, 1);
//    }
}


- (void)setChangeColor {
    self.IDC.layer.borderColor = [UIColor blackColor].CGColor;
    [self.IDC setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

- (void)setNormalColor {
    self.IDC.layer.borderColor = [UIColor blackColor].CGColor;
    [self.IDC setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

#pragma mark -- VerifyCode --- End

#pragma mark -- 键盘回收
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.userTextField resignFirstResponder];
    [self.passWordTextField resignFirstResponder];
    [self.IDCTextField resignFirstResponder];
}



#pragma mark -- BackGround
- (CAGradientLayer *)shadowAsInverse
{
    CAGradientLayer *newShadow = [[CAGradientLayer alloc] init];
    CGRect newShadowFrame = CGRectMake(0, 0, PRwidth,PRheight);
    newShadow.frame = newShadowFrame;
    //添加渐变的颜色组合（颜色透明度的改变）
    newShadow.colors = [NSArray arrayWithObjects:
                        (id)[[COLOR_RGB(58, 51, 42, 0.5) colorWithAlphaComponent:0.5] CGColor] ,
                        (id)[[COLOR_RGB(58, 51, 42, 0.5) colorWithAlphaComponent:0.4] CGColor],
                        (id)[[COLOR_RGB(58, 51, 42, 0.5) colorWithAlphaComponent:0.3] CGColor],
                        (id)[[COLOR_RGB(58, 51, 42, 0.5) colorWithAlphaComponent:0.2] CGColor],
                        (id)[[COLOR_RGB(58, 51, 42, 0.5) colorWithAlphaComponent:0.1] CGColor],
                        (id)[[COLOR_RGB(58, 51, 42, 0.5) colorWithAlphaComponent:0] CGColor],
                        nil];
    return newShadow;
}

#pragma mark -- getter

- (PRTextFieldAndImage *)userTextField {
    if (!_userTextField) {
        _userTextField = [[PRTextFieldAndImage alloc] initWithFrame:CGRectMake(_spaceW, _SpaceH, PRwidth -_spaceW*2 - 50*AAdaptionWidth(), 35) imageName:@"手机" imageFrame:Imageleft lineFrame:LineBottom Space:0 imageAndViewSpace:10 LineHightOrWidth:1 LineBack:[UIColor blackColor] TextFieldBack:[UIColor clearColor] imageOnView:self.view imageWidth:_ImageWidth imageHeight:_ImageHeight SecureTextEntry:NO Placeholder:@"请输入手机号" PlaceholderColor:[UIColor  grayColor] PlaceholderFont:14];
    }
    return _userTextField;
}

- (PRTextFieldAndImage *)passWordTextField {
    if (!_passWordTextField) {
        _passWordTextField = [[PRTextFieldAndImage alloc] initWithFrame:CGRectMake(_spaceW, CGRectGetMaxY(_userTextField.frame)+15*AAdaptionWidth(), PRwidth - 1.5*_spaceW, 35) imageName:@"密码" imageFrame:Imageleft lineFrame:LineBottom Space:0 imageAndViewSpace:10 LineHightOrWidth:1 LineBack:[UIColor blackColor] TextFieldBack:[UIColor clearColor] imageOnView:self.view imageWidth:_ImageWidth imageHeight:_ImageHeight SecureTextEntry:YES Placeholder:@"请输入密码" PlaceholderColor:[UIColor  grayColor] PlaceholderFont:14];
    }
    return _passWordTextField;
}

- (PRTextFieldAndImage *)IDCTextField {
    if (!_IDCTextField) {
        _IDCTextField = [[PRTextFieldAndImage alloc] initWithFrame:CGRectMake(_spaceW, CGRectGetMaxY(_passWordTextField.frame) + 15 * AAdaptionWidth(), PRwidth - 1.5*_spaceW, 35) imageName:@"信息" imageFrame:Imageleft lineFrame:LineBottom Space:0 imageAndViewSpace:10 LineHightOrWidth:1 LineBack:[UIColor blackColor] TextFieldBack:[UIColor clearColor] imageOnView:self.view imageWidth:_ImageWidth imageHeight:_ImageHeight SecureTextEntry:NO Placeholder:@"请输入验证码" PlaceholderColor:[UIColor  grayColor] PlaceholderFont:14];
    }
    return _IDCTextField;
}

- (PRButton *)registerButton {
    if (!_registerButton) {
        CGFloat BtnWidth = 200*AAdaptionWidth();
        _registerButton = [[PRButton alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.frame) - BtnWidth/2, CGRectGetMaxY(_IDCTextField.frame) + 50*AAdaptionWidth(), BtnWidth, 35) Title:@"注 册" TitleColor:[UIColor blackColor] titleFont:15 backColor:[UIColor whiteColor] BackImage:nil Tag:12345 radius:0.5 BorderWidth:1 BorderColor:[UIColor blackColor] Block:^(id sender) {
            [self onrigisterBtn];
        }];
        
    }
    return _registerButton;
}

- (PRButton *)IDC {
    if (!_IDC) {
        _IDC = [[PRButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_userTextField.frame), _SpaceH, 80*AAdaptionWidth(), 35) Title:@"获取验证码" TitleColor:[UIColor blackColor] titleFont:14*AAdaptionWidth() backColor:[UIColor clearColor] BackImage:nil Tag:123123 radius:0.3 BorderWidth:1 BorderColor:[UIColor blackColor] Block:^(id sender) {
            [self onIDCBtn];
        }];
    }
    return _IDC;
}

-(PRButton *)backButton{
    if (!_backButton) {
        _backButton = [[PRButton alloc] initWithFrame:CGRectMake(20*AAdaptionWidth(), 30*AAdaptionWidth(), 30, 30) Title:nil TitleColor:nil titleFont:0 backColor:nil BackImage:[UIImage imageNamed:@"登录返回"] Tag:1008611 radius:0.5 BorderWidth:0 BorderColor:nil Block:^(id sender) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    }
    return _backButton;
}

- (DGActivityIndicatorView *)requestAnimation {
    if (!_requestAnimation) {
        _requestAnimation = [[DGActivityIndicatorView alloc]initWithType: DGActivityIndicatorAnimationTypeNineDots tintColor:[UIColor blackColor] size:60 * AAdaptionWidth()];
        _requestAnimation.center = self.view.center;
    }
    return _requestAnimation;
}


-(UILabel *)successLabel{
    if (!_successLabel) {
        CGFloat labelW = AAdaption(150);
        CGFloat labelH = AAdaption(30);
        _successLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, labelW, labelH)];
        _successLabel.center = CGPointMake(self.view.center.x, self.view.center.y + 150*AAdaptionWidth());
        _successLabel.text = @"验证码发送成功";
        _successLabel.textAlignment = NSTextAlignmentCenter;
        _successLabel.layer.cornerRadius = 8;
        _successLabel.layer.masksToBounds = YES;
        _successLabel.textColor = [UIColor blackColor];
        _successLabel.backgroundColor = [UIColor whiteColor];
        _successLabel.font = AAFont(17);
        _successLabel.alpha = 0;
        
    }
    return _successLabel;
}

-(UILabel *)failLable{
    if (!_failLable) {
        CGFloat labelW = AAdaption(150);
        CGFloat labelH = AAdaption(30);
        _failLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, labelW, labelH)];
        _failLable.center = CGPointMake(self.view.center.x, self.view.center.y + 150*AAdaptionWidth());
        _failLable.text = @"验证码发送失败";
        _failLable.textAlignment = NSTextAlignmentCenter;
        _failLable.layer.cornerRadius = 8;
        _failLable.layer.masksToBounds = YES;
        _failLable.textColor = [UIColor blackColor];
        _failLable.backgroundColor = [UIColor whiteColor];
        _failLable.font = AAFont(17);
        _failLable.alpha = 0;
        
    }
    return _failLable;
}


@end

