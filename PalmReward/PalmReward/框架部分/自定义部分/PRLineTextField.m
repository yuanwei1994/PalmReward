//
//  PRLineTextField.m
//  PalmReward
//
//  Created by rimi on 16/12/10.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import "PRLineTextField.h"

@implementation PRLineTextField


-(instancetype)initWithFrame:(CGRect)frame LineViewColor:(UIColor*)lineViewColor LineViewHeight:(CGFloat)lineViewHeight LineFrame:(WherelienFrame)lineframe LineOnViewController:(UIViewController*)lineOnViewController FieldPlaceholder:(NSString*)fieldPlaceholder FieldBackColor:(UIColor *)fieldBackColor {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = fieldBackColor;
        self.placeholder = fieldPlaceholder;
        switch (lineframe) {
            case Top:
            {
                UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame)-2, CGRectGetWidth(self.frame), lineViewHeight)];
                lineView.backgroundColor = lineViewColor;
                [lineOnViewController.view addSubview:lineView];
            }
                break;
            case Left:
            {
                UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.frame)-2, CGRectGetMinY(self.frame), lineViewHeight, CGRectGetHeight(self.frame))];
                lineView.backgroundColor = lineViewColor;
                [lineOnViewController.view addSubview:lineView];            }
                break;
            case Right:
            {
                UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.frame)+2, CGRectGetMinY(self.frame), lineViewHeight, CGRectGetHeight(self.frame))];
                lineView.backgroundColor = lineViewColor;
                [lineOnViewController.view addSubview:lineView];
            }
                break;
            case Bottom:
            {
                UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.frame), CGRectGetMaxY(self.frame)+2, CGRectGetWidth(self.frame), lineViewHeight)];
                lineView.backgroundColor = lineViewColor;
                [lineOnViewController.view addSubview:lineView];
            }
                break;
            default:
                break;
        }
        
    }
    return self;
}


@end
