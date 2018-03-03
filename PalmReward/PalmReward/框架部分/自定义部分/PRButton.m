//
//  PRButton.m
//  PalmReward
//
//  Created by rimi on 16/12/8.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import "PRButton.h"

@implementation PRButton

-(instancetype)initWithFrame:(CGRect)frame Title:(NSString*)title TitleColor:(UIColor*)titleColor titleFont:(CGFloat)titleFont backColor:(UIColor*)backColor BackImage:(UIImage*)backimage Tag:(NSInteger)tag radius:(CGFloat)radius BorderWidth:(CGFloat)BorderWidth BorderColor:(UIColor *)BorderColor Block:(PRButtonBlock)block {
    self = [super initWithFrame:frame];
    if (self) {
        if (block) {
            self.BtnBlock = block;
        }
        self.tag = tag;
        [self addTarget:self action:@selector(onBtnTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:titleColor forState:UIControlStateNormal];
        [self.titleLabel setFont:AAFont(titleFont)];
        [self setBackgroundColor:backColor];
        [self setImage:backimage forState:UIControlStateNormal];
        [self.layer setBorderWidth:BorderWidth];
        [self.layer setBorderColor:BorderColor.CGColor];
        self.layer.cornerRadius = self.frame.size.height * radius;
    }
    return self;
}


//点击按钮调用此方法
-(void)onBtnTouchUpInside:(UIButton *)sender{
    self.BtnBlock(sender);
}


@end
