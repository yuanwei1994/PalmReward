//
//  ViewController.m
//  类似QQ图片添加、图片浏览
//
//  Created by seven on 16/3/30.
//  Copyright © 2016年 QQpicture. All rights reserved.
//

#import "PictureViewController.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "PictureCollectionViewCell.h"
#import "PictureAddCell.h"
#import "ELCImagePickerController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <AssetsLibrary/ALAsset.h>


@interface PictureViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,MJPhotoBrowserDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UICollectionViewDelegateFlowLayout> {
    
    CGFloat _minY;  //选择后图片最小Y值
    CGFloat _space; //x间距
    CGFloat _width;
}



@property(nonatomic,strong)NSMutableArray *itemsSectionPictureArray;

@end

@implementation PictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _minY = CGRectGetMinY(self.cellFrame);
    _space = CGRectGetMinX(self.cellFrame);
    _width = CGRectGetWidth(self.cellFrame);
    
//    self.automaticallyAdjustsScrollViewInsets = NO;
    //self.navigationController.navigationBar.hidden = YES;
    
    
    self.itemsSectionPictureArray = [NSMutableArray array];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = AAdaptionSize(75,75);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 5; //上下的间距 可以设置0看下效果
    layout.sectionInset = UIEdgeInsetsMake(0.f, 5, 5.f, 5);
    
    //创建 UICollectionView
    self.pictureCollectonView = [[UICollectionView alloc] initWithFrame:self.cellFrame collectionViewLayout:layout];
    
    [self.pictureCollectonView registerClass:[PictureCollectionViewCell class]forCellWithReuseIdentifier:@"cell"];
    
    [self.pictureCollectonView registerClass:[PictureAddCell class] forCellWithReuseIdentifier:@"addItemCell"];
    
    self.pictureCollectonView.backgroundColor = [UIColor clearColor];//75背景测试
    
    self.pictureCollectonView.delegate = self;
    self.pictureCollectonView.dataSource = self;
    self.pictureCollectonView.scrollEnabled = NO;

    
    [self.view addSubview:self.pictureCollectonView];
    
}


#pragma mark - collectionView 调用方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.itemsSectionPictureArray.count +1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.itemsSectionPictureArray.count) {
        static NSString *addItem = @"addItemCell";
        
        UICollectionViewCell *addItemCell = [collectionView dequeueReusableCellWithReuseIdentifier:addItem forIndexPath:indexPath];
        addItemCell.frame = CGRectMake(0, 0, 75 *AAdaptionWidth() , 75*AAdaptionWidth());
        
        return addItemCell;
    }else
    {
        static NSString *identify = @"cell";
        PictureCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
        
        cell.imageView.image = self.itemsSectionPictureArray[indexPath.row];
        
        return cell;
    }
}

//用代理
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.itemsSectionPictureArray.count) {
        if (self.itemsSectionPictureArray.count > 2) {
            return;
        }
        
//        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册选择", @"相机拍照", nil];
//        sheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
//        [sheet showInView:self.view];
        [self onAddImageButton];
    }else
    {
        NSMutableArray *photoArray = [[NSMutableArray alloc] init];
        for (int i = 0;i< self.itemsSectionPictureArray.count; i ++) {
            UIImage *image = self.itemsSectionPictureArray[i];
            
            MJPhoto *photo = [MJPhoto new];
            photo.image = image;
            PictureCollectionViewCell *cell = (PictureCollectionViewCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            photo.srcImageView = cell.imageView;
            [photoArray addObject:photo];
        }
        
        MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
        browser.photoBrowserdelegate = self;
        browser.currentPhotoIndex = indexPath.row;
        browser.photos = photoArray;
        [browser show];
        
    }
}

#pragma mark -- 相册、相机调用方法
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



-(void)deletedPictures:(NSSet *)set
{
    NSMutableArray *cellArray = [NSMutableArray array];
    
    for (NSString *index1 in set) {
        [cellArray addObject:index1];
    }
    
    if (cellArray.count == 0) {
        
    }else if (cellArray.count == 1 && self.itemsSectionPictureArray.count == 1) {
        NSIndexPath *indexPathTwo = [NSIndexPath indexPathForRow:0 inSection:0];
        
        [self.itemsSectionPictureArray removeObjectAtIndex:indexPathTwo.row];
        [self.pictureCollectonView deleteItemsAtIndexPaths:@[indexPathTwo]];
    }else{
        
        for (int i = 0; i<cellArray.count-1; i++) {
            for (int j = 0; j<cellArray.count-1-i; j++) {
                if ([cellArray[j] intValue]<[cellArray[j+1] intValue]) {
                    NSString *temp = cellArray[j];
                    cellArray[j] = cellArray[j+1];
                    cellArray[j+1] = temp;
                }
            }
        }
        
        for (int b = 0; b<cellArray.count; b++) {
            int idexx = [cellArray[b] intValue]-1;
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idexx inSection:0];
            
            [self.itemsSectionPictureArray removeObjectAtIndex:indexPath.row];
            [self.pictureCollectonView deleteItemsAtIndexPaths:@[indexPath]];
        }
    }
    
    if (self.itemsSectionPictureArray.count < 2) {
        self.pictureCollectonView.frame = CGRectMake(_space, _minY , _width, 75*AAdaptionWidth() );
    }else if (self.itemsSectionPictureArray.count < 2)
    {
        self.pictureCollectonView.frame = CGRectMake(_space, _minY, _width, 160*AAdaptionWidth());
    }else
    {
        self.pictureCollectonView.frame = CGRectMake(_space, _minY , _width, 240*AAdaptionWidth() );
    }
}

#pragma mark - 相册、相机调用方法
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    if (buttonIndex == 0) {
//        NSLog(@"点击了从手机选择");
//        
//        ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
//        elcPicker.maximumImagesCount = 9 - self.itemsSectionPictureArray.count;
//        elcPicker.returnsOriginalImage = YES;
//        elcPicker.returnsImage = YES;
//        elcPicker.onOrder = NO;
//        elcPicker.mediaTypes = @[(NSString *)kUTTypeImage, (NSString *)kUTTypeMovie];
//        elcPicker.imagePickerDelegate = self;
//        //    elcPicker.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;//过渡特效
//        [self presentViewController:elcPicker animated:YES completion:nil];
//        
//    }else if (buttonIndex == 1)
//    {
//        NSLog(@"点击了精美配图");
//        
//    }else if (buttonIndex == 2)
//    {
//        NSLog(@"点击了拍照");
//        
//        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
//        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
//            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//            picker.delegate = self;
//            //设置拍照后的图片可被编辑
//            picker.allowsEditing = YES;
//            picker.sourceType = sourceType;
//            
//            picker.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//            
//            [self presentViewController:picker animated:YES completion:nil];
//        }else{
//            NSLog(@"模拟无效,请真机测试");
//        }
//    }
}

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
    __weak PictureViewController *wself = self;
    [self dismissViewControllerAnimated:YES completion:^{
        BOOL hasVideo = NO;
        
        NSMutableArray *images = [NSMutableArray array];
        for (NSDictionary *dict in info) {
            if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypePhoto){
                if ([dict objectForKey:UIImagePickerControllerOriginalImage]){
                    UIImage* image=[dict objectForKey:UIImagePickerControllerOriginalImage];
                    [images addObject:image];
                } else {
                    NSLog(@"UIImagePickerControllerReferenceURL = %@", dict);
                }
            } else if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypeVideo){
                if (!hasVideo) {
                    hasVideo = YES;
                }
            } else {
                NSLog(@"Uknown asset type");
            }
        }
        
        NSMutableArray *indexPathes = [NSMutableArray array];
        for (unsigned long i = wself.itemsSectionPictureArray.count; i < wself.itemsSectionPictureArray.count + images.count; i++) {
            [indexPathes addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }
        [wself.itemsSectionPictureArray addObjectsFromArray:images];
        // 调整集合视图的高度
        
        [UIView animateWithDuration:.25 delay:0 options:7 animations:^{
            
            if (wself.itemsSectionPictureArray.count <2) {
                wself.pictureCollectonView.frame = CGRectMake(_space, _minY, _width, 75*AAdaptionWidth() );
            }else if (wself.itemsSectionPictureArray.count <2)
            {
                wself.pictureCollectonView.frame = CGRectMake(_space, _minY, _width, 160*AAdaptionWidth() );
            }else
            {
                wself.pictureCollectonView.frame = CGRectMake(_space, _minY, _width, 240*AAdaptionWidth() );
            }
            
            [wself.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            // 添加新选择的图片
            [wself.pictureCollectonView performBatchUpdates:^{
                [wself.pictureCollectonView insertItemsAtIndexPaths:indexPathes];
            } completion:^(BOOL finished) {
                if (hasVideo) {
                    [[[UIAlertView alloc] initWithTitle:@"提示" message:@"暂不支持视频发布" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
                }
            }];
        }];
    }];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    
    //保存并上传图片
    [self saveImage:image];
    [self.itemsSectionPictureArray addObject:image];
    __weak PictureViewController *wself = self;
    
    [picker dismissViewControllerAnimated:YES completion:^{
        [UIView animateWithDuration:.25 delay:0 options:7 animations:^{
            if (wself.itemsSectionPictureArray.count < 2) {
                wself.pictureCollectonView.frame = CGRectMake(_space, _minY, _width, 75*AAdaptionWidth() );
            }else if (wself.itemsSectionPictureArray.count < 2)
            {
                wself.pictureCollectonView.frame = CGRectMake(_space, _minY, _width, 160*AAdaptionWidth() );
            }else
            {
                wself.pictureCollectonView.frame = CGRectMake(_space, _minY, _width, 240*AAdaptionWidth() );
            }
            
            [wself.view layoutIfNeeded];
        } completion:nil];
        
        [self.pictureCollectonView performBatchUpdates:^{
            [wself.pictureCollectonView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:wself.itemsSectionPictureArray.count - 1 inSection:0]]];
        } completion:nil];
    }];
    
}

#pragma mark - 1.保存图片并上传
- (void)saveImage:(UIImage *)image {
    //缩略图片处理
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    //    NSLog(@"documentsDirectory ->>%@",documentsDirectory);
    NSString *imageFilePath = [documentsDirectory stringByAppendingPathComponent:@"myimage.jpg"];
    
    success = [fileManager fileExistsAtPath:imageFilePath];
    if(success) {
        success = [fileManager removeItemAtPath:imageFilePath error:&error];
    }
    UIImage *smallImage = [self thumbnailWithImageWithoutScale:image size:CGSizeMake(414 *AAdaptionWidth(), 200 * AAdaptionWidth())];
    [UIImageJPEGRepresentation(smallImage, 1.0f) writeToFile:imageFilePath atomically:YES];//写入文件
    UIImage *avatarImage = [UIImage imageWithContentsOfFile:imageFilePath];//读取图片文件
    
    NSData *imageData = UIImagePNGRepresentation(avatarImage);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"getImage" object:imageData];

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



- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
