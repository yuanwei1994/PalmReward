//
//  PRUITableView.h
//  PalmReward
//
//  Created by rimi on 16/12/8.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PRUITableView : UITableView

@property (nonatomic,copy)PRUITableViewBlock TablefootBlock;
@property (nonatomic,copy)PRUITableViewBlock TableheadBlock;

/*
 初始化方法
 位置             frame
 样式             style
 tableView行高    rowHeight
 Nib注册          registerNib
 唯一标示符        identifier
 tableView头部视图 tableHeaderView
 上拉Block      footblock
 下拉Block         headblock
*/
-(instancetype)initWithFrame:(CGRect)frame Style:(UITableViewStyle)style RowHeight:(CGFloat)rowHeight RegisterNib:(UINib*)registerNib Identifier:(NSString*)identifier TableHeaderView:(UIView*)tableHeaderView FootBlock:(PRUITableViewBlock)footblock HeadBlock:(PRUITableViewBlock)headblock;
    
@end
