
//
//  PRLogInViewController.m
//  PalmReward
//
//  Created by Gilgamesh丶 on 2016/12/12.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import "PRLogInViewController.h"
#import "PRTextFieldAndImage.h"
#import "PRButton.h"
#import "PRImageButton.h"
#import "PRRegisterViewController.h"
#import "PRFindViewController.h"
#import "PRMineViewController.h"
#import "PRURL.h"
#import "PRUserModel.h"
#import "PRAlertController.h"
#import <RongIMKit/RongIMKit.h>

@interface PRLogInViewController ()<RCIMUserInfoDataSource>{
    CGFloat _spaceW;
    CGFloat _SpaceH;
    CGFloat _ImageWidth;
    CGFloat _ImageHeight;
    CGFloat _spaceLogoW;
    CGFloat _LogoWidth;
    CGFloat _LogoHeight;
    //PRUserModel *userModel;
}

@property (nonatomic, strong) PRButton *loginButton;
@property (nonatomic, strong) PRButton *RegisterButton;
@property (nonatomic, strong) PRButton *backButton;
@property (nonatomic, strong) PRButton *FindButton;
@property (nonatomic, strong) PRImageButton *RememberButton;
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) PRTextFieldAndImage *userTextField;
@property (nonatomic, strong) PRTextFieldAndImage *passWordTextField;

@property (nonatomic, strong) PRUserModel *userModel;

//网络请求动画
@property (nonatomic, strong) DGActivityIndicatorView *requestAnimation;

@end

@implementation PRLogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _spaceW = 100*AAdaptionWidth();
    _SpaceH = 280*AAdaptionWidth();
    _ImageWidth = 20 *AAdaptionWidth();
    _ImageHeight = 20 *AAdaptionWidth();
    _LogoWidth = 120 *AAdaptionWidth();
    _LogoHeight = 120 *AAdaptionWidth();
   _spaceLogoW = (PRwidth-_LogoWidth)/2;
    self.view.backgroundColor = [UIColor whiteColor];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回"] style:UIBarButtonItemStyleDone target:self action:@selector(setBackInTo)];
    self.navigationItem.title = @"登 录";
    self.navigationItem.leftBarButtonItem.tintColor = RGBCOLOR(96, 0, 7);
  

    [self setControllers];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    _userTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
    _passWordTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"userPass"];
    _RememberButton.selected = [[NSUserDefaults standardUserDefaults] boolForKey:@"isRemeber"];
}


- (void) setBackInTo {
    
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)setControllers {
    
    [self.view addSubview:self.userTextField];
    [self.view addSubview:self.passWordTextField];
    [self.view addSubview:self.loginButton];
    [self.view addSubview:self.RegisterButton];
    [self.view addSubview:self.FindButton];
    [self.view addSubview:self.RememberButton];
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.backButton];
    [self.view.layer addSublayer:self.shadowAsInverse];
    [self.view addSubview:self.requestAnimation];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onTextFieldNotification) name:UITextFieldTextDidChangeNotification object:nil];
}

#pragma mark -- RCIMUserInfoDataSource
-(void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion{
    //if ([userId isEqualToString:userModel.user_id]) {
        RCUserInfo * userInfo = [[RCUserInfo alloc] init];
        userInfo.userId = userId;
        userInfo.name = [PRUserModel shareUserModel].user_name;
        NSString *replaceStr = [[PRUserModel shareUserModel].user_avatar ReplaceSlash];
        userInfo.portraitUri = [NSString stringWithFormat:@"%@%@",BASE_URL,replaceStr];
        return completion(userInfo);
    //}
    //return completion(nil);
}

#pragma mark -- 键盘回收
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.userTextField resignFirstResponder];
    [self.passWordTextField resignFirstResponder];
}

#pragma mark --Action



-(void)onTextFieldNotification{
    self.RememberButton.selected = NO;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userPass"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isRemeber"];
}

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

-(void)jj{
    if ((self.userTextField.text.length == 0 )||(self.passWordTextField.text.length == 0)) {
        PRAlertController * AlertController =  [PRAlertController alertControllerWithTitle:@"温馨提示" message:@"账号密码不能为空" preferredStyle:UIAlertControllerStyleAlert hanler:^(PRAlertController *alertController, NSInteger buttonIndex) {
        } cancleButtonTitle:@"确定" ohterButtonTitle:nil];
        [self presentViewController:AlertController animated:YES completion:nil];
    }
}

- (void) onFindBtn {
    PRFindViewController *FindVC = [[PRFindViewController alloc] init];
    [self presentViewController:FindVC animated:YES completion:nil];
}

- (void)onRegistBtn {
    PRRegisterViewController *RegisterVC = [[PRRegisterViewController alloc] init];
    [self presentViewController:RegisterVC animated:YES completion:nil];
}

- (void)onRemember:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [[NSUserDefaults standardUserDefaults] setObject:_userTextField.text forKey:@"userName"];
        [[NSUserDefaults standardUserDefaults] setObject:_passWordTextField.text forKey:@"userPass"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isRemeber"];
    }else{
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userPass"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isRemeber"];
    }
}

#pragma mark -- 网络请求

- (void) onLoginButton {
    [self jj];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:self.userTextField.text forKey:@"username"];
    [parameters setObject:self.passWordTextField.text forKey:@"password"];
    
    [self.requestAnimation startAnimating];
    
    [PRBaseRequest starRequest:USER_LOGIN_URL parameters:parameters completionHandler:^(PRResponse *response) {
        if (response.success) {
            NSLog(@"_______________Yes");
            // 18583813251
            _userModel = [PRUserModel shareUserModel];
            //系统自带解析
            [_userModel setValuesForKeysWithDictionary:(NSDictionary *)response.resultVaule];
            //三方解析
            //userModel = [PRUserModel mj_objectWithKeyValues:response.resultVaule];
            // 请求融云token
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            [parameters setObject:_userModel.user_token forKey:@"token"];
            [PRBaseRequest starRequest:RONGCLOUD_TOKEN_URL parameters:parameters completionHandler:^(PRResponse *response) {
                if (response.success) {
                    
                    _userModel.user_rongcloud_token = response.resultVaule;
                    NSLog(@"融云Token请求成功!%@",_userModel.user_rongcloud_token);
                    //登陆融云
                    [[RCIM sharedRCIM] connectWithToken:_userModel.user_rongcloud_token success:^(NSString *userId) {
                        [self.requestAnimation stopAnimating];
                        //融云设置代理
                        [[RCIM sharedRCIM] setUserInfoDataSource:self];
                        NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
                        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLogin"];
                        [self dismissViewControllerAnimated:YES completion:nil];
                    } error:^(RCConnectErrorCode status) {
                        NSLog(@"登陆的错误码为:%ld", (long)status);
                        [self.requestAnimation stopAnimating];
                    } tokenIncorrect:^{
                        NSLog(@"token错误");
                        [self.requestAnimation stopAnimating];
                    }];
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLogin"];
                } else {
                    NSLog(@"------NO,%@",response.resultDesc);
                    [self.requestAnimation stopAnimating];
                }
            }];
        } else {
            NSLog(@"_______%@No",response.resultDesc);
            [self.requestAnimation stopAnimating];
        }
        
    }];
}


#pragma mark -- getter

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(_spaceLogoW,_LogoHeight, _LogoWidth, _LogoWidth)];
        _imageView.image = [UIImage imageNamed:@"Logo"];
        _imageView.layer.masksToBounds = YES;
        _imageView.layer.cornerRadius = _LogoWidth / 2;
    }
    return _imageView;
}

- (PRTextFieldAndImage *)userTextField {
    if (!_userTextField) {
        _userTextField = [[PRTextFieldAndImage alloc] initWithFrame:CGRectMake(_spaceW , _SpaceH, PRwidth -_spaceW * 2 + 30 *AAdaptionWidth(), 35*AAdaptionWidth()) imageName:@"手机" imageFrame:Imageleft lineFrame:LineBottom Space:0 imageAndViewSpace:10 LineHightOrWidth:1 LineBack:[UIColor blackColor] TextFieldBack:[UIColor clearColor] imageOnView:self.view imageWidth:_ImageWidth imageHeight:_ImageHeight SecureTextEntry:NO Placeholder:@"请输入手机号" PlaceholderColor:[UIColor grayColor] PlaceholderFont:14];
    }
    return _userTextField;
}

- (PRTextFieldAndImage *)passWordTextField {
    if (!_passWordTextField) {
        _passWordTextField = [[PRTextFieldAndImage alloc] initWithFrame:CGRectMake(_spaceW, _SpaceH + 65 *AAdaptionWidth(), PRwidth -_spaceW * 2 + 30 *AAdaptionWidth(), 35*AAdaptionWidth()) imageName:@"密码" imageFrame:Imageleft lineFrame:LineBottom Space:0 imageAndViewSpace:10 LineHightOrWidth:1 LineBack:[UIColor blackColor] TextFieldBack:[UIColor clearColor] imageOnView:self.view imageWidth:_ImageWidth imageHeight:_ImageHeight SecureTextEntry:YES Placeholder:@"请输入密码" PlaceholderColor:[UIColor  grayColor] PlaceholderFont:14];
    }
    return _passWordTextField;
}

- (PRButton *)loginButton {
    if (!_loginButton) {
        _loginButton = [[PRButton alloc] initWithFrame:CGRectMake(_spaceW, _SpaceH + 200 *AAdaptionWidth(), PRwidth -_spaceW * 2, 35 *AAdaptionWidth()) Title:@"登 录" TitleColor:[UIColor blackColor] titleFont:15 backColor:[UIColor whiteColor] BackImage:nil Tag:12345 radius:0.5 BorderWidth:1 BorderColor:[UIColor blackColor] Block:^(id sender) {
            [self onLoginButton];
        }];
    }
    return _loginButton;
}




- (PRButton *)RegisterButton {
    if (!_RegisterButton) {
        _RegisterButton = [[PRButton alloc] initWithFrame:CGRectMake(_spaceW + 70 *AAdaptionWidth(), _SpaceH + 280 *AAdaptionWidth(), PRwidth -_spaceW * 2 + 30 *AAdaptionWidth(), 35) Title:@"还没注册?立即注册" TitleColor:[UIColor blackColor] titleFont:14 backColor:[UIColor clearColor] BackImage:nil Tag:1008611 radius:0 BorderWidth:1 BorderColor:[UIColor whiteColor] Block:^(id sender) {
            [self onRegistBtn];
        }];
    }
    return _RegisterButton;
}

- (PRButton *)FindButton {
    if (!_FindButton) {
        CGFloat BtnW = 70 *AAdaptionWidth();
        _FindButton = [[PRButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_userTextField.frame)-BtnW, _SpaceH + 120 *AAdaptionWidth(), BtnW, 20 *AAdaptionWidth()) Title:@"忘记密码?" TitleColor:[UIColor redColor] titleFont:14*AAdaptionWidth() backColor:[UIColor clearColor] BackImage:nil Tag:110 radius:0 BorderWidth:1 BorderColor:[UIColor whiteColor] Block:^(id sender) {
            [self onFindBtn];
        }];
    }
    return _FindButton;
}

- (PRImageButton *)RememberButton {
    if (!_RememberButton) {
        CGFloat imageW = 20 *AAdaptionWidth();
        CGFloat titleW = 60 *AAdaptionWidth();
        CGFloat space = 10 *AAdaptionWidth();
        _RememberButton = [[PRImageButton alloc] initWithTitleRect:CGRectMake(imageW +space, 0, titleW, imageW) ImageRect:CGRectMake(0, 0, imageW, imageW)];
        _RememberButton.frame = CGRectMake(_spaceW, _SpaceH + 120 *AAdaptionWidth(), imageW + titleW + space, imageW);
        _RememberButton.titleLabel.font = AAFont(14);
        [_RememberButton setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
        [_RememberButton setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateSelected];
        [_RememberButton setTitle:@"记住密码" forState:UIControlStateNormal];
        [_RememberButton setTitle:@"记住密码" forState:UIControlStateSelected];
        [_RememberButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_RememberButton addTarget:self
                            action:@selector(onRemember:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _RememberButton;
}

-(PRButton *)backButton{
    if (!_backButton) {
        CGFloat btnWidth = 30.0 *AAdaptionWidth();
        _backButton = [[PRButton alloc] initWithFrame:CGRectMake(20 *AAdaptionWidth(), 30 *AAdaptionWidth(), btnWidth, btnWidth) Title:nil TitleColor:nil titleFont:0 backColor:nil BackImage:[UIImage imageNamed:@"登录返回"] Tag:1008611 radius:0.5 BorderWidth:0 BorderColor:nil Block:^(id sender) {
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




@end
