//
//  PRDeleteImageView.h
//  PalmReward
//
//  Created by rimi on 16/12/9.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PRDeleteImageView : UIImageView
@property (nonatomic, strong) PRUIimageViewBlock imageBolck;
-(instancetype)initWithFrame:(CGRect)frame Image:(UIImage*)image IsUserInteraction:(BOOL)isUserInteraction Block:(PRUIimageViewBlock)block;


@end
