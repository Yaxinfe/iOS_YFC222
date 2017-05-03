//
//  FourthViewController.m
//  YFC
//
//  Created by topone on 7/14/15.
//  Copyright (c) 2015 ming. All rights reserved.
//

#import "publicHeaders.h"
#import "FourthViewController.h"
#import "FifthViewController.h"
#import "ChangePassViewController.h"
#import "AppDelegate.h"

@interface FourthViewController ()<UITextFieldDelegate>
{
    int timeCount;
    UIButton *resendBtn;
}
@property (nonatomic, strong) UITextField *numberField;

@end

@implementation FourthViewController
@synthesize numberField, phoneNumber;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    timeCount = 60;
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    backImageView.image = [UIImage imageNamed:@"firstViewBack"];
    [self.view addSubview:backImageView];
    
    UIButton *back_btn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.origin.x , self.view.frame.origin.y + 25, 27, 30)];
    [back_btn setImage:[UIImage imageNamed:@"backBtn.png"] forState:UIControlStateNormal];
    [back_btn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [back_btn setTintColor:[UIColor lightGrayColor]];
    back_btn.alpha = 1.0;
    back_btn.transform = CGAffineTransformMakeTranslation(10, 0);
    [self.view addSubview:back_btn];
    
    UILabel *lbl_Title = [[UILabel alloc] init];
    [lbl_Title setFrame:CGRectMake(self.view.frame.size.width - 100, 30, 80, 30)];
    [lbl_Title setTextAlignment:NSTextAlignmentCenter];
    [lbl_Title setTextColor:[UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0]];
    [lbl_Title setBackgroundColor:[UIColor clearColor]];
    [lbl_Title setFont:[UIFont systemFontOfSize:20.0]];
    lbl_Title.text = @"3. 认证";
    [self.view addSubview:lbl_Title];
    
    UILabel *lbl_Success = [[UILabel alloc] init];
    [lbl_Success setFrame:CGRectMake(self.view.frame.size.width/2 - 150, 120, 300, 20)];
    [lbl_Success setTextAlignment:NSTextAlignmentCenter];
    [lbl_Success setTextColor:[UIColor blackColor]];
    [lbl_Success setBackgroundColor:[UIColor clearColor]];
    [lbl_Success setFont:[UIFont boldSystemFontOfSize:22.0]];
    lbl_Success.text = @"请输入验证 号码";
    [self.view addSubview:lbl_Success];
    
    numberField = [[UITextField alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 120, lbl_Success.frame.origin.y + lbl_Success.frame.size.height + 30, 120, 20)];
    numberField.backgroundColor = [UIColor clearColor];
    numberField.textColor = [UIColor blackColor];
    numberField.font = [UIFont systemFontOfSize:18];
    numberField.placeholder = @"数字号码";
    numberField.keyboardType = UIKeyboardTypeNumberPad;
    numberField.delegate = self;
    [numberField setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.view addSubview:numberField];
    
    UIImageView *lineImg = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 120, numberField.frame.origin.y + numberField.frame.size.height + 4, 240, 1)];
    lineImg.backgroundColor = [UIColor grayColor];
    [self.view addSubview:lineImg];
    
    resendBtn = [[UIButton alloc] initWithFrame:CGRectMake(lineImg.frame.size.width + lineImg.frame.origin.x - 110, numberField.frame.origin.y, 100, 20)];
    [resendBtn setTitle:@"重新发送(60s)" forState:UIControlStateNormal];
    [resendBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [resendBtn addTarget:self action:@selector(resendBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    resendBtn.alpha = 1.0;
    resendBtn.transform = CGAffineTransformMakeTranslation(10, 0);
    [resendBtn setFont:[UIFont systemFontOfSize:15.0]];
    resendBtn.enabled = NO;
    [self.view addSubview:resendBtn];
    
    UIButton *nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 50, lineImg.frame.origin.y + lineImg.frame.size.height + 20, 100, 40)];
    [nextBtn setTitle:@"下一步 >" forState:UIControlStateNormal];
    nextBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [nextBtn setTitleColor:[UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(nextBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [nextBtn setTintColor:[UIColor lightGrayColor]];
    nextBtn.alpha = 1.0;
    nextBtn.transform = CGAffineTransformMakeTranslation(10, 0);
    [self.view addSubview:nextBtn];
    
    [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(targetMethod:)
                                   userInfo:nil
                                    repeats:YES];
    
}

- (void)resendBtnClicked{
//    NSString *qqsignUp_state = [[NSUserDefaults standardUserDefaults] objectForKey:@"isQQSocialSignUp"];
//    NSString *wechatsignUp_state = [[NSUserDefaults standardUserDefaults] objectForKey:@"isWechatSocialSignUp"];
//    
//    if ([wechatsignUp_state isEqualToString:@"YES"]) {
//        NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
//        
//        NSString *wechatid = [[NSUserDefaults standardUserDefaults] objectForKey:@"wechatID"];
//        NSString *wechatNickname = [[NSUserDefaults standardUserDefaults] objectForKey:@"wechatNickname"];
//        NSString *wechatPhoto = [[NSUserDefaults standardUserDefaults] objectForKey:@"wechatPhoto"];
//        
//        if ([wechatPhoto isEqualToString:@""]) {
//            wechatPhoto = @"default";
//        }
//        else{
//            
//        }
//        NSDictionary *parameters = @{@"phonenumber":phoneNumber,
//                                     @"wechatid": wechatid,
//                                     @"nickname": wechatNickname,
//                                     @"photourl": wechatPhoto,
//                                     @"token": deviceToken
//                                     };
//        
//        [SVProgressHUD showWithStatus:@"请稍后..." maskType:SVProgressHUDMaskTypeBlack];
//        
//        [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
//        [[GlobalPool sharedInstance].OAuth2Manager POST:LC_SOCIAL_SIGNUP parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
//         {
//             NSLog(@"%@",responseObject);
//             
//             NSString *status = [responseObject objectForKey:@"status"];
//             
//             [SVProgressHUD dismiss];
//             if ([status intValue] == 200) {
//                 
//             }
//             else
//             {
////                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"!!!" message:@"Error" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
////                 [alert show];
//             }
//             
//         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//             [SVProgressHUD dismiss];
//         }];
//    }
//    else if ([qqsignUp_state isEqualToString:@"YES"]) {
//        NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
//        
//        NSString *qqid = [[NSUserDefaults standardUserDefaults] objectForKey:@"qqID"];
//        NSString *qqNickname = [[NSUserDefaults standardUserDefaults] objectForKey:@"qqNickname"];
//        NSString *qqPhoto = [[NSUserDefaults standardUserDefaults] objectForKey:@"qqPhoto"];
//        
//        if ([qqPhoto isEqualToString:@""]) {
//            qqPhoto = @"default";
//        }
//        else{
//            
//        }
//        
//        NSDictionary *parameters = @{@"phonenumber":phoneNumber,
//                                     @"qqid": qqid,
//                                     @"nickname": qqNickname,
//                                     @"photourl": qqPhoto,
//                                     @"token": deviceToken
//                                     };
//        
//        [SVProgressHUD showWithStatus:@"请稍后..." maskType:SVProgressHUDMaskTypeBlack];
//        
//        [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
//        [[GlobalPool sharedInstance].OAuth2Manager POST:LC_SOCIAL_SIGNUP parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            NSLog(@"%@",responseObject);
//            
//            NSString *status = [responseObject objectForKey:@"status"];
//            [SVProgressHUD dismiss];
//            if ([status intValue] == 200) {
//                
//            }
//            else{
////                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
////                [alert show];
//            }
//            
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            [SVProgressHUD dismiss];
//        }];
//    }
//    else{
//        NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
//        
//        NSString *registerNickname = [[NSUserDefaults standardUserDefaults] objectForKey:@"register_nickname"];
//        NSString *registerPassword = [[NSUserDefaults standardUserDefaults] objectForKey:@"register_password"];
//        
//        NSDictionary *parameters = @{@"nickname":registerNickname,
//                                     @"phonenumber":phoneNumber,
//                                     @"password": registerPassword,
//                                     @"token": deviceToken
//                                     };
//        
//        [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
//        [[GlobalPool sharedInstance].OAuth2Manager POST:LC_SIGNUP parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            NSLog(@"%@",responseObject);
//            
//            NSString *status = [responseObject objectForKey:@"status"];
//            [SVProgressHUD dismiss];
//            if ([status intValue] == 200) {
//               
//            }
//            else{
////                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
////                [alert show];
//            }
//            
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            [SVProgressHUD dismiss];
//        }];
//    }
}

- (void)backBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) targetMethod:(NSTimer *)timer
{
    if (timeCount == 0) {
        resendBtn.enabled = YES;
        [resendBtn setTitle:@"重新发送" forState:UIControlStateNormal];
        [resendBtn setTitleColor:[UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [timer invalidate];
        timer = nil;
    }
    else{
        timeCount = timeCount - 1;
        NSString *title_btn = [NSString stringWithFormat:@"重新发送(%ds)", timeCount];
        [resendBtn setTitle:title_btn forState:UIControlStateNormal];
    }
    
}

- (void)nextBtnClicked{
    NSString *isForgotPass = [[NSUserDefaults standardUserDefaults] objectForKey:@"forgotPassword"];
    NSString *isUserSignUp = [[NSUserDefaults standardUserDefaults] objectForKey:@"isUserSignUp"];
    NSString *isQQSocialSignUp = [[NSUserDefaults standardUserDefaults] objectForKey:@"isQQSocialSignUp"];
    NSString *isWechatSocialSignUp = [[NSUserDefaults standardUserDefaults] objectForKey:@"isWechatSocialSignUp"];
    NSString *isWeiboSocialSignUp = [[NSUserDefaults standardUserDefaults] objectForKey:@"isWeiboSocialSignUp"];
    
    if ([isForgotPass isEqualToString:@"YES"]) {
        NSDictionary *parameters = @{@"phonenumber":phoneNumber,
                                     @"verifycode": numberField.text
                                     };
        
        [SVProgressHUD showWithStatus:@"请稍后..." maskType:SVProgressHUDMaskTypeBlack];
        
//        [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
        [[GlobalPool sharedInstance].OAuth2Manager POST:LC_USERVERIFY parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@",responseObject);
            
            NSString *status = [responseObject objectForKey:@"status"];
            [SVProgressHUD dismiss];
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
                
                [defaults synchronize];
                
                ChangePassViewController *nextView = [[ChangePassViewController alloc] init];
                [self.navigationController pushViewController:nextView animated:YES];
            }
            else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请正确输入" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                [alert show];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"Connection failed"];
        }];
    }
    
    if ([isWeiboSocialSignUp isEqualToString:@"YES"]) {
        NSLog(@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"weiboID"]);
        NSString *phoneNum = [[NSUserDefaults standardUserDefaults] objectForKey:@"userPhonenumber"];
        
        NSDictionary *parameters = @{@"phonenumber":phoneNum,
                                     @"verifycode": numberField.text,
                                     @"weiboid": [[NSUserDefaults standardUserDefaults] objectForKey:@"weiboID"]
                                     };
        
        [SVProgressHUD showWithStatus:@"请稍后..." maskType:SVProgressHUDMaskTypeBlack];
        
        [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
        [[GlobalPool sharedInstance].OAuth2Manager POST:LC_USERVERIFY parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@",responseObject);
            
            NSString *status = [responseObject objectForKey:@"status"];
            [SVProgressHUD dismiss];
            if ([status intValue] == 200) {
                NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
                
                NSString *userid = [[responseObject objectForKey:@"userinfo"] objectForKey:@"userid"];
                NSString *username = [[responseObject objectForKey:@"userinfo"] objectForKey:@"username"];
                NSString *userPhoto = [[responseObject objectForKey:@"userinfo"] objectForKey:@"photourl"];
                NSString *nickName = [[responseObject objectForKey:@"userinfo"] objectForKey:@"nickname"];
                NSString *langid = [[responseObject objectForKey:@"userinfo"] objectForKey:@"langid"];
                
                [defaults setObject:userid forKey:@"userid"];
                [defaults setObject:username forKey:@"username"];
                [defaults setObject:userPhoto forKey:@"userphoto"];
                [defaults setObject:nickName forKey:@"nickname"];
                [defaults setObject:langid forKey:@"langid"];
                [defaults setObject:@"YES" forKey:@"isLoginState"];
                
                NSString *ischeckedname = [[responseObject objectForKey:@"userinfo"] objectForKey:@"changednickname"];
                if ([ischeckedname intValue] == 0) {
                    [defaults setObject:@"NO" forKey:@"ischeckedNickname"];
                }
                else{
                    [defaults setObject:@"YES" forKey:@"ischeckedNickname"];
                }
                
                [defaults synchronize];
                FifthViewController *nextView = [[FifthViewController alloc] init];
                [self.navigationController pushViewController:nextView animated:YES];
            }
            else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"此号码已注册" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                [alert show];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"Connection failed"];
        }];
    }
    
    if ([isWechatSocialSignUp isEqualToString:@"YES"]) {
        NSLog(@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"wechatID"]);
        NSString *phoneNum = [[NSUserDefaults standardUserDefaults] objectForKey:@"userPhonenumber"];
        
        NSDictionary *parameters = @{@"phonenumber":phoneNum,
                                     @"verifycode": numberField.text,
                                     @"wechatid": [[NSUserDefaults standardUserDefaults] objectForKey:@"wechatID"]
                                     };
        
        [SVProgressHUD showWithStatus:@"请稍后..." maskType:SVProgressHUDMaskTypeBlack];
        
        [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
        [[GlobalPool sharedInstance].OAuth2Manager POST:LC_USERVERIFY parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@",responseObject);
            
            NSString *status = [responseObject objectForKey:@"status"];
            [SVProgressHUD dismiss];
            if ([status intValue] == 200) {
                NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
                
                NSString *userid = [[responseObject objectForKey:@"userinfo"] objectForKey:@"userid"];
                NSString *username = [[responseObject objectForKey:@"userinfo"] objectForKey:@"username"];
                NSString *userPhoto = [[responseObject objectForKey:@"userinfo"] objectForKey:@"photourl"];
                NSString *nickName = [[responseObject objectForKey:@"userinfo"] objectForKey:@"nickname"];
                NSString *langid = [[responseObject objectForKey:@"userinfo"] objectForKey:@"langid"];
                
                [defaults setObject:userid forKey:@"userid"];
                [defaults setObject:username forKey:@"username"];
                [defaults setObject:userPhoto forKey:@"userphoto"];
                [defaults setObject:nickName forKey:@"nickname"];
                [defaults setObject:langid forKey:@"langid"];
                [defaults setObject:@"YES" forKey:@"isLoginState"];
                
                NSString *ischeckedname = [[responseObject objectForKey:@"userinfo"] objectForKey:@"changednickname"];
                if ([ischeckedname intValue] == 0) {
                    [defaults setObject:@"NO" forKey:@"ischeckedNickname"];
                }
                else{
                    [defaults setObject:@"YES" forKey:@"ischeckedNickname"];
                }
                
                [defaults synchronize];
                FifthViewController *nextView = [[FifthViewController alloc] init];
                [self.navigationController pushViewController:nextView animated:YES];
            }
            else{
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
//                [alert show];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"Connection failed"];
        }];
    }
    
    if ([isQQSocialSignUp isEqualToString:@"YES"]) {
        NSString *phoneNum = [[NSUserDefaults standardUserDefaults] objectForKey:@"userPhonenumber"];
        
        NSDictionary *parameters = @{@"phonenumber":phoneNum,
                                     @"verifycode": numberField.text,
                                     @"qqid": [[NSUserDefaults standardUserDefaults] objectForKey:@"qqID"]
                                     };
        
        [SVProgressHUD showWithStatus:@"请稍后..." maskType:SVProgressHUDMaskTypeBlack];
        
        [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
        [[GlobalPool sharedInstance].OAuth2Manager POST:LC_USERVERIFY parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@",responseObject);
            
            NSString *status = [responseObject objectForKey:@"status"];
            [SVProgressHUD dismiss];
            if ([status intValue] == 200) {
                NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
                
                NSString *userid = [[responseObject objectForKey:@"userinfo"] objectForKey:@"userid"];
                NSString *username = [[responseObject objectForKey:@"userinfo"] objectForKey:@"username"];
                NSString *userPhoto = [[responseObject objectForKey:@"userinfo"] objectForKey:@"photourl"];
                NSString *nickName = [[responseObject objectForKey:@"userinfo"] objectForKey:@"nickname"];
                NSString *langid = [[responseObject objectForKey:@"userinfo"] objectForKey:@"langid"];
                
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
                
                [defaults synchronize];
                
                FifthViewController *nextView = [[FifthViewController alloc] init];
                [self.navigationController pushViewController:nextView animated:YES];
            }
            else{
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
//                [alert show];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"Connection failed"];
        }];
    }
    
    if ([isUserSignUp isEqualToString:@"YES"]) {
        NSDictionary *parameters = @{@"username":_username,
                                     @"password":_password,
                                     @"phonenumber":phoneNumber,
                                     @"verifycode": numberField.text
                                     };
        
        [SVProgressHUD showWithStatus:@"请稍后..." maskType:SVProgressHUDMaskTypeBlack];
        
        [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
        [[GlobalPool sharedInstance].OAuth2Manager POST:LC_USERVERIFY parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@",responseObject);
            
            NSString *status = [responseObject objectForKey:@"status"];
            [SVProgressHUD dismiss];
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
                
                FifthViewController *nextView = [[FifthViewController alloc] init];
                [self.navigationController pushViewController:nextView animated:YES];
            }
            else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请输入正确的密码" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                [alert show];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"Connection failed"];
        }];
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
