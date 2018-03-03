//
//  PRImageLabel.m
//  PalmReward
//
//  Created by rimi on 16/12/10.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import "PRImageLabel.h"

@implementation PRImageLabel

-(instancetype)initWithFrame:(CGRect)frame ImageH:(CGFloat)imageH ImageW:(CGFloat)imageW ImageName:(UIImage*)imageName ImageFrame:(WhereImageFrame)imageFrame ImageOnController:(UIViewController*)imageOnController ImageSpaceWithLabel:(CGFloat)imageSpaceWithLabel LabelText:(NSString*)labelText LabelColor:(UIColor *)labelColor LabelFont:(UIFont *)labelFont LabelTextColor:(UIColor *)labelTextColor {
    self = [super initWithFrame:frame];
    if (self) {
        self.text = labelText;
        self.font = labelFont;
        self.textColor = labelTextColor;
        self.backgroundColor = labelColor;
        switch (imageFrame) {
            case ImgTop:
            {
                UIImageView * img = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.frame) - imageW/2, CGRectGetMinY(self.frame)-imageSpaceWithLabel - imageH, imageW, imageH)];
                img.image = imageName;
                [imageOnController.view addSubview:img];
            }
                break;
            case ImgLeft:
            {
                UIImageView * img = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.frame) - imageW - imageSpaceWithLabel, CGRectGetMinY(self.frame), imageW, imageH)];
                img.image = imageName;
                [imageOnController.view addSubview:img];
            }
                break;
            case ImgRight:
            {
                UIImageView * img = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.frame) +imageSpaceWithLabel, CGRectGetMinY(self.frame), imageW, imageH)];
                img.image = imageName;
                [imageOnController.view addSubview:img];
            }
                break;
            case ImgBottom:
            {
                UIImageView * img = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.frame) - imageW/2, CGRectGetMaxY(self.frame)+imageSpaceWithLabel, imageW, imageH)];
                img.image = imageName;
                [imageOnController.view addSubview:img];
            }
                break;
                
            default:
                break;
        }
    }
    return self;
}



@end
