//
//  NetEasyViewController.m
//  UI高级第五天网易首页封装
//
//  Created by rimi on 16/9/24.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import "NetEasyViewController.h"

@interface NetEasyViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    CGFloat _width; //屏幕宽
    CGFloat _height; //屏幕高
    CGFloat _btnW; //按钮宽
    CGFloat _btnH; //按钮高
    NSArray * _titles; //导航文字
    NSArray * _viewrollers; //视图数组
    UIButton * _lastSelectedButton; //记录上一个选中的按钮
}

@property(nonatomic,strong) UIScrollView * titleScrollView;

@property(nonatomic,strong) UICollectionView * collectionView;
@end

@implementation NetEasyViewController


-(instancetype)initWithTitles:(NSArray *)titles viewControllers:(NSArray *)viewControllers{
    self = [super init];
    if (self) {
        _titles = titles;
        _viewrollers = viewControllers;
        _width=[UIScreen mainScreen].bounds.size.width;
        _height=[UIScreen mainScreen].bounds.size.height;
        _btnH=45;
        _btnW=_width*0.2;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.barHeight!=0) {
        _btnH = self.barHeight;
    }
    
    if (_viewrollers) {
        //添加子控制器
        [_viewrollers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self addChildViewController:obj];
        }];
    }
    
    self.view.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:self.titleScrollView];
    [self.view addSubview:self.collectionView];
}
#pragma mark -- action
-(void)onButton:(UIButton *)sender{
    //修改collectionView contentOffset
    [self.collectionView setContentOffset:CGPointMake((sender.tag-100)*_width, 0)  animated:YES];
    [self updateButtonWithIdex:sender.tag-100];
}

-(void)updateButtonWithIdex:(NSInteger)index{
    if (_lastSelectedButton) {
        //还原上一个BUtton
        //1.选中状态
        _lastSelectedButton.selected=NO;
        [UIView animateWithDuration:0.3 animations:^{
        _lastSelectedButton.transform = CGAffineTransformIdentity;
        }];
    }
    
    //获取当前Button
    UIButton *btn = [self.titleScrollView viewWithTag:index+100];
    [UIView animateWithDuration:0.3 animations:^{
        btn.selected = YES;
        btn.transform = CGAffineTransformMakeScale(1.3, 1.3);
    }completion:^(BOOL finished) {
        //判断前三个 偏移回到0，0
        if (index <=2) {
            [self.titleScrollView setContentOffset:CGPointZero animated:YES];
        }
        //如果是后三个 偏移变为倒数第五个bth的宽度
        if (index >= _titles.count-3) {
            [self.titleScrollView setContentOffset:CGPointMake((_titles.count-5)*_btnW, 0) animated:YES];
        }
        //如果是中间的
        if (index > 2 && index < _titles.count-3) {
            [self.titleScrollView setContentOffset:CGPointMake((index-2)*_btnW, 0) animated:YES];
        }
    }];
    //记录
    _lastSelectedButton = btn;
}
#pragma mark -- dataSouurce
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _titles.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.f green:arc4random()%255/255.f blue:arc4random()%255/255.f alpha:1];
    if (_viewrollers) {
        UIViewController * vc = _viewrollers[indexPath.item];
        [cell.contentView addSubview:vc.view];
    }
    return cell;
}
#pragma mark -- delegate
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//   
//}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == self.collectionView) {
        //改变title
        [self updateButtonWithIdex:scrollView.contentOffset.x/_width];
    }
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    if (scrollView == self.collectionView) {
        //改变title
        [self updateButtonWithIdex:scrollView.contentOffset.x/_width];
    }
}


#pragma mark -- getter
-(UIScrollView *)titleScrollView{
    if (!_titleScrollView) {
        _titleScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 20, _width, _btnH)];
        _titleScrollView.contentSize = CGSizeMake(_titles.count*_btnW, _btnH);
        _titleScrollView.backgroundColor=[UIColor whiteColor];
        //弹性效果关闭
        _titleScrollView.bounces = NO;
        //滑动条关闭
        _titleScrollView.showsHorizontalScrollIndicator = NO;
        //遍历导航文字数组
        [_titles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            //创建按钮
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(idx * _btnW, 0, _btnW, _btnH);
            [btn setTitle:obj forState:UIControlStateNormal];
            //设置不同颜色
            [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
            [btn setBackgroundColor:[UIColor colorWithRed:251/255.0 green:178/255.0 blue:23/255.0 alpha:1]];
            btn.tag= 100+idx;
            [btn addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
            //UIControlEventTouchDragInside 拖才会触发
            [_titleScrollView addSubview:btn];
            if (idx==0) {
                [self updateButtonWithIdex:btn.tag-100];
            }
        }];
    }
    return _titleScrollView;
}

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat maxY = CGRectGetMaxY(self.titleScrollView.frame);
        layout.itemSize = CGSizeMake(_width, _height-maxY);
        //行距，间距
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        //滚动方向
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, maxY, _width, _height-maxY) collectionViewLayout:layout];
        
        _collectionView.dataSource=self;
        _collectionView.delegate=self;
        _collectionView.backgroundColor=[UIColor whiteColor];
        //分页
        _collectionView.pagingEnabled = YES;
        //关闭弹性效果
        _collectionView.bounces = NO;
        //注册cell
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    }
    return _collectionView;
}

@end
