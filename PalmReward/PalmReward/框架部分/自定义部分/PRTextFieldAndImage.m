//
//  PRTextFieldAndImage.m
//  PalmReward
//
//  Created by Gilgamesh丶 on 2016/12/12.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import "PRTextFieldAndImage.h"

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height


@implementation PRTextFieldAndImage


/*
 imageName:图片名字
 imageFrame:图片的大小位置
 lineFrame:竖线的大小位置
 Line:竖线的粗细
 LineBack:竖线的颜色
 TextFieldBack:输入框的背景颜色
 */
- (instancetype)initWithFrame:(CGRect)frame imageName:(NSString *)imageName imageFrame:(textFieldFrame)imageFrame lineFrame:(LineFrame)lineFrame Space:(CGFloat)Space imageAndViewSpace:(CGFloat)imageAndViewSpace LineHightOrWidth:(CGFloat)LineHightOrWidth LineBack:(UIColor *)LineBack TextFieldBack:(UIColor *)TextFieldBack imageOnView:(UIView *)imageOnView imageWidth:(CGFloat)imageWidth imageHeight:(CGFloat)imageHeight SecureTextEntry:(BOOL)SecureTextEntry Placeholder:(NSString *)Placeholder PlaceholderColor:(UIColor *)PlaceholderColor PlaceholderFont:(NSInteger)PlaceholderFont {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = TextFieldBack;
        self.secureTextEntry = SecureTextEntry;
        self.placeholder = Placeholder;
        [self setValue:PlaceholderColor forKeyPath:@"_placeholderLabel.textColor"];
        [self setValue:[UIFont boldSystemFontOfSize:PlaceholderFont] forKeyPath:@"_placeholderLabel.font"];
        switch (imageFrame) {
                
#pragma mark ---- 图片在上部
            case Imagetop:
            {
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.frame) - imageWidth / 2, CGRectGetMinY(self.frame) - imageHeight - imageAndViewSpace, imageWidth, imageHeight)];
                imageView.image = [UIImage imageNamed:imageName];
                [imageOnView addSubview:imageView]
                ;
                [self setLineFrame:lineFrame Space:Space imageAndViewSpace:imageAndViewSpace   LineHightOrWidth:LineHightOrWidth LineBack:LineBack onView:imageOnView];
            }
                
                break;
                
#pragma mark ---- 图片在底部
            case Imagebottom:
            {
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.frame) - imageWidth / 2, CGRectGetMaxY(self.frame) + imageHeight +imageAndViewSpace, imageWidth, imageHeight)];
                imageView.image = [UIImage imageNamed:imageName];
                [imageOnView addSubview:imageView]
                ;
                
                [self setLineFrame:lineFrame Space:Space imageAndViewSpace:imageAndViewSpace   LineHightOrWidth:LineHightOrWidth LineBack:LineBack onView:imageOnView];
                
            }
                break;
                
#pragma mark ---- 图片在左边
            case Imageleft:
            {
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.frame) - imageWidth -  imageAndViewSpace, CGRectGetMidY(self.frame) - imageHeight / 2, imageWidth, imageHeight)];
                
                imageView.image = [UIImage imageNamed:imageName];
                
                [imageOnView addSubview:imageView]
                ;
                
                [self setLineFrame:lineFrame Space:Space imageAndViewSpace:imageAndViewSpace   LineHightOrWidth:LineHightOrWidth LineBack:LineBack onView:imageOnView];
            }
                
                break;
#pragma mark ---- 图片在右边
            case Imageright:
            {
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.frame) + imageAndViewSpace, CGRectGetMidY(self.frame) - imageHeight / 2, imageWidth, imageHeight)];
                
                imageView.image = [UIImage imageNamed:imageName];
                
                [imageOnView addSubview:imageView]
                ;
                
                [self setLineFrame:lineFrame Space:Space imageAndViewSpace:imageAndViewSpace   LineHightOrWidth:LineHightOrWidth LineBack:LineBack onView:imageOnView];
                
            }
                break;
                
                
                
                
            default:
                break;
        }
        
    }
    return self;
}



- (void)setLineFrame:(LineFrame)LineFrame Space:(CGFloat)Space imageAndViewSpace:(CGFloat)imageAndViewSpace LineHightOrWidth:(CGFloat)LineHightOrWidth  LineBack:(UIColor *)LineBack onView:(UIView *)onView{
    switch (LineFrame) {
            
#pragma mark -- 竖线在上部
        case LineTop:
        {
            UIView *Line = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame) - Space, CGRectGetWidth(self.frame), LineHightOrWidth)];
            Line.backgroundColor = LineBack;
            [onView addSubview:Line];
            ;
        }
            break;
            
#pragma mark -- 竖线在下部
        case LineBottom:
        {
            UIView *Line = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.frame), CGRectGetMaxY(self.frame) + Space, CGRectGetWidth(self.frame), LineHightOrWidth)];
            Line.backgroundColor = LineBack;
            [onView addSubview:Line];
        }
            
            break;
#pragma mark -- 竖线在左部
        case LineLeft:
        {
            UIView *Line = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.frame) - Space, CGRectGetMinY(self.frame), LineHightOrWidth, CGRectGetHeight(self.frame))];
            
            Line.backgroundColor = LineBack;
            [onView addSubview:Line];
        }
            break;
#pragma mark -- 竖线在右部
        case LineRight:
        {
            UIView *Line = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.frame) + Space, CGRectGetMinY(self.frame), LineHightOrWidth, CGRectGetHeight(self.frame))];
            Line.backgroundColor = LineBack;
            [onView addSubview:Line];
        }
            break;
            
       #pragma mark -- 没有竖线
        case LineNone:
        {
        
        }
            break;
        default:
            break;
}


}

@end
