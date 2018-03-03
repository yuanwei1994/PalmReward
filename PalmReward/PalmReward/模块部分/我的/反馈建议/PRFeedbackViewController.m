//
//  PRFeedbackViewController.m
//  PalmReward
//
//  Created by Candy on 16/12/17.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import "PRFeedbackViewController.h"
#import "PRButton.h"

@interface PRFeedbackViewController () {
    CGFloat _submitButtonWidth;
    CGFloat _submitButtonHeight;
    CGFloat _textViewHeight;
}

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *promptLable;
@property (nonatomic, strong) UILabel * successLabel;
@property (nonatomic, strong) UILabel *  failLable;
@property (nonatomic, strong) PRButton *submitButton;


@end

@implementation PRFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setControllers];
}

- (void) setControllers {
    self.navigationItem.title = @"反 馈 建 议";
//    self.view.backgroundColor = COLOR_RGB(235, 235, 235, 0.2);
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _submitButtonWidth = 300 *AAdaptionWidth();
    _submitButtonHeight = 35 *AAdaptionWidth();
    _textViewHeight = 300 *AAdaptionWidth();
    
    [self.view addSubview:self.textView];
    [self.view addSubview:self.submitButton];
    [self.view addSubview:self.successLabel];
    [self.view addSubview:self.failLable];
    //监听所有的textView
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setPromptLableHidden) name:UITextViewTextDidChangeNotification object:nil];
}

#pragma mark -- Action

-(void)onsubmitButton{
    NSMutableDictionary *parameters  = [NSMutableDictionary dictionary];
    [parameters setValue:[PRUserModel shareUserModel].user_token forKey:@"token"];
    [parameters setValue:self.textView.text forKey:@"feedback_content"];
    [PRBaseRequest starRequest:FEEDBACK_URL parameters:parameters completionHandler:^(PRResponse *response) {
        if (response.success) {
            self.textView.text = @"";
            self.promptLable.hidden = NO;
            [self show:self.successLabel];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else{
            NSLog(@"%@",response.resultDesc);
            [self show:self.failLable];
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

- (void)setPromptLableHidden {
    self.promptLable.hidden = self.textView.text.length > 0 ? 1 : 0;
}




#pragma mark -- Getter
- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 64 + 8 *AAdaptionWidth(), PRwidth, (PRheight - _textViewHeight) / 2)];
//        _textView.layer.borderWidth = 1;
//        _textView.layer.borderColor = [UIColor grayColor].CGColor;
        _textView.backgroundColor = [UIColor whiteColor];
        [_textView setFont:[UIFont systemFontOfSize:16]];
        [_textView addSubview:self.promptLable];
    }
    return _textView;
}

- (UILabel *)promptLable {
    if (!_promptLable) {
        _promptLable = [[UILabel alloc] initWithFrame:CGRectMake(5 , 0, PRwidth, 35 *AAdaptionWidth())];
        _promptLable.text = @"请输入您宝贵的意见吧";
        _promptLable.textColor = [UIColor lightGrayColor];
        _promptLable.textAlignment = NSTextAlignmentJustified;
        [_promptLable setFont:[UIFont systemFontOfSize:16]];
    }
    return _promptLable;
}

- (PRButton *)submitButton {
    if (!_submitButton) {
        _submitButton = [[PRButton alloc] initWithFrame:CGRectMake((PRwidth - _submitButtonWidth) / 2, (PRheight - _submitButtonHeight) / 2, _submitButtonWidth, _submitButtonHeight) Title:@"提 交" TitleColor:[UIColor blackColor] titleFont:15 backColor:[UIColor whiteColor] BackImage:nil Tag:123 radius:0.5 BorderWidth:1 BorderColor:[UIColor blackColor] Block:^(id sender) {
            [self onsubmitButton];
        }];
    }
    return _submitButton;
}

-(UILabel *)successLabel{
    if (!_successLabel) {
        CGFloat labelW = 90;
        _successLabel = [[UILabel alloc] initWithFrame:AAdaptionRect((PRwidth-labelW)/2, PRheight - labelW, labelW, 21)];
        _successLabel.text = @"反馈成功";
        _successLabel.textAlignment = NSTextAlignmentCenter;
        _successLabel.textColor = [UIColor blackColor];
        _successLabel.backgroundColor = [UIColor clearColor];
        _successLabel.font = AAFont(17);
        _successLabel.alpha = 0;
        
    }
    return _successLabel;
}

-(UILabel *)failLable{
    if (!_failLable) {
        CGFloat labelW = 90;
        _failLable = [[UILabel alloc] initWithFrame:AAdaptionRect((PRwidth-labelW)/2, PRheight - labelW, labelW, 21)];
        _failLable.text = @"反馈失败";
        _failLable.textAlignment = NSTextAlignmentCenter;
        _failLable.textColor = [UIColor blackColor];
        _failLable.backgroundColor = [UIColor clearColor];
        _failLable.font = AAFont(17);
        _failLable.alpha = 0;
        
    }
    return _failLable;
}
@end
