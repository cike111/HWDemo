//
//  HWGPUImageController.m
//  HWDemo
//
//  Created by hw on 2017/6/2.
//  Copyright © 2017年 Hw. All rights reserved.
//

#import "HWGPUImageController.h"
#import <GPUImage/GPUImageView.h>
#import <GPUImage/GPUImageSepiaFilter.h>
#import <GPUImage/GPUImage.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
@interface HWGPUImageController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
{
    UIImagePickerController *_imagePickerController;
}
@property(nonatomic,strong) UIImageView * imageView;
@property(nonatomic,strong) UIImage * image;
@end

@implementation HWGPUImageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.delegate = self;
    _imagePickerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    _imagePickerController.allowsEditing = YES;
    [self creteUI];
}

- (void)creteUI{
    NSArray * arr = @[@"相册选择",@"拍照",@"录制"];
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/3-200, 10, 400, 400)];
    [self.view addSubview:self.imageView];
    for (int i =0; i<3; i++) {
        UIButton * but = [UIButton buttonWithType:UIButtonTypeCustom];
        but.frame = CGRectMake(20+i*(self.view.frame.size.width-40)/3, 440, (self.view.frame.size.width/3-20), 30);
        [but setTitle:arr[i] forState:UIControlStateNormal];
        [but setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        but.tag = 1000+i;
        [but addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:but];
    }
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(50, 50);
    // 设置最小行间距
    layout.minimumLineSpacing = 2;
    // 设置垂直间距
    layout.minimumInteritemSpacing = 2;
    // 设置滚动方向（默认垂直滚动）
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    UICollectionView * filtersView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 600,self.view.bounds.size.width, 52) collectionViewLayout:layout];
    filtersView.delegate = self;
    filtersView.dataSource = self;
    filtersView.backgroundColor = [UIColor whiteColor];
    [filtersView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:filtersView];
    
    
}
- (void)btnClick:(UIButton*)btn{
    [self selectImageFromAlbum];
}
- (void)handlBtnClick:(UIButton*)btn{
    
}


#pragma mark collectonView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 11;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor cyanColor];
    UILabel * title = [[UILabel alloc]init];
    title.center = cell.contentView.center;
    title.bounds = cell.contentView.bounds;
    [cell.contentView addSubview:title];
    title.text = [NSString stringWithFormat:@"%zd",indexPath.row];
    return cell;
}



//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(50,50);
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

#pragma mark --UICollectionViewDelegate

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.image) {
        return;
    }
    switch (indexPath.row) {
        case 0:
        {
            GPUImageVignetteFilter * filter = [[GPUImageVignetteFilter alloc]init];
            [filter setupFilterForSize:self.image.size];
            [filter useNextFrameForImageCapture];
            filter.vignetteCenter = CGPointMake(0.5, 0.5);
            GPUImagePicture * image = [[GPUImagePicture alloc]initWithImage:self.image];
            [image addTarget:filter];
            [image processImage];
//            GPUImagePicture * image2 = [[GPUImagePicture alloc]initWithImage:[filter imageFromCurrentFramebuffer]];
//            GPUImageVignetteFilter * filter1 = [[GPUImageVignetteFilter alloc]init];
//            [filter1 setupFilterForSize:self.image.size];
//            [filter1 useNextFrameForImageCapture];
//            filter1.vignetteCenter = CGPointMake(0.5, 0.5);
//            [image2 addTarget:filter1];
//            [image2 processImage];
            self.imageView.image =[filter imageFromCurrentFramebuffer];
      
        }
            break;
            
        case 1:{
            GPUImageRGBFilter * filter = [[GPUImageRGBFilter alloc]init];
            filter.red = 0.5;
            filter.blue = 0.8;
            filter.green =0.9;
            [filter setupFilterForSize:self.image.size];
            [filter useNextFrameForImageCapture];
            GPUImagePicture * image = [[GPUImagePicture alloc]initWithImage:self.image];
            [image addTarget:filter];
            [image processImage];
            self.imageView.image =[filter imageFromCurrentFramebuffer];
        }
            
            break;
            
        case 2:
        {
            GPUImageSepiaFilter * filter = [[GPUImageSepiaFilter alloc]init];
           
            [filter setupFilterForSize:self.image.size];
            [filter useNextFrameForImageCapture];
            GPUImagePicture * image = [[GPUImagePicture alloc]initWithImage:self.image];
            [image addTarget:filter];
            [image processImage];
            self.imageView.image =[filter imageFromCurrentFramebuffer];
        }
            break;
            
        case 3:
        {
            GPUImageHazeFilter * filter = [[GPUImageHazeFilter alloc]init];
            filter.slope =0;
            filter.distance =-0.3;
            [filter setupFilterForSize:self.image.size];
            [filter useNextFrameForImageCapture];
            GPUImagePicture * image = [[GPUImagePicture alloc]initWithImage:self.image];
            [image addTarget:filter];
            [image processImage];
            self.imageView.image =[filter imageFromCurrentFramebuffer];
        }

            break;
            
            
        case 4:{
            GPUImageSaturationFilter * filter = [[GPUImageSaturationFilter alloc]init];
            filter.saturation = 1.5;
            [filter setupFilterForSize:self.image.size];
            [filter useNextFrameForImageCapture];
            GPUImagePicture * image = [[GPUImagePicture alloc]initWithImage:self.image];
            [image addTarget:filter];
            [image processImage];
            self.imageView.image = [filter imageFromCurrentFramebuffer];
        }
            
            break;
            
            
        case 5:
        {
            GPUImageBrightnessFilter * filter = [[GPUImageBrightnessFilter alloc]init];
            filter.brightness = 0.7;
            [filter setupFilterForSize:self.image.size];
            [filter useNextFrameForImageCapture];
            GPUImagePicture * image = [[GPUImagePicture alloc]initWithImage:self.image];
            [image addTarget:filter];
            [image processImage];
            self.imageView.image = [filter imageFromCurrentFramebuffer];
        }
            break;
            
        case 6:
        {
            GPUImageExposureFilter * filter = [[GPUImageExposureFilter alloc]init];
            filter.exposure = 0.7;
            [filter setupFilterForSize:self.image.size];
            [filter useNextFrameForImageCapture];
            GPUImagePicture * image = [[GPUImagePicture alloc]initWithImage:self.image];
            [image addTarget:filter];
            [image processImage];
            self.imageView.image = [filter imageFromCurrentFramebuffer];
        }

            
            break;
        case 7:
        {
            
//            /// The image width and height factors tweak the appearance of the edges. By default, they match the filter size in pixels
//            @property(readwrite, nonatomic) CGFloat texelWidth;
//            /// The image width and height factors tweak the appearance of the edges. By default, they match the filter size in pixels
//            @property(readwrite, nonatomic) CGFloat texelHeight;
//            
//            /// The radius of the underlying Gaussian blur. The default is 2.0.
//            @property (readwrite, nonatomic) CGFloat blurRadiusInPixels;
//            
//            /// The threshold at which to apply the edges, default of 0.2
//            @property(readwrite, nonatomic) CGFloat threshold;
//            
//            /// The levels of quantization for the posterization of colors within the scene, with a default of 10.0
//            @property(readwrite, nonatomic) CGFloat quantizationLevels;
            GPUImageSmoothToonFilter * filter = [[GPUImageSmoothToonFilter alloc]init];

            filter.blurRadiusInPixels = 1;
            filter.threshold = 0.2;
            [filter forceProcessingAtSize:self.image.size];
            [filter useNextFrameForImageCapture];
            GPUImagePicture * image = [[GPUImagePicture alloc]initWithImage:self.image];
            [image addTarget:filter];
            [image processImage];
            self.imageView.image = [filter imageFromCurrentFramebuffer];
        }

            break;
            
        case 8:
        {
            
        }
            
            break;
            
        case 9:
            
            break;
            
            
        case 10:
            
            break;
            
            
        default:
            break;
    }
}

/** /防图片90度
 func fixOrientation(img:UIImage) -> UIImage {
 
 if (img.imageOrientation == UIImageOrientation.Up) {
 return img;
 }
 
 UIGraphicsBeginImageContextWithOptions(img.size, false, img.scale);
 let rect = CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height)
 img.drawInRect(rect)
 
 let normalizedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
 UIGraphicsEndImageContext();
 return normalizedImage;
 
 } */
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


#pragma mark 从摄像头获取图片或视频
- (void)selectImageFromCamera
{
    _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    //录制视频时长，默认10s
    _imagePickerController.videoMaximumDuration = 15;
    
    //相机类型（拍照、录像...）字符串需要做相应的类型转换
    _imagePickerController.mediaTypes = @[(NSString *)kUTTypeMovie,(NSString *)kUTTypeImage];
    
    //视频上传质量
    //UIImagePickerControllerQualityTypeHigh高清
    //UIImagePickerControllerQualityTypeMedium中等质量
    //UIImagePickerControllerQualityTypeLow低质量
    //UIImagePickerControllerQualityType640x480
    _imagePickerController.videoQuality = UIImagePickerControllerQualityTypeHigh;
    
    //设置摄像头模式（拍照，录制视频）为录像模式
    _imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
    [self presentViewController:_imagePickerController animated:YES completion:nil];
}

#pragma mark 从相册获取图片或视频
- (void)selectImageFromAlbum
{
    //NSLog(@"相册");
    _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:_imagePickerController animated:YES completion:nil];
    
}

#pragma mark UIImagePickerControllerDelegate
//该代理方法仅适用于只选取图片时
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {
    NSLog(@"选择完毕----image:%@-----info:%@",image,editingInfo);
    
}

//适用获取所有媒体资源，只需判断资源类型
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    //判断资源类型
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        //如果是图片
        self.imageView.image = info[UIImagePickerControllerEditedImage];
        self.image= info[UIImagePickerControllerEditedImage];
        //压缩图片
        //        NSData *fileData = UIImageJPEGRepresentation(self.imageView.image, 1.0);
        //保存图片至相册
        UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        
        
    }else{
        //如果是视频
        NSURL *url = info[UIImagePickerControllerMediaURL];
        //播放视频
        //        _moviePlayer.contentURL = url;
        //        [_moviePlayer play];
        //保存视频至相册（异步线程）
        NSString *urlStr = [url path];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(urlStr)) {
                
                UISaveVideoAtPathToSavedPhotosAlbum(urlStr, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
            }
        });
        //        NSData *videoData = [NSData dataWithContentsOfURL:url];
        
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark 图片保存完毕的回调
- (void) image: (UIImage *) image didFinishSavingWithError:(NSError *) error contextInfo: (void *)contextInf{
    
}

#pragma mark 视频保存完毕的回调
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInf{
    if (error) {
        NSLog(@"保存视频过程中发生错误，错误信息:%@",error.localizedDescription);
    }else{
        NSLog(@"视频保存成功.");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
