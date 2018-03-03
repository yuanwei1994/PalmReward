//
//  Adaption.h
//  MYSFTeacher
//
//  Created by zhengbing on 2016/11/1.
//  Copyright © 2016年 zhengbing. All rights reserved.
//

#ifndef Adaption_h
#define Adaption_h

#import <UIKit/UIKit.h>

#pragma 尺寸

#define PRwidth [UIScreen mainScreen].bounds.size.width
#define PRheight [UIScreen mainScreen].bounds.size.height
#define PRsize [UIScreen mainScreen].bounds.size
#define PRorigin [UIScreen mainScreen].bounds.origin


#pragma 参照尺寸

#define PRBaseWidth 414
#define PRBaseHeight 736

#define Inline static inline



//适配比率
Inline CGFloat AAdaptionWidth() {
    return PRwidth/PRBaseWidth;
}

//尺寸适配
Inline CGFloat AAdaption(CGFloat x) {
    return x * AAdaptionWidth();
}

Inline CGSize AAdaptionSize(CGFloat width, CGFloat height) {
    CGFloat newWidth = width * AAdaptionWidth();
    CGFloat newHeight = height * AAdaptionWidth();
    return CGSizeMake(newWidth, newHeight);
}

Inline CGPoint AAadaptionPoint(CGFloat x, CGFloat y) {
    CGFloat newX = x * AAdaptionWidth();
    CGFloat newY = y * AAdaptionWidth();
    return  CGPointMake(newX, newY);
}

Inline CGRect AAdaptionRect(CGFloat x, CGFloat y, CGFloat width, CGFloat height){
    CGFloat newX = x*AAdaptionWidth();
    CGFloat newY = y*AAdaptionWidth();
    CGFloat newW = width*AAdaptionWidth();
    CGFloat newH = height*AAdaptionWidth();
    return CGRectMake(newX, newY, newW, newH);
}

Inline CGRect AAdaptionRectFromFrame(CGRect frame){
    CGFloat newX = frame.origin.x*AAdaptionWidth();
    CGFloat newY = frame.origin.y*AAdaptionWidth();
    CGFloat newW = frame.size.width*AAdaptionWidth();
    CGFloat newH = frame.size.height*AAdaptionWidth();
    return CGRectMake(newX, newY, newW, newH);
}

//字体适配
Inline UIFont * AAFont(CGFloat font){
    return [UIFont systemFontOfSize:font*AAdaptionWidth()];
}

#endif /* Adaption_h */
