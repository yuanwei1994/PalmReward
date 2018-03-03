//
//  PRImageButton.m
//  PalmReward
//
//  Created by Candy on 16/12/17.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import "PRImageButton.h"

@interface PRImageButton()
//传入定位
@property(nonatomic, assign) CGRect titleRect;
@property(nonatomic, assign) CGRect imageRect;

@end

@implementation PRImageButton

- (instancetype)initWithTitleRect:(CGRect)titleRect ImageRect:(CGRect)imageRect
{
    self = [super init];
    if (self) {
        self.titleRect = titleRect;
        self.imageRect = imageRect;
    }
    return self;
}
- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    return self.titleRect;
}
- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    return self.imageRect;
}

@end
