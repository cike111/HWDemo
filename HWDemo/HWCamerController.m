//
//  HWCamerController.m
//  HWDemo
//
//  Created by hw on 2017/6/12.
//  Copyright © 2017年 Hw. All rights reserved.
//

#import "HWCamerController.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreImage/CoreImage.h>
#define kMainScreenWidth [UIScreen mainScreen].bounds.size.width
#define kMainScreenHeight  [UIScreen mainScreen].bounds.size.height
@interface HWCamerController ()<AVCapturePhotoCaptureDelegate>
/** 输入设备 */
@property(nonatomic,strong) AVCaptureDevice * deVice;
/** AVCaptureSession对象来执行输入设备和输出设备之间的数据传递 */
@property(nonatomic,strong) AVCaptureSession * session;
@end

@implementation HWCamerController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self creteUI];
}


- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
   
        if (self.session) {
            [self.session stopRunning];
        }
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
    
    
}
- (void)btnClick:(UIButton*)btn{
    switch (btn.tag) {
        case 1000:
        {
            
        
//            [self selectImageFromAlbum];
        }
            break;
        case 1001:
        {
      
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
- (void)selectImageFromCamera{
      NSError *error;
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput * input = [[AVCaptureDeviceInput alloc]initWithDevice:device error:&error];
    AVCapturePhotoOutput * outPut = [[AVCapturePhotoOutput alloc]init];
//    AVCaptureVideoDataOutput
   
    //输出设置。AVVideoCodecJPEG   输出jpeg格式图片
    NSDictionary * outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey, nil];
    [outPut setPhotoSettingsForSceneMonitoring: [AVCapturePhotoSettings photoSettingsWithFormat:outputSettings]];
    
    self.session = [[AVCaptureSession alloc]init];
    if ([self.session canAddInput:input]) {
        [self.session addInput:input];
    }
    if ([self.session canAddOutput:outPut]) {
        [self.session addOutput:outPut];
    }
    AVCaptureVideoPreviewLayer * preView = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.session];
    [preView setVideoGravity:AVLayerVideoGravityResizeAspect];
    preView.frame = CGRectMake(0, 0,kMainScreenWidth, kMainScreenHeight - 64);
    [self.view.layer addSublayer:preView];
    if (self.session) {
        [self.session startRunning];
    }
    
    
   
    
    
    
    
    
    
    
    [outPut capturePhotoWithSettings: [AVCapturePhotoSettings photoSettingsWithFormat:outputSettings] delegate:self];
    
    

}

- (void)willOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer{
    
}
- (void)captureOutput:(AVCapturePhotoOutput *)captureOutput didFinishProcessingPhotoSampleBuffer:(nullable CMSampleBufferRef)photoSampleBuffer previewPhotoSampleBuffer:(nullable CMSampleBufferRef)previewPhotoSampleBuffer resolvedSettings:(AVCaptureResolvedPhotoSettings *)resolvedSettings bracketSettings:(nullable AVCaptureBracketedStillImageSettings *)bracketSettings error:(nullable NSError *)error {
    
    NSData *data = [AVCapturePhotoOutput JPEGPhotoDataRepresentationForJPEGSampleBuffer:photoSampleBuffer previewPhotoSampleBuffer:previewPhotoSampleBuffer];
    UIImage *image = [UIImage imageWithData:data];
    
//    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}
#pragma mark 图片保存完毕的回调
- (void) image: (UIImage *) image didFinishSavingWithError:(NSError *) error contextInfo: (void *)contextInf{
  
    
    NSLog(@"%@,%@",contextInf,error);
    
    
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
