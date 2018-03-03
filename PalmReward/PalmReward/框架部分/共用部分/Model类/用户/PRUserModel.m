//
//  PRUserModel.m
//  PalmReward
//
//  Created by Candy on 16/12/18.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import "PRUserModel.h"

@implementation PRUserModel

+ (instancetype)shareUserModel {
    static PRUserModel *userModel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userModel = [[PRUserModel alloc] init];
    });
    return userModel;
}

@end
