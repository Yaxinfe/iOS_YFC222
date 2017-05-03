//
//  ThirdViewController.m
//  YFC
//
//  Created by topone on 7/14/15.
//  Copyright (c) 2015 ming. All rights reserved.
//

#import "publicHeaders.h"
#import "ThirdViewController.h"
#import "FourthViewController.h"
#import "ChangePassViewController.h"

@interface ThirdViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *phoneField;

@end

@implementation ThirdViewController
@synthesize phoneField;

- (void)viewDidLoad {
    [super viewDidLoad];
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
    [lbl_Title setFrame:CGRectMake(self.view.frame.size.width - 140, 30, 120, 30)];
    [lbl_Title setTextAlignment:NSTextAlignmentCenter];
    [lbl_Title setTextColor:[UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0]];
    [lbl_Title setBackgroundColor:[UIColor clearColor]];
    [lbl_Title setFont:[UIFont systemFontOfSize:20.0]];
    lbl_Title.text = @"2. 手机号码";
    [self.view addSubview:lbl_Title];
    
    UILabel *lbl_Success = [[UILabel alloc] init];
    [lbl_Success setFrame:CGRectMake(self.view.frame.size.width/2 - 150, 120, 300, 20)];
    [lbl_Success setTextAlignment:NSTextAlignmentCenter];
    [lbl_Success setTextColor:[UIColor blackColor]];
    [lbl_Success setBackgroundColor:[UIColor clearColor]];
    [lbl_Success setFont:[UIFont boldSystemFontOfSize:22.0]];
    lbl_Success.text = @"请输入手机号码";
    [self.view addSubview:lbl_Success];
    
    phoneField = [[UITextField alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 120, lbl_Success.frame.origin.y + lbl_Success.frame.size.height + 30, 240, 20)];
    phoneField.backgroundColor = [UIColor clearColor];
    phoneField.textColor = [UIColor blackColor];
    phoneField.font = [UIFont systemFontOfSize:18];
    phoneField.placeholder = @"手机号码";
    phoneField.keyboardType = UIKeyboardTypeNumberPad;
    phoneField.delegate = self;
    [phoneField setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.view addSubview:phoneField];
    
    UIImageView *lineImg = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 120, phoneField.frame.origin.y + phoneField.frame.size.height + 4, 240, 1)];
    lineImg.backgroundColor = [UIColor grayColor];
    [self.view addSubview:lineImg];
    
    UIButton *nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 50, lineImg.frame.origin.y + lineImg.frame.size.height + 20, 100, 40)];
    [nextBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    nextBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [nextBtn setTitleColor:[UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(nextBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [nextBtn setTintColor:[UIColor lightGrayColor]];
    nextBtn.alpha = 1.0;
    nextBtn.transform = CGAffineTransformMakeTranslation(10, 0);
    [self.view addSubview:nextBtn];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    [self.view addGestureRecognizer:tapGesture];
}

- (void)backBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewTapped:(UIGestureRecognizer *)gesture {
    [phoneField resignFirstResponder];
}

- (void)nextBtnClicked{
    NSString *qqsignUp_state = [[NSUserDefaults standardUserDefaults] objectForKey:@"isQQSocialSignUp"];
    NSString *wechatsignUp_state = [[NSUserDefaults standardUserDefaults] objectForKey:@"isWechatSocialSignUp"];
    NSString *weibosignUp_state = [[NSUserDefaults standardUserDefaults] objectForKey:@"isWeiboSocialSignUp"];
    NSString *usersignUp_state = [[NSUserDefaults standardUserDefaults] objectForKey:@"isUserSignUp"];
    NSString *forgotPass_state = [[NSUserDefaults standardUserDefaults] objectForKey:@"forgotPassword"];
    
    if ([phoneField.text length] < 7) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请输入正确的手机号码" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
    }
    else{
        if ([weibosignUp_state isEqualToString:@"YES"]) {
            NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
            
            NSString *wechatid = [[NSUserDefaults standardUserDefaults] objectForKey:@"weiboID"];
            NSString *wechatNickname = [[NSUserDefaults standardUserDefaults] objectForKey:@"weiboNickname"];
            NSString *wechatPhoto = [[NSUserDefaults standardUserDefaults] objectForKey:@"weiboPhoto"];
            
            NSLog(@"%@", phoneField.text);
            
            if ([wechatPhoto isEqualToString:@""]) {
                wechatPhoto = @"default";
            }
            else{
                
            }
            NSDictionary *parameters = @{@"phonenumber":phoneField.text,
                                         @"weiboid": wechatid,
                                         @"nickname": wechatNickname,
                                         @"photourl": wechatPhoto,
                                         @"token": deviceToken
                                         };
            
            [SVProgressHUD showWithStatus:@"请稍后..." maskType:SVProgressHUDMaskTypeBlack];
            
            [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
            [[GlobalPool sharedInstance].OAuth2Manager POST:LC_SOCIAL_SIGNUP parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
             {
                 NSLog(@"%@",responseObject);
                 
                 NSString *status = [responseObject objectForKey:@"status"];
                 
                 [SVProgressHUD dismiss];
                 if ([status intValue] == 200) {
                     NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
                     [defaults setObject:phoneField.text forKey:@"userPhonenumber"];
                     [defaults synchronize];
                     FourthViewController *nextView = [[FourthViewController alloc] init];
                     nextView.phoneNumber = phoneField.text;
                     [self.navigationController pushViewController:nextView animated:YES];
                 }
                 else if ([status intValue] == 600) {
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"该号码已被注册" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                     [alert show];
                 }
                 else
                 {
                     
                 }
                 
             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 [SVProgressHUD showErrorWithStatus:@"Connection failed"];
             }];
        }
        
        if ([wechatsignUp_state isEqualToString:@"YES"]) {
            NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
            
            NSString *wechatid = [[NSUserDefaults standardUserDefaults] objectForKey:@"wechatID"];
            NSString *wechatNickname = [[NSUserDefaults standardUserDefaults] objectForKey:@"wechatNickname"];
            NSString *wechatPhoto = [[NSUserDefaults standardUserDefaults] objectForKey:@"wechatPhoto"];
            
            NSLog(@"%@", phoneField.text);
            
            if ([wechatPhoto isEqualToString:@""]) {
                wechatPhoto = @"default";
            }
            else{
                
            }
            NSDictionary *parameters = @{@"phonenumber":phoneField.text,
                                         @"wechatid": wechatid,
                                         @"nickname": wechatNickname,
                                         @"photourl": wechatPhoto,
                                         @"token": deviceToken
                                         };
            
            [SVProgressHUD showWithStatus:@"请稍后..." maskType:SVProgressHUDMaskTypeBlack];
            
            [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
            [[GlobalPool sharedInstance].OAuth2Manager POST:LC_SOCIAL_SIGNUP parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
             {
                 NSLog(@"%@",responseObject);
                 
                 NSString *status = [responseObject objectForKey:@"status"];
                 
                 [SVProgressHUD dismiss];
                 if ([status intValue] == 200) {
                     NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
                     [defaults setObject:phoneField.text forKey:@"userPhonenumber"];
                     [defaults synchronize];
                     FourthViewController *nextView = [[FourthViewController alloc] init];
                     nextView.phoneNumber = phoneField.text;
                     [self.navigationController pushViewController:nextView animated:YES];
                 }
                 else if ([status intValue] == 600) {
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"该号码已被注册" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                     [alert show];
                 }
                 else
                 {
                     
                 }
                 
             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 [SVProgressHUD showErrorWithStatus:@"Connection failed"];
             }];
        }
        
        if ([qqsignUp_state isEqualToString:@"YES"]) {
            NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
            
            NSString *qqid = [[NSUserDefaults standardUserDefaults] objectForKey:@"qqID"];
            NSString *qqNickname = [[NSUserDefaults standardUserDefaults] objectForKey:@"qqNickname"];
            NSString *qqPhoto = [[NSUserDefaults standardUserDefaults] objectForKey:@"qqPhoto"];
            
            if ([qqPhoto isEqualToString:@""]) {
                qqPhoto = @"default";
            }
            else{
                
            }
            
            NSDictionary *parameters = @{@"phonenumber":phoneField.text,
                                         @"qqid": qqid,
                                         @"nickname": qqNickname,
                                         @"photourl": qqPhoto,
                                         @"token": deviceToken
                                         };
            
            [SVProgressHUD showWithStatus:@"请稍后..." maskType:SVProgressHUDMaskTypeBlack];
            
            [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
            [[GlobalPool sharedInstance].OAuth2Manager POST:LC_SOCIAL_SIGNUP parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"%@",responseObject);
                
                NSString *status = [responseObject objectForKey:@"status"];
                [SVProgressHUD dismiss];
                if ([status intValue] == 200) {
                    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setObject:phoneField.text forKey:@"userPhonenumber"];
                    [defaults synchronize];
                    FourthViewController *nextView = [[FourthViewController alloc] init];
                    nextView.phoneNumber = phoneField.text;
                    [self.navigationController pushViewController:nextView animated:YES];
                }
                else if ([status intValue] == 600) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"该号码已被注册" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                    [alert show];
                }
                else{
                    
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [SVProgressHUD showErrorWithStatus:@"Connection failed"];
            }];
        }
        if ([usersignUp_state isEqualToString:@"YES"]) {
//            NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
//            NSDictionary *parameters = @{@"username":_username,
//                                         @"phonenumber":phoneField.text,
//                                         @"password": _password,
//                                         @"token": deviceToken
//                                         };
            NSDictionary *parameters = @{@"phonenumber":phoneField.text
                                         };
            
            [SVProgressHUD showWithStatus:@"请稍后..." maskType:SVProgressHUDMaskTypeBlack];
            
            [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
            [[GlobalPool sharedInstance].OAuth2Manager POST:LC_SIGNUP parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"%@",responseObject);
                
                NSString *status = [responseObject objectForKey:@"status"];
                [SVProgressHUD dismiss];
                if ([status intValue] == 200) {
                    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
                    [userdefault setObject:_username forKey:@"register_username"];
                    [userdefault setObject:_password forKey:@"register_password"];
                    [userdefault synchronize];
                    
                    FourthViewController *nextView = [[FourthViewController alloc] init];
                    nextView.phoneNumber = phoneField.text;
                    nextView.username = _username;
                    nextView.password = _password;
                    [self.navigationController pushViewController:nextView animated:YES];
                }
//                else if ([status intValue] == 600) {
//                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"此号码已注册" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
//                    [alert show];
//                }
                else{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"此号码已注册" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                    [alert show];
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [SVProgressHUD showErrorWithStatus:@"Connection failed"];
            }];
        }
        if ([forgotPass_state isEqualToString:@"YES"]) {
            NSDictionary *parameters = @{@"phonenumber":phoneField.text
                                         };
            
            [SVProgressHUD showWithStatus:@"请稍后..." maskType:SVProgressHUDMaskTypeBlack];
            [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
            [[GlobalPool sharedInstance].OAuth2Manager POST:LC_SEND_VERIFY parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"%@",responseObject);
                
                NSString *status = [responseObject objectForKey:@"status"];
                [SVProgressHUD dismiss];
                if ([status intValue] == 200) {
                    FourthViewController *nextView = [[FourthViewController alloc] init];
                    nextView.phoneNumber = phoneField.text;
                    [self.navigationController pushViewController:nextView animated:YES];
                }
                if ([status intValue] == 607) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"该用户不存在" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                    [alert show];
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [SVProgressHUD showErrorWithStatus:@"Connection failed"];
            }];
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
