//
//  PRChatViewController.m
//  PalmReward
//
//  Created by rimi on 16/12/16.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import "PRChatViewController.h"
#import "PRUserModel.h"
@interface PRChatViewController ()
@property (nonatomic,strong) PRUserModel  *usermodel;
@end

@implementation PRChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)willDisplayMessageCell:(RCMessageBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    if ([cell isMemberOfClass:[RCTextMessageCell class]]) {
        
        _usermodel = [PRUserModel shareUserModel];
        RCTextMessageCell * testMsgcell = (RCTextMessageCell *)cell;
        UILabel * textMsgLabel = (UILabel *)testMsgcell.textLabel;
        textMsgLabel.textColor = [UIColor redColor];
        
        if (cell.messageDirection == MessageDirection_SEND) {
            testMsgcell.bubbleBackgroundView.image = [UIImage imageNamed:@"send"];
            UIImageView * imageView = (UIImageView *)testMsgcell.portraitImageView;
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[self setAvatar]]];
            imageView.image = [UIImage imageWithData:data];
        }
        if(cell.messageDirection == MessageDirection_RECEIVE){
            testMsgcell.bubbleBackgroundView.image = [UIImage imageNamed:@"receive"];
            UIImageView * imageView = (UIImageView *)testMsgcell.portraitImageView;
            imageView.image = [UIImage imageNamed:@"10"];
        }
        
        
    }
}

-(NSString *) setAvatar{
    NSString * avatarString;
    if (![_usermodel.user_avatar isEqual:[NSNull null]]) {
        avatarString = [_usermodel.user_avatar ReplaceSlash];
    }
    return [NSString stringWithFormat:@"%@%@",BASE_URL,avatarString];
}

@end
