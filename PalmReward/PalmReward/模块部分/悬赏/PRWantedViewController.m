//
//  PRWantedViewController.m
//  PalmReward
//
//  Created by rimi on 16/12/7.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import "PRWantedViewController.h"
#import "PictureViewController.h"
#import "PRLogInViewController.h"
#import "TZImagePickerController.h"

#import "PRButton.h"
#import "PRLineTextField.h"
#import "PRImageLabel.h"
#import "PRTextFieldAndImage.h"
#import "PRBaseRequest.h"
#import "UIImageView+WebCache.h"
#import "PRWantedCollectionViewCell.h"

@interface PRWantedViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,TZImagePickerControllerDelegate>{
    NSInteger num;
    CGFloat space;
}
@property (nonatomic, strong) UIImageView       * viewBackImageView;
@property (nonatomic, strong) PRLineTextField   * titleField;
@property (nonatomic, strong) UITextView        * wantedTextView;
@property (nonatomic, strong) UILabel           * successLabel;
@property (nonatomic, strong) UILabel           * failLable;
@property (nonatomic, strong) UIImageView       * userAvaterView;
@property (nonatomic, strong) PRImageLabel      * userLabel;
@property (nonatomic, strong) PRTextFieldAndImage * priceField;
@property (nonatomic ,strong) NSMutableArray    * datasouce;
@property (nonatomic, strong) NSMutableArray    * imageDataArray;
@property (nonatomic, strong) UIButton          *loginStatusButton;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic ,strong) UIButton          *cameraBtn;

//网络请求动画
@property (nonatomic, strong) DGActivityIndicatorView *requestAnimation;

@end

@implementation PRWantedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.viewBackImageView];
    [self setSomeThing];
}

-(void)setSomeThing{
    space = 40 *AAdaptionWidth();
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(onRightItem)];
    self.navigationController.navigationBar.tintColor=[UIColor blackColor];
    [self.view addSubview:self.titleField];
    [self.view addSubview:self.wantedTextView];
    [self.view addSubview:self.userLabel];
    [self.view addSubview:self.userAvaterView];
    [self.view addSubview:self.successLabel];
    [self.view addSubview:self.failLable];
    [self.view addSubview:self.priceField];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.cameraBtn];
    [self.view addSubview:self.loginStatusButton];
    [self.view addSubview:self.requestAnimation];


}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"]) {
        self.loginStatusButton.hidden = YES;
        self.userLabel.text = [PRUserModel shareUserModel].user_nickname;
        [self.userAvaterView setImageWithURLString:[NSString stringWithFormat:@"%@%@",BASE_URL ,[[PRUserModel shareUserModel].user_avatar  ReplaceSlash]] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    }else{
        self.loginStatusButton.hidden = NO;
        self.userLabel.text = @"未登录";
        self.userAvaterView.image = [UIImage imageNamed:@"默认头像"];
    }
}

#pragma mark -- 键盘回收
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.titleField resignFirstResponder];
    [self.wantedTextView resignFirstResponder];
    [self.priceField resignFirstResponder];
}

#pragma mark -- Action


-(void)onCameraBtn:(UIButton*)sender{
    if (num >2) {
        sender.userInteractionEnabled = NO;
        return;
    }
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    [self.navigationController presentViewController:imagePickerVc animated:YES completion:nil];
    
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        [self.datasouce addObjectsFromArray:photos];
        [self.collectionView reloadData];
        num++;
    }];
}

-(void)onLoginStatuBtn{
    [self presentViewController:[PRLogInViewController new]  animated:YES completion:nil];
}

-(void)onRightItem{
    
    if ((self.titleField.text.length>0)&&(self.wantedTextView.text.length>0)) {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setValue:[PRUserModel shareUserModel].user_token forKey:@"token"];
        [parameters setValue:self.titleField.text forKey:@"reward_title"];
        [parameters setValue:self.wantedTextView.text forKey:@"reward_content"];
        [parameters setValue:self.priceField.text forKey:@"reward_coin"];
        
        [self.requestAnimation startAnimating];
        [PRBaseRequest uploadRequests:RELEASE_TASK_URL imageDataArray:self.datasouce parameters:parameters completionHandler:^(PRResponse *response) {
            if (response.success) {
                self.titleField.text = @"";
                self.wantedTextView.text = @"";
                self.priceField.text = @"";
                [self.imageDataArray removeAllObjects];
                [self.datasouce removeAllObjects];
                num = 0;
                [self.collectionView reloadData];
                [self.requestAnimation stopAnimating];
                [self show:self.successLabel];
                PRLog(@"发布成功");
                
            }else{
                [self.requestAnimation stopAnimating];
                [self show:self.failLable];
                PRLog(@"%@",response.resultDesc);
            }
        }];
    }else{
        NSLog(@"不能为空");
    }
    
}


-(void)show:(UILabel *)label{
    [UIView animateWithDuration:1 animations:^{
        label.alpha = 1;
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:1 animations:^{
            label.alpha = 0;
        }];
    });
}


#pragma mark -- collectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.datasouce.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PRWantedCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backImageView.image = self.datasouce[indexPath.row];
    cell.isDel = ^(BOOL isdel){
        if (isdel) {
            [self.datasouce removeObjectAtIndex:indexPath.row];
            [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.collectionView reloadData];
            });
            num--;
            self.cameraBtn.userInteractionEnabled = YES;
        }
        
    };
    return cell;
}

#pragma mark -- getter

-(UIImageView *)viewBackImageView{
    if (!_viewBackImageView) {
        _viewBackImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 64, PRwidth, PRheight-108)];
        _viewBackImageView.image = [UIImage imageNamed:@"背景"];
    }
    return _viewBackImageView;
}

-(PRLineTextField *)titleField{
    if (!_titleField) {
        CGFloat titleWidth = 300*AAdaptionWidth();
        _titleField = [[PRLineTextField alloc] initWithFrame:CGRectMake((PRwidth-titleWidth)/2, 215*AAdaptionWidth(), titleWidth, 30*AAdaptionWidth()) LineViewColor:[UIColor lightGrayColor] LineViewHeight:1 LineFrame:Bottom LineOnViewController:self FieldPlaceholder:@"标题" FieldBackColor:[UIColor clearColor]];
        _titleField.textAlignment = NSTextAlignmentCenter;
        
    }
    return _titleField;
}


-(UITextView *)wantedTextView{
    if (!_wantedTextView) {
        CGFloat interval = 35 *AAdaptionWidth();
        CGFloat wantedTextViewHight = (300 - CGRectGetHeight(_titleField.frame))*AAdaptionWidth();
        _wantedTextView = [[UITextView alloc] initWithFrame:CGRectMake(interval, CGRectGetMaxY(_titleField.frame), PRwidth-2*interval, wantedTextViewHight)];
        _wantedTextView.backgroundColor = [UIColor clearColor];
        _wantedTextView.font = [UIFont systemFontOfSize:14];
    }
    return _wantedTextView;
}

-(PRTextFieldAndImage *)priceField{
    if (!_priceField) {
        _priceField = [[PRTextFieldAndImage alloc] initWithFrame:CGRectMake(110 * AAdaptionWidth(), CGRectGetMaxY(_wantedTextView.frame) + 90*AAdaptionWidth(), 200*AAdaptionWidth(), 30*AAdaptionWidth()) imageName:@"货币" imageFrame:Imageleft lineFrame:LineBottom Space:0 imageAndViewSpace:5 LineHightOrWidth:1 LineBack:[UIColor lightGrayColor] TextFieldBack:[UIColor clearColor] imageOnView:self.view imageWidth:60*AAdaptionWidth() imageHeight:30*AAdaptionWidth() SecureTextEntry:NO Placeholder:@"输入悬赏金额" PlaceholderColor:[UIColor lightGrayColor] PlaceholderFont:15*AAdaptionWidth()];
    }
    return _priceField;
}

- (UIButton *)loginStatusButton {
    if (!_loginStatusButton) {
        _loginStatusButton = [[UIButton alloc] initWithFrame:self.view.frame];
        _loginStatusButton.backgroundColor = [UIColor whiteColor];
        _loginStatusButton.titleLabel.font = AAFont(25);
        [_loginStatusButton setBackgroundColor:[UIColor clearColor]];
        [_loginStatusButton setTitle:@"请先登陆" forState:UIControlStateNormal];
        [_loginStatusButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_loginStatusButton addTarget:self action:@selector(onLoginStatuBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginStatusButton;
}

- (UIImageView *)userAvaterView {
    if (!_userAvaterView) {
        CGFloat imageWidth = 21*AAdaptionWidth();
        _userAvaterView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.userLabel.frame) - imageWidth - 5, CGRectGetMidY(self.userLabel.frame) - imageWidth / 2, imageWidth, imageWidth)];
        _userAvaterView.layer.cornerRadius = imageWidth / 2;
        _userAvaterView.layer.masksToBounds = YES;
    }
    return _userAvaterView;
}

- (NSMutableArray *)imageDataArray {
    if (!_imageDataArray) {
        _imageDataArray = [NSMutableArray array];
        
    }
    return _imageDataArray;
}

-(UILabel *)successLabel{
    if (!_successLabel) {
        CGFloat labelW = 90*AAdaptionWidth();
        _successLabel = [[UILabel alloc] initWithFrame:CGRectMake((PRwidth-labelW)/2, PRheight - labelW, labelW, 21*AAdaptionWidth())];
        _successLabel.text = @"发布成功";
        _successLabel.textAlignment = NSTextAlignmentCenter;
        _successLabel.textColor = [UIColor blackColor];
        _successLabel.backgroundColor = [UIColor clearColor];
        _successLabel.font = AAFont(17);
        _successLabel.alpha = 0;
        
    }
    return _successLabel;
}

-(UILabel *)failLable{
    if (!_failLable) {
        CGFloat labelW = 90*AAdaptionWidth();
        _failLable = [[UILabel alloc] initWithFrame:CGRectMake((PRwidth-labelW)/2, PRheight - labelW, labelW, 21*AAdaptionWidth())];
        _failLable.text = @"发布成功";
        _failLable.textAlignment = NSTextAlignmentCenter;
        _failLable.textColor = [UIColor blackColor];
        _failLable.backgroundColor = [UIColor clearColor];
        _failLable.font = AAFont(17);
        _failLable.alpha = 0;
        
    }
    return _failLable;
}

-(PRImageLabel *)userLabel{
    if (!_userLabel) {
        CGFloat labelH = 21*AAdaptionWidth();
        _userLabel = [[PRImageLabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.successLabel.frame), PRheight - 90*AAdaptionWidth(), 130*AAdaptionWidth(), labelH) ImageH:0 ImageW:0 ImageName:nil ImageFrame:ImgLeft ImageOnController:self ImageSpaceWithLabel:5 LabelText:@"SXZ" LabelColor:[UIColor clearColor] LabelFont:AAFont(14) LabelTextColor:[UIColor redColor]];
    }
    return _userLabel;
}

-(NSMutableArray *)datasouce{
    if (!_datasouce) {
        _datasouce = [NSMutableArray array];
    }
    return _datasouce;
}

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake((PRwidth - (space*2) - 8 *AAdaptionWidth())/4, (PRwidth - (space*2) - 8 *AAdaptionWidth())/4);
        layout.minimumLineSpacing = 5 *AAdaptionWidth();
        layout.minimumInteritemSpacing = 2*AAdaptionWidth();
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        //layout.headerReferenceSize = CGSizeMake(PRwidth, 40*AAdaptionWidth());
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(space, CGRectGetMaxY(self.wantedTextView.frame)+5*AAdaptionWidth(), PRwidth - ((space * 2) +((PRwidth - (space*2) - 8 *AAdaptionWidth())/4)), 75 * AAdaptionWidth()) collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerNib:[UINib nibWithNibName:@"PRWantedCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    }
    return  _collectionView;
}


-(UIButton *)cameraBtn{
    if (!_cameraBtn) {
        _cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cameraBtn.frame = CGRectMake(PRwidth - (((PRwidth - (space*2) - 8 *AAdaptionWidth())/4) + space), CGRectGetMaxY(self.wantedTextView.frame)+5*AAdaptionWidth(), (PRwidth - (space*2) - 8 *AAdaptionWidth())/4, (PRwidth - (space*2) - 8 *AAdaptionWidth())/4);
        [_cameraBtn setImage:[UIImage imageNamed:@"相机"] forState:UIControlStateNormal];
        [_cameraBtn addTarget:self action:@selector(onCameraBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cameraBtn;
}

- (DGActivityIndicatorView *)requestAnimation {
    if (!_requestAnimation) {
        _requestAnimation = [[DGActivityIndicatorView alloc]initWithType: DGActivityIndicatorAnimationTypeNineDots tintColor:[UIColor blackColor] size:60 * AAdaptionWidth()];
        _requestAnimation.center = self.view.center;
    }
    return _requestAnimation;
}


@end
