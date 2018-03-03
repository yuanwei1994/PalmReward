//
//  PRLineTextField.h
//  PalmReward
//
//  Created by rimi on 16/12/10.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum :NSUInteger{
    Top,
    Bottom,
    Left,
    Right,
}WherelienFrame;

@interface PRLineTextField : UITextField

-(instancetype)initWithFrame:(CGRect)frame LineViewColor:(UIColor*)lineViewColor LineViewHeight:(CGFloat)lineViewHeight LineFrame:(WherelienFrame)lineframe LineOnViewController:(UIViewController*)lineOnViewController FieldPlaceholder:(NSString*)fieldPlaceholder FieldBackColor:(UIColor *)fieldBackColor;

@end
