//
//  PRBaseRequest.h
//  PalmReward
//
//  Created by rimi on 16/12/12.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import "PRResponse.h"
#import "PRURL.h"

typedef void(^RequestCompletion)(PRResponse * response);

@interface PRBaseRequest : NSObject

@property(nonatomic,assign) BOOL success;
@property(nonatomic,strong) id data;
@property(nonatomic,copy) NSString *error;

+ (void)starRequest:(NSString *)urlString
         parameters:(NSDictionary *)parameters
  completionHandler:(RequestCompletion)comletionHandler;

+ (void)uploadRequest:(NSString *)urlString
            imageData:(NSData *)imageData
           parameters:(NSDictionary *)parameters
    completionHandler:(RequestCompletion)completionHandler;

+ (void)uploadRequests:(NSString *)urlString
        imageDataArray:(NSArray *)imageDataArray
            parameters:(NSDictionary *)parameters
     completionHandler:(RequestCompletion)completionHandler;

@end
