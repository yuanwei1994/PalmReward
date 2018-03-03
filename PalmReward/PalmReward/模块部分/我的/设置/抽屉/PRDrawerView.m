//
//  PRDrawerView.m
//  PalmReward
//
//  Created by Candy on 16/12/17.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import "PRDrawerView.h"

// 宏定义获得屏幕尺寸，以及设置颜色
#define COVERVIEW_ALPHA         0.7


@interface PRDrawerView ()
@property (nonatomic ,assign)CGRect  menuViewframe;
@property (nonatomic ,assign)CGRect  coverViewframe;
@property (nonatomic ,strong)UIView  *coverView;
@property (nonatomic ,strong)UIView  *leftMenuView;
@property (nonatomic ,assign)BOOL    isShowCoverView;;
@end

@implementation PRDrawerView

+(instancetype)MenuViewWithDependencyView:(UIView *)dependencyView MenuView:(UIView *)leftmenuView isShowCoverView:(BOOL)isCover{
    PRDrawerView  *drawerView = [[PRDrawerView alloc]initWithDependencyView:dependencyView MenuView:leftmenuView isShowCoverView:isCover];
    
    return drawerView;
}


-(instancetype)initWithDependencyView:(UIView *)dependencyView MenuView:(UIView *)leftmenuView isShowCoverView:(BOOL)isCover{
    
    if(self = [super init]){
        self.isShowCoverView = isCover;
        [self addPanGestureAtDependencyView:dependencyView];
        self.leftMenuView = leftmenuView;
        self.menuViewframe = leftmenuView.frame;
        self.coverViewframe = CGRectMake(self.menuViewframe.size.width, self.menuViewframe.origin.y, PRwidth - self.menuViewframe.size.width, self.menuViewframe.size.height);
    }
    return self;
}

-(void)setIsShowCoverView:(BOOL)isShowCoverView
{
    _isShowCoverView = isShowCoverView;
    if(self.isShowCoverView){
        self.coverView.backgroundColor = COVERVIEW_BACKGROUND;
    }else{
        self.coverView.backgroundColor = [UIColor clearColor];
    }
    
}

-(void)addPanGestureAtDependencyView:(UIView *)dependencyView{
    //屏幕边缘pan手势(优先级高于其他手势)
    UIScreenEdgePanGestureRecognizer *leftEdgeGesture = \
    [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleLeftEdgeGesture:)];
    //屏幕左侧边缘响应
    leftEdgeGesture.edges= UIRectEdgeLeft;
    [dependencyView addGestureRecognizer:leftEdgeGesture];
}

-(void)show{
    UIWindow * window = [[UIApplication sharedApplication].delegate window];
    [window addSubview:self.coverView];
    [window addSubview:self.leftMenuView];
    self.leftMenuView.frame = CGRectMake(-self.menuViewframe.size.width, self.menuViewframe.origin.y, self.menuViewframe.size.width, self.menuViewframe.size.height);
    self.coverView.frame = CGRectMake(0, 0, PRwidth, self.menuViewframe.size.height);
    [UIView animateWithDuration:0.3 animations:^{
        self.leftMenuView.frame = self.menuViewframe;
        self.coverView.frame    = self.coverViewframe;
        self.coverView.alpha = COVERVIEW_ALPHA;
    }];
}



-(void)hidenWithoutAnimation{
    [self removeCoverAndMenuView];
}

-(void)hidenWithAnimation{
    [self coverTap];
}


#pragma mark - 屏幕左侧菜单
-(UIView *)leftMenuView{
    
    if(_leftMenuView == nil){
        UIView *LeftView = [[UIView alloc]initWithFrame:self.menuViewframe];
        _leftMenuView    = LeftView;
        
    }
    return _leftMenuView;
}

#pragma mark - 遮盖
-(UIView *)coverView {
    if (_coverView == nil) {
        UIView *Cover = [[UIView alloc]initWithFrame:self.coverViewframe];
        Cover.backgroundColor                     = COVERVIEW_BACKGROUND;
        Cover.alpha                               = 0;
        UITapGestureRecognizer *Click             = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(coverTap)];
        [Cover addGestureRecognizer:Click];
        UIGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handleftPan:)];
        [Cover addGestureRecognizer:panGestureRecognizer];
        [Click requireGestureRecognizerToFail:panGestureRecognizer];
        _coverView = Cover;
    }
    return _coverView;
}


#pragma mark - 屏幕往右滑处理
- (void)handleLeftEdgeGesture:(UIScreenEdgePanGestureRecognizer *)gesture{
    
    UIWindow * window = [[UIApplication sharedApplication].delegate window];
    [window addSubview:self.coverView];
    [window addSubview:self.leftMenuView];
    
    // 根据被触摸手势的view计算得出坐标值
    CGPoint translation = [gesture translationInView:gesture.view];
    
    if(UIGestureRecognizerStateBegan == gesture.state ||
       UIGestureRecognizerStateChanged == gesture.state){
        
        if(translation.x <= self.menuViewframe.size.width){// && self.leftMenuView.frame.origin.x != 0
            
            if(translation.x <= 10){
                self.coverView.frame = CGRectMake(0, self.menuViewframe.origin.y, PRwidth, self.menuViewframe.size.height);
            }
            
            CGFloat x = translation.x  - self.menuViewframe.size.width;
            CGFloat y = self.menuViewframe.origin.y;
            CGFloat w = self.menuViewframe.size.width;
            CGFloat h = self.menuViewframe.size.height;
            self.leftMenuView.frame = CGRectMake(x, y, w, h);
            
            self.coverView.frame    = CGRectMake(self.leftMenuView.frame.size.width+x, 0,PRwidth - self.leftMenuView.frame.size.width-x, h);
            self.coverView.alpha    = COVERVIEW_ALPHA * (translation.x / w);
        }else{
            
            self.leftMenuView.frame = self.menuViewframe;
            self.coverView.frame = self.coverViewframe;
        }
    }
    else{
        //结束
        if(translation.x > self.menuViewframe.size.width/2){
            // 展开设置
            [self openMenuView];
        }else{
            // 恢复设置
            [self closeMenuView];
        }
        
    }
}


#pragma mark - coverView往左滑隐藏
-(void)handleftPan:(UIPanGestureRecognizer*)recognizer{
    
    CGPoint translation = [recognizer translationInView:recognizer.view];
    static CGFloat BeganX;
    
    if(UIGestureRecognizerStateBegan == recognizer.state){
        BeganX = translation.x;
    }
    
    CGFloat Place = (-translation.x) - (-BeganX);
    
    if(UIGestureRecognizerStateBegan == recognizer.state ||
       UIGestureRecognizerStateChanged == recognizer.state){
        
        CGFloat x = 0 ;
        CGFloat y = self.menuViewframe.origin.y;
        CGFloat w = self.menuViewframe.size.width;
        CGFloat h = self.menuViewframe.size.height;
        
        if(Place <= self.leftMenuView.frame.size.width &&  Place >0){
            
            x  = 0 - Place;
            
            //            self.leftMenuView.frame = CGRectMake(x, y, w, h);
            
            self.coverView.frame    = CGRectMake(self.leftMenuView.frame.size.width-Place, 0,PRwidth - self.leftMenuView.frame.size.width+Place, h);
            self.coverView.alpha    = COVERVIEW_ALPHA * ((w - Place) / w);
            
        }else if(Place >0){
            x  = - self.menuViewframe.size.width;
            self.coverView.frame    = CGRectMake(0, 0, PRwidth ,h);
            
        }else{
            x = 0;
            self.coverView.frame    = CGRectMake(self.leftMenuView.frame.size.width, 0,PRwidth -self.leftMenuView.frame.size.width, h);
            self.coverView.alpha    = COVERVIEW_ALPHA;
        }
        self.leftMenuView.frame = CGRectMake(x, y, w, h);
    }else{
        //结束
        if(Place > self.menuViewframe.size.width/2){
            // 收起设置
            [self closeMenuView];
            
        }else{
            // 展开设置
            [self openMenuView];
        }
    }
    
}

-(void)openMenuView{
    [UIView animateWithDuration:0.3 animations:^{
        CGFloat x = 0;
        CGFloat y = self.menuViewframe.origin.y;
        CGFloat w = self.menuViewframe.size.width;
        CGFloat h = self.menuViewframe.size.height;
        self.leftMenuView.frame = CGRectMake(x, y, w, h);
        
        self.coverView.frame = self.coverViewframe;
        self.coverView.alpha = COVERVIEW_ALPHA;
    }];
}

-(void)closeMenuView{
    
    [UIView animateWithDuration:0.3 animations:^{
        
        CGFloat x = -self.menuViewframe.size.width;
        CGFloat y = self.menuViewframe.origin.y;
        CGFloat w = self.menuViewframe.size.width;
        CGFloat h = self.menuViewframe.size.height;
        self.leftMenuView.frame = CGRectMake(x, y, w, h);//self.LeftViewFrame;
        self.coverView.frame    = CGRectMake(0, 0,PRwidth, self.menuViewframe.size.height);
        
    } completion:^(BOOL finished) {
        [self removeCoverAndMenuView];
    }];
}



#pragma mark - 点击遮盖移除
-(void)coverTap{
    
    [UIView animateKeyframesWithDuration:0.3 delay:0 options:UIViewKeyframeAnimationOptionLayoutSubviews animations:^{
        self.leftMenuView.frame = CGRectMake(-self.menuViewframe.size.width, 0, self.menuViewframe.size.width, self.menuViewframe.size.height);
        self.coverView.frame = CGRectMake(0, 0,PRwidth, PRheight);
        self.coverView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.coverView removeFromSuperview];
        [self.leftMenuView removeFromSuperview];
    }];
    
}

#pragma mark - 移除菜单和遮盖
-(void)removeCoverAndMenuView{
    
    self.leftMenuView.frame = CGRectMake(-self.leftMenuView.frame.size.width, 0, self.leftMenuView.frame.size.width, PRheight);
    self.coverView.frame = CGRectMake(0, 0,PRwidth, PRheight);
    self.coverView.alpha = 0.0;
    
    [self.coverView removeFromSuperview];
    [self.leftMenuView removeFromSuperview];
}


@end
