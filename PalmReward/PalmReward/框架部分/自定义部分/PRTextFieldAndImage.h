//
//  PRTextFieldAndImage.h
//  PalmReward
//
//  Created by Gilgamesh丶 on 2016/12/12.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSInteger {
    Imagetop,
    Imagebottom,
    Imageleft,
    Imageright,
}textFieldFrame;

typedef enum : NSInteger {
    LineTop,
    LineBottom,
    LineLeft,
    LineRight,
    LineNone,
}LineFrame;

@interface PRTextFieldAndImage : UITextField

- (instancetype)initWithFrame:(CGRect)frame imageName:(NSString *)imageName imageFrame:(textFieldFrame)imageFrame lineFrame:(LineFrame)lineFrame Space:(CGFloat)Space imageAndViewSpace:(CGFloat)imageAndViewSpace LineHightOrWidth:(CGFloat)LineHightOrWidth LineBack:(UIColor *)LineBack TextFieldBack:(UIColor *)TextFieldBack imageOnView:(UIView *)imageOnView imageWidth:(CGFloat)imageWidth imageHeight:(CGFloat)imageHeight SecureTextEntry:(BOOL)SecureTextEntry Placeholder:(NSString *)Placeholder PlaceholderColor:(UIColor *)PlaceholderColor PlaceholderFont:(NSInteger)PlaceholderFont;

@end
