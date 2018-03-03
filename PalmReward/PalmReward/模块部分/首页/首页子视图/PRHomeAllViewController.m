//
//  PRHomeAllViewController.m
//  PalmReward
//
//  Created by rimi on 16/12/7.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import "PRHomeAllViewController.h"
#import "PRHomeAllCollectionViewCell.h"
#import "PRDetailViewController.h"


@interface PRHomeAllViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectinView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UIImageView * BackImageView;
@end

@implementation PRHomeAllViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setSomeThing];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    NSLog(@"%ld",_index);
//    if (_index == 0) {
//        [self homeAllNotAcceptTaskRequest];
//        return;
//    }
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setValue:@(_index) forKey:@"type_id"];
    [self homeRequest:parameter];

    
}

#pragma mark -- 网络请求
//按条件查询所有悬赏任务
- (void)homeRequest:(NSDictionary *)parameters {
    
    [PRBaseRequest starRequest:SELECT_TASK_URL parameters:parameters completionHandler:^(PRResponse *response) {
        if (response.success) {
            //_task = [PRTaskModel shareTaskModel];
            //_al = [NSMutableArray array];
            //for (int i = 0; i<[(NSArray*)response.resultVaule count] ; i++) {
            //  [_task setValuesForKeysWithDictionary:response.resultVaule[i]];
            //   [_al addObject:_task];
            //}
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



-(void)setSomeThing{
    self.view.backgroundColor = [UIColor whiteColor];
    //背景颜色
    _BackImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"8"]];//皮肤三
    _BackImageView.frame = CGRectMake(0, 0, PRwidth, PRheight - 108);
    [self.view addSubview:_BackImageView];
    [self.view addSubview:self.collectinView];
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
    NSLog(@"%ld - %ld", indexPath.section, indexPath.row);
    PRDetailViewController *detailVC = [[PRDetailViewController alloc] init];
    detailVC.taskModel = self.dataSource[indexPath.row];
    [self.navigationController pushViewController:detailVC animated:YES];
    
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
        NSLog(@"%F,%F",(PRwidth - 60*AAdaptionWidth()) / 2,PRheight / 3);
        
        layout.minimumLineSpacing = 15 * AAdaptionWidth(); // 上下
        
        layout.minimumInteritemSpacing = 15 * AAdaptionWidth(); // 左右
        
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
