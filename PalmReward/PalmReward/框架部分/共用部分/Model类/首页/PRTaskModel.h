//
//  PRTaskModel.h
//  PalmReward
//
//  Created by rimi on 16/12/20.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PRTaskModel : NSObject
//@property (nonatomic ,copy) NSString * task_schedule_id;
@property (nonatomic ,copy) NSString * reward_task_id;
//@property (nonatomic ,copy) NSString * accepter_user_id;
@property (nonatomic ,copy) NSString * reward_task_stauts;
@property (nonatomic ,copy) NSString * reward_task_accept_time;
@property (nonatomic ,copy) NSString * reward_task_finish_time;
//@property (nonatomic ,copy) NSString * reward_task_id;
@property (nonatomic ,copy) NSString * promoter_user_id;    //
@property (nonatomic ,copy) NSString * task_image_id;
@property (nonatomic ,copy) NSString * reward_title;
@property (nonatomic ,copy) NSString * reward_content;
@property (nonatomic ,copy) NSString * reward_coin;
@property (nonatomic ,copy) NSString * reward_commit_time;
@property (nonatomic ,copy) NSString * user_nickname;
@property (nonatomic ,copy) NSString * user_avatar;


//+(instancetype)shareTaskModel;

@end
