//
//  PRLabelWithFieldView.h
//  PalmReward
//
//  Created by rimi on 16/12/27.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PRLabelWithFieldView : UIView
@property (nonatomic,strong) UILabel * titleLabel;
@property (nonatomic,strong) UITextField * textField;
-(instancetype)initWithFrame:(CGRect)frame backColor:(UIColor *)backColor LabelTitle:(NSString *)labeltitle FieldText:(NSString *)fieldtext UserInterac:(BOOL)userInterac Secure:(BOOL)secure;
@end
