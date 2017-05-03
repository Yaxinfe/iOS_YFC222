//
//  FanVoiceViewController.m
//  YFC
//
//  Created by topone on 7/17/15.
//  Copyright (c) 2015 ming. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

#import "publicHeaders.h"
#import "PlayerView.h"

#import "FanVoiceViewController.h"
#import "AllAroundPullView.h"

#import "TheSidebarController.h"
#import "SendViedoViewController.h"
#import "FirstViewController.h"

#import "AllAroundPullView.h"
#import "YFGIFImageView.h"
#import "UIImageView+PlayGIF.h"

#import "LXActivity.h"
#import "WXApi.h"

#import "LDSDKManager.h"

#import "LDSDKRegisterService.h"
#import "LDSDKPayService.h"
#import "LDSDKAuthService.h"
#import "LDSDKShareService.h"

@interface FanVoiceViewController ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, PlayerViewDelegate, UIActionSheetDelegate, LXActivityDelegate, WXApiDelegate>
{
    UIScrollView     *scrollView;
    UICollectionView *_collectionView;
    UIButton         *videoSendBtn;
    
    NSMutableArray *liveBraodArray;
    NSMutableArray *voiceArray;
    
    MPMoviePlayerViewController *moviePlayerController;
    
    NSString *videoShareUrl;
    UIImage *videoShareImg;
}

@property (strong, nonatomic) PlayerView *playerView;

@end

@implementation FanVoiceViewController
@synthesize playerView;

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationLandscapeLeft;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [playerView stop];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    liveBraodArray = [[NSMutableArray alloc] init];
    voiceArray = [[NSMutableArray alloc] init];
    
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    backImageView.image = [UIImage imageNamed:@"shopBack.png"];
    [self.view addSubview:backImageView];
    
    UIButton *back_btn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + 23, 36, 33)];
    [back_btn setImage:[UIImage imageNamed:@"listIcon.png"] forState:UIControlStateNormal];
    [back_btn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [back_btn setTintColor:[UIColor lightGrayColor]];
    back_btn.alpha = 1.0;
    back_btn.transform = CGAffineTransformMakeTranslation(10, 0);
    [self.view addSubview:back_btn];
    
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 100, 30, 200, 24)];
    titleLbl.font = [UIFont boldSystemFontOfSize:22.0];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.textColor = [UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0];
    [self.view addSubview:titleLbl];
    
    UIButton *shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 45, self.view.frame.origin.y + 25, 27, 30)];
    [shareBtn setImage:[UIImage imageNamed:@"shareIcon.png"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [shareBtn setTintColor:[UIColor lightGrayColor]];
    shareBtn.alpha = 1.0;
    shareBtn.transform = CGAffineTransformMakeTranslation(10, 0);
    [self.view addSubview:shareBtn];
    
    playerView = [[PlayerView alloc] initWithFrame:CGRectMake(0, 65, self.view.frame.size.width, self.view.frame.size.width*9.0f/16.0f)];
    [playerView setDelegate:self];
    playerView.backgroundColor = [UIColor blackColor];
    
//    UIImageView *videoImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, playerView.frame.origin.y + playerView.frame.size.height + 10, 100, 35)];
//    videoImg.image = [UIImage imageNamed:@"videoBtnImg.png"];
//    [self.view addSubview:videoImg];
    
    UIButton *videoImg = [[UIButton alloc] initWithFrame:CGRectMake(0, playerView.frame.origin.y + playerView.frame.size.height + 10, 100, 35)];
    [videoImg setBackgroundImage:[UIImage imageNamed:@"videoBtnImg.png"] forState:UIControlStateNormal];
    [videoImg setTitleColor:[UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0] forState:UIControlStateNormal];
//    [videoImg addTarget:self action:@selector(videoSendBtnClicked) forControlEvents:UIControlEventTouchUpInside];
//    [videoImg setTintColor:[UIColor lightGrayColor]];
//    videoImg.alpha = 1.0;
//    videoImg.transform = CGAffineTransformMakeTranslation(10, 0);
    [self.view addSubview:videoImg];
    
    videoSendBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 200, playerView.frame.origin.y + playerView.frame.size.height + 10, 200, 35)];
    [videoSendBtn setBackgroundImage:[UIImage imageNamed:@"videoSendImg.png"] forState:UIControlStateNormal];
    [videoSendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [videoSendBtn addTarget:self action:@selector(videoSendBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [videoSendBtn setTintColor:[UIColor lightGrayColor]];
    videoSendBtn.alpha = 1.0;
    videoSendBtn.transform = CGAffineTransformMakeTranslation(10, 0);
    [self.view addSubview:videoSendBtn];
    
    NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
    if ([applang isEqualToString:@"ko"]) {
        titleLbl.text = FANVOICE_TITLE[0];
        [videoSendBtn setTitle:FANVOICE_VIDEOSEND_BUTTON[0] forState:UIControlStateNormal];
        [videoImg setTitle:FANVOICE_VIDEO_LABEL[0] forState:UIControlStateNormal];
    }
    if ([applang isEqualToString:@"cn"]) {
        titleLbl.text = FANVOICE_TITLE[1];
        [videoSendBtn setTitle:FANVOICE_VIDEOSEND_BUTTON[1] forState:UIControlStateNormal];
        [videoImg setTitle:FANVOICE_VIDEO_LABEL[1] forState:UIControlStateNormal];
    }
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, videoSendBtn.frame.origin.y + videoSendBtn.frame.size.height + 10, self.view.frame.size.width, self.view.frame.size.height - (videoSendBtn.frame.origin.y + videoSendBtn.frame.size.height + 10))];
    scrollView.alwaysBounceHorizontal = NO;
    scrollView.alwaysBounceVertical = YES;
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    _collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, voiceArray.count*(self.view.frame.size.width/2)) collectionViewLayout:layout];
    [_collectionView setDataSource:self];
    [_collectionView setDelegate:self];
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [_collectionView setBackgroundColor:[UIColor clearColor]];
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 3;
    _collectionView.scrollEnabled = NO;
    [scrollView addSubview:_collectionView];
    
    // top
    AllAroundPullView *topPullView = [[AllAroundPullView alloc] initWithScrollView:scrollView position:AllAroundPullViewPositionTop action:^(AllAroundPullView *view){
        NSLog(@"--");
        [view performSelector:@selector(finishedLoading) withObject:nil afterDelay:4.0f];
        [self getRequest];
    }];
    topPullView.backgroundColor = [UIColor clearColor];
    topPullView.activityView.hidden = YES;
    
    NSData *gifData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"football1.gif" ofType:nil]];
    YFGIFImageView *gifView = [[YFGIFImageView alloc] initWithFrame:CGRectMake(topPullView.frame.size.width/2 - 90, topPullView.frame.size.height - 50, 180, 50)];
    gifView.backgroundColor = [UIColor clearColor];
    gifView.gifData = gifData;
    [topPullView addSubview:gifView];
    [gifView startGIF];
    gifView.userInteractionEnabled = YES;
    
    [scrollView addSubview:topPullView];
    
    [self.view addSubview:scrollView];
    [self.view addSubview:playerView];
    
    [self getRequest];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fanSliderViewDelegate) name:@"fanHideNaviDelegate" object:nil];
}

- (void)shareBtnClicked{
    NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
    if ([applang isEqualToString:@"ko"]) {
        NSArray* aryBtns = @[@"icon1.png", @"icon2.png", @"icon4.png", @"icon3.png"];
        NSArray* titleAry = @[@"微博", @"QQ", @"朋友圈", @"微信"];
        
        LXActivity *lxActivity = [[LXActivity alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"취소" ShareButtonTitles:titleAry withShareButtonImagesName:aryBtns];
        [lxActivity show];
    }
    if ([applang isEqualToString:@"cn"]) {
        NSArray* aryBtns = @[@"icon1.png", @"icon2.png", @"icon4.png", @"icon3.png"];
        NSArray* titleAry = @[@"微博", @"QQ", @"微信朋友圈", @"微信好友"];
        
        LXActivity *lxActivity = [[LXActivity alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"￼取消" ShareButtonTitles:titleAry withShareButtonImagesName:aryBtns];
        [lxActivity show];
    }
}

#pragma mark - LXActivityDelegate

- (void)didClickOnImageIndex:(NSInteger *)imageIndex
{
    UIGraphicsBeginImageContext(CGSizeMake(300,200));
    CGContextRef  context = UIGraphicsGetCurrentContext();
    [videoShareImg drawInRect: CGRectMake(0, 0, 300, 200)];
    UIImage *shareImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if (imageIndex == 0)
    {
        NSLog(@"shareByWeibo");
        NSString *video = [NSString stringWithFormat:@"Video %@", videoShareUrl];
        NSDictionary *shareDict = [NSDictionary
                                   dictionaryWithObjectsAndKeys:
                                   @"延边富德足球俱乐部", LDSDKShareContentTitleKey,
                                   @"视频", LDSDKShareContentDescriptionKey,
                                   videoShareUrl, LDSDKShareContentWapUrlKey,
                                   videoShareImg, LDSDKShareContentImageKey,
                                   video, LDSDKShareContentTextKey,
                                   nil];
        [[LDSDKManager getShareService:LDSDKPlatformWeibo]
         shareWithContent:shareDict
         shareModule:LDSDKShareToOther
         onComplete:^(BOOL success, NSError *error) {
             if (success) {
                 [ProgressHUD showSuccess:@"공유성공"];
             } else {
                 
             }
         }];
        
    }
    else if ((int)imageIndex == 1)
    {
        NSLog(@"shareByQQ");
        NSDictionary *shareDict = [NSDictionary
                                   dictionaryWithObjectsAndKeys:
                                   @"延边富德足球俱乐部", LDSDKShareContentTitleKey,
                                   @"视频", LDSDKShareContentDescriptionKey,
                                   videoShareUrl, LDSDKShareContentWapUrlKey,
                                   videoShareImg, LDSDKShareContentImageKey,
                                   @"视频", LDSDKShareContentTextKey,
                                   nil];
        [[LDSDKManager getShareService:LDSDKPlatformQQ]
         shareWithContent:shareDict
         shareModule:LDSDKShareToContact
         onComplete:^(BOOL success, NSError *error) {
             if (success) {
                 [ProgressHUD showSuccess:@"공유성공"];
             } else {
                 
             }
         }];
        
    }
    else if ((int)imageIndex == 2){
        NSLog(@"shareByWX");
        
        NSDictionary *shareDict = [NSDictionary
                                   dictionaryWithObjectsAndKeys:
                                   @"延边富德足球俱乐部", LDSDKShareContentTitleKey,
                                   @"视频", LDSDKShareContentDescriptionKey,
                                   videoShareUrl, LDSDKShareContentWapUrlKey,
                                   shareImg,LDSDKShareContentImageKey,
                                   @"视频", LDSDKShareContentTextKey,
                                   nil];
        [[LDSDKManager getShareService:LDSDKPlatformWeChat]
         shareWithContent:shareDict
         shareModule:LDSDKShareToTimeLine
         onComplete:^(BOOL success, NSError *error) {
             if (success) {
                 [ProgressHUD showSuccess:@"공유성공"];
             }
             else {
                 
             }
         }];
    }
    else if ((int)imageIndex == 3){
        NSLog(@"shareByWX");
        NSDictionary *shareDict = [NSDictionary
                                   dictionaryWithObjectsAndKeys:
                                   @"延边富德足球俱乐部", LDSDKShareContentTitleKey,
                                   @"视频", LDSDKShareContentDescriptionKey,
                                   videoShareUrl, LDSDKShareContentWapUrlKey,
                                   shareImg,LDSDKShareContentImageKey,
                                   @"视频", LDSDKShareContentTextKey,
                                   nil];
        [[LDSDKManager getShareService:LDSDKPlatformWeChat]
         shareWithContent:shareDict
         shareModule:LDSDKShareToContact
         onComplete:^(BOOL success, NSError *error) {
             if (success) {
                 [ProgressHUD showSuccess:@"공유성공"];
             }
             else {
                 
             }
         }];
    }
    else{
        
    }
}

- (void)fanSliderViewDelegate{
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)getRequest{
    NSString *isFirstLogin = [[NSUserDefaults standardUserDefaults] objectForKey:@"isLoginState"];
    if ([isFirstLogin isEqualToString:@"NO"]) {
        NSDictionary *parameters = @{@"userid":@"0",
                                     @"lastnewsid": @"0"
                                     };
        
        [SVProgressHUD showWithStatus:@"请稍后..." maskType:SVProgressHUDMaskTypeBlack];
        
        [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
        [[GlobalPool sharedInstance].OAuth2Manager POST:LC_FANVOICE_LIST parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //        NSLog(@"%@",responseObject);
            
            [SVProgressHUD dismiss];
            
            voiceArray = [NSMutableArray arrayWithArray:[responseObject objectForKey:@"voicelist"]];
            //        NSLog(@"%@",voiceArray);
            
            NSURL *URL = [NSURL URLWithString:[[voiceArray objectAtIndex:0] objectForKey:@"mediaurl"]];
            NSString *videoId = [[voiceArray objectAtIndex:0] objectForKey:@"voiceid"];
            videoShareUrl = [NSString stringWithFormat:@"http://123.57.173.92/share/video.php?videoID=%@", videoId];
            NSString *path = [[voiceArray objectAtIndex:0] objectForKey:@"thumburl"];
            videoShareImg = [UIImage imageWithData: [NSData dataWithContentsOfURL:[NSURL URLWithString:path]]];
            
            playerView = [[PlayerView alloc] initWithFrame:CGRectMake(0, 65, self.view.frame.size.width, self.view.frame.size.width*9.0f/16.0f)];
            [playerView setDelegate:self];
            playerView.backgroundColor = [UIColor blackColor];
            [playerView setVideoURL:URL];
            [self.view addSubview:playerView];
            [playerView prepareAndPlayAutomatically:NO];
            
            
            NSUInteger count = voiceArray.count;
            if (count%2 == 0) {
                _collectionView.frame = CGRectMake(0, 0, self.view.frame.size.width, voiceArray.count*(self.view.frame.size.width/2)/2);
                
                scrollView.contentSize = CGSizeMake(self.view.frame.size.width, _collectionView.frame.size.height + 5);
            }
            else{
                _collectionView.frame = CGRectMake(0, 0, self.view.frame.size.width, (voiceArray.count/2+1)*(self.view.frame.size.width/2));
                
                scrollView.contentSize = CGSizeMake(self.view.frame.size.width, _collectionView.frame.size.height + 5);
            }
            
            [_collectionView reloadData];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"Connection failed"];
        }];
    }
    else{
        NSString *userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"];
        NSDictionary *parameters = @{@"userid":userid,
                                     @"lastnewsid": @"0"
                                     };
        
        [SVProgressHUD showWithStatus:@"请稍后..." maskType:SVProgressHUDMaskTypeBlack];
        
        [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
        [[GlobalPool sharedInstance].OAuth2Manager POST:LC_FANVOICE_LIST parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //        NSLog(@"%@",responseObject);
            
            [SVProgressHUD dismiss];
            
            voiceArray = [NSMutableArray arrayWithArray:[responseObject objectForKey:@"voicelist"]];
            //        NSLog(@"%@",voiceArray);
            
            NSURL *URL = [NSURL URLWithString:[[voiceArray objectAtIndex:0] objectForKey:@"mediaurl"]];
            NSString *videoId = [[voiceArray objectAtIndex:0] objectForKey:@"voiceid"];
            videoShareUrl = [NSString stringWithFormat:@"http://123.57.173.92/share/video.php?videoID=%@", videoId];
            NSString *path = [[voiceArray objectAtIndex:0] objectForKey:@"thumburl"];
            videoShareImg = [UIImage imageWithData: [NSData dataWithContentsOfURL:[NSURL URLWithString:path]]];
            
            playerView = [[PlayerView alloc] initWithFrame:CGRectMake(0, 65, self.view.frame.size.width, self.view.frame.size.width*9.0f/16.0f)];
            [playerView setDelegate:self];
            playerView.backgroundColor = [UIColor blackColor];
            [playerView setVideoURL:URL];
            [self.view addSubview:playerView];
            [playerView prepareAndPlayAutomatically:NO];
            
            
            NSUInteger count = voiceArray.count;
            if (count%2 == 0) {
                _collectionView.frame = CGRectMake(0, 0, self.view.frame.size.width, voiceArray.count*(self.view.frame.size.width/2)/2);
                
                scrollView.contentSize = CGSizeMake(self.view.frame.size.width, _collectionView.frame.size.height + 5);
            }
            else{
                _collectionView.frame = CGRectMake(0, 0, self.view.frame.size.width, (voiceArray.count/2+1)*(self.view.frame.size.width/2));
                
                scrollView.contentSize = CGSizeMake(self.view.frame.size.width, _collectionView.frame.size.height + 5);
            }
            
            [_collectionView reloadData];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"Connection failed"];
        }];
    }
    
}

#pragma mark - UICollectionView data source

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return voiceArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize retval;
    retval =  CGSizeMake(self.view.frame.size.width/2, self.view.frame.size.width/2 - 5);
    return retval;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    if (cell==nil)
    {
        cell.backgroundColor=[UIColor clearColor];
        
    }
    else
    {
        for (UIView *view in cell.contentView.subviews)
            [view removeFromSuperview];
    }
    
    UIImageView *back = [[UIImageView alloc] init];
    back.backgroundColor = [UIColor blackColor];
    back.frame = CGRectMake(10, 5, cell.frame.size.width - 20, cell.frame.size.height - 30);
//    back.contentMode = UIViewContentModeScaleAspectFit;
    [cell.contentView addSubview:back];
    
    UILabel *lbl_title = [[UILabel alloc]initWithFrame:CGRectMake(0, cell.frame.size.height - 20, cell.frame.size.width, 20)];
    [lbl_title setTextColor:[UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0]];
    [lbl_title setBackgroundColor:[UIColor clearColor]];
    [lbl_title setFont:[UIFont systemFontOfSize:15.0]];
    [lbl_title setTextAlignment:NSTextAlignmentCenter];
    [cell.contentView addSubview:lbl_title];
    
//    NSString *path = [[voiceArray objectAtIndex:indexPath.row] objectForKey:@"mediaurl"];
//    UIImage *thumbImg = [self generateThumbImage:path];
//    back.image = thumbImg;
    
    NSString *path = [[voiceArray objectAtIndex:indexPath.row] objectForKey:@"thumburl"];
    [back setImageWithURL:[NSURL URLWithString:path]];
    
    lbl_title.text = [[voiceArray objectAtIndex:indexPath.row] objectForKey:@"date"];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSURL *URL = [NSURL URLWithString:[[voiceArray objectAtIndex:indexPath.row] objectForKey:@"mediaurl"]];
    NSString *videoId = [[voiceArray objectAtIndex:indexPath.row] objectForKey:@"voiceid"];
    videoShareUrl = [NSString stringWithFormat:@"http://123.57.173.92/share/video.php?videoID=%@", videoId];
    NSString *path = [[voiceArray objectAtIndex:indexPath.row] objectForKey:@"thumburl"];
    videoShareImg = [UIImage imageWithData: [NSData dataWithContentsOfURL:[NSURL URLWithString:path]]];
    
    [self addPlayerWithURL:URL];
}

-(UIImage *)generateThumbImage : (NSString *)filepath
{
    NSURL *url = [NSURL URLWithString:filepath];
    
    AVAsset *asset = [AVAsset assetWithURL:url];
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc]initWithAsset:asset];
    CMTime time = [asset duration];
    time.value = 0;
    CGImageRef imageRef = [imageGenerator copyCGImageAtTime:time actualTime:NULL error:NULL];
    UIImage *thumbnail = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);  // CGImageRef won't be released by ARC
    
    return thumbnail;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)addPlayerWithURL:(NSURL*)videoURL{
    [playerView clean];
    playerView = [[PlayerView alloc] initWithFrame:CGRectMake(0, 65, self.view.frame.size.width, self.view.frame.size.width*9.0f/16.0f)];
    [playerView setDelegate:self];
    playerView.backgroundColor = [UIColor blackColor];
    [playerView setVideoURL:videoURL];
    [self.view addSubview:playerView];
    [playerView prepareAndPlayAutomatically:NO];
}

- (void)videoSendBtnClicked{
    NSString *isFirstLogin = [[NSUserDefaults standardUserDefaults] objectForKey:@"isLoginState"];
    if ([isFirstLogin isEqualToString:@"NO"]) {
//        [[AppDelegate sharedAppDelegate] runLogin];
        FirstViewController *loginView = [[FirstViewController alloc] init];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:loginView];
        navi.navigationBarHidden = YES;
        navi.modalPresentationStyle = UIModalPresentationCurrentContext;
        [self presentViewController:navi animated:YES completion:nil];
    }
    else{
        SendViedoViewController *send_view = [[SendViedoViewController alloc] init];
        [self.navigationController pushViewController:send_view animated:YES];
    }
}

#pragma mark - GUI Player View Delegate Methods

- (void)playerWillEnterFullscreen {
    [[self navigationController] setNavigationBarHidden:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
}

- (void)playerWillLeaveFullscreen {
    [[self navigationController] setNavigationBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

- (void)playerDidEndPlaying {
    [playerView stop];
}

- (void)playerFailedToPlayToEnd {
    NSLog(@"Error: could not play video");
    //[playerView clean];
}

- (void)backBtnClicked{
    if(self.sidebarController.sidebarIsPresenting)
    {
        [self.sidebarController dismissSidebarViewController];
    }
    else
    {
        [playerView clean];
        
        NSString *isFirstLogin = [[NSUserDefaults standardUserDefaults] objectForKey:@"isLoginState"];
        if ([isFirstLogin isEqualToString:@"NO"]) {
        }
        else{
            NSString *userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"];
            NSDictionary *parameters = @{@"userid":userid
                                         };
            
            [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
            [[GlobalPool sharedInstance].OAuth2Manager POST:LC_ONLINE_STATE parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"%@",responseObject);
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [SVProgressHUD showErrorWithStatus:@"Connection failed"];
            }];
        }
        
        [self.sidebarController presentLeftSidebarViewController];
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
