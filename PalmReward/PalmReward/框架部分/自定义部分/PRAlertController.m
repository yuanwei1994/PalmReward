//
//  PRAlertController.m
//  PalmReward
//
//  Created by rimi on 16/12/17.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import "PRAlertController.h"

@interface PRAlertController ()

@end

@implementation PRAlertController

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle hanler:(void (^)(PRAlertController *, NSInteger))handler cancleButtonTitle:(NSString *)cancelButtonTitle ohterButtonTitle:(NSString *)otherButtonTitles, ... {
    
    PRAlertController *alertController = [PRAlertController alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
    
    
    NSInteger buttonIndex = 0;
    
    if (cancelButtonTitle) {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            if (handler) {
                handler(alertController,buttonIndex);
            }
            
        }];
        //追加到里面去
        [alertController addAction:cancelAction];
    }
    
    if (otherButtonTitles) {
        
        buttonIndex ++;
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:otherButtonTitles style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            if (handler) {
                handler(alertController, buttonIndex);
            }
            
        }];
        [alertController addAction:action];
        
        //        ...要用的宏
        //        va_list  //指向可变参数表的当前参数的指针
        //        va_arg(<#ap#>, <#type#>) //从ap 当前指针 读取指定类型type的值
        //        va_end(<#ap#>) //将 ap指针置NULL
        //        va_start(<#ap#>, <#param#>) 给 ap指针赋值 其中 param 为。。。前面指针的值
        
        va_list argumentList;
        NSString *aTitle;
        va_start(argumentList, otherButtonTitles);
        
        while (1) {
            aTitle = va_arg(argumentList, NSString *);
            if (aTitle == nil) {
                break;
            }
            
            buttonIndex ++;
            UIAlertAction *action = [UIAlertAction actionWithTitle:aTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                if (handler) {
                    handler(alertController, buttonIndex);
                }
                
            }];
            [alertController addAction:action];
        }
        
        va_end(argumentList);
    }
    
    
    return alertController;
    
}


@end
