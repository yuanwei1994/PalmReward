//
//  PRBaseRequest.m
//  PalmReward
//
//  Created by rimi on 16/12/12.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import "PRBaseRequest.h"

@implementation PRBaseRequest

#pragma mark -- 普通POST网络请求
+ (void)starRequest:(NSString *)urlString parameters:(NSDictionary *)parameters completionHandler:(RequestCompletion)comletionHandler{
    AFHTTPSessionManager *manager = [self sessionManager];
    [manager POST:[NSString stringWithFormat:@"%@%@",BASE_URL,urlString] parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self handleResponse:responseObject error:nil completionHandler:comletionHandler];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self handleResponse:nil error:error completionHandler:comletionHandler];
    }];
}

#pragma mark -- 单文件上传
+ (void)uploadRequest:(NSString *)urlString imageData:(NSData *)imageData parameters:(NSDictionary *)parameters completionHandler:(RequestCompletion)completionHandler {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/html",@"text/javascript", nil];
    manager.requestSerializer= [AFHTTPRequestSerializer serializer]; //序列化
    
    [manager POST:[NSString stringWithFormat:@"%@%@", BASE_URL, urlString] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {

        //上传的参数(上传图片，以文件流的格式)
        
        [formData appendPartWithFileData:imageData
                                    name:@"file"
                                fileName:@"image.png"
                                mimeType:@"image/png"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"上传成功!");
        NSLog(@" - %@ - ",responseObject);
        [self handleResponse:responseObject error:nil completionHandler:completionHandler];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"上传失败!");
        NSLog(@" - %@ - ",error);
        [self handleResponse:nil error:error completionHandler:completionHandler];
        
    }];
}


#pragma mark -- 多文件上传
+ (void)uploadRequests:(NSString *)urlString imageDataArray:(NSArray *)imageDataArray parameters:(NSDictionary *)parameters completionHandler:(RequestCompletion)completionHandler {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/html",@"text/javascript", nil];
    manager.requestSerializer= [AFHTTPRequestSerializer serializer]; //序列化
    
    [manager POST:[NSString stringWithFormat:@"%@%@", BASE_URL, urlString] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        //上传的参数(上传图片，以文件流的格式)//[NSString stringWithFormat:@"file%d",i]
        for (int i = 0; i < imageDataArray.count; i ++) {
            NSData *imageData = UIImagePNGRepresentation(imageDataArray[i]);
            [formData appendPartWithFileData: imageData
                                        name:[NSString stringWithFormat:@"file%d",i]
                                    fileName:[NSString stringWithFormat:@"image%d.png",i]
                                    mimeType:@"image/png"];
            
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"上传成功!");
        NSLog(@" - %@ - ",responseObject);
         [self handleResponse:responseObject error:nil completionHandler:completionHandler];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"上传失败!");
        NSLog(@" - %@ - ",error);
        [self handleResponse:nil error:error completionHandler:completionHandler];
        
    }];
}


#pragma mark -- Private


+ (AFHTTPSessionManager * )sessionManager{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    //manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 15.0;
    return manager;
}

//+ (NSString *)handleURLString:(NSString*)urlString Token:(NSString*)token {
//    return [NSString stringWithFormat:@"%@%@&token=%@",BASE_URL,urlString,token];
//}

+ (void) handleResponse:(id)responseObject error:(NSError *)error completionHandler:(RequestCompletion)comletionHandler{
    PRResponse * response = [[PRResponse alloc] init];
    if (error) {
        //请求失败
        response.resultDesc = error.localizedDescription;
        if (error.code == NSURLErrorNotConnectedToInternet) {
            response.resultDesc = @"无网络连接";
        } else if (error.code == NSURLErrorTimedOut){
            response.resultDesc = @"网络连接超时";
        }
    } else{
        NSInteger resultCode = [responseObject[@"status"] integerValue];
        if (resultCode == 1) {
            response.success = YES;
            response.resultVaule = responseObject[@"data"];
            response.resultDesc = @"获取消息成功";
        }else{
            NSString * message = responseObject[@"msg"];
            if (message) {
                response.resultDesc = message;
            }else{
                response.resultDesc = @"获取数据失败";
            }
        }
    }
    if (comletionHandler) {
        comletionHandler(response);
    }
}

@end
