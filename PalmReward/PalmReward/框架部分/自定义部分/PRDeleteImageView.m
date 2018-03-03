//
//  PRDeleteImageView.m
//  PalmReward
//
//  Created by rimi on 16/12/9.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import "PRDeleteImageView.h"
#import "PRButton.h"

@implementation PRDeleteImageView

-(instancetype)initWithFrame:(CGRect)frame Image:(UIImage*)image IsUserInteraction:(BOOL)isUserInteraction Block:(PRUIimageViewBlock)block{
    self = [super initWithFrame:frame];
    if (self) {
        if (block) {
            self.imageBolck = block;
        }
        self.image = image;
        self.userInteractionEnabled = isUserInteraction;
        
        if (image) {
            PRButton *deleteBtn = [[PRButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame), 0, 16*AAdaptionWidth(), 16*AAdaptionWidth()) Title:nil TitleColor:nil titleFont:1 backColor:nil BackImage:[UIImage imageNamed:@"悬赏图片删除"] Tag:100 radius:0.5 BorderWidth:1 BorderColor:[UIColor whiteColor] Block:^(id sender) {
                [self onImageDeleteBtn:deleteBtn];
            }];
            [self addSubview:deleteBtn];
        }
    }
    return self;
}

-(void)onImageDeleteBtn:(UIButton*)sender{
    self.imageBolck(sender);
}

@end
