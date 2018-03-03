//
//  PRResponse.h
//  PalmReward
//
//  Created by rimi on 16/12/12.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PRResponse : NSObject

@property (nonatomic,assign) BOOL success;/*是否正确返回*/
@property (nonatomic,strong) id resultVaule;/*请求结果*/
@property (nonatomic,copy) NSString * resultDesc;/*请求结果描述*/

@end
