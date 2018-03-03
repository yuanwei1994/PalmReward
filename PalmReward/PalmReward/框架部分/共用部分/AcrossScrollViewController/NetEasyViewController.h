//
//  NetEasyViewController.h
//  UI高级第五天网易首页封装
//
//  Created by rimi on 16/9/24.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NetEasyViewController : UIViewController
@property(nonatomic,assign) CGFloat barHeight;
-(instancetype)initWithTitles:(NSArray*)titles viewControllers:(NSArray*)viewControllers;
@end
