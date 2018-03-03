///Users/Candy/Desktop/PalmReward/PalmReward/PalmReward/资源部分/ThirdLib
//  PictureAddCell.m
//  类似QQ图片添加、图片浏览
//
//  Created by seven on 16/3/31.
//  Copyright © 2016年 QQpicture. All rights reserved.
//

#import "PictureAddCell.h"

@implementation PictureAddCell
{
    UIImageView *addImageView;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
     addImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:addImageView];
    
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    addImageView.frame = CGRectMake(0, 0, 75*AAdaptionWidth(), 75*AAdaptionWidth());
    addImageView.image = [UIImage imageNamed:@"相机"];//添加
    
    
}


@end
