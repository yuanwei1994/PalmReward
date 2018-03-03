//
//  PRRightLabelTextField.m
//  PalmReward
//
//  Created by rimi on 16/12/19.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import "PRRightLabelTextField.h"

@implementation PRRightLabelTextField

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame: frame];
    if (self) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30*AAdaptionWidth(), 25*AAdaptionWidth())];
        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]
                                                    initWithString:@"| 元"];
        [AttributedStr addAttribute:NSFontAttributeName
                              value:[UIFont systemFontOfSize:14*AAdaptionWidth()]range:NSMakeRange(0, 2)];
        [AttributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor]range:NSMakeRange(0, 1)];
        label.attributedText = AttributedStr;
        label.font = [UIFont systemFontOfSize:15*AAdaptionWidth()];
        self.rightView = label;
        self.rightViewMode = UITextFieldViewModeAlways;
    }
    return self;
}

@end
