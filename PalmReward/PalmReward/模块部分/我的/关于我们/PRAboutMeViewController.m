//
//  PRAboutMeViewController.m
//  PalmReward
//
//  Created by Candy on 16/12/17.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import "PRAboutMeViewController.h"
#import "PRAboutUsTableViewCell.h"
@interface PRAboutMeViewController () <UITableViewDelegate, UITableViewDataSource> {
    CGFloat _UIViewHeight;
    CGFloat _LogoWidth;
}

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *UIView;

@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) NSArray *nameArray;

@end

@implementation PRAboutMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setController];
}

- (void) setController {
    self.navigationItem.title = @"关 于 我 们";
    self.view.backgroundColor = COLOR_RGB(235, 235, 235, 1);
    
    _UIViewHeight = 260 *AAdaptionWidth();
    _LogoWidth = 100 *AAdaptionWidth();
    
    [self.view addSubview:self.UIView];
    
    [self.view addSubview:self.tableView];
}

#pragma mark -- TableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  self.dataSource.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PRAboutUsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.AppMessage.text = self.dataSource[indexPath.row][0];
    cell.Message.text = self.dataSource[indexPath.row][1];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark -- Getter
- (UIView *)UIView {
    if (!_UIView) {
        _UIView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, PRwidth, _UIViewHeight)];
        
        UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake((PRwidth - _LogoWidth) / 2, (self.UIView.frame.size.height - _LogoWidth) / 2, _LogoWidth, _LogoWidth)];
        logoImageView.image = [UIImage imageNamed:@"Logo"];
        [self.UIView addSubview:logoImageView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(logoImageView.frame), PRwidth , 35 * AAdaptionWidth())];
        titleLabel.text = @"掌悬 - 无处不在";
        titleLabel.font = AAFont(15);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.UIView addSubview:titleLabel];
        
        
    }
    return _UIView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;

        _tableView.tableHeaderView = self.UIView;
        
        [_tableView registerNib:[UINib nibWithNibName:@"PRAboutUsTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        _tableView.tableFooterView = [UIView new];
        
    }
    return _tableView;
}

- (NSArray *)dataSource {
    if (!_dataSource)
    {
        //获取App信息
        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
        NSMutableDictionary *infoDic = [NSMutableDictionary dictionaryWithContentsOfFile:bundlePath];
        NSString *version = [NSString stringWithFormat:@"Version %@",[infoDic objectForKey:@"CFBundleShortVersionString"]] ;
        _dataSource = @[@[@"应用名称：", @"掌悬"], @[@"应用版本：", version], @[@"系统支持：", @"iOS 9.3以上"], @[@"技术支持：", @"Yuan. Zhou. Wen"]];
    }
    return _dataSource;
}

@end
