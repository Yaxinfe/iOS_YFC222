//
//  SendViedoViewController.m
//  YFC
//
//  Created by topone on 9/24/15.
//  Copyright (c) 2015 ming. All rights reserved.
//

#import "publicHeaders.h"
#import "SendViedoViewController.h"
#import "FirstViewController.h"

#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

#import "UzysAssetsPickerController.h"

#import "YFGIFImageView.h"
#import "UIImageView+PlayGIF.h"

@interface SendViedoViewController ()<UzysAssetsPickerControllerDelegate>
{
    UIImageView *videoImg;
    UIImageView *thumbnailImg;
    
    UzysAssetsPickerController *picker1;
    UzysAssetsPickerController *picker2;
    
    NSData *videoData;
    NSData *imageData;
    
    NSURL  *uploadUrl;
    
    YFGIFImageView *gifView_Load;
    
    CGFloat video_width;
    CGFloat video_height;
}

@end

@implementation SendViedoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    video_height = 0;
    video_width = 0;
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    backImageView.image = [UIImage imageNamed:@"newsBackImg.png"];
    [self.view addSubview:backImageView];
    
    UIButton *back_btn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.origin.x , self.view.frame.origin.y + 25, 27, 30)];
    [back_btn setImage:[UIImage imageNamed:@"backBtn.png"] forState:UIControlStateNormal];
    [back_btn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [back_btn setTintColor:[UIColor lightGrayColor]];
    back_btn.alpha = 1.0;
    back_btn.transform = CGAffineTransformMakeTranslation(10, 0);
    [self.view addSubview:back_btn];
    
    UILabel *lbl_Title = [[UILabel alloc] init];
    [lbl_Title setFrame:CGRectMake(self.view.frame.origin.x + 0, self.view.frame.origin.y + 30, self.view.frame.size.width, 20)];
    [lbl_Title setTextAlignment:NSTextAlignmentCenter];
    [lbl_Title setTextColor:[UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0]];
    [lbl_Title setBackgroundColor:[UIColor clearColor]];
    [lbl_Title setFont:[UIFont boldSystemFontOfSize:22.0]];
    [self.view addSubview:lbl_Title];
    
    UIImageView *lineImg5 =[UIImageView new];
    lineImg5.frame=CGRectMake(0, 63, self.view.frame.size.width, 2);
    lineImg5.clipsToBounds = YES;
    lineImg5.userInteractionEnabled=YES;
    lineImg5.backgroundColor = [UIColor colorWithRed:216.0/255.0 green:229.0/255.0 blue:241.0/255.0 alpha:1.0];
    [self.view addSubview:lineImg5];
    
    UILabel *lbl_Video = [[UILabel alloc] init];
    [lbl_Video setFrame:CGRectMake(30, 80, self.view.frame.size.width - 30, 20)];
    [lbl_Video setTextAlignment:NSTextAlignmentLeft];
    [lbl_Video setTextColor:[UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0]];
    [lbl_Video setBackgroundColor:[UIColor clearColor]];
    [lbl_Video setFont:[UIFont systemFontOfSize:17.0]];
    [self.view addSubview:lbl_Video];
    
    videoImg = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 100, 110, 200, 120)];
    videoImg.backgroundColor = [UIColor lightGrayColor];
    videoImg.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:videoImg];
    
    UIButton *selectVideoBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 100, 110, 200, 120)];
    [selectVideoBtn addTarget:self action:@selector(selectVideoBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    selectVideoBtn.alpha = 1.0;
    selectVideoBtn.transform = CGAffineTransformMakeTranslation(10, 0);
    [self.view addSubview:selectVideoBtn];
    
    UILabel *lbl_Thumb = [[UILabel alloc] init];
    [lbl_Thumb setFrame:CGRectMake(30, 240, self.view.frame.size.width - 30, 20)];
    [lbl_Thumb setTextAlignment:NSTextAlignmentLeft];
    [lbl_Thumb setTextColor:[UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0]];
    [lbl_Thumb setBackgroundColor:[UIColor clearColor]];
    [lbl_Thumb setFont:[UIFont systemFontOfSize:17.0]];
    [self.view addSubview:lbl_Thumb];
    
    thumbnailImg = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 100, 270, 200, 120)];
    thumbnailImg.backgroundColor = [UIColor lightGrayColor];
    thumbnailImg.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:thumbnailImg];
    
    UIButton *selectImgBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 100, 270, 200, 120)];
    [selectImgBtn addTarget:self action:@selector(selectImgBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    selectImgBtn.alpha = 1.0;
    selectImgBtn.transform = CGAffineTransformMakeTranslation(10, 0);
    [self.view addSubview:selectImgBtn];
    
    UIButton *done_btn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 200, 410, 200, 40)];
    [done_btn setBackgroundImage:[UIImage imageNamed:@"videoSendImg.png"] forState:UIControlStateNormal];
    [done_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [done_btn addTarget:self action:@selector(settedBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [done_btn setTintColor:[UIColor lightGrayColor]];
    done_btn.alpha = 1.0;
    done_btn.transform = CGAffineTransformMakeTranslation(10, 0);
    [self.view addSubview:done_btn];
    
    NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
    if ([applang isEqualToString:@"ko"]) {
        lbl_Title.text = VIDEOSEND_TITLE[0];
        lbl_Video.text = VIDEOSEND_VIDEO[0];
        lbl_Thumb.text = VIDEOSEND_THUMB[0];
        [done_btn setTitle:VIDEOSEND_SEND_BUTTON[0] forState:UIControlStateNormal];
    }
    if ([applang isEqualToString:@"cn"]) {
        lbl_Title.text = VIDEOSEND_TITLE[1];
        lbl_Video.text = VIDEOSEND_VIDEO[1];
        lbl_Thumb.text = VIDEOSEND_THUMB[1];
        [done_btn setTitle:VIDEOSEND_SEND_BUTTON[1] forState:UIControlStateNormal];
    }
    
    NSData *gifData_Load = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Loading.gif" ofType:nil]];
    gifView_Load = [[YFGIFImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 50, self.view.frame.size.height/2 - 50, 100, 100)];
    gifView_Load.backgroundColor = [UIColor clearColor];
    gifView_Load.gifData = gifData_Load;
    [self.view addSubview:gifView_Load];
    gifView_Load.hidden = YES;
    gifView_Load.userInteractionEnabled = YES;
}

- (void)selectImgBtnClicked{
    picker2 = [[UzysAssetsPickerController alloc] init];
    picker2.delegate = self;
    picker2.modalPresentationStyle = UIModalPresentationCurrentContext;
    
    picker2.maximumNumberOfSelectionVideo = 0;
    picker2.maximumNumberOfSelectionPhoto = 1;
    
    [self presentViewController:picker2 animated:YES completion:^{
        
    }];
}

- (void)selectVideoBtnClicked{
    picker1 = [[UzysAssetsPickerController alloc] init];
    picker1.delegate = self;
    picker1.modalPresentationStyle = UIModalPresentationCurrentContext;
    
    picker1.maximumNumberOfSelectionVideo = 1;
    picker1.maximumNumberOfSelectionPhoto = 0;
    
    [self presentViewController:picker1 animated:YES completion:^{
        
    }];
}

- (void)settedBtnClicked{
    
    if (imageData == nil || uploadUrl == nil) {
        NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
        if ([applang isEqualToString:@"ko"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"이미지와 비디오를 선택하세요." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        if ([applang isEqualToString:@"cn"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请选择图片和视频" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            [alert show];
        }
    
    }
    else{
        gifView_Load.hidden = NO;
        [gifView_Load startGIF];
        [gifView_Load startAnimating];
        
        NSString *userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"];
        NSDictionary *parameters = @{@"userid":userid,
                                     @"desc":@"test"
                                     };
        
        [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
        [[GlobalPool sharedInstance].OAuth2Manager POST:LC_FANVOICE_SEND_VIDEO parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData){
            [formData appendPartWithFileData:imageData name:@"image" fileName:@"photo.jpg" mimeType:@"image/jpeg"];
            [formData appendPartWithFileData:videoData name:@"video" fileName:@"myVideo.mov" mimeType:@"video/quicktime"];
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@",responseObject);
            
            gifView_Load.hidden = YES;
            [gifView_Load stopGIF];
            [gifView_Load stopAnimating];
            
            NSString *status = [responseObject objectForKey:@"status"];
            if ([status intValue] == 200) {
                NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
                if ([applang isEqualToString:@"ko"]) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"이미지와 비디오가 업로드되였습니다." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                }
                if ([applang isEqualToString:@"cn"]) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"视频上传成功" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                    [alert show];
                }
                
            }
            else{
                NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
                if ([applang isEqualToString:@"ko"]) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"업로드가 실패하였습니다" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                }
                if ([applang isEqualToString:@"cn"]) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"上传失败" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                    [alert show];
                }
                
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            gifView_Load.hidden = YES;
            [gifView_Load stopGIF];
            [gifView_Load stopAnimating];
            [SVProgressHUD showErrorWithStatus:@"Connection failed"];
        }];
        
//        videoData = [NSData dataWithContentsOfURL:uploadUrl];
        
        
//        [self cropVideoAtURL:uploadUrl toWidth:video_width height:video_height completion:^(NSURL *resultURL, NSError *error) {
//            if (error) {
//                NSLog(@"Error");
//            }
//            else {
//                videoData = [NSData dataWithContentsOfURL:resultURL];
//
//                NSString *userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"];
//                NSDictionary *parameters = @{@"userid":userid,
//                                             @"desc":@"test"
//                                             };
//                
//                [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
//                [[GlobalPool sharedInstance].OAuth2Manager POST:LC_FANVOICE_SEND_VIDEO parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData){
//                    [formData appendPartWithFileData:imageData name:@"image" fileName:@"photo.jpg" mimeType:@"image/jpeg"];
//                    [formData appendPartWithFileData:videoData name:@"video" fileName:@"myVideo.mov" mimeType:@"video/quicktime"];
//                } success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                    NSLog(@"%@",responseObject);
//                    
//                    gifView_Load.hidden = YES;
//                    [gifView_Load stopGIF];
//                    [gifView_Load stopAnimating];
//                    
//                    NSString *status = [responseObject objectForKey:@"status"];
//                    if ([status intValue] == 200) {
//                        NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
//                        if ([applang isEqualToString:@"ko"]) {
//                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"이미지와 비디오가 업로드되였습니다." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                            [alert show];
//                        }
//                        if ([applang isEqualToString:@"cn"]) {
//                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"视频上传成功" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
//                            [alert show];
//                        }
//                        
//                    }
//                    else{
//                        NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
//                        if ([applang isEqualToString:@"ko"]) {
//                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"업로드가 실패하였습니다" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                            [alert show];
//                        }
//                        if ([applang isEqualToString:@"cn"]) {
//                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"上传失败" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
//                            [alert show];
//                        }
//                        
//                    }
//                    
//                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                    [SVProgressHUD dismiss];
//                }];
//            }
//        }];
    }
}

#pragma mark - UzysAssetsPickerControllerDelegate methods
- (void)uzysAssetsPickerController:(UzysAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    DLog(@"assets %@",assets);
    if(assets.count ==1)
    {
        //        self.labelDescription.text = [NSString stringWithFormat:@"%ld asset selected",(unsigned long)assets.count];
    }
    else
    {
        //        self.labelDescription.text = [NSString stringWithFormat:@"%ld assets selected",(unsigned long)assets.count];
    }
    
    if (picker == picker1) {
        if([[assets[0] valueForProperty:@"ALAssetPropertyType"] isEqualToString:@"ALAssetTypePhoto"]) //Photo
        {
            
        }
        else //Video
        {
            ALAsset *alAsset = assets[0];
            
            UIImage *img = [UIImage imageWithCGImage:alAsset.defaultRepresentation.fullResolutionImage
                                               scale:alAsset.defaultRepresentation.scale
                                         orientation:(UIImageOrientation)alAsset.defaultRepresentation.orientation];
            videoImg.image = img;
            
            ALAssetRepresentation *representation = alAsset.defaultRepresentation;
            NSURL *movieURL = representation.url;
            
            ALAssetRepresentation *rep = [alAsset defaultRepresentation];
            Byte *buffer = (Byte*)malloc((NSUInteger)rep.size);
            NSUInteger buffered = [rep getBytes:buffer fromOffset:0.0 length:(NSUInteger)rep.size error:nil];
            videoData = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];
            
//            AVAsset *asset = [AVAsset assetWithURL:movieURL];
//            AVAssetTrack *assetVideoTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] lastObject];
//            CGSize originalSize = assetVideoTrack.naturalSize;
            
            video_height = img.size.height;
            video_width = img.size.width;
            
//            NSURL *uploadURL = [NSURL fileURLWithPath:[[NSTemporaryDirectory() stringByAppendingPathComponent:@"test"] stringByAppendingString:@".mp4"]];
//            AVAsset *asset      = [AVURLAsset URLAssetWithURL:movieURL options:nil];
//            AVAssetExportSession *session = [AVAssetExportSession exportSessionWithAsset:asset presetName:AVAssetExportPresetMediumQuality];
//            
//            session.outputFileType  = AVFileTypeQuickTimeMovie;
//            session.outputURL       = uploadURL;
            
            uploadUrl = movieURL;
        }
    }
    else{
        if([[assets[0] valueForProperty:@"ALAssetPropertyType"] isEqualToString:@"ALAssetTypePhoto"]) //Photo
        {
            [assets enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                ALAsset *representation = obj;
                
                UIImage *img = [UIImage imageWithCGImage:representation.defaultRepresentation.fullResolutionImage
                                                   scale:representation.defaultRepresentation.scale
                                             orientation:(UIImageOrientation)representation.defaultRepresentation.orientation];
                thumbnailImg.image = img;
                imageData = UIImageJPEGRepresentation(img, 0.3);
                
                *stop = YES;
            }];
        }
        else //Video
        {
            
        }
    }
    
}

- (void)cropVideoAtURL:(NSURL *)videoURL toWidth:(CGFloat)width height:(CGFloat)height completion:(void(^)(NSURL *resultURL, NSError *error))completionHander {
    
    AVAsset *asset = [AVAsset assetWithURL:videoURL];
    
    AVAssetTrack *assetVideoTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] lastObject];
    
    CGSize originalSize = assetVideoTrack.naturalSize;
    
    CGFloat scale;
    
    if (originalSize.width < originalSize.height) {
        scale = width / originalSize.width;
    } else {
        scale = height / originalSize.height;
    }
    
    CGSize scaledSize = CGSizeMake(originalSize.width * scale, originalSize.height * scale);
    
    CGPoint topLeft = CGPointMake(width*.5 - scaledSize.width*.5, height*.5 - scaledSize.height*.5);
    
    AVMutableVideoCompositionLayerInstruction *layerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:assetVideoTrack];
    
    CGAffineTransform orientationTransform = assetVideoTrack.preferredTransform;
    
    if (orientationTransform.tx == originalSize.width || orientationTransform.tx == originalSize.height) {
        orientationTransform.tx = width;
    }
    
    if (orientationTransform.ty == originalSize.width || orientationTransform.ty == originalSize.height) {
        orientationTransform.ty = height;
    }
    
    CGAffineTransform transform = CGAffineTransformConcat(CGAffineTransformConcat(CGAffineTransformMakeScale(scale, scale),  CGAffineTransformMakeTranslation(topLeft.x, topLeft.y)), orientationTransform);
    
    [layerInstruction setTransform:transform atTime:kCMTimeZero];
    
    AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    
    instruction.layerInstructions = @[layerInstruction];
    instruction.timeRange = assetVideoTrack.timeRange;
    
    AVMutableVideoComposition *videoComposition = [AVMutableVideoComposition videoComposition];
    
    videoComposition.renderSize = CGSizeMake(width, height);
    videoComposition.renderScale = 1.0;
    videoComposition.frameDuration = CMTimeMake(1, 30);
    
    videoComposition.instructions = @[instruction];
    
    AVAssetExportSession *export = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetMediumQuality];
    
    export.videoComposition = videoComposition;
    export.outputURL = [NSURL fileURLWithPath:[[NSTemporaryDirectory() stringByAppendingPathComponent:[NSUUID new].UUIDString] stringByAppendingPathExtension:@"MOV"]];
    export.outputFileType = AVFileTypeQuickTimeMovie;
    export.shouldOptimizeForNetworkUse = YES;
    
    [export exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (export.status == AVAssetExportSessionStatusCompleted) {
                
                completionHander(export.outputURL, nil);
                
            } else {
                
                completionHander(nil, export.error);
                
            }
        });
    }];
}

- (void)uzysAssetsPickerControllerDidExceedMaximumNumberOfSelection:(UzysAssetsPickerController *)picker
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:NSLocalizedStringFromTable(@"Exceed Maximum Number Of Selection", @"UzysAssetsPickerController", nil)
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)backBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
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
