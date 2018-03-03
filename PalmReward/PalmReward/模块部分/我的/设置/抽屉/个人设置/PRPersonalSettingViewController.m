//
//  PRPersonalSettingViewController.m
//  PalmReward
//
//  Created by Candy on 16/12/17.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import "PRPersonalSettingViewController.h"
#import "PRLabelWithFieldView.h"
#import "PRButton.h"
@interface PRPersonalSettingViewController (){
    CGFloat _viewWidth;
    CGFloat _btnWidth;
    CGFloat _btnheight;
}

@property (nonatomic ,strong) PRLabelWithFieldView * nameView;
@property (nonatomic ,strong) PRLabelWithFieldView * passView;
@property (nonatomic ,strong) PRLabelWithFieldView * phoneView;
@property (nonatomic ,strong) PRButton * ChangeButton;

@end

@implementation PRPersonalSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setSomething];
}

- (void)setSomething {
    self.title = @"个 人 设 置";
    _viewWidth = 40 *AAdaptionWidth();
    _btnWidth = 90 *AAdaptionWidth();
    _btnheight = 30 *AAdaptionWidth();
    [self.view addSubview:self.nameView];
    [self.view addSubview:self.passView];
    [self.view addSubview:self.phoneView];
    [self.view addSubview:self.ChangeButton];
}

#pragma mark -- 键盘回收
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.nameView resignFirstResponder];
    [self.passView resignFirstResponder];
    [self.phoneView resignFirstResponder];
}

#pragma mark -- Action 
-(void)onChangeBtn{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"验证" message:@"输入旧密码" preferredStyle:UIAlertControllerStyleAlert];
    __weak typeof(alert) weakAlert = alert;
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.textColor = [UIColor blackColor];
        textField.secureTextEntry = YES;
        textField.placeholder = @"输入旧密码";
    }];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消    " style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString * pass = [weakAlert.textFields.firstObject text];
        NSLog(@"%@",pass);
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setValue:pass forKey:@"old_pass"];
        [parameters setValue:self.passView.textField.text forKey:@"new_pass"];
        [parameters setValue:self.nameView.textField.text forKey:@"new_nickname"];
        [parameters setValue:[PRUserModel shareUserModel].user_token forKey:@"token"];
        [PRBaseRequest starRequest:CHANGE_USER_URL parameters:parameters completionHandler:^(PRResponse *response) {
            if (response.success) {
                [PRUserModel shareUserModel].user_nickname = self.nameView.textField.text;
                [PRUserModel shareUserModel].user_password = self.passView.textField.text
                ;
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark -- Getter
-(PRLabelWithFieldView *)nameView{
    if (!_nameView) {
        _nameView = [[PRLabelWithFieldView alloc] initWithFrame:CGRectMake(0, 64, PRwidth, _viewWidth) backColor:[UIColor clearColor] LabelTitle:@"昵称" FieldText:[PRUserModel shareUserModel].user_nickname UserInterac:YES Secure:NO];
    }
    return _nameView;
}

-(PRLabelWithFieldView *)passView{
    if (!_passView) {
        _passView = [[PRLabelWithFieldView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.nameView.frame), PRwidth, _viewWidth) backColor:[UIColor whiteColor] LabelTitle:@"密码" FieldText:@"123456" UserInterac:YES Secure:YES];
    }
    return _passView;
}

-(PRLabelWithFieldView *)phoneView{
    if (!_phoneView) {
        _phoneView = [[PRLabelWithFieldView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.passView.frame), PRwidth, _viewWidth) backColor:[UIColor whiteColor] LabelTitle:@"手机号" FieldText:[PRUserModel shareUserModel].user_mobile UserInterac:NO Secure:NO];
    }
    return _phoneView;
}

-(PRButton *)ChangeButton{
    if(!_ChangeButton){
        _ChangeButton = [[PRButton alloc] initWithFrame:CGRectMake(0, 0, _btnWidth, _btnheight) Title:@"保存" TitleColor:[UIColor blackColor] titleFont:17 backColor:[UIColor whiteColor] BackImage:nil Tag:1008 radius:0.3 BorderWidth:1 BorderColor:[UIColor blackColor] Block:^(id sender) {
            [self onChangeBtn];
        }];
        _ChangeButton.center = self.view.center;
    }
    return _ChangeButton;
}
@end
