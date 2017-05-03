//
//  BroadViewController.m
//  YFC
//
//  Created by topone on 7/17/15.
//  Copyright (c) 2015 ming. All rights reserved.
//

#import "publicHeaders.h"
#import "GUIPlayerView.h"

#import "BroadViewController.h"
#import "TheSidebarController.h"
#import "FillViewController.h"
#import "FirstViewController.h"

#import "YFGIFImageView.h"
#import "UIImageView+PlayGIF.h"

#import "LXActivity.h"
#import "WXApi.h"

#import "LDSDKManager.h"

#import "LDSDKRegisterService.h"
#import "LDSDKPayService.h"
#import "LDSDKAuthService.h"
#import "LDSDKShareService.h"

@interface BroadViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, GUIPlayerViewDelegate, UIAlertViewDelegate, LXActivityDelegate, WXApiDelegate>
{
    UITableView *chatTable;
    NSMutableArray *chatArray;
    NSMutableArray *scrollChatArray;
    
    UIView *sendView;
    UITextField *sendText;
    UIImageView *chatBackImg;
    
    NSDictionary *liveBroad;
    
    NSString *lastID;
    NSString *liveID;
    
    UILabel *totalBallLbl;
    
    YFGIFImageView *gifView_Load;
    
    NSTimer *_timer;
    
    BOOL isJoin;
    
    NSString *videoShareUrl;
}
@property (strong, nonatomic) GUIPlayerView *playerView;

@end

@implementation BroadViewController
@synthesize playerView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isJoin = NO;
    lastID = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastID"];
    
    if (lastID == nil) {
        lastID = @"0";
    }
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    chatArray = [[NSMutableArray alloc] init];
    scrollChatArray = [[NSMutableArray alloc] init];
    
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
    titleLbl.text = @"생 방 송";
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
    
    playerView = [[GUIPlayerView alloc] initWithFrame:CGRectMake(0, 65, self.view.frame.size.width, self.view.frame.size.width*9.0f/16.0f)];
    [playerView setDelegate:self];
    playerView.backgroundColor = [UIColor blackColor];
    
    UIButton *totalBallBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, playerView.frame.origin.y + playerView.frame.size.height + 10, 25, 25)];
    [totalBallBtn setImage:[UIImage imageNamed:@"blueBall.png"] forState:UIControlStateNormal];
    [totalBallBtn addTarget:self action:@selector(totalBallBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [totalBallBtn setTintColor:[UIColor lightGrayColor]];
    totalBallBtn.alpha = 1.0;
    totalBallBtn.transform = CGAffineTransformMakeTranslation(10, 0);
    [self.view addSubview:totalBallBtn];
    
    totalBallLbl = [[UILabel alloc] initWithFrame:CGRectMake(totalBallBtn.frame.origin.x + totalBallBtn.frame.size.width + 10, playerView.frame.origin.y + playerView.frame.size.height + 10, 80, 24)];
    totalBallLbl.font = [UIFont systemFontOfSize:15.0];
    totalBallLbl.textAlignment = NSTextAlignmentLeft;
    totalBallLbl.textColor = [UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0];
    [self.view addSubview:totalBallLbl];
    
    UIButton *redBallBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 45, playerView.frame.origin.y + playerView.frame.size.height + 2, 25, 25)];
    [redBallBtn setImage:[UIImage imageNamed:@"redBall.png"] forState:UIControlStateNormal];
    [redBallBtn addTarget:self action:@selector(redBallBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [redBallBtn setTintColor:[UIColor lightGrayColor]];
    redBallBtn.alpha = 1.0;
    redBallBtn.tag = 1002;
    redBallBtn.transform = CGAffineTransformMakeTranslation(10, 0);
    [self.view addSubview:redBallBtn];
    
    UILabel *redballLbl = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 35, redBallBtn.frame.origin.y + redBallBtn.frame.size.height, 25, 15)];
    redballLbl.text = @"100";
    redballLbl.font = [UIFont systemFontOfSize:12];
    redballLbl.textAlignment = NSTextAlignmentCenter;
    redballLbl.textColor = [UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0];
    [self.view addSubview:redballLbl];
    
    UIButton *yellowBallBtn = [[UIButton alloc] initWithFrame:CGRectMake(redBallBtn.frame.origin.x - 45, playerView.frame.origin.y + playerView.frame.size.height + 2, 25, 25)];
    [yellowBallBtn setImage:[UIImage imageNamed:@"yellowBall.png"] forState:UIControlStateNormal];
    [yellowBallBtn addTarget:self action:@selector(yelloBallBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [yellowBallBtn setTintColor:[UIColor lightGrayColor]];
    yellowBallBtn.alpha = 1.0;
    yellowBallBtn.transform = CGAffineTransformMakeTranslation(10, 0);
    yellowBallBtn.tag = 1001;
    [self.view addSubview:yellowBallBtn];
    
    UILabel *yellowballLbl = [[UILabel alloc] initWithFrame:CGRectMake(redBallBtn.frame.origin.x - 35, yellowBallBtn.frame.origin.y + yellowBallBtn.frame.size.height, 25, 15)];
    yellowballLbl.text = @"10";
    yellowballLbl.font = [UIFont systemFontOfSize:12];
    yellowballLbl.textAlignment = NSTextAlignmentCenter;
    yellowballLbl.textColor = [UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0];
    [self.view addSubview:yellowballLbl];
    
    UIButton *blueBallBtn = [[UIButton alloc] initWithFrame:CGRectMake(yellowBallBtn.frame.origin.x - 45, playerView.frame.origin.y + playerView.frame.size.height + 2, 25, 25)];
    [blueBallBtn setImage:[UIImage imageNamed:@"blueBall.png"] forState:UIControlStateNormal];
    [blueBallBtn addTarget:self action:@selector(blueBallBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [blueBallBtn setTintColor:[UIColor lightGrayColor]];
    blueBallBtn.alpha = 1.0;
    blueBallBtn.transform = CGAffineTransformMakeTranslation(10, 0);
    blueBallBtn.tag = 1000;
    [self.view addSubview:blueBallBtn];
    
    UILabel *blueballLbl = [[UILabel alloc] initWithFrame:CGRectMake(yellowBallBtn.frame.origin.x - 35, blueBallBtn.frame.origin.y + blueBallBtn.frame.size.height, 25, 15)];
    blueballLbl.text = @"1";
    blueballLbl.font = [UIFont systemFontOfSize:12];
    blueballLbl.textAlignment = NSTextAlignmentCenter;
    blueballLbl.textColor = [UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0];
    [self.view addSubview:blueballLbl];
    
    UIButton *qungjenBtn = [[UIButton alloc] initWithFrame:CGRectMake(blueBallBtn.frame.origin.x - 80, playerView.frame.origin.y + playerView.frame.size.height + 10, 60, 24)];
    [qungjenBtn setBackgroundImage:[UIImage imageNamed:@"ballPayBtn.png"] forState:UIControlStateNormal];
    [qungjenBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    [qungjenBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [qungjenBtn addTarget:self action:@selector(qungjenBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [qungjenBtn setTintColor:[UIColor lightGrayColor]];
    qungjenBtn.layer.cornerRadius = 5;
    qungjenBtn.layer.masksToBounds = YES;
    [self.view addSubview:qungjenBtn];
    
    chatBackImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, blueBallBtn.frame.origin.y + blueBallBtn.frame.size.height + 15, self.view.frame.size.width, 5*100 + 5)];
    chatBackImg.image = [UIImage imageNamed:@"chatBackImg.png"];
    chatBackImg.alpha = 0.65;
    [self.view addSubview:chatBackImg];
    
    chatTable = [[UITableView alloc] initWithFrame:CGRectMake(0, chatBackImg.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height - chatBackImg.origin.y - 50) style:UITableViewStylePlain];
    chatTable.dataSource = self;
    chatTable.delegate = self;
    [chatTable setBackgroundColor:[UIColor clearColor]];
    chatTable.userInteractionEnabled=YES;
    [chatTable setAllowsSelection:YES];
    if ([chatTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [chatTable setSeparatorInset:UIEdgeInsetsZero];
    }
    [chatTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:chatTable];
    
    sendView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50)];
    sendView.backgroundColor = [UIColor whiteColor];
    
    UIButton *sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(sendView.frame.size.width - 100, 5, 80, 40)];
    sendBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [sendBtn setTitleColor:[UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(sendBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [sendBtn setTintColor:[UIColor lightGrayColor]];
    sendBtn.alpha = 1.0;
    sendBtn.transform = CGAffineTransformMakeTranslation(10, 0);
    [sendView addSubview:sendBtn];
    
    UIImageView *lineImg1 = [[UIImageView alloc] initWithFrame:CGRectMake(20, 5, sendView.frame.size.width - 120, 40)];
    lineImg1.backgroundColor = [UIColor clearColor];
    lineImg1.layer.cornerRadius = 5;
    lineImg1.layer.borderColor = [UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0].CGColor;
    lineImg1.layer.borderWidth = 1;
    lineImg1.layer.masksToBounds = YES;
    [sendView addSubview:lineImg1];
    
    sendText = [[UITextField alloc] initWithFrame:CGRectMake(25, 8, sendView.frame.size.width - 130, 34)];
    sendText.backgroundColor = [UIColor whiteColor];
    sendText.textColor = [UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0];
    sendText.font = [UIFont systemFontOfSize:15.0];
    sendText.keyboardType = UIKeyboardTypeDefault;
    sendText.delegate = self;
    [sendText setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [sendView addSubview:sendText];
    
    NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
    if ([applang isEqualToString:@"ko"]) {
        titleLbl.text = BROADCAST_TITLE[0];
        [qungjenBtn setTitle:BROADCAST_QUNGJEN_BUTTON[0] forState:UIControlStateNormal];
        [sendBtn setTitle:BROADCAST_SEND_BUTTON[0] forState:UIControlStateNormal];
        sendText.placeholder = BROADCAST_MESSAGE[0];
    }
    if ([applang isEqualToString:@"cn"]) {
        titleLbl.text = BROADCAST_TITLE[1];
        [qungjenBtn setTitle:BROADCAST_QUNGJEN_BUTTON[1] forState:UIControlStateNormal];
        [sendBtn setTitle:BROADCAST_SEND_BUTTON[1] forState:UIControlStateNormal];
        sendText.placeholder = BROADCAST_MESSAGE[1];
    }
    
    [self.view addSubview:sendView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    [self.view addGestureRecognizer:tapGesture];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sliderViewDelegate) name:@"hideNaviDelegate" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendMessageNoty) name:@"sendMessageNoty" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(braodkeyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(braodkeyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detectOrientation:) name:@"UIDeviceOrientationDidChangeNotification" object:nil];
    
    [self.view addSubview:playerView];
}

-(void)braodkeyboardWillShow:(NSNotification *)notification {
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    //    int height = MIN(keyboardSize.height,keyboardSize.width);
    
    [UIView animateWithDuration:0.2 animations:^{
        sendView.frame = CGRectMake(0, self.view.frame.size.height - keyboardSize.height - 50, self.view.frame.size.width, 50);
    }completion:^(BOOL finished){
        
    }];
}

-(void)braodkeyboardWillHide:(NSNotification *)notification {
    [UIView animateWithDuration:0.2 animations:^{
        sendView.frame = CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50);
    }completion:^(BOOL finished){
        
    }];
}

- (void)_timerFired:(NSTimer *)timer {
    [self reLoadMessages];
}

- (void)reLoadMessages
{
    @autoreleasepool
    {
        NSDictionary *parameters1 = @{@"lastid": lastID
                                      };
        
        [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
        [[GlobalPool sharedInstance].OAuth2Manager POST:LC_BroadCast_LOAD_MESSAGE parameters:parameters1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSLog(@"timer==%@",responseObject);
            
            scrollChatArray = [NSMutableArray arrayWithArray:[responseObject objectForKey:@"messages"]];
            
            if (scrollChatArray.count == 0) {
                
            }
            else{
                [chatArray addObjectsFromArray:scrollChatArray];
                lastID = [[scrollChatArray objectAtIndex:0] objectForKey:@"messageid"];
                [chatTable setContentOffset:CGPointMake(0, chatArray.count * 80 - chatTable.frame.origin.y) animated:YES];
                
                NSString *strChat = @"";
                for (int i = 0 ; i < scrollChatArray.count; i++) {
                    NSString *name = [[scrollChatArray objectAtIndex:i] objectForKey:@"nickname"];
                    if ([[[scrollChatArray objectAtIndex:i] objectForKey:@"nickname"] isEqualToString:@""]) {
                        name = @"Admin";
                    }
                    NSString *chat = [[scrollChatArray objectAtIndex:i] objectForKey:@"message"];
                    strChat = [NSString stringWithFormat:@"%@      -%@: %@", strChat, name, chat];
                }
                
                [[NSUserDefaults standardUserDefaults] setObject:strChat forKey:@"scrollChats"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"changeChatContents" object:nil];
                
                [chatTable reloadData];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"Connection failed"];
        }];
    }
    
}

- (void)qungjenBtnClicked{
    NSString *isFirstLogin = [[NSUserDefaults standardUserDefaults] objectForKey:@"isLoginState"];
    if ([isFirstLogin isEqualToString:@"NO"]) {
//        [[AppDelegate sharedAppDelegate] runLogin];
        FirstViewController *loginView = [[FirstViewController alloc] init];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:loginView];
        navi.modalPresentationStyle = UIModalPresentationCurrentContext;
        navi.navigationBar.hidden = YES;
        [self presentViewController:navi animated:YES completion:nil];
    }
    else{
        FillViewController *fillView = [[FillViewController alloc] init];
        [self.navigationController pushViewController:fillView animated:YES];
    }
    
}

- (void)sliderViewDelegate{
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    [self getRequest];
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
    if (imageIndex == 0)
    {
        NSLog(@"shareByWeibo");
        NSDictionary *shareDict = [NSDictionary
                                   dictionaryWithObjectsAndKeys:@"延边富德足球俱乐部", LDSDKShareContentTitleKey,
                                   @"直播", LDSDKShareContentDescriptionKey,
                                   videoShareUrl, LDSDKShareContentWapUrlKey,
                                   [UIImage imageNamed:@"mark.png"], LDSDKShareContentImageKey,
                                   videoShareUrl, LDSDKShareContentTextKey,
                                   nil];
        [[LDSDKManager getShareService:LDSDKPlatformWeibo]
         shareWithContent:shareDict
         shareModule:LDSDKShareToContact
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
                                   dictionaryWithObjectsAndKeys:@"延边富德足球俱乐部", LDSDKShareContentTitleKey,
                                   @"直播", LDSDKShareContentDescriptionKey,
                                   videoShareUrl, LDSDKShareContentWapUrlKey,
                                   [UIImage imageNamed:@"mark.png"], LDSDKShareContentImageKey,
                                   @"直播", LDSDKShareContentTextKey,
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
                                   @"直播", LDSDKShareContentDescriptionKey,
                                   videoShareUrl, LDSDKShareContentWapUrlKey,
                                   [UIImage imageNamed:@"mark.png"],LDSDKShareContentImageKey,
                                   @"直播", LDSDKShareContentTextKey,
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
                                   @"直播", LDSDKShareContentDescriptionKey,
                                   videoShareUrl, LDSDKShareContentWapUrlKey,
                                   [UIImage imageNamed:@"mark.png"],LDSDKShareContentImageKey,
                                   @"直播", LDSDKShareContentTextKey,
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

- (void)getAllMessages{
    NSDictionary *parameters1 = @{@"lastid": lastID
                                  };
    
    [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
    [[GlobalPool sharedInstance].OAuth2Manager POST:LC_BroadCast_ALLMESSAGE parameters:parameters1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"%@",responseObject);
        
        [SVProgressHUD dismiss];
        
        scrollChatArray = [NSMutableArray arrayWithArray:[responseObject objectForKey:@"messages"]];
        
        chatArray =[[[scrollChatArray reverseObjectEnumerator] allObjects] mutableCopy];
        
        [chatTable setContentOffset:CGPointMake(0, chatArray.count * 80 - chatTable.frame.origin.y) animated:YES];
        [chatTable reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"Connection failed"];
    }];
    
}

- (void)getRequest{
    NSString *isFirstLogin = [[NSUserDefaults standardUserDefaults] objectForKey:@"isLoginState"];
    if ([isFirstLogin isEqualToString:@"NO"]) {
        NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];

        NSDictionary *parameters = @{@"userid":@"0",
                                     @"deviceid":deviceToken,
                                     @"lastnewsid": lastID
                                     };
        
        [SVProgressHUD showWithStatus:@"请稍后..." maskType:SVProgressHUDMaskTypeBlack];
        
        [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
        [[GlobalPool sharedInstance].OAuth2Manager POST:LC_BroadCast_LIST parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@",responseObject);
            
            NSString *status = [responseObject objectForKey:@"status"];
            
            if ([status intValue] == 200) {
                liveBroad = [responseObject objectForKey:@ "livebroadcast"];
                liveID = [liveBroad objectForKey:@"liveid"];
                totalBallLbl.text = @"0";
                
                lastID = [responseObject objectForKey:@"lastid"];
                
                NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:lastID forKey:@"lastID"];
                [defaults synchronize];
    
                //            NSURL *URL = [NSURL URLWithString:[liveBroad objectForKey:@"liveurl"]];
                //            videoShareUrl = [liveBroad objectForKey:@"liveurl"];
                videoShareUrl = @"http://mlive.iybtv.com:8012/MJqQNlZ/500/live.m3u8";
                NSURL *URL = [NSURL URLWithString:@"http://mlive.iybtv.com:8012/MJqQNlZ/500/live.m3u8"];
                
                [self addPlayerWithURL:URL];
                
                NSDictionary *parameters2 = @{@"deviceid":deviceToken,
                                              @"liveid": liveID
                                              };
                
                [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
                [[GlobalPool sharedInstance].OAuth2Manager POST:LC_BroadCast_JOIN_LIVE parameters:parameters2 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    //                NSLog(@"%@",responseObject);
                    [SVProgressHUD dismiss];
                    
                    NSString *status = [responseObject objectForKey:@"status"];
                    
                    if ([status intValue] == 200) {
                        _timer = [NSTimer scheduledTimerWithTimeInterval:3.0f
                                                                  target:self
                                                                selector:@selector(_timerFired:)
                                                                userInfo:nil
                                                                 repeats:YES];
                        isJoin = YES;
                        [self getAllMessages];
                    }
                    else{
                        isJoin = NO;
                        NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
                        if ([applang isEqualToString:@"ko"]) {
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"가입이 실패하였습니다." delegate:self cancelButtonTitle:@"다시 시도해주세요." otherButtonTitles:nil, nil];
                            alert.tag = 1000;
                            [alert show];
                        }
                        if ([applang isEqualToString:@"cn"]) {
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"登录失败" delegate:self cancelButtonTitle:@"请重试" otherButtonTitles:nil, nil];
                            alert.tag = 1000;
                            [alert show];
                        }
                    }
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [SVProgressHUD showErrorWithStatus:@"Connection failed"];
                    isJoin = NO;
                    NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
                    if ([applang isEqualToString:@"ko"]) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"가입이 실패하였습니다." delegate:self cancelButtonTitle:@"다시 시도해주세요." otherButtonTitles:nil, nil];
                        alert.tag = 1000;
                        [alert show];
                    }
                    if ([applang isEqualToString:@"cn"]) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"登录失败" delegate:self cancelButtonTitle:@"请重试" otherButtonTitles:nil, nil];
                        alert.tag = 1000;
                        [alert show];
                    }
                }];
            }
            else{
                [SVProgressHUD dismiss];
                isJoin = NO;
                NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
                if ([applang isEqualToString:@"ko"]) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"가입이 실패하였습니다." delegate:self cancelButtonTitle:@"다시 시도해주세요." otherButtonTitles:nil, nil];
                    alert.tag = 1000;
                    [alert show];
                }
                if ([applang isEqualToString:@"cn"]) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"登录失败" delegate:self cancelButtonTitle:@"请重试" otherButtonTitles:nil, nil];
                    alert.tag = 1000;
                    [alert show];
                }
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            isJoin = NO;
            NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
            if ([applang isEqualToString:@"ko"]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"가입이 실패하였습니다." delegate:self cancelButtonTitle:@"다시 시도해주세요." otherButtonTitles:nil, nil];
                alert.tag = 1000;
                [alert show];
            }
            if ([applang isEqualToString:@"cn"]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"登录失败" delegate:self cancelButtonTitle:@"请重试" otherButtonTitles:nil, nil];
                alert.tag = 1000;
                [alert show];
            }
            [SVProgressHUD showErrorWithStatus:@"Connection failed"];
        }];
    }
    else{
        NSString *userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"];
        NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
        
        NSDictionary *parameters = @{@"userid":userid,
                                     @"deviceid":deviceToken,
                                     @"lastnewsid": lastID
                                     };
        
        [SVProgressHUD showWithStatus:@"请稍后..." maskType:SVProgressHUDMaskTypeBlack];
        
        [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
        [[GlobalPool sharedInstance].OAuth2Manager POST:LC_BroadCast_LIST parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //        NSLog(@"%@",responseObject);
            
            NSString *status = [responseObject objectForKey:@"status"];
            
            if ([status intValue] == 200) {
                liveBroad = [responseObject objectForKey:@ "livebroadcast"];
                liveID = [liveBroad objectForKey:@"liveid"];
                totalBallLbl.text = [responseObject objectForKey:@"ballcount"];
                
                lastID = [responseObject objectForKey:@"lastid"];
                
                NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:lastID forKey:@"lastID"];
                [defaults synchronize];
                
                //            NSURL *URL = [NSURL URLWithString:[liveBroad objectForKey:@"liveurl"]];
                //            videoShareUrl = [liveBroad objectForKey:@"liveurl"];
                videoShareUrl = @"http://mlive.iybtv.com:8012/MJqQNlZ/500/live.m3u8";
                NSURL *URL = [NSURL URLWithString:@"http://mlive.iybtv.com:8012/MJqQNlZ/500/live.m3u8"];
                
                [self addPlayerWithURL:URL];
                
                NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
                NSDictionary *parameters2 = @{@"deviceid":deviceToken,
                                              @"liveid": liveID
                                              };
                
                [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
                [[GlobalPool sharedInstance].OAuth2Manager POST:LC_BroadCast_JOIN_LIVE parameters:parameters2 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    //                NSLog(@"%@",responseObject);
                    [SVProgressHUD dismiss];
                    
                    NSString *status = [responseObject objectForKey:@"status"];
                    
                    if ([status intValue] == 200) {
                        _timer = [NSTimer scheduledTimerWithTimeInterval:3.0f
                                                                  target:self
                                                                selector:@selector(_timerFired:)
                                                                userInfo:nil
                                                                 repeats:YES];
                        isJoin = YES;
                        [self getAllMessages];
                    }
                    else{
                        isJoin = NO;
                        NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
                        if ([applang isEqualToString:@"ko"]) {
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"가입이 실패하였습니다." delegate:self cancelButtonTitle:@"다시 시도해주세요." otherButtonTitles:nil, nil];
                            alert.tag = 1000;
                            [alert show];
                        }
                        if ([applang isEqualToString:@"cn"]) {
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"登录失败" delegate:self cancelButtonTitle:@"请重试" otherButtonTitles:nil, nil];
                            alert.tag = 1000;
                            [alert show];
                        }
                    }
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [SVProgressHUD showErrorWithStatus:@"Connection failed"];
                    isJoin = NO;
                    NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
                    if ([applang isEqualToString:@"ko"]) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"가입이 실패하였습니다." delegate:self cancelButtonTitle:@"다시 시도해주세요." otherButtonTitles:nil, nil];
                        alert.tag = 1000;
                        [alert show];
                    }
                    if ([applang isEqualToString:@"cn"]) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"登录失败" delegate:self cancelButtonTitle:@"请重试" otherButtonTitles:nil, nil];
                        alert.tag = 1000;
                        [alert show];
                    }
                }];
            }
            else{
                [SVProgressHUD dismiss];
                isJoin = NO;
                NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
                if ([applang isEqualToString:@"ko"]) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"가입이 실패하였습니다." delegate:self cancelButtonTitle:@"다시 시도해주세요." otherButtonTitles:nil, nil];
                    alert.tag = 1000;
                    [alert show];
                }
                if ([applang isEqualToString:@"cn"]) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"登录失败" delegate:self cancelButtonTitle:@"请重试" otherButtonTitles:nil, nil];
                    alert.tag = 1000;
                    [alert show];
                }
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            isJoin = NO;
            NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
            if ([applang isEqualToString:@"ko"]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"가입이 실패하였습니다." delegate:self cancelButtonTitle:@"다시 시도해주세요." otherButtonTitles:nil, nil];
                alert.tag = 1000;
                [alert show];
            }
            if ([applang isEqualToString:@"cn"]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"登录失败" delegate:self cancelButtonTitle:@"请重试" otherButtonTitles:nil, nil];
                alert.tag = 1000;
                [alert show];
            }
            [SVProgressHUD showErrorWithStatus:@"Connection failed"];
        }];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1000) {
        [playerView clean];
        [sendText resignFirstResponder];
        [self.sidebarController presentLeftSidebarViewController];
    }
}

- (void)addPlayerWithURL:(NSURL*)videoURL{
    [playerView stop];
    [playerView setVideoURL:videoURL];
    [playerView prepareAndPlayAutomatically:NO];
}

- (void)viewTapped:(UIGestureRecognizer *)gesture {
    [sendText resignFirstResponder];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    NSString *isFirstLogin = [[NSUserDefaults standardUserDefaults] objectForKey:@"isLoginState"];
    if ([isFirstLogin isEqualToString:@"NO"]) {
//        [[AppDelegate sharedAppDelegate] runLogin];
        FirstViewController *loginView = [[FirstViewController alloc] init];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:loginView];
        navi.navigationBarHidden = YES;
        navi.modalPresentationStyle = UIModalPresentationCurrentContext;
        [self presentViewController:navi animated:YES completion:nil];
        
        return NO;
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)sendMessageNoty{
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
        NSString *sendMessage = [[NSUserDefaults standardUserDefaults] objectForKey:@"sendMessage"];
        NSString *userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"];
        NSDictionary *parameters = @{@"userid": userid,
                                     @"message": sendMessage,
                                     @"liveid": liveID,
                                     @"lastid": lastID
                                     };
        
        [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
        [[GlobalPool sharedInstance].OAuth2Manager POST:LC_BroadCast_LEAVE_MESSAGE parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@",responseObject);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"Connection failed"];
        }];
    }
    
}

- (void)sendBtnClicked{
    [sendText resignFirstResponder];
    
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
        NSString *userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"];
        NSString *sessionkey = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionkey"];
        
        NSDictionary *parameters = @{@"userid": userid,
                                     @"message": sendText.text,
                                     @"liveid": liveID,
                                     @"sessionkey":sessionkey,
                                     @"lastid": lastID
                                     };
        
        sendText.text = @"";
        
        [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
        [[GlobalPool sharedInstance].OAuth2Manager POST:LC_BroadCast_LEAVE_MESSAGE parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@",responseObject);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"Connection failed"];
        }];
    }
    
    
}

#pragma mark - tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return chatArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.backgroundColor=[UIColor clearColor];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.accessoryType=UITableViewCellAccessoryNone;
        
    }
    else
    {
        UIView *subview;
        while ((subview= [[[cell contentView]subviews]lastObject])!=nil)
            [subview removeFromSuperview];
    }
    
    UIImageView *photoImage =[UIImageView new];
    photoImage.frame=CGRectMake(20, 10, 40, 40);
    photoImage.clipsToBounds = YES;
    photoImage.userInteractionEnabled=YES;
    photoImage.backgroundColor = [UIColor blackColor];
    photoImage.layer.cornerRadius = 20;
    photoImage.layer.masksToBounds = YES;
    photoImage.contentMode = UIViewContentModeScaleToFill;
    [cell.contentView addSubview:photoImage];
    
    UILabel *lbl_Name = [[UILabel alloc]init];
    [lbl_Name setFrame:CGRectMake(0, 60, 80, 20)];
    [lbl_Name setTextAlignment:NSTextAlignmentCenter];
    [lbl_Name setTextColor:[UIColor blackColor]];
    [lbl_Name setBackgroundColor:[UIColor clearColor]];
    [lbl_Name setFont:[UIFont systemFontOfSize:14.0]];
    [cell.contentView addSubview:lbl_Name];
    
    NSString *type = [[chatArray objectAtIndex:indexPath.row] objectForKey:@"type"];
    if ([type isEqualToString:@"0"]) {
        UILabel *lbl_Content = [[UILabel alloc]init];
        [lbl_Content setFrame:CGRectMake(80, 5, self.view.frame.size.width - 110, 70)];
        [lbl_Content setTextAlignment:NSTextAlignmentLeft];
        [lbl_Content setTextColor:[UIColor blackColor]];
        [lbl_Content setBackgroundColor:[UIColor clearColor]];
        [lbl_Content setFont:[UIFont systemFontOfSize:15.0]];
        lbl_Content.numberOfLines = 5;
        [cell.contentView addSubview:lbl_Content];
        
        lbl_Content.text = [[chatArray objectAtIndex:indexPath.row] objectForKey:@"message"];
    }
    else{
        NSString *count = [[chatArray objectAtIndex:indexPath.row] objectForKey:@"message"];
        NSString *imageName = nil;
        
        if ([count isEqualToString:@"1"]) {
            imageName = @"blueBall.png";
        }
        if ([count isEqualToString:@"10"]) {
            imageName = @"yellowBall.png";
        }
        if ([count isEqualToString:@"100"]) {
            imageName = @"redBall.png";
        }
        
        UIImageView *ballImg = [[UIImageView alloc] initWithFrame:CGRectMake(photoImage.frame.size.width + photoImage.frame.origin.x + 20, 20, 40, 40)];
        ballImg.image = [UIImage imageNamed:imageName];
        [cell.contentView addSubview:ballImg];
    }
    
    NSString *path = [[chatArray objectAtIndex:indexPath.row] objectForKey:@"photourl"];
    [photoImage setImageWithURL:[NSURL URLWithString:path]];
  
    if ([[[chatArray objectAtIndex:indexPath.row] objectForKey:@"nickname"] isEqualToString:@""]) {
        lbl_Name.text = @"Admin";
    }
    else{
        lbl_Name.text = [[chatArray objectAtIndex:indexPath.row] objectForKey:@"nickname"];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //Height of the rows
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - GUI Player View Delegate Methods

- (void)playerWillEnterFullscreen {
    [[self navigationController] setNavigationBarHidden:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
}

- (void)playerWillLeaveFullscreen {
    [[self navigationController] setNavigationBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

-(void)detectOrientation:(NSNotification *)notification
{
    UIInterfaceOrientation newOrientation =  [UIApplication sharedApplication].statusBarOrientation;
    if ((newOrientation == UIInterfaceOrientationLandscapeLeft || newOrientation == UIInterfaceOrientationLandscapeRight))
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    }
    else if (newOrientation == UIInterfaceOrientationPortrait || newOrientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(braodkeyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(braodkeyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
        
        [UIView animateWithDuration:0.2 animations:^{
            sendView.frame = CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50);
        }completion:^(BOOL finished){
            
        }];
    }
}

- (void)playerDidEndPlaying {
    //    [playerView clean];
}

- (void)playerFailedToPlayToEnd {
    NSLog(@"Error: could not play video");
    [playerView clean];
}

- (void)totalBallBtnClicked{
    
}

- (void)redBallBtnClicked{
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
        int totalCount = [totalBallLbl.text intValue];
        
        if (totalCount < 100) {
            NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
            if ([applang isEqualToString:@"ko"]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"주의" message:@"충전을 하세요." delegate:nil cancelButtonTitle:@"예" otherButtonTitles:nil, nil];
                [alert show];
            }
            if ([applang isEqualToString:@"cn"]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注意" message:@"请充值" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                [alert show];
            }
        }
        else{
            NSString *totalcount = totalBallLbl.text;
            totalBallLbl.text = [NSString stringWithFormat:@"%d", [totalcount intValue] - 100];
            
            NSString *userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"];
            NSString *sessionkey = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionkey"];
            
            NSDictionary *parameters = @{@"userid": userid,
                                         @"liveid": liveID,
                                         @"ballnumber": @"100",
                                         @"sessionkey":sessionkey,
                                         @"lastid": lastID
                                         };
            
            [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
            [[GlobalPool sharedInstance].OAuth2Manager POST:LC_BroadCast_GIGUM parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"%@",responseObject);
                
                NSString *status = [responseObject objectForKey:@"status"];
                if ([status intValue] == 1001) {
                    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setObject:@"NO" forKey:@"isLoginState"];
                    [defaults synchronize];
                    [[AppDelegate sharedAppDelegate] runMain];
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [SVProgressHUD showErrorWithStatus:@"Connection failed"];
            }];
        }
    }
    
}

- (void)yelloBallBtnClicked{
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
        int totalCount = [totalBallLbl.text intValue];
        
        if (totalCount < 10) {
            NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
            if ([applang isEqualToString:@"ko"]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"주의" message:@"충전을 하세요." delegate:nil cancelButtonTitle:@"예" otherButtonTitles:nil, nil];
                [alert show];
            }
            if ([applang isEqualToString:@"cn"]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注意" message:@"请充值" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                [alert show];
            }
        }
        else{
            NSString *totalcount = totalBallLbl.text;
            totalBallLbl.text = [NSString stringWithFormat:@"%d", [totalcount intValue] - 10];
            
            NSString *userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"];
            NSString *sessionkey = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionkey"];
            
            NSDictionary *parameters = @{@"userid": userid,
                                         @"liveid": liveID,
                                         @"ballnumber": @"10",
                                         @"sessionkey":sessionkey,
                                         @"lastid": lastID
                                         };
            
            [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
            [[GlobalPool sharedInstance].OAuth2Manager POST:LC_BroadCast_GIGUM parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"%@",responseObject);
                
                NSString *status = [responseObject objectForKey:@"status"];
                if ([status intValue] == 1001) {
                    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setObject:@"NO" forKey:@"isLoginState"];
                    [defaults synchronize];
                    [[AppDelegate sharedAppDelegate] runMain];
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [SVProgressHUD showErrorWithStatus:@"Connection failed"];
            }];
        }
    }
    
}

- (void)blueBallBtnClicked{
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
        int totalCount = [totalBallLbl.text intValue];
        
        if (totalCount < 1) {
            NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
            if ([applang isEqualToString:@"ko"]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"주의" message:@"충전을 하세요." delegate:nil cancelButtonTitle:@"예" otherButtonTitles:nil, nil];
                [alert show];
            }
            if ([applang isEqualToString:@"cn"]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注意" message:@"请充值" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                [alert show];
            }
        }
        else{
            NSString *totalcount = totalBallLbl.text;
            totalBallLbl.text = [NSString stringWithFormat:@"%d", [totalcount intValue] - 1];
            
            NSString *userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"];
            NSString *sessionkey = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionkey"];
            
            NSDictionary *parameters = @{@"userid": userid,
                                         @"liveid": liveID,
                                         @"ballnumber": @"1",
                                         @"sessionkey":sessionkey,
                                         @"lastid": lastID
                                         };
            
            [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
            [[GlobalPool sharedInstance].OAuth2Manager POST:LC_BroadCast_GIGUM parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"%@",responseObject);
                
                NSString *status = [responseObject objectForKey:@"status"];
                if ([status intValue] == 1001) {
                    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setObject:@"NO" forKey:@"isLoginState"];
                    [defaults synchronize];
                    [[AppDelegate sharedAppDelegate] runMain];
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [SVProgressHUD showErrorWithStatus:@"Connection failed"];
            }];
        }
    }
    
}

- (void)backBtnClicked{
    if(self.sidebarController.sidebarIsPresenting)
    {
        [self.sidebarController dismissSidebarViewController];
    }
    else
    {
        if (isJoin == NO) {
            [_timer invalidate];
            _timer = nil;
            [playerView clean];
            [sendText resignFirstResponder];
            [self.sidebarController presentLeftSidebarViewController];
        }
        else{
            
            if (liveID == nil) {
                [_timer invalidate];
                _timer = nil;
                [playerView clean];

                [sendText resignFirstResponder];
                [self.sidebarController presentLeftSidebarViewController];
            }
            else{
                NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
                NSDictionary *parameters = @{@"deviceid":deviceToken,
                                              @"liveid": liveID
                                              };
                
                [SVProgressHUD showWithStatus:@"" maskType:SVProgressHUDMaskTypeBlack];
                
                [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
                [[GlobalPool sharedInstance].OAuth2Manager POST:LC_BroadCast_EXIT_LIVE parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSLog(@"%@",responseObject);
                    
                    [SVProgressHUD dismiss];
                    
                    NSString *status = [responseObject objectForKey:@"status"];
                    
                    if ([status intValue] == 200) {
                        [_timer invalidate];
                        _timer = nil;
                        [playerView clean];
                        [sendText resignFirstResponder];
                        
                        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"hideNaviDelegate" object:nil];
                        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"sendMessageNoty" object:nil];
                        
                        [self.sidebarController presentLeftSidebarViewController];
                    }
                    else{
                        NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
                        if ([applang isEqualToString:@"ko"]) {
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"탈퇴가 실패하였습니다." delegate:self cancelButtonTitle:@"다시 시도하십시오" otherButtonTitles:nil, nil];
                            [alert show];
                        }
                        if ([applang isEqualToString:@"cn"]) {
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"退出失败" delegate:self cancelButtonTitle:@"请重试" otherButtonTitles:nil, nil];
                            [alert show];
                        }
                        
                    }
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [SVProgressHUD showErrorWithStatus:@"Connection failed"];
                }];
            }
        }
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
