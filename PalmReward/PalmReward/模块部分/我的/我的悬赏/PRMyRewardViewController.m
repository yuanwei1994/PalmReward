//
//  PRMyRewardViewController.m
//  PalmReward
//
//  Created by Gilgamesh丶 on 2016/12/20.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import "PRMyRewardViewController.h"
#import "PRFinishRewardTableViewCell.h"
#import "PRUserTaksModel.h"
#import "PRMyRewardDetailViewController.h"

@interface PRMyRewardViewController ()<UITableViewDelegate,UITableViewDataSource> {
    NSInteger _page;
    NSInteger _index;
}

@property (nonatomic, strong) UITableView *tableView; // 发布悬赏模块

@property (nonatomic, strong) NSMutableArray *dataSoure;

@end

@implementation PRMyRewardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setControllers];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self myReleaseReward];
}

- (void) setControllers {
    [self UISegmentedControl];
    [self.view addSubview:self.tableView];
}

#pragma mark -- tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSoure.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PRFinishRewardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.task = self.dataSoure[indexPath.row];
    return  cell;
}

#pragma mark -- tableViewdelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PRMyRewardDetailViewController *detailVC = [[PRMyRewardDetailViewController alloc] init];
    detailVC.taskModel = self.dataSoure[indexPath.row];
    [self.navigationController pushViewController:detailVC animated:YES];
}


#pragma mark -- Action
- (void) exChangeSegmentedControl:(UISegmentedControl *)SegmentedControl {
    _page = 0;
    
    _index = SegmentedControl.selectedSegmentIndex;
    switch (_index) {
        case 0:
            [self myReleaseReward];
            break;
        default:
            [self myAcceptReward];
            break;
    }
    
}


#pragma mark -- 数据源网络请求
- (void) myReleaseReward {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[PRUserModel shareUserModel].user_token forKey:@"token"];
    [parameters setObject:@(1) forKey:@"type_id"];
    [parameters setObject:@(0) forKey:@"page_index"];
    [parameters setObject:@(30) forKey:@"page_num"];
    [PRBaseRequest starRequest:SELECT_USER_TASK_URL parameters:parameters completionHandler:^(PRResponse *response) {
        if (response.success) {
            [self.dataSoure removeAllObjects];
            self.dataSoure = [PRUserTaksModel mj_objectArrayWithKeyValuesArray:response.resultVaule];
            [self.tableView reloadData];
        }
        else{
            [self.dataSoure removeAllObjects];
            [self.tableView reloadData];
        }
    }];
}

- (void) myAcceptReward {
       NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[PRUserModel shareUserModel].user_token forKey:@"token"];
    [parameters setObject:@(2) forKey:@"type_id"];
    [parameters setObject:@(0) forKey:@"page_index"];
    [parameters setObject:@(30) forKey:@"page_num"];
    [PRBaseRequest starRequest:SELECT_USER_TASK_URL parameters:parameters completionHandler:^(PRResponse *response) {
        if (response.success) {
            [self.dataSoure removeAllObjects];
            self.dataSoure = [PRUserTaksModel mj_objectArrayWithKeyValuesArray:response.resultVaule];
            [self.tableView reloadData];
        }else{
            [self.dataSoure removeAllObjects];
            [self.tableView reloadData];
        }
    }];
}

#pragma mark -- Getter
- (void) UISegmentedControl {
    // 定义分段控制器数组
    NSArray *array = [NSArray arrayWithObjects:@"发布悬赏",@"接受悬赏", nil];
    
    // 初始化分段控制器
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:array];
    
    // 定义分段控制器的大小位置
    segmentedControl.frame = CGRectMake(0, 0, 200 *AAdaptionWidth(), 30 *AAdaptionWidth());
    
    // 分段控制器的字体颜色
    segmentedControl.tintColor = [UIColor blackColor];
    
    // 分段控制器的背景颜色
    segmentedControl.backgroundColor = [UIColor whiteColor];
    
    // 分段控制器边框修饰
    [segmentedControl.layer setMasksToBounds:YES];
    segmentedControl.layer.borderWidth = 1;
    segmentedControl.layer.backgroundColor = [UIColor whiteColor].CGColor;
    [segmentedControl.layer setCornerRadius:15 * AAdaptionWidth()];
    
    // 将分段控制器的默认显示页面为：发布悬赏
    segmentedControl.selectedSegmentIndex = 0;
    
    // 关闭导航栏偏移 64px
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationItem.titleView = segmentedControl;
    
    // 分段控制器的点击事件
    [segmentedControl addTarget:self action:@selector(exChangeSegmentedControl:) forControlEvents:UIControlEventValueChanged];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, PRwidth, PRheight - 64)];
        _tableView.rowHeight = 55 * AAdaptionWidth();
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"PRFinishRewardTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        
    }
    return _tableView;
}

- (NSMutableArray *)dataSoure {
    if (!_dataSoure) {
        _dataSoure = [NSMutableArray array];
    }
    return _dataSoure;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
