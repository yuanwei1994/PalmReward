//
//  PRMineViewController.m
//  PalmReward
//
//  Created by rimi on 16/12/7.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import "PRMineViewController.h"
#import "PRLogInViewController.h"
#import "PRMoneyViewController.h"
#import "PRPersonalSettingViewController.h"
#import "PRSystemSettingViewController.h"

#import "PRButton.h"
#import "PRMineTableViewCell.h"
#import "PRDrawerView.h"
#import "PRMenuView.h"
//#import <SDWebImage/UIButton+WebCache.h>
#import "UIButton+WebCache.h"

#import "PRMyRewardViewController.h"
#import "PRFinishRewardViewController.h"
#import "PRFeedbackViewController.h"
#import "PRAboutMeViewController.h"
#import "PRAlertController.h"

#define CELL_IDENTIFIER     @"MineTableViewCell"

@interface PRMineViewController ()<UITableViewDelegate, UITableViewDataSource, PushViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    CGFloat _headViewHeight;
}

@property (nonatomic, strong) UIButton      *LogInButton;
@property (nonatomic, strong) UITableView   *tableView;

@property (nonatomic, strong) NSArray       *dataSource;        //数据源
@property (nonatomic, strong) UIView        *tableHeadView;     //tableView的头部视图
@property (nonatomic, strong) UIButton      *avatarButton;      //头像按钮
@property (nonatomic, strong) UILabel       *usernameLabel;     //用户名
@property (nonatomic, strong) UIView        *userInfoView;      //用户信息(悬赏等级/解决率)
@property (nonatomic, strong) UIImageView   *levelImageView;    //用户等级图标
@property (nonatomic, strong) UILabel       *rateLabel;         //解决率(百分比)
@property (nonatomic, strong) UIButton      *loginButton;       //登录按钮

@property (nonatomic, strong) CAGradientLayer *shadowAsInverse; //渐变的颜色组合
@property (nonatomic, strong) PRUserModel   *userModel;

@property (nonatomic, strong) PRDrawerView  *drawerView;

@property (nonatomic , strong) UILabel * sayLogin;

@end

@implementation PRMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setSomeThing];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    [[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"] ? [self.loginButton setHidden:YES] : [self.loginButton setHidden:NO];
    _userModel = [PRUserModel shareUserModel];
    _levelImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@星级",[PRUserModel shareUserModel].user_level_id]];
    _rateLabel.text = [NSString stringWithFormat:@"%@%%",[PRUserModel shareUserModel].user_resolution_rate];
    //刷新头像
    [self refreshAvatarImage];
    
    
}

//通知事件
- (void)onNotification:(NSNotification *)notification {
    self.loginButton.hidden = NO;
    //收到通知后 进行退出登录 ,再把抽屉隐藏(移除)
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLogin"];
    //刷新头像
    [self.avatarButton setImage:[UIImage imageNamed:@"默认头像"] forState:UIControlStateNormal];
    [self.drawerView hidenWithAnimation];
}

- (void)setSomeThing {
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNotification:) name:@"logout" object:nil];
    
    _headViewHeight = 260 * AAdaptionWidth();
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.tableView addSubview:self.sayLogin];
    [self.view addSubview:self.tableView];
    
#pragma mark -- 导航栏两个按钮
    CGFloat btnWidth = 30.0 * AAdaptionWidth() ;
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, btnWidth, btnWidth);
    [leftButton setImage:[UIImage imageNamed:@"钱包"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(onLeftItemButton) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, btnWidth, btnWidth);
    [rightButton setImage:[UIImage imageNamed:@"设置"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(onRightItemButton) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];

    
    
}


#pragma mark -- Action
-(void)show{
    
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.sayLogin.alpha = 1;
    } completion:nil];
  
}

-(void)hiden{
    
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.sayLogin.alpha = 0;
    } completion:nil];
    
}

#pragma mark -- Button Action
//

- (void) onAlertController {
    PRAlertController *alertController = [PRAlertController alertControllerWithTitle:@"温馨提示" message:@"该功能还未实现" preferredStyle:UIAlertControllerStyleAlert hanler:^(PRAlertController *alertController, NSInteger buttonIndex) {
    } cancleButtonTitle:@"确定" ohterButtonTitle:nil];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)onLoginButton {
    self.tabBarController.tabBar.hidden = YES;
    [self presentViewController:[PRLogInViewController new]  animated:YES completion:nil];
}

- (void)onLeftItemButton {
    if ([self isLogin]) {
        
        [self onAlertController];
        
        //[self.navigationController pushViewController:[PRMoneyViewController new] animated:YES];
        
    }
}

- (void)onRightItemButton {
    if ([self isLogin]) {
        //[self.navigationController pushViewController:[PRSettingViewController new] animated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"setUserInfo" object:nil];
        [self.drawerView show];
    }
}

- (void)onAvatarButton {
    if ([self isLogin]) {
        //如果用户已登录 就进行更换头像操作
        self.avatarButton.userInteractionEnabled = YES;
        [self onAddImageButton];
    }
}

//判断是否已登录
- (BOOL)isLogin {
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"]) {
        NSLog(@"请先登录");
        [self presentViewController:[PRLogInViewController new]  animated:YES completion:nil];
        return NO;
    }
    return YES;
}

#pragma mark -- 刷新头像
-(void)refreshAvatarImage{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"]) {
        //反斜线替换
        NSString *avatarString;
        if (![_userModel.user_avatar isEqual:[NSNull null]]) {
            avatarString = [_userModel.user_avatar ReplaceSlash];
        }
        [self.avatarButton setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BASE_URL, avatarString]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"默认头像"]];
        
        self.usernameLabel.text = _userModel.user_nickname;
    }
    
}

#pragma mark -- 相机相册获取图片 - //上传头像 ---------start---------------------
- (void)onAddImageButton{
    NSLog(@"选择图片");
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"修改头像 - 温馨提示" message:@"图片选取方式" preferredStyle:UIAlertControllerStyleActionSheet];
    //管理系统相机相册的控制器 UIImagePickerController
    __block UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    //设置代理
    picker.delegate = self;
    //运行编辑
    picker.allowsEditing = YES;
    
    //添加行为
    [alert addAction:[UIAlertAction actionWithTitle:@"相机拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //推出相机
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            //打开摄像头
            //修改数据源类型
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:picker animated:YES completion:nil];
        } else {
            NSLog(@"模拟器暂时不支持相机");
        }
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"相册选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //推出相册
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:nil];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        picker = nil;
    }]];
    //退出alert 模态推送
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark -- UIImagePikerCotrollerDelegate
//图片选择完成
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //NSLog(@"完成图片选择 - info = %@",info);
    if ([info [UIImagePickerControllerMediaType] isEqualToString:@"public.image"]) {
        NSLog(@"%@", info);
        UIImage *headImage = info[UIImagePickerControllerEditedImage];
        [self.avatarButton setImage:info[UIImagePickerControllerEditedImage] forState:UIControlStateNormal];
        //保存并上传图片
        [self saveImage:headImage];
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//取消
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 1.保存图片并上传
- (void)saveImage:(UIImage *)image {
    self.avatarButton.userInteractionEnabled = NO;
    
    //缩略图片处理
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    //    NSLog(@"documentsDirectory ->>%@",documentsDirectory);
    NSString *imageFilePath = [documentsDirectory stringByAppendingPathComponent:@"avatar.jpg"];
    
    success = [fileManager fileExistsAtPath:imageFilePath];
    if(success) {
        success = [fileManager removeItemAtPath:imageFilePath error:&error];
    }
    UIImage *smallImage = [self thumbnailWithImageWithoutScale:image size:CGSizeMake(200, 200)];
    [UIImageJPEGRepresentation(smallImage, 1.0f) writeToFile:imageFilePath atomically:YES];//写入文件
    UIImage *avatarImage = [UIImage imageWithContentsOfFile:imageFilePath];//读取图片文件
    
    NSData *imageData = UIImagePNGRepresentation(avatarImage);
    
    
#pragma mark -- 上传头像网络请求
    [PRBaseRequest uploadRequest:UPLOAD_AVATAR_URL imageData:imageData parameters:@{@"user_id":_userModel.user_id} completionHandler:^(PRResponse *response) {
        if (response.success) {
            NSLog(@"上传成功!");
            self.avatarButton.userInteractionEnabled = YES;
            _userModel.user_avatar = response.resultVaule;
            //刷新头像
            [self refreshAvatarImage];
            
        } else {
            NSLog(@"上传失败 - %@",response.resultDesc);
            self.avatarButton.userInteractionEnabled = YES;
        }
    }];
}

#pragma mark -- 2.保持原来的长宽比，生成一个缩略图
- (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize
{
    UIImage *newimage;
    if (nil == image) {
        newimage = nil;
    }
    else{
        CGSize oldsize = image.size;
        CGRect rect;
        if (asize.width/asize.height > oldsize.width/oldsize.height) {
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            rect.size.height = asize.height;
            rect.origin.x = (asize.width - rect.size.width)/2;
            rect.origin.y = 0;
        }
        else{
            rect.size.width = asize.width;
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            rect.origin.x = 0;
            rect.origin.y = (asize.height - rect.size.height)/2;
        }
        UIGraphicsBeginImageContext(asize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
        [image drawInRect:rect];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
}

#pragma mark -- 相机相册获取图片 - //上传头像 ---------end---------------------



#pragma mark -- tableView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PRMineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
   
    cell.nameString = self.dataSource[indexPath.row];
    
    return cell;
}

#pragma mark -- tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"]) {
        // 等0 是我的悬赏
        if (indexPath.row == 0) {
            [self.navigationController pushViewController:[[PRMyRewardViewController alloc] init] animated:YES];
        }
        
        if (indexPath.row == 1) {
            [self.navigationController pushViewController:[[PRFinishRewardViewController alloc] init] animated:YES];
        }
        
        if (indexPath.row == 2) {
            [self.navigationController pushViewController:[[PRFeedbackViewController alloc] init] animated:YES];
        }
        
        if (indexPath.row == 3) {
            [self.navigationController pushViewController:[PRAboutMeViewController new] animated:YES];
            
        }
        
        NSLog(@"select - %@",indexPath);
    }
    else{
        [self show];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self hiden];
        });
    }
}


#pragma mark -- PushViewDelegate
- (void)pushViewController:(NSInteger)index{
    [self.drawerView hidenWithAnimation];
    //点击进入详细设置页面
    if (index == 0) {
        [self.navigationController pushViewController:[PRPersonalSettingViewController new] animated:YES];
    }
    
    if (index == 1) {
        [self onAlertController];
//        [self.navigationController pushViewController:[PRSystemSettingViewController new] animated:YES];
    }
    
    if (index == 2) {
        [self onClearButton];
    }
    
}

#pragma mark -- 清除缓存
//清除缓存
- (void)onClearButton {
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString * cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSArray *filenames = [manager contentsOfDirectoryAtPath:cachePath error:nil];
    for (NSString * fileName in filenames) {
        NSString * filePath = [cachePath stringByAppendingPathComponent:fileName];
        
        //查看沙盒文件信息
        //        NSDictionary *dic =  [manager attributesOfItemAtPath:filePath error:nil];
        //        NSLog(@"fileAttri = %@", dic);
        //移除缓存
        [manager removeItemAtPath:filePath error:nil];
        PRLog(@"清除缓存成功");
        [self onAlertSuccess];
    }
    
    //只清除缓存图片
    //    [[SDImageCache sharedImageCache] clearDisk];
    
}

- (void)onAlertSuccess {
    PRAlertController *alertController = [PRAlertController alertControllerWithTitle:@"温馨提示" message:@"清除缓存成功" preferredStyle:UIAlertControllerStyleAlert hanler:^(PRAlertController *alertController, NSInteger buttonIndex) {
    } cancleButtonTitle:@"确定" ohterButtonTitle:nil];
    [self presentViewController:alertController animated:YES completion:nil];

}


#pragma mark -- getter


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, PRwidth, PRheight - 64 - 44) style:UITableViewStylePlain];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 50 * AAdaptionWidth();
        _tableView.tableHeaderView = self.tableHeadView;
        _tableView.tableFooterView = [UIView new];

        [_tableView registerNib:[UINib nibWithNibName:@"PRMineTableViewCell" bundle:nil] forCellReuseIdentifier:CELL_IDENTIFIER];
        
        
    }
    return _tableView;
}

- (UIView *)tableHeadView {
    if (!_tableHeadView) {
        _tableHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PRwidth, _headViewHeight)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, PRwidth, _headViewHeight)];
        imageView.image = [UIImage imageNamed:@"mine_background"];
        //[_tableHeadView addSubview:imageView];
        [_tableHeadView addSubview:self.avatarButton];
        [_tableHeadView addSubview:self.userInfoView];
        [_tableHeadView addSubview:self.usernameLabel];
        [_tableHeadView addSubview:self.loginButton];
        [_tableHeadView.layer addSublayer:self.shadowAsInverse];
        
    }
    return _tableHeadView;
}

- (UIButton *)avatarButton {
    if (!_avatarButton) {
        CGFloat btnWidth = 100.0 * AAdaptionWidth();
        CGFloat spaceX = ( PRwidth - btnWidth ) / 2;
        CGFloat spaceY = ( _headViewHeight - btnWidth ) / 2 - 30 * AAdaptionWidth();
        
        _avatarButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _avatarButton.frame = CGRectMake(spaceX, spaceY, btnWidth, btnWidth);
        [_avatarButton setImage:[UIImage imageNamed:@"默认头像"] forState:UIControlStateNormal];
        _avatarButton.layer.cornerRadius = btnWidth / 2;
        _avatarButton.layer.masksToBounds = YES;
        
        [_avatarButton addTarget:self action:@selector(onAvatarButton) forControlEvents:UIControlEventTouchUpInside];

    }
    return _avatarButton;
}


- (UIView *)userInfoView {
    if (!_userInfoView) {
        //avatarButton 最大Y值 + 5
        CGFloat maxY = CGRectGetMaxY(self.avatarButton.frame) + 5.0 * AAdaptionWidth();
        //userInfoView 的高度
        CGFloat height = 60.0 * AAdaptionWidth();
        _userInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, maxY, PRwidth, height)];
        CGFloat lineSpace = 10.0 * AAdaptionWidth();
        CGFloat labelWidth = 90.0 * AAdaptionWidth();
        CGFloat leftLabelSpace = PRwidth / 2 - labelWidth;
        CGFloat rightLabelSpace = PRwidth / 2 + 10.0 * AAdaptionWidth();
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(PRwidth / 2 - 1, lineSpace, 2, height - lineSpace) ];
        lineView.backgroundColor = [UIColor lightGrayColor];
        //等级标签
        UILabel *levelLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(leftLabelSpace, lineSpace, labelWidth, height / 2 - lineSpace)];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = @"悬赏等级";
            [label setFont:AAFont(16)];
            label;
        });
        
        // 等级图标
        _levelImageView = [[UIImageView alloc] initWithFrame:CGRectMake(leftLabelSpace, CGRectGetMaxY(levelLabel.frame), labelWidth, 30 * AAdaptionWidth())];
        
        //解决率
        UILabel *rateLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(rightLabelSpace, lineSpace, labelWidth, height / 2 - lineSpace)];
            label.textAlignment = NSTextAlignmentLeft;
            label.text = @"解决率";
            [label setFont:AAFont(16)];
            label;
        });

        //用户解决率(百分比)
        _rateLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(rightLabelSpace, CGRectGetMaxY(rateLabel.frame), labelWidth, 30 * AAdaptionWidth())];
            label.textAlignment = NSTextAlignmentLeft;
            label.text = @"100";
            label.textColor = COLOR_RGB(204, 47, 44, 1);
            [label setFont:AAFont(14)];
            label;
        });
        
        
        [_userInfoView addSubview:lineView];
        [_userInfoView addSubview:levelLabel];
        [_userInfoView addSubview:rateLabel];
        [_userInfoView addSubview:_levelImageView];
        [_userInfoView addSubview:_rateLabel];
        
    }
    return _userInfoView;
}


- (UILabel *)usernameLabel {
    if (!_usernameLabel) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.userInfoView.frame) + 5 * AAdaptionWidth(), PRwidth, 30 * AAdaptionWidth())];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"用 户 名";
        [label setFont:AAFont(20)];
        
        _usernameLabel = label;
    }
    return _usernameLabel;
}

- (UIButton *)loginButton {
    if (!_loginButton) {
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat maxY = CGRectGetMaxY(self.avatarButton.frame);
        
        _loginButton.frame = CGRectMake(0, maxY , PRwidth, CGRectGetHeight(self.tableHeadView.frame) - maxY);
        [_loginButton setTitle:@"请 登 录" forState:UIControlStateNormal];
        _loginButton.backgroundColor = [UIColor whiteColor];
        [_loginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_loginButton addTarget:self action:@selector(onLoginButton) forControlEvents:UIControlEventTouchUpInside];

    }
    return _loginButton;
}

#pragma mark -- 渐变的颜色组合
- (CAGradientLayer *)shadowAsInverse
{
    CAGradientLayer *newShadow = [[CAGradientLayer alloc] init];
    CGRect newShadowFrame = CGRectMake(0, 0, PRwidth,PRheight);
    newShadow.frame = newShadowFrame;
    //添加渐变的颜色组合（颜色透明度的改变）
    newShadow.colors = [NSArray arrayWithObjects:
                        (id)[[COLOR_RGB(255, 255, 255, 0.5) colorWithAlphaComponent:0] CGColor] ,
                        
                        (id)[[COLOR_RGB(255, 255, 255, 0.5) colorWithAlphaComponent:0.1] CGColor],
                        
                        (id)[[COLOR_RGB(255, 255, 255, 0.5) colorWithAlphaComponent:0.2] CGColor],
                        
                        (id)[[COLOR_RGB(255, 255, 255, 0.5) colorWithAlphaComponent:0.3] CGColor],
                        
                        (id)[[COLOR_RGB(255, 255, 255, 0.5) colorWithAlphaComponent:0.4] CGColor],
                        
                        (id)[[COLOR_RGB(255, 255, 255, 0.5) colorWithAlphaComponent:0.5] CGColor],
                        nil];
    return newShadow;
}

- (NSArray *)dataSource {
    if (!_dataSource)
    {
        _dataSource = @[@"我 的 悬 赏", @"完 成 悬 赏", @"反 馈 建 议", @"关 于 我 们"];
    }
    return _dataSource;
}

- (PRDrawerView *)drawerView {
    if (!_drawerView) {
        //设置显示出来的宽度
        PRMenuView *menuView = [[PRMenuView alloc]initWithFrame:CGRectMake(0, 0, PRwidth * 0.7 , PRheight)];
        //设置它的代理
        menuView.pushViewDelegate = self;
        
        //创建一个菜单
        _drawerView = [PRDrawerView MenuViewWithDependencyView:self.view MenuView:menuView isShowCoverView:NO];
    }
    return _drawerView;
}

-(UILabel *)sayLogin{
    if (!_sayLogin) {
        _sayLogin = [[UILabel alloc] init];
        _sayLogin.bounds = CGRectMake(0, 0, 120 *AAdaptionWidth(), 30 *AAdaptionWidth());
        _sayLogin.center = self.view.center;
        _sayLogin.textAlignment = NSTextAlignmentCenter;
        _sayLogin.text = @"请 登 录";
        _sayLogin.font = AAFont(17);
        _sayLogin.backgroundColor = [UIColor whiteColor];
        _sayLogin.alpha = 0;
    }
    return  _sayLogin;
}

@end
