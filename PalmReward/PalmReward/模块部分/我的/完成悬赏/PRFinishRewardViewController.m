//
//  PRFinishRewardViewController.m
//  PalmReward
//
//  Created by Candy on 16/12/17.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import "PRFinishRewardViewController.h"
#import "PRMyRewardDetailViewController.h"

#import "PRUserTaksModel.h"
#import "PRMyFinishTableViewCell.h"

#define CELL_IDENTIFIER @"cellIdentifier"

@interface PRFinishRewardViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation PRFinishRewardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setControllers];
}




- (void) setControllers {
    self.navigationItem.title = @"完 成 悬 赏";
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self myFinishReward];
}

#pragma mark -- 网络请求
- (void) myFinishReward {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[PRUserModel shareUserModel].user_token forKey:@"token"];
    [parameters setObject:@(3) forKey:@"type_id"];
    [parameters setObject:@(0) forKey:@"page_index"];
    [parameters setObject:@(30) forKey:@"page_num"];
    [PRBaseRequest starRequest:SELECT_USER_TASK_URL parameters:parameters completionHandler:^(PRResponse *response) {
        if (response.success) {
            [self.dataSource removeAllObjects];
            self.dataSource = [PRUserTaksModel mj_objectArrayWithKeyValuesArray:response.resultVaule];
            [self.tableView reloadData];
        }else{
            [self.dataSource removeAllObjects];
            [self.tableView reloadData];
        }
    }];
}

#pragma mark -- delegate && dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PRMyFinishTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    cell.task = self.dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PRMyRewardDetailViewController *myFinishDetailVC = [[PRMyRewardDetailViewController alloc] init];
    myFinishDetailVC.taskModel = self.dataSource[indexPath.row];
    myFinishDetailVC.statusString = @"已完成";
    [self.navigationController pushViewController:myFinishDetailVC animated:YES];
}

#pragma mark -- Getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame];
        _tableView.rowHeight = 55 * AAdaptionWidth();
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];

        [_tableView registerNib:[UINib nibWithNibName:@"PRMyFinishTableViewCell" bundle:nil] forCellReuseIdentifier:CELL_IDENTIFIER];
        
    }
    return _tableView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}



@end
