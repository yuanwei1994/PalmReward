//
//  PRURL.h
//  PalmReward
//
//  Created by rimi on 16/12/12.
//  Copyright © 2016年 zjy. All rights reserved.
//

#ifndef PRURL_h
#define PRURL_h


#define BASE_URL                @"http://zx.90candy.com"

#pragma mark -- 用户模块
//用户注册地址:
#define USER_REGIST_URL         @"/index-user-regist"
//用户登录地址:
#define USER_LOGIN_URL          @"/index-user-login"
//用户退出登录地址:
#define USER_LOGOUT_URL         @"/index-user-loginOut"

//上传头像图片
#define UPLOAD_AVATAR_URL       @"/index-upload-avatar"

//分页查询用户
#define FIND_USERS_URL          @"/index-user-findUser"

//请求融云token地址:
#define RONGCLOUD_TOKEN_URL     @"/api-Rongyun-getToken"


#pragma mark -- 悬赏相关


//悬赏任务发布地址:
#define RELEASE_TASK_URL         @"/index-rewardtasks-releaseTask"

//接受悬赏任务地址:
#define ACCEPT_TASK_URL          @"/index-rewardtasks-acceptRewardTask"

//取消接受悬赏任务地址:
#define CANCEL_TASK_URL          @"/index-rewardtasks-cancelAcceptRewardTask"

//首页网络请求 - 按条件查询
#define SELECT_TASK_URL           @"/index-rewardtasks-selectRewardTask"

//首页网络请求 - 所有未被接受的悬赏地址
#define SELECT_ALL_URL           @"/index-rewardtasks-selectAllNotAcceptTask"


//我的页面TableViewCell网络请求
#define SELECT_USER_TASK_URL      @"/index-rewardtasks-selectUserTask"
//修改用户信息
#define CHANGE_USER_URL           @"/index-User-resetPassword"
//提交请求
#define FEEDBACK_URL              @"/index-Feedbacks-feedBack"
//图片网络请求
#define REWARDIMAGE_URL           @"/index-Rewardimages-RewardImage"

#endif /* PRURL_h */
