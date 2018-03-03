//
//  PRWantedCollectionViewCell.m
//  PalmReward
//
//  Created by rimi on 16/12/29.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import "PRWantedCollectionViewCell.h"

@implementation PRWantedCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [_delButton addTarget:self action:@selector(onDelButton) forControlEvents:UIControlEventTouchUpInside];
}

-(void)onDelButton{
    if (_isDel) {
        _isDel(YES);
    }
}

@end
