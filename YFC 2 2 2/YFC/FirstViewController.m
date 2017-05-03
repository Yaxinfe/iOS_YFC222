//
//  FirstViewController.m
//  YFC
//
//  Created by topone on 7/14/15.
//  Copyright (c) 2015 ming. All rights reserved.
//
#import "publicHeaders.h"

#import "FirstViewController.h"
#import "MainViewController.h"
#import "ThirdViewController.h"
#import "SignupViewController.h"
#import "FourthViewController.h"

#import "CCMPopupSegue.h"
#import "CCMBorderView.h"
#import "CCMPopupTransitioning.h"
#import "AdsViewController.h"

#import "LDSDKManager.h"
#import "LDSDKRegisterService.h"
#import "LDSDKPayService.h"
#import "LDSDKAuthService.h"
#import "LDSDKShareService.h"

#import "Weibo.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import <TencentOpenAPI/TencentOAuth.h>

@interface FirstViewController ()<UITextFieldDelegate, TencentSessionDelegate>
{
    NSString* wxCode;
    NSString* wxAccessToken;
    NSString* wxOpenID;
    TencentOAuth *_tencentOAuth;
}
@property(nonatomic, strong) UITextField *phoneTxt;
@property(nonatomic, strong) UITextField *passwordTxt;

@property (weak, nonatomic) UIImageView *imageViewTop;
@property (weak, nonatomic) UIImageView *imageViewBotton;
@property (weak, nonatomic) CCMBorderView *buttonContainerView;
@property (weak, nonatomic) CCMBorderView *secondButtonContainerView;
@property (weak) UIViewController *popupController;

@end

@implementation FirstViewController{
    
}
@synthesize phoneTxt, passwordTxt;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view. 会员登录
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    backImageView.image = [UIImage imageNamed:@"firstViewBack"];
    [self.view addSubview:backImageView];
    
    UIButton *btnCancel = [[UIButton alloc] initWithFrame:CGRectMake(10, 30, 30, 30)];
    [btnCancel setImage:[UIImage imageNamed:@"btnCancelImg.png"] forState:UIControlStateNormal];
    [btnCancel addTarget:self action:@selector(btnCancelClicked) forControlEvents:UIControlEventTouchUpInside];
    [btnCancel setTintColor:[UIColor lightGrayColor]];
    btnCancel.alpha = 1.0;
    btnCancel.transform = CGAffineTransformMakeTranslation(10, 0);
    [self.view addSubview:btnCancel];
    
    UILabel *lbl_Title = [[UILabel alloc] init];
    [lbl_Title setFrame:CGRectMake(self.view.frame.size.width - 100, 30, 80, 30)];
    [lbl_Title setTextAlignment:NSTextAlignmentCenter];
    [lbl_Title setTextColor:[UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0]];
    [lbl_Title setBackgroundColor:[UIColor clearColor]];
    [lbl_Title setFont:[UIFont boldSystemFontOfSize:20.0]];
    lbl_Title.text = @"会员登录";
    [self.view addSubview:lbl_Title];
    
    UIImageView *lineImg1 = [[UIImageView alloc] initWithFrame:CGRectMake(40, 80, self.view.frame.size.width - 80, (self.view.frame.size.width - 80)/6)];
    lineImg1.backgroundColor = [UIColor clearColor];
    lineImg1.layer.cornerRadius = 5;
    lineImg1.layer.borderColor = [UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0].CGColor;
    lineImg1.layer.borderWidth = 1;
    lineImg1.layer.masksToBounds = YES;
    [self.view addSubview:lineImg1];
    
    phoneTxt = [[UITextField alloc] initWithFrame:CGRectMake(lineImg1.frame.origin.x + 10, lineImg1.frame.origin.y + 3, lineImg1.frame.size.width - 20, lineImg1.frame.size.width/6 - 6)];
    phoneTxt.backgroundColor = [UIColor clearColor];
    phoneTxt.textColor = [UIColor blackColor];
    phoneTxt.font = [UIFont systemFontOfSize:15];
    phoneTxt.placeholder = @"请输入登录账号";
    phoneTxt.keyboardType = UIKeyboardTypeDefault;
    phoneTxt.delegate = self;
    [phoneTxt setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.view addSubview:phoneTxt];
    
    UIImageView *lineImg2 = [[UIImageView alloc] initWithFrame:CGRectMake(40, lineImg1.frame.origin.y + lineImg1.frame.size.height + 10, self.view.frame.size.width - 80, (self.view.frame.size.width - 80)/6)];
    lineImg2.backgroundColor = [UIColor clearColor];
    lineImg2.layer.cornerRadius = 5;
    lineImg2.layer.borderColor = [UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0].CGColor;
    lineImg2.layer.borderWidth = 1;
    lineImg2.layer.masksToBounds = YES;
    [self.view addSubview:lineImg2];
    
    passwordTxt = [[UITextField alloc] initWithFrame:CGRectMake(lineImg2.frame.origin.x + 10, lineImg2.frame.origin.y + 3, lineImg2.frame.size.width - 20, lineImg2.frame.size.width/6 - 6)];
    passwordTxt.backgroundColor = [UIColor clearColor];
    passwordTxt.textColor = [UIColor blackColor];
    passwordTxt.font = [UIFont systemFontOfSize:15];
    passwordTxt.placeholder = @"请输入登录密码";
    passwordTxt.secureTextEntry = YES;
    passwordTxt.delegate = self;
    [passwordTxt setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.view addSubview:passwordTxt];
    
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, lineImg2.frame.origin.y + lineImg2.frame.size.height + 10, lineImg2.frame.size.width, 45)];
    [loginBtn setTitle:@"登        陆" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"loginBtn.png"] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [loginBtn setTintColor:[UIColor lightGrayColor]];
    loginBtn.alpha = 1.0;
    loginBtn.transform = CGAffineTransformMakeTranslation(10, 0);
    [self.view addSubview:loginBtn];
    
    UIButton *forgotBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, loginBtn.frame.origin.y + loginBtn.frame.size.height + 8, 100, 20)];
    [forgotBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
    forgotBtn.titleLabel.font = [UIFont systemFontOfSize:18.0];
    [forgotBtn setTitleColor:[UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [forgotBtn addTarget:self action:@selector(forgotBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [forgotBtn setTintColor:[UIColor lightGrayColor]];
    forgotBtn.alpha = 1.0;
    forgotBtn.transform = CGAffineTransformMakeTranslation(10, 0);
    [self.view addSubview:forgotBtn];
    
    UIButton *signupBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 130, forgotBtn.frame.origin.y, 100, 20)];
    [signupBtn setTitle:@"￼注册会员" forState:UIControlStateNormal];
    signupBtn.titleLabel.font = [UIFont systemFontOfSize:18.0];
    [signupBtn setTitleColor:[UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [signupBtn addTarget:self action:@selector(signupBtnBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [signupBtn setTintColor:[UIColor lightGrayColor]];
    signupBtn.alpha = 1.0;
    signupBtn.transform = CGAffineTransformMakeTranslation(10, 0);
    [self.view addSubview:signupBtn];
    
    UIButton *social_btn1 = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/3 - 105, signupBtn.frame.origin.y + signupBtn.frame.size.height + 30, 75, 75)];
    [social_btn1 setImage:[UIImage imageNamed:@"icon1.png"] forState:UIControlStateNormal];
    [social_btn1 addTarget:self action:@selector(socialBtn1Clicked) forControlEvents:UIControlEventTouchUpInside];
    [social_btn1 setTintColor:[UIColor lightGrayColor]];
    social_btn1.alpha = 1.0;
    social_btn1.transform = CGAffineTransformMakeTranslation(10, 0);
    [self.view addSubview:social_btn1];
    
    UIButton *social_btn2 = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/3*2 - 105, signupBtn.frame.origin.y + signupBtn.frame.size.height + 30, 75, 75)];
    [social_btn2 setImage:[UIImage imageNamed:@"icon3.png"] forState:UIControlStateNormal];
    [social_btn2 addTarget:self action:@selector(socialBtn2Clicked) forControlEvents:UIControlEventTouchUpInside];
    [social_btn2 setTintColor:[UIColor lightGrayColor]];
    social_btn2.alpha = 1.0;
    social_btn2.transform = CGAffineTransformMakeTranslation(10, 0);
    [self.view addSubview:social_btn2];
    
    if ([[LDSDKManager getAuthService:LDSDKPlatformWeChat] isLoginEnabledOnPlatform] == NO) {
        social_btn2.hidden = YES;
    }
    
    UIButton *social_btn3 = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 105, signupBtn.frame.origin.y + signupBtn.frame.size.height + 30, 75, 75)];
    [social_btn3 setImage:[UIImage imageNamed:@"icon2.png"] forState:UIControlStateNormal];
    [social_btn3 addTarget:self action:@selector(socialBtn3Clicked) forControlEvents:UIControlEventTouchUpInside];
    [social_btn3 setTintColor:[UIColor lightGrayColor]];
    social_btn3.alpha = 1.0;
    social_btn3.transform = CGAffineTransformMakeTranslation(10, 0);
    [self.view addSubview:social_btn3];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    [self.view addGestureRecognizer:tapGesture];
    
    NSString *doneRunApp = [[NSUserDefaults standardUserDefaults] objectForKey:@"doneRunApp"];
    if ([doneRunApp isEqualToString:@"YES"]) {
        self.imageViewTop.image = [self.imageViewTop.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        self.imageViewBotton.image = [self.imageViewBotton.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        self.buttonContainerView.layer.shadowColor = [UIColor blackColor].CGColor;
        self.buttonContainerView.layer.shadowRadius = 15;
        self.buttonContainerView.clipsToBounds = NO;
        self.buttonContainerView.layer.shadowOffset = CGSizeMake(0, 5);
        
        AdsViewController *presentingController = [[AdsViewController alloc] init];
        
        CCMPopupTransitioning *popup = [CCMPopupTransitioning sharedInstance];
        popup.destinationBounds = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        popup.presentedController = presentingController;
        popup.presentingController = self;
        self.popupController = presentingController;
        self.popupController.modalPresentationStyle = UIModalPresentationCurrentContext;
        [self presentViewController:presentingController animated:YES completion:nil];
    }
    
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didReceiveWechat:) name:@"WECHAT" object:nil];
}

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    [self.view layoutIfNeeded];
    if (size.height < 420) {
        [UIView animateWithDuration:[coordinator transitionDuration] animations:^{
            self.popupController.view.bounds = CGRectMake(0, 0, (size.height-20) * .75, size.height-20);
            [self.view layoutIfNeeded];
        }];
    } else {
        [UIView animateWithDuration:[coordinator transitionDuration] animations:^{
            self.popupController.view.bounds = CGRectMake(0, 0, 300, 400);
            [self.view layoutIfNeeded];
        }];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"NO" forKey:@"forgotPassword"];
    [defaults setObject:@"NO" forKey:@"isLoginState"];
    [defaults setObject:@"NO" forKey:@"isUserSignUp"];
    [defaults setObject:@"NO" forKey:@"isQQSocialSignUp"];
    [defaults setObject:@"NO" forKey:@"isWechatSocialSignUp"];
    [defaults setObject:@"NO" forKey:@"isWeiboSocialSignUp"];
    [defaults synchronize];
}

- (void)viewTapped:(UIGestureRecognizer *)gesture {
    [phoneTxt resignFirstResponder];
    [passwordTxt resignFirstResponder];
}

- (void)btnCancelClicked{
    [self dismissViewControllerAnimated:YES completion:nil];
//    [[AppDelegate sharedAppDelegate] runMain];
    [phoneTxt resignFirstResponder];
    [passwordTxt resignFirstResponder];
}

- (void)socialBtn1Clicked{
    [phoneTxt resignFirstResponder];
    [passwordTxt resignFirstResponder];
    
    [Weibo.weibo authorizeWithCompleted:^(WeiboAccount *account, NSError *error) {
        if (!error) {
            NSLog(@"Sign in successful: %@", account.user);
            
            User *loginUser = account.user;
            NSLog(@"%@", loginUser);
            
            NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
            NSString *nickname = loginUser.name;
            NSString *username = account.userId;
            NSString *photourl = loginUser.profileImageUrl;
            
            NSDictionary *parameters = @{@"weiboid": account.userId,
                                         @"token": deviceToken,
                                         @"nickname": nickname,
                                         @"photourl": photourl,
                                         @"username": username
                                         };
            [SVProgressHUD showWithStatus:@"请稍后..." maskType:SVProgressHUDMaskTypeBlack];
            
            [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
            [[GlobalPool sharedInstance].OAuth2Manager POST:LC_WEIBO_LOGIN parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"%@",responseObject);
                
                NSString *status = [responseObject objectForKey:@"status"];
                
                if ([status intValue] == 200) {
                    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
                    
                    NSString *userid = [[responseObject objectForKey:@"userinfo"] objectForKey:@"userid"];
                    NSString *username = [[responseObject objectForKey:@"userinfo"] objectForKey:@"username"];
                    NSString *userPhoto = [[responseObject objectForKey:@"userinfo"] objectForKey:@"photourl"];
                    NSString *nickName = [[responseObject objectForKey:@"userinfo"] objectForKey:@"nickname"];
                    NSString *langid = [[responseObject objectForKey:@"userinfo"] objectForKey:@"langid"];
                    NSString *sessionkey = [[responseObject objectForKey:@"userinfo"] objectForKey:@"sessionkey"];
                    
                    [defaults setObject:userid forKey:@"userid"];
                    [defaults setObject:username forKey:@"username"];
                    [defaults setObject:userPhoto forKey:@"userphoto"];
                    [defaults setObject:nickName forKey:@"nickname"];
                    [defaults setObject:langid forKey:@"langid"];
                    [defaults setObject:@"YES" forKey:@"isLoginState"];
                    [defaults setObject:sessionkey forKey:@"sessionkey"];
                    
                    NSString *ischeckedname = [[responseObject objectForKey:@"userinfo"] objectForKey:@"changednickname"];
                    if ([ischeckedname intValue] == 0) {
                        [defaults setObject:@"NO" forKey:@"ischeckedNickname"];
                    }
                    else{
                        [defaults setObject:@"YES" forKey:@"ischeckedNickname"];
                    }
                    
                    [defaults synchronize];
                    
//                    [[AppDelegate sharedAppDelegate] runMain];
                    [self dismissViewControllerAnimated:YES completion:nil];
                    
                    [ProgressHUD showSuccess:@"로그인 성공!"];
                }
                
                [SVProgressHUD dismiss];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [SVProgressHUD showErrorWithStatus:@"Connection failed"];
            }];
        }
        else {
            NSLog(@"Failed to sign in: %@", error);
        }
    }];
}

//-(void)didReceiveWechat:(NSNotification*)not
//{
//    NSDictionary* info =not.userInfo;
//    wxCode =[info objectForKey:@"code"];
//    [self getAccess_token];
//}
//
////第二步获取接入token
//-(void)getAccess_token
//{
//    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",kWeChat_KEY,kWeChat_Secret,wxCode];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSURL* zoneUrl =[NSURL URLWithString:url];
//        NSString* zoneString =[NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
//        NSData* data =[zoneString dataUsingEncoding:NSUTF8StringEncoding];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (data) {
//                NSDictionary* dict =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//                wxAccessToken =[dict objectForKey:@"access_token"];
//                wxOpenID =[dict objectForKey:@"openid"];
//                [self getUserINFo];
//            }
//        });
//    });
//    
//}
//
////第三步获取用户信息
//-(void)getUserINFo
//{
//    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",wxAccessToken,wxOpenID];
//    NSLog(@"\n url:%@",url);
//    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSURL* zoneUrl =[NSURL URLWithString:url];
//        NSString* zoneString =[NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
//        NSData* data =[zoneString dataUsingEncoding:NSUTF8StringEncoding];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (data) {
//                NSDictionary* dict =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//                NSLog(@"\nnickname:%@",[dict objectForKey:@"nickname"]);
//
//                 NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
//                 NSString *nickname = [dict objectForKey:@"nickname"];
//                 NSString *username = [dict objectForKey:@"openid"];
//                 NSString *photourl = [dict objectForKey:@"headimgurl"];
//                 NSString *wechatid = [dict objectForKey:@"openid"];
//
//                 NSDictionary *parameters = @{@"wechatid": wechatid,
//                                              @"nickname": nickname,
//                                              @"photourl": photourl,
//                                              @"username": username,
//                                              @"token": deviceToken
//                                              };
//
//                 [SVProgressHUD showWithStatus:@"请稍后..." maskType:SVProgressHUDMaskTypeBlack];
//
//                 [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
//                 [[GlobalPool sharedInstance].OAuth2Manager POST:LC_WECHAT_LOGIN parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                     NSLog(@"%@",responseObject);
//
//                     NSString *status = [responseObject objectForKey:@"status"];
//
//                     if ([status intValue] == 200) {
//                         NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
//
//                         NSString *userid = [[responseObject objectForKey:@"userinfo"] objectForKey:@"userid"];
//                         NSString *username = [[responseObject objectForKey:@"userinfo"] objectForKey:@"username"];
//                         NSString *userPhoto = [[responseObject objectForKey:@"userinfo"] objectForKey:@"photourl"];
//                         NSString *nickName = [[responseObject objectForKey:@"userinfo"] objectForKey:@"nickname"];
//                         NSString *langid = [[responseObject objectForKey:@"userinfo"] objectForKey:@"langid"];
//                         NSString *sessionkey = [[responseObject objectForKey:@"userinfo"] objectForKey:@"sessionkey"];
//
//                         NSString *ischeckedname = [[responseObject objectForKey:@"userinfo"] objectForKey:@"changednickname"];
//                         if ([ischeckedname intValue] == 0) {
//                             [defaults setObject:@"NO" forKey:@"ischeckedNickname"];
//                         }
//                         else{
//                             [defaults setObject:@"YES" forKey:@"ischeckedNickname"];
//                         }
//
//                         [defaults setObject:userid forKey:@"userid"];
//                         [defaults setObject:username forKey:@"username"];
//                         [defaults setObject:userPhoto forKey:@"userphoto"];
//                         [defaults setObject:nickName forKey:@"nickname"];
//                         [defaults setObject:langid forKey:@"langid"];
//                         [defaults setObject:@"YES" forKey:@"isLoginState"];
//                         [defaults setObject:sessionkey forKey:@"sessionkey"];
//                         
//                         [defaults synchronize];
//                         
////                         [[AppDelegate sharedAppDelegate] runMain];
//                         [self dismissViewControllerAnimated:YES completion:nil];
//                        [ProgressHUD showSuccess:@"로그인 성공!"];
//                     }
//                     
//                     [SVProgressHUD dismiss];
//                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                     NSLog(@"%@", error);
//                     [SVProgressHUD showErrorWithStatus:@"Connection failed"];
//                 }];
//                
//                /*
//                 city = "";
//                 country = CN;
//                 headimgurl = "";
//                 language = "zh_CN";
//                 nickname = "\U732a\U5934";
//                 openid = "oPfHYjqs0lMtwT3tgpv_MVo4nO6M";
//                 privilege =     (
//                 );
//                 province = Shanghai;
//                 sex = 2;
//                 unionid = ovotquP9XLtcbtBxNY901AxSNGxs;
//                 */
//            }
//        });
//    });
//    
//}

- (void)socialBtn2Clicked{
    [phoneTxt resignFirstResponder];
    [passwordTxt resignFirstResponder];
    
//    SendAuthReq* request =[[SendAuthReq alloc]init];
//    request.scope =@"snsapi_userinfo";
//    request.state =@"333";
//    [WXApi sendAuthReq:request viewController:self delegate:nil];
    
    [[LDSDKManager getAuthService:LDSDKPlatformWeChat]
     loginToPlatformWithCallback:^(NSDictionary *oauthInfo, NSDictionary *userInfo,
                                   NSError *error) {
         if (error == nil) {
             if (userInfo == nil && oauthInfo != nil) {
                 
             }
             else {
                 NSLog(@"%@, %@", userInfo, oauthInfo);
                 
                 NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
                 NSString *nickname = [userInfo objectForKey:@"nickname"];
                 NSString *username = [oauthInfo objectForKey:@"openid"];
                 NSString *photourl = [userInfo objectForKey:@"headimgurl"];
                 NSString *wechatid = [oauthInfo objectForKey:@"openid"];
                 
                 NSDictionary *parameters = @{@"wechatid": wechatid,
                                              @"nickname": nickname,
                                              @"photourl": photourl,
                                              @"username": username,
                                              @"token": deviceToken
                                              };
                 
                 [SVProgressHUD showWithStatus:@"请稍后..." maskType:SVProgressHUDMaskTypeBlack];
                 
                 [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
                 [[GlobalPool sharedInstance].OAuth2Manager POST:LC_WECHAT_LOGIN parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                     NSLog(@"%@",responseObject);
                     
                     NSString *status = [responseObject objectForKey:@"status"];
                     
                     if ([status intValue] == 200) {
                         NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
                         
                         NSString *userid = [[responseObject objectForKey:@"userinfo"] objectForKey:@"userid"];
                         NSString *username = [[responseObject objectForKey:@"userinfo"] objectForKey:@"username"];
                         NSString *userPhoto = [[responseObject objectForKey:@"userinfo"] objectForKey:@"photourl"];
                         NSString *nickName = [[responseObject objectForKey:@"userinfo"] objectForKey:@"nickname"];
                         NSString *langid = [[responseObject objectForKey:@"userinfo"] objectForKey:@"langid"];
                         NSString *sessionkey = [[responseObject objectForKey:@"userinfo"] objectForKey:@"sessionkey"];
                         
                         NSString *ischeckedname = [[responseObject objectForKey:@"userinfo"] objectForKey:@"changednickname"];
                         if ([ischeckedname intValue] == 0) {
                             [defaults setObject:@"NO" forKey:@"ischeckedNickname"];
                         }
                         else{
                             [defaults setObject:@"YES" forKey:@"ischeckedNickname"];
                         }
                         
                         [defaults setObject:userid forKey:@"userid"];
                         [defaults setObject:username forKey:@"username"];
                         [defaults setObject:userPhoto forKey:@"userphoto"];
                         [defaults setObject:nickName forKey:@"nickname"];
                         [defaults setObject:langid forKey:@"langid"];
                         [defaults setObject:@"YES" forKey:@"isLoginState"];
                         [defaults setObject:sessionkey forKey:@"sessionkey"];
                         
                         [defaults synchronize];
                         
//                         [[AppDelegate sharedAppDelegate] runMain];
                         [self dismissViewControllerAnimated:YES completion:nil];
                         
                         [ProgressHUD showSuccess:@"로그인 성공!"];
                        
                     }
                     
                     [SVProgressHUD dismiss];
                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                     NSLog(@"%@", error);
                     [SVProgressHUD showErrorWithStatus:@"Connection failed"];
                 }];
             }
         }
         else {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请先安装微信客户端" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
             alert.tag = 3000;
             [alert show];
         }
     }];
}

#pragma mark --TencentSessionDelegate--
-(void)getUserInfoResponse:(APIResponse *)response
{
     NSLog(@"%@", response.jsonResponse);
     NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
     NSString *nickname = [response.jsonResponse objectForKey:@"nickname"];
     NSString *username = [response.jsonResponse objectForKey:@"nickname"];
     NSString *photourl = [response.jsonResponse objectForKey:@"figureurl_qq_2"];

     NSDictionary *parameters = @{@"qqid": username,
                                  @"token": deviceToken,
                                  @"nickname": nickname,
                                  @"photourl": photourl,
                                  @"username": username
                                  };

     [SVProgressHUD showWithStatus:@"请稍后..." maskType:SVProgressHUDMaskTypeBlack];

     [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
     [[GlobalPool sharedInstance].OAuth2Manager POST:LC_QQ_LOGIN parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSLog(@"%@",responseObject);

         NSString *status = [responseObject objectForKey:@"status"];

         if ([status intValue] == 200) {
             NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];

             NSString *userid = [[responseObject objectForKey:@"userinfo"] objectForKey:@"userid"];
             NSString *username = [[responseObject objectForKey:@"userinfo"] objectForKey:@"username"];
             NSString *userPhoto = [[responseObject objectForKey:@"userinfo"] objectForKey:@"photourl"];
             NSString *nickName = [[responseObject objectForKey:@"userinfo"] objectForKey:@"nickname"];
             NSString *langid = [[responseObject objectForKey:@"userinfo"] objectForKey:@"langid"];
             NSString *sessionkey = [[responseObject objectForKey:@"userinfo"] objectForKey:@"sessionkey"];

             NSString *ischeckedname = [[responseObject objectForKey:@"userinfo"] objectForKey:@"changednickname"];
             if ([ischeckedname intValue] == 0) {
                 [defaults setObject:@"NO" forKey:@"ischeckedNickname"];
             }
             else{
                 [defaults setObject:@"YES" forKey:@"ischeckedNickname"];
             }

             [defaults setObject:userid forKey:@"userid"];
             [defaults setObject:username forKey:@"username"];
             [defaults setObject:userPhoto forKey:@"userphoto"];
             [defaults setObject:nickName forKey:@"nickname"];
             [defaults setObject:langid forKey:@"langid"];
             [defaults setObject:@"YES" forKey:@"isLoginState"];
             [defaults setObject:sessionkey forKey:@"sessionkey"];

             [defaults synchronize];

//             [[AppDelegate sharedAppDelegate] runMain];
             [self dismissViewControllerAnimated:YES completion:nil];

             [ProgressHUD showSuccess:@"로그인 성공!"];
         }
         [SVProgressHUD dismiss];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [SVProgressHUD showErrorWithStatus:@"Connection failed"];
     }];
}

- (void)tencentDidLogin
{
    if (_tencentOAuth.accessToken && 0 != [_tencentOAuth.accessToken length]){
        //  记录登录用户的OpenID、Token以及过期时间
        NSLog(@"过期时间：%@",_tencentOAuth.expirationDate);
        //获得
        [_tencentOAuth getUserInfo];
        [_tencentOAuth accessToken];
        [_tencentOAuth openId];
        [_tencentOAuth expirationDate];
        
    }else{
        NSLog(@"登录不成功 没有获取accesstoken");
    }
}

- (void)socialBtn3Clicked{
    [phoneTxt resignFirstResponder];
    [passwordTxt resignFirstResponder];
    
    _tencentOAuth =[[TencentOAuth alloc]initWithAppId:kQQ_KEY andDelegate:self];
    NSArray* permissions = [NSArray arrayWithObjects:
                            kOPEN_PERMISSION_GET_USER_INFO,
                            kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                            kOPEN_PERMISSION_ADD_ALBUM,
                            kOPEN_PERMISSION_ADD_ONE_BLOG,
                            kOPEN_PERMISSION_ADD_SHARE,
                            kOPEN_PERMISSION_ADD_TOPIC,
                            kOPEN_PERMISSION_CHECK_PAGE_FANS,
                            kOPEN_PERMISSION_GET_INFO,
                            kOPEN_PERMISSION_GET_OTHER_INFO,
                            kOPEN_PERMISSION_LIST_ALBUM,
                            kOPEN_PERMISSION_UPLOAD_PIC,
                            kOPEN_PERMISSION_GET_VIP_INFO,
                            kOPEN_PERMISSION_GET_VIP_RICH_INFO,
                            nil];
    [_tencentOAuth authorize:permissions inSafari:NO];
    
//    [[LDSDKManager getAuthService:LDSDKPlatformQQ]
//     loginToPlatformWithCallback:^(NSDictionary *oauthInfo, NSDictionary *userInfo,
//                                   NSError *error) {
//         if (error == nil) {
//             if (userInfo == nil && oauthInfo != nil) {
//                 
//             }
//             else {
//                 NSLog(@"%@, %@", userInfo, oauthInfo);
//                 NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
//                 NSString *nickname = [userInfo objectForKey:@"nickname"];
//                 NSString *username = [oauthInfo objectForKey:@"openId"];
//                 NSString *photourl = [userInfo objectForKey:@"figureurl_qq_2"];
//                 
//                 NSDictionary *parameters = @{@"qqid": username,
//                                              @"token": deviceToken,
//                                              @"nickname": nickname,
//                                              @"photourl": photourl,
//                                              @"username": username
//                                              };
//
//                 [SVProgressHUD showWithStatus:@"请稍后..." maskType:SVProgressHUDMaskTypeBlack];
//                 
//                 [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
//                 [[GlobalPool sharedInstance].OAuth2Manager POST:LC_QQ_LOGIN parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                     NSLog(@"%@",responseObject);
//                     
//                     NSString *status = [responseObject objectForKey:@"status"];
//                     
//                     if ([status intValue] == 200) {
//                         NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
//                         
//                         NSString *userid = [[responseObject objectForKey:@"userinfo"] objectForKey:@"userid"];
//                         NSString *username = [[responseObject objectForKey:@"userinfo"] objectForKey:@"username"];
//                         NSString *userPhoto = [[responseObject objectForKey:@"userinfo"] objectForKey:@"photourl"];
//                         NSString *nickName = [[responseObject objectForKey:@"userinfo"] objectForKey:@"nickname"];
//                         NSString *langid = [[responseObject objectForKey:@"userinfo"] objectForKey:@"langid"];
//                         NSString *sessionkey = [[responseObject objectForKey:@"userinfo"] objectForKey:@"sessionkey"];
//                         
//                         NSString *ischeckedname = [[responseObject objectForKey:@"userinfo"] objectForKey:@"changednickname"];
//                         if ([ischeckedname intValue] == 0) {
//                             [defaults setObject:@"NO" forKey:@"ischeckedNickname"];
//                         }
//                         else{
//                             [defaults setObject:@"YES" forKey:@"ischeckedNickname"];
//                         }
//                         
//                         [defaults setObject:userid forKey:@"userid"];
//                         [defaults setObject:username forKey:@"username"];
//                         [defaults setObject:userPhoto forKey:@"userphoto"];
//                         [defaults setObject:nickName forKey:@"nickname"];
//                         [defaults setObject:langid forKey:@"langid"];
//                         [defaults setObject:@"YES" forKey:@"isLoginState"];
//                         [defaults setObject:sessionkey forKey:@"sessionkey"];
//                         
//                         [defaults synchronize];
//                         
//                         [[AppDelegate sharedAppDelegate] runMain];
//                         
////                         [ProgressHUD showSuccess:@"로그인 성공!"];
//                     }
//                     [SVProgressHUD dismiss];
//                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                     [SVProgressHUD showErrorWithStatus:@"Connection failed"];
//                 }];
//             }
//         }
//         else {
//             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请先安装QQ客户端" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
//             alert.tag = 2000;
//             [alert show];
//         }
//     }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 2000) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"itms://itunes.apple.com/us/app/qq/id444934666?mt=8"]];
    }
    if (alertView.tag == 3000) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"itms://itunes.apple.com/ca/app/wechat/id414478124?mt=8"]];
    }
}

- (void)loginBtnClicked{
    [phoneTxt resignFirstResponder];
    [passwordTxt resignFirstResponder];
    
    if ([phoneTxt.text isEqualToString:@""] || [passwordTxt.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请输入帐号和密码" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
    }
    else{
        NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
        
        NSDictionary *parameters = @{@"username":phoneTxt.text,
                                     @"password": passwordTxt.text,
                                     @"token": deviceToken
                                     };
        
        [SVProgressHUD showWithStatus:@"请稍后..." maskType:SVProgressHUDMaskTypeBlack];
        
        [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
        [[GlobalPool sharedInstance].OAuth2Manager POST:LC_LOGIN parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@",responseObject);
            [SVProgressHUD dismiss];
            
            NSString *status = [responseObject objectForKey:@"status"];
            
            if ([status intValue] == 200) {
                NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
                
                NSString *userid = [[responseObject objectForKey:@"userinfo"] objectForKey:@"userid"];
                NSString *username = [[responseObject objectForKey:@"userinfo"] objectForKey:@"username"];
                NSString *userPhoto = [[responseObject objectForKey:@"userinfo"] objectForKey:@"photourl"];
                NSString *nickName = [[responseObject objectForKey:@"userinfo"] objectForKey:@"nickname"];
                NSString *langid = [[responseObject objectForKey:@"userinfo"] objectForKey:@"langid"];
                NSString *sessionkey = [[responseObject objectForKey:@"userinfo"] objectForKey:@"sessionkey"];
                
                [defaults setObject:userid forKey:@"userid"];
                [defaults setObject:username forKey:@"username"];
                [defaults setObject:userPhoto forKey:@"userphoto"];
                [defaults setObject:nickName forKey:@"nickname"];
                [defaults setObject:langid forKey:@"langid"];
                [defaults setObject:sessionkey forKey:@"sessionkey"];
                
                NSString *ischeckedname = [[responseObject objectForKey:@"userinfo"] objectForKey:@"changednickname"];
                if ([ischeckedname intValue] == 0) {
                    [defaults setObject:@"NO" forKey:@"ischeckedNickname"];
                }
                else{
                    [defaults setObject:@"YES" forKey:@"ischeckedNickname"];
                }
                
                [defaults setObject:@"YES" forKey:@"isLoginState"];
                [defaults synchronize];
                
//                [[AppDelegate sharedAppDelegate] runMain];
                [self dismissViewControllerAnimated:YES completion:nil];
                [ProgressHUD showSuccess:@"로그인 성공!"];
            
            }
            else{
                NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
                if ([applang isEqualToString:@"ko"]) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"가입이 실패하였습니다." delegate:self cancelButtonTitle:@"다시 시도해주세요." otherButtonTitles:nil, nil];
                    [alert show];
                }
                if ([applang isEqualToString:@"cn"]) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"登录失败" delegate:self cancelButtonTitle:@"请重试" otherButtonTitles:nil, nil];
                    [alert show];
                }
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"Connection failed"];
        }];
    }
}

- (void)signupBtnBtnClicked{
    [phoneTxt resignFirstResponder];
    [passwordTxt resignFirstResponder];
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"YES" forKey:@"isUserSignUp"];
    [defaults synchronize];
    SignupViewController *signupView = [[SignupViewController alloc] init];
    [self.navigationController pushViewController:signupView animated:YES];
}

- (void)forgotBtnClicked{
    [phoneTxt resignFirstResponder];
    [passwordTxt resignFirstResponder];
    
    ThirdViewController *forgotView = [[ThirdViewController alloc] init];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"YES" forKey:@"forgotPassword"];
    [defaults synchronize];
    [self.navigationController pushViewController:forgotView animated:YES];
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
