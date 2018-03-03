//
//  PRImageLabel.h
//  PalmReward
//
//  Created by rimi on 16/12/10.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSInteger{
    ImgTop,
    ImgBottom,
    ImgLeft,
    ImgRight,
}WhereImageFrame;

@interface PRImageLabel : UILabel

-(instancetype)initWithFrame:(CGRect)frame ImageH:(CGFloat)imageH ImageW:(CGFloat)imageW ImageName:(UIImage*)imageName ImageFrame:(WhereImageFrame)imageFrame ImageOnController:(UIViewController*)imageOnController ImageSpaceWithLabel:(CGFloat)imageSpaceWithLabel LabelText:(NSString*)labelText LabelColor:(UIColor *)labelColor LabelFont:(UIFont *)labelFont LabelTextColor:(UIColor *)labelTextColor;

@end
