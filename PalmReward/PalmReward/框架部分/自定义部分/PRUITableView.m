//
//  PRUITableView.m
//  PalmReward
//
//  Created by rimi on 16/12/8.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import "PRUITableView.h"
#import "MJRefresh.h"

@implementation PRUITableView

-(instancetype)initWithFrame:(CGRect)frame Style:(UITableViewStyle)style RowHeight:(CGFloat)rowHeight RegisterNib:(UINib*)registerNib Identifier:(NSString*)identifier TableHeaderView:(UIView*)tableHeaderView FootBlock:(PRUITableViewBlock)footblock HeadBlock:(PRUITableViewBlock)headblock{
    self = [super initWithFrame:frame style:style];
    if (self) {

        self.rowHeight = rowHeight;
        if (registerNib) {
            [self registerNib:registerNib forCellReuseIdentifier:identifier];
        }else{
            [self registerClass:[UITableViewCell class] forCellReuseIdentifier:identifier];
        }
        self.tableHeaderView = tableHeaderView;
        
        //判断是否有Block
        if (footblock) {
            self.TablefootBlock = footblock;
            self.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
                [self onfootReloadData:self];
            }];
        }
        if (headblock) {
            self.TableheadBlock = headblock;
            self.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
                [self onheadReloadData:self];
            }];
        }
    }
    return self;
}


-(void)onfootReloadData:(UITableView*)sender{
    self.TablefootBlock(sender);
}
    
-(void)onheadReloadData:(UITableView*)sender{
    self.TableheadBlock(sender);
}
    
@end
