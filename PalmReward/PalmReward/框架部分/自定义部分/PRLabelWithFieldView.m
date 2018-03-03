//
//  PRLabelWithFieldView.m
//  PalmReward
//
//  Created by rimi on 16/12/27.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import "PRLabelWithFieldView.h"

@implementation PRLabelWithFieldView

-(instancetype)initWithFrame:(CGRect)frame backColor:(UIColor *)backColor LabelTitle:(NSString *)labeltitle FieldText:(NSString *)fieldtext UserInterac:(BOOL)userInterac Secure:(BOOL)secure{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor  = backColor;
        CGFloat labelH = 40 *AAdaptionWidth();
        CGFloat textFieldW = 200*AAdaptionWidth();
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (self.bounds.size.height - labelH)/2, 90 *AAdaptionWidth(), labelH)];
        _titleLabel.text = labeltitle;
        _titleLabel.font = AAFont(17);
        [self addSubview:_titleLabel];
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.frame) - textFieldW, (self.bounds.size.height - labelH)/2, textFieldW, labelH)];
        _textField.text = fieldtext;
        _textField.secureTextEntry = secure;
        _textField.font = AAFont(17);
        _textField.userInteractionEnabled = userInterac;
        [self addSubview:_textField];
    }
    return self;
}

@end
