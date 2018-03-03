//
//  PRPayView.m
//  PalmReward
//
//  Created by rimi on 16/12/19.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import "PRPayView.h"

@interface PRPayView ()

@property (nonatomic,strong) UIImageView * okImageView;
@end

@implementation PRPayView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setSomeThing];
    }
    return self;
}

-(void)setSomeThing{
    self.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer * viewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onViewTap)];
    [self addGestureRecognizer:viewTap];
    self.imageView = [[UIImageView alloc] init];
    self.imageView.frame = CGRectMake(20 *AAdaptionWidth(), 10 *AAdaptionWidth(), 35 *AAdaptionWidth(), 35 *AAdaptionWidth());
    UIImageView * okImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"愿望-打赏-选中"]];
    okImageView.frame = CGRectMake(CGRectGetMaxX(self.frame) - 50*AAdaptionWidth(), 15*AAdaptionWidth(), 25*AAdaptionWidth(), 25*AAdaptionWidth());
    okImageView.hidden = YES;
    self.okImageView = okImageView;
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.imageView.frame) + 5*AAdaptionWidth(), 10*AAdaptionWidth(), 180*AAdaptionWidth(), 35*AAdaptionWidth())];
    label.font = AAFont(14);
    self.titleLabel = label;
    [self addSubview:okImageView];
    [self addSubview:self.imageView];
    [self addSubview:self.titleLabel];

}

-(void)onViewTap{
    if ([self.deleagte respondsToSelector:@selector(onPayViewAction:)]) {
        [self.deleagte onPayViewAction:self];
    }
}

#pragma mark - Setter

- (void)setSelected:(BOOL)selected {
    _selected = selected;
    self.okImageView.hidden = !selected;

}

@end
