//
//  PRAlertController.h
//  PalmReward
//
//  Created by rimi on 16/12/17.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PRAlertController : UIAlertController

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(UIAlertControllerStyle) preferredStyle hanler:(void(^)(PRAlertController *alertController, NSInteger buttonIndex)) handler cancleButtonTitle:(NSString *) cancelButtonTitle ohterButtonTitle:(NSString *) otherButtonTitles, ...;

@end
