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
#import <Photos/Photos.h>
#import <MediaPlayer/MediaPlayer.h>
@interface HWGPUImageController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
{
    UIImagePickerController *_imagePickerController;
}
@property(nonatomic,strong) UIImageView * imageView;
@property(nonatomic,strong) GPUImageView * gpuImageView;
@property(nonatomic,strong) UIImage * image;
@property(nonatomic,strong) GPUImageOutput<GPUImageInput> * fifter;
/** 相机 */
@property(nonatomic,strong)  GPUImageStillCamera * mCamera;
@end

@implementation HWGPUImageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.delegate = self;
    _imagePickerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    _imagePickerController.allowsEditing = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(savepicture)];
    [self creteUI];
}

- (void)creteUI{
    NSArray * arr = @[@"相册选择",@"拍照",@"录制"];
    for (int i =0; i<3; i++) {
        UIButton * but = [UIButton buttonWithType:UIButtonTypeCustom];
        but.frame = CGRectMake(20+i*(self.view.frame.size.width-40)/3, 500, (self.view.frame.size.width/3-20), 30);
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

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.mCamera stopCameraCapture];
    self.mCamera = nil;
}
- (void)savepicture{
    if (self.mCamera) {
       
        [_mCamera capturePhotoAsJPEGProcessedUpToFilter:_fifter withCompletionHandler:^(NSData *processedJPEG, NSError *error) {
            if (error) {
                NSLog(@"ereerreertertreret%@",error);
                [_mCamera stopCameraCapture];
                self.mCamera = nil;
                return ;
            }
            UIImage * image = [UIImage imageWithData:processedJPEG];
            
            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                //  写入图片到相册
             [PHAssetChangeRequest creationRequestForAssetFromImage:image];
                
            } completionHandler:^(BOOL success, NSError * _Nullable error) {
                
                NSLog(@"success = %d, error = %@", success, error);
                [_mCamera stopCameraCapture];
                self.mCamera = nil;
                
            }];
        }];
        


    }
    
    
 }














- (void)btnClick:(UIButton*)btn{
    switch (btn.tag) {
        case 1000:
        {
             
            self.mCamera = nil;
            [self.gpuImageView removeFromSuperview];
            self.gpuImageView = nil;
            [self selectImageFromAlbum];
        }
            break;
        case 1001:
        {
            [self.imageView removeFromSuperview];
            self.imageView = nil;
            [self selectImageFromCamera];
        }
            break;
        case 1002:
        {
            
        }
            break;
        default:
            break;
    }
    
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
    switch (indexPath.row) {
        case 0:
        {
            GPUImageVignetteFilter * filter = [[GPUImageVignetteFilter alloc]init];
            if (self.mCamera) {
                [self hadelCameraPictureWithFilter:filter];
            }else{
                [self hadelALumbPictureWithFilter:filter];
            }
        
        }
            break;
            
        case 1:
        {
            GPUImageRGBFilter * filter = [[GPUImageRGBFilter alloc]init];
            filter.red = 0.5;
            filter.blue = 0.8;
            filter.green =0.9;
            if (self.mCamera) {
                  
                [self hadelCameraPictureWithFilter:filter];
            }else{
                [self hadelALumbPictureWithFilter:filter];
            }

        }
            
            break;
            
        case 2:
        {
            GPUImageSepiaFilter * filter = [[GPUImageSepiaFilter alloc]init];
           
            if (self.mCamera) {
                  
                [self hadelCameraPictureWithFilter:filter];
            }else{
                [self hadelALumbPictureWithFilter:filter];
            }

        }
            break;
            
        case 3:
        {
            GPUImageHazeFilter * filter = [[GPUImageHazeFilter alloc]init];
            if (self.mCamera) {
                  
                [self hadelCameraPictureWithFilter:filter];
            }else{
                [self hadelALumbPictureWithFilter:filter];
            }

        }

            break;
            
            
        case 4:{
            GPUImageSaturationFilter * filter = [[GPUImageSaturationFilter alloc]init];
            filter.saturation = 2;
            if (self.mCamera) {
                  
                [self hadelCameraPictureWithFilter:filter];
            }else{
                [self hadelALumbPictureWithFilter:filter];
            }

        }
            
            break;
            
            
        case 5:
        {
            GPUImageBrightnessFilter * filter = [[GPUImageBrightnessFilter alloc]init];
            filter.brightness = -1;
            if (self.mCamera) {
                  
                [self hadelCameraPictureWithFilter:filter];
            }else{
                [self hadelALumbPictureWithFilter:filter];
            }

        }
            break;
            
        case 6:
        {
            GPUImageExposureFilter * filter = [[GPUImageExposureFilter alloc]init];
            filter.exposure = 5;
            if (self.mCamera) {
                  
                [self hadelCameraPictureWithFilter:filter];
            }else{
                [self hadelALumbPictureWithFilter:filter];
            }
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
            if (self.mCamera) {
                  
                [self hadelCameraPictureWithFilter:filter];
            }else{
                [self hadelALumbPictureWithFilter:filter];
            }

           
        }

            break;
            
        case 8:
        {
            
            if (self.mCamera) {
                [_mCamera removeAllTargets];
                
                UIView *contentView = [[UIView alloc] initWithFrame:self.gpuImageView.bounds];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy年MM月dd日hh:mm:ss"];
                NSDate *currentDate = [NSDate date];
                NSString *timeString = [formatter stringFromDate:currentDate];
                UILabel *timestampLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 100, 300, 30)];
                timestampLabel.text = timeString;
                timestampLabel.textColor = [UIColor redColor];
                [contentView addSubview:timestampLabel];
                GPUImageUIElement *uiElement = [[GPUImageUIElement alloc] initWithView:contentView];
                GPUImageDissolveBlendFilter *filter = [[GPUImageDissolveBlendFilter alloc] init];
                filter.mix = 0.5;
                
                GPUImageFilter *videoFilter = [[GPUImageFilter alloc] init];
                UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
                [self.gpuImageView addGestureRecognizer:pinchGestureRecognizer];
                [self.view addSubview:self.gpuImageView];
//                //组合
                [_mCamera addTarget:videoFilter];
                [videoFilter addTarget:filter];
                [uiElement addTarget:filter];
                
                [filter addTarget:self.gpuImageView];
                self.fifter = filter;
    
                [videoFilter setFrameProcessingCompletionBlock:^(GPUImageOutput *output, CMTime time) {
               
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"yyyy年MM月dd日hh:mm:ss"];
                    NSDate *currentDate = [NSDate date];
                    NSString *timeString = [formatter stringFromDate:currentDate];
                    timestampLabel.text = timeString;
                    [uiElement update];
                    
                }];
            }else{
                if (!self.image) {
                    return;
                }
                UIView *contentView = [[UIView alloc] initWithFrame:self.view.bounds];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy年MM月dd日hh:mm:ss"];
                NSDate *currentDate = [NSDate date];
                NSString *timeString = [formatter stringFromDate:currentDate];
                UILabel *timestampLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 100, 300, 30)];
                timestampLabel.text = timeString;
                timestampLabel.textColor = [UIColor redColor];
                [contentView addSubview:timestampLabel];
                GPUImageUIElement *uiElement = [[GPUImageUIElement alloc] initWithView:contentView];
                
                
                GPUImagePicture * image = [[GPUImagePicture alloc]initWithImage:self.image];            //创建滤镜
                GPUImageDissolveBlendFilter *filter = [[GPUImageDissolveBlendFilter alloc] init];
                filter.mix = 0.5;
                
                GPUImageFilter *videoFilter = [[GPUImageFilter alloc] init];
                //            [self addTarget:videoFilter];
                [image addTarget:videoFilter];
                [videoFilter addTarget:filter];
                [uiElement addTarget:filter];
                
                // 添加滤镜
                [filter forceProcessingAtSize:self.image.size];
                [filter useNextFrameForImageCapture];
                //            [videoCamera startCameraCapture];
                [image processImage];
                
    self.imageView.image = [filter imageFromCurrentFramebuffer];
            }
  
                    
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

- (void)hadelCameraPictureWithFilter:(GPUImageOutput<GPUImageInput>*)filter{
   
    [_mCamera removeAllTargets];
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
    [self.gpuImageView addGestureRecognizer:pinchGestureRecognizer];
    [self.view addSubview:self.gpuImageView];
    //组合
    [_mCamera addTarget:filter];
    [filter addTarget:self.gpuImageView];
    self.fifter = filter;


}

- (void)hadelALumbPictureWithFilter:(GPUImageOutput<GPUImageInput>*)filter{
    
    if (!self.image) {
        return;
    }
    [filter forceProcessingAtSize:self.image.size];
    [filter useNextFrameForImageCapture];
    GPUImagePicture * image = [[GPUImagePicture alloc]initWithImage:self.image];
    [image addTarget:filter];
    [image processImage];
    self.imageView.image = [filter imageFromCurrentFramebuffer];
    
}

#pragma mark 从摄像头获取图片或视频
- (void)selectImageFromCamera
{
    self.gpuImageView = [[GPUImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-200, 70, 400, 400)];
    self.gpuImageView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
    //相机
    GPUImageStillCamera * mCamera = [[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPresetPhoto cameraPosition:AVCaptureDevicePositionBack];
    self.mCamera = mCamera;
    mCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    GPUImageFilter * filter = [[GPUImageFilter alloc]init];
    [self hadelCameraPictureWithFilter:filter];
    [self.mCamera startCameraCapture];
    
//    _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
//    //录制视频时长，默认10s
//    _imagePickerController.videoMaximumDuration = 15;
//    
//    //相机类型（拍照、录像...）字符串需要做相应的类型转换
//    _imagePickerController.mediaTypes = @[(NSString *)kUTTypeMovie,(NSString *)kUTTypeImage];
//    
//    //视频上传质量
//    //UIImagePickerControllerQualityTypeHigh高清
//    //UIImagePickerControllerQualityTypeMedium中等质量
//    //UIImagePickerControllerQualityTypeLow低质量
//    //UIImagePickerControllerQualityType640x480
//    _imagePickerController.videoQuality = UIImagePickerControllerQualityTypeHigh;
//    
//    //设置摄像头模式（拍照，录制视频）为录像模式
//    _imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
//    [self presentViewController:_imagePickerController animated:YES completion:nil];
    
}

#pragma mark 从相册获取图片或视频
- (void)selectImageFromAlbum
{
    //NSLog(@"相册");
    _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:_imagePickerController animated:YES completion:nil];
    
}
// 处理缩放手势
- (void) pinchView:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{
//    UIView *view = pinchGestureRecognizer.view;
    NSError *error = nil;
    [self.mCamera.inputCamera lockForConfiguration:&error];
    if (!error&&pinchGestureRecognizer.scale>1) {
        self.mCamera.inputCamera.videoZoomFactor =  pinchGestureRecognizer.scale;
    }else
    {
        NSLog(@"error = %@", error);
    }
    [self.mCamera.inputCamera unlockForConfiguration];
}

//    pinchGestureRecognizer.scale;
   

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
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-200, 70, 400, 400)];
        [self.view addSubview:self.imageView];
        self.imageView.image = info[UIImagePickerControllerEditedImage];
        self.image= info[UIImagePickerControllerEditedImage];
        //压缩图片
        //        NSData *fileData = UIImageJPEGRepresentation(self.imageView.image, 1.0);
        //保存图片至相册
//        UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        
        
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
    self.image = image;
    self.imageView.image = image;
    
    NSLog(@"%@,%@",contextInf,error);
    
    
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
