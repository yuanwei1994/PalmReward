//
//  PRHomeFristViewController.m
//  PalmReward
//
//  Created by rimi on 16/12/23.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import "PRHomeFristViewController.h"
#import "PRHomeAllCollectionViewCell.h"
#import "PRDetailViewController.h"

@interface PRHomeFristViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSInteger _pageIndex;
}
@property (nonatomic, strong) UICollectionView *collectinView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UIImageView * BackImageView;

@end

@implementation PRHomeFristViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setSomeThing];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self homeAllNotAcceptTaskRequest];
}

-(void)setSomeThing{
    _pageIndex = 0;
    self.collectinView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        _pageIndex ++;
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setValue:@(_pageIndex) forKey:@"page_index"];
        [parameters setValue:@(10) forKey:@"page_num"];
        [PRBaseRequest starRequest:SELECT_ALL_URL parameters:parameters completionHandler:^(PRResponse *response) {
            if (response.success) {
                //三方
                NSArray *ary = [PRTaskModel mj_objectArrayWithKeyValuesArray:(NSArray*)response.resultVaule];
                [self.dataSource addObjectsFromArray:ary];
                [self.collectinView reloadData];
                [self.collectinView.mj_footer endRefreshing];
                            }
            else{
                PRLog(@"失败");
                [self.dataSource removeAllObjects];
            }
        }];
        
    }];
    self.view.backgroundColor = [UIColor whiteColor];
    //背景颜色
    _BackImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"8"]];//皮肤三
    _BackImageView.frame = CGRectMake(0, 0, PRwidth, PRheight - 108);
    [self.view addSubview:_BackImageView];
    [self.view addSubview:self.collectinView];
}


- (void)homeAllNotAcceptTaskRequest{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@(_pageIndex) forKey:@"page_index"];
    [parameters setValue:@(10) forKey:@"page_num"];
    [PRBaseRequest starRequest:SELECT_ALL_URL parameters:parameters completionHandler:^(PRResponse *response) {
        if (response.success) {
            //三方
            [self.dataSource removeAllObjects];
            self.dataSource = [PRTaskModel mj_objectArrayWithKeyValuesArray:(NSArray*)response.resultVaule];
            [self.collectinView reloadData];
        }
        
        else{
            PRLog(@"失败");
        }
    }];
}

#pragma mark -- UICollectionViewCell dataSource
//返回每个段cell的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    //从重用队列中 获取cell
    PRHomeAllCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    //cell背景颜色就是皮肤
    cell.bacaImageView.image = [UIImage imageNamed:@"10"];
    PRTaskModel *task = self.dataSource[indexPath.row];
    cell.TaskModel = task;
    //设置边框
    //    cell.layer.borderColor=[UIColor blackColor].CGColor;
    //    cell.layer.borderWidth=1;
    return cell;
    
}
#pragma marl -- deleget
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    PRDetailViewController *detailVC = [[PRDetailViewController alloc] init];
    detailVC.taskModel = self.dataSource[indexPath.row];
    [self.navigationController pushViewController:detailVC animated:YES];
    NSLog(@"%ld,%ld",indexPath.row,indexPath.section);
}


- (UIEdgeInsets) collectionView:(UICollectionView *)collectionView
                         layout:(UICollectionViewLayout *)collectionViewLayout
         insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(-15.0f*AAdaptionWidth(), 20.0f*AAdaptionWidth(), 0.0f, 20.0f*AAdaptionWidth());
}
#pragma mark -- getter

-(UICollectionView *)collectinView{
    if(!_collectinView){
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake((PRwidth-60*AAdaptionWidth())/2, PRheight/3);
        NSLog(@"%F,%F",(PRwidth-60*AAdaptionWidth())/2,PRheight/3);
        layout.minimumLineSpacing = 15*AAdaptionWidth();
        layout.minimumInteritemSpacing = 15*AAdaptionWidth();
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.headerReferenceSize = CGSizeMake(PRwidth, 40*AAdaptionWidth());
        _collectinView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, PRwidth, PRheight-110) collectionViewLayout:layout];
        _collectinView.dataSource = self;
        _collectinView.delegate = self;
        _collectinView.backgroundColor = [UIColor clearColor];
        [_collectinView registerNib:[UINib nibWithNibName:@"PRHomeAllCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
        //        //注册附加视图--section头部尾部视图
        //        [_collectinView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headcell"];
    }
    return _collectinView;
}

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource=[NSMutableArray array];
    }
    return _dataSource;
}


@end
