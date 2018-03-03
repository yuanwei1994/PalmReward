//
//  PictureCollectionViewCell.m
//  类似QQ图片添加、图片浏览
//
//  Created by seven on 16/3/31.
//  Copyright © 2016年 QQpicture. All rights reserved.
//

#import "PictureCollectionViewCell.h"

@implementation PictureCollectionViewCell

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    self.imageView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.imageView];
    [[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"];
    
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(0, 0, 75*AAdaptionWidth(), 75*AAdaptionWidth());
}

@end
