//
//  PRImageButton.h
//  PalmReward
//
//  Created by Candy on 16/12/17.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PRImageButton : UIButton

- (instancetype)initWithTitleRect:(CGRect)titleRect ImageRect:(CGRect)imageRect;

- (CGRect)titleRectForContentRect:(CGRect)contentRect;
- (CGRect)imageRectForContentRect:(CGRect)contentRect;

@end
