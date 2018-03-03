//
//  PRUserModel.h
//  PalmReward
//
//  Created by Candy on 16/12/18.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PRUserModel : NSObject

@property (nonatomic, copy) NSString *user_adopted_number;
@property (nonatomic, copy) NSString *user_answer_number;
@property (nonatomic, copy) NSString *user_ask_number;
@property (nonatomic, copy) NSString *user_avatar;
@property (nonatomic, copy) NSString *user_coin;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *user_level_id;
@property (nonatomic, copy) NSString *user_mobile;
@property (nonatomic, copy) NSString *user_name;
@property (nonatomic, copy) NSString *user_nickname;
@property (nonatomic, copy) NSString *user_password;
@property (nonatomic, copy) NSString *user_regist_time;
@property (nonatomic, copy) NSString *user_resolution_rate;
@property (nonatomic, copy) NSString *user_status;
@property (nonatomic, copy) NSString *user_token;
@property (nonatomic, copy) NSString *user_token_time;
@property (nonatomic, copy) NSString *user_rongcloud_token;

+ (instancetype)shareUserModel;

@end
