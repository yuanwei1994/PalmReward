//
//  PRMessagesViewController.m
//  PalmReward
//
//  Created by rimi on 16/12/7.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import "PRMessagesViewController.h"
#import "PRDetailViewController.h"
#import "PRLogInViewController.h"
#import "PRChatViewController.h"
#import "PRLogInViewController.h"
#import "PRAlertController.h"

@interface PRMessagesViewController ()

@property (nonatomic, strong) UIButton *LogInButton;
@property (nonatomic, strong) UIButton *loginStatusButton;

@end

@implementation PRMessagesViewController

-(id)init{
    self = [super init];
    if (self) {
        [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),
                                            @(ConversationType_DISCUSSION),
                                            @(ConversationType_GROUP)]];
        //[self setCollectionConversationType:@[@(ConversationType_PRIVATE)]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.LogInButton];

    _loginStatusButton = [[UIButton alloc] initWithFrame:self.view.frame];
    _loginStatusButton.backgroundColor = [UIColor whiteColor];
    _loginStatusButton.titleLabel.font = [UIFont systemFontOfSize:25];
    [_loginStatusButton setTitle:@"请先登陆" forState:UIControlStateNormal];
    [_loginStatusButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_loginStatusButton addTarget:self action:@selector(onLoginStatuBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginStatusButton];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"]) {
        _loginStatusButton.hidden = YES;
        [self onAlertController];
    }else{
        _loginStatusButton.hidden = NO;
    }
}

- (void)onAlertController {
    PRAlertController *alertController = [PRAlertController alertControllerWithTitle:@"温馨提示" message:@"该功能还未实现" preferredStyle:UIAlertControllerStyleAlert hanler:^(PRAlertController *alertController, NSInteger buttonIndex) {
    } cancleButtonTitle:@"确定" ohterButtonTitle:nil];
    [self presentViewController:alertController animated:YES completion:nil];
}


-(void)onLoginStatuBtn{
    [self presentViewController:[PRLogInViewController new]  animated:YES completion:nil];
}

- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath {
    //else if (model.conversationType == ConversationType_PRIVATE){
    PRChatViewController *conversationVC = [[PRChatViewController alloc]init];
    conversationVC.conversationType = model.conversationType;
    conversationVC.targetId = model.targetId;
    conversationVC.title = @"想显示的会话标题";
    self.tabBarController.tabBar.hidden = YES;
    [self.navigationController pushViewController:conversationVC animated:YES];
}



@end
