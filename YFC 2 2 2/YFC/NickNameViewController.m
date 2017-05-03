//
//  NickNameViewController.m
//  YFC
//
//  Created by topone on 9/1/15.
//  Copyright (c) 2015 ming. All rights reserved.
//

#import "NickNameViewController.h"
#import "publicHeaders.h"

@interface NickNameViewController ()<UITextFieldDelegate>
{
    UITextField *nameText;
    BOOL         isConfirmNickname;
}
@end

@implementation NickNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isConfirmNickname = NO;
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    backImageView.image = [UIImage imageNamed:@"settingBack.png"];
    [self.view addSubview:backImageView];
    
    UIButton *back_btn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.origin.x , self.view.frame.origin.y + 25, 27, 30)];
    [back_btn setImage:[UIImage imageNamed:@"backBtn.png"] forState:UIControlStateNormal];
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
    
    UIImageView *lineImg5 =[UIImageView new];
    lineImg5.frame=CGRectMake(0, 63, self.view.frame.size.width, 2);
    lineImg5.clipsToBounds = YES;
    lineImg5.userInteractionEnabled=YES;
    lineImg5.backgroundColor = [UIColor colorWithRed:216.0/255.0 green:229.0/255.0 blue:241.0/255.0 alpha:1.0];
    [self.view addSubview:lineImg5];
    
    UIImageView *lineImg1 = [[UIImageView alloc] initWithFrame:CGRectMake(40, 80, self.view.frame.size.width - 80, (self.view.frame.size.width - 80)/6)];
    lineImg1.backgroundColor = [UIColor clearColor];
    lineImg1.layer.cornerRadius = 5;
    lineImg1.layer.borderColor = [UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0].CGColor;
    lineImg1.layer.borderWidth = 1;
    lineImg1.layer.masksToBounds = YES;
    [self.view addSubview:lineImg1];
    
    nameText = [[UITextField alloc] initWithFrame:CGRectMake(lineImg1.frame.origin.x + 10, lineImg1.frame.origin.y + 3, lineImg1.frame.size.width - 20, lineImg1.frame.size.width/6 - 6)];
    nameText.delegate = self;
//    nameText.placeholder = @"닉네임은 한번밖에 설정못합니다.";
    nameText.backgroundColor = [UIColor clearColor];
    nameText.textColor = [UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0];
    nameText.font = [UIFont systemFontOfSize:16];
    [nameText setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.view addSubview:nameText];
    
    UIButton *confirm_btn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 60, lineImg1.frame.origin.y + lineImg1.frame.size.height + 15, 120, 40)];
    [confirm_btn setBackgroundImage:[UIImage imageNamed:@"confirmBtn.png"] forState:UIControlStateNormal];
    [confirm_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirm_btn addTarget:self action:@selector(confirmBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [confirm_btn setTintColor:[UIColor lightGrayColor]];
    confirm_btn.alpha = 1.0;
    confirm_btn.transform = CGAffineTransformMakeTranslation(10, 0);
    [self.view addSubview:confirm_btn];
    
    UIButton *done_btn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 150, confirm_btn.frame.origin.y + confirm_btn.frame.size.height + 30, 150, 40)];
    [done_btn setBackgroundImage:[UIImage imageNamed:@"settedBtn.png"] forState:UIControlStateNormal];
    [done_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [done_btn addTarget:self action:@selector(settedBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [done_btn setTintColor:[UIColor lightGrayColor]];
    done_btn.alpha = 1.0;
    done_btn.transform = CGAffineTransformMakeTranslation(10, 0);
    [self.view addSubview:done_btn];
    
    NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
    if ([applang isEqualToString:@"ko"]) {
        titleLbl.text = NICKNAME_SETTING_TITLE[0];
        nameText.placeholder = NICKNAME_SETTING_PLACEHOLDER[0];
        [confirm_btn setTitle:NICKNAME_SETTING_CONFIRM_BUTTON[0] forState:UIControlStateNormal];
        [done_btn setTitle:NICKNAME_SETTING_SETTING_BUTTON[0] forState:UIControlStateNormal];
    }
    if ([applang isEqualToString:@"cn"]) {
        titleLbl.text = NICKNAME_SETTING_TITLE[1];
        nameText.placeholder = NICKNAME_SETTING_PLACEHOLDER[1];
        [confirm_btn setTitle:NICKNAME_SETTING_CONFIRM_BUTTON[1] forState:UIControlStateNormal];
        [done_btn setTitle:NICKNAME_SETTING_SETTING_BUTTON[1] forState:UIControlStateNormal];
    }
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    [self.view addGestureRecognizer:tapGesture];
}

- (void)viewTapped:(UIGestureRecognizer *)gesture {
    [nameText resignFirstResponder];
}

- (void)backBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)confirmBtnClicked{
    NSString *userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"];
    NSString *sessionkey = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionkey"];
    
    NSDictionary *parameters = @{@"userid":userid,
                                 @"username":nameText.text,
                                 @"sessionkey":sessionkey
                                 };
    
    [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
    [[GlobalPool sharedInstance].OAuth2Manager POST:LC_SIGNUP_CHECKNAME parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        
        NSString *status = [responseObject objectForKey:@"status"];
        if ([status intValue] == 200) {
            NSString *exist = [responseObject objectForKey:@"existflag"];
            if ([exist intValue] == 1) {
                NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
                if ([applang isEqualToString:@"ko"]) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"이미 사용중인 닉네임입니다." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [alert show];
                }
                if ([applang isEqualToString:@"cn"]) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"通知" message:@"该用户名已被注册" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                    [alert show];
                }
            
                isConfirmNickname = NO;
            }
            else{
                NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
                if ([applang isEqualToString:@"ko"]) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"사용가능한 닉네임입니다." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                }
                if ([applang isEqualToString:@"cn"]) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"通知" message:@"사용가능한 닉네임입니다." delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                    [alert show];
                }
                
                isConfirmNickname = YES;
            }
        }
        else{
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"Connection failed"];
    }];
}

- (void)settedBtnClicked{
    if (![nameText.text isEqualToString:@""]) {
        if (isConfirmNickname == YES) {
            NSString *userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"];
            NSString *sessionkey = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionkey"];
            
            NSDictionary *parameters = @{@"userid":userid,
                                         @"nickname":nameText.text,
                                         @"sessionkey":sessionkey
                                         };
            
            [SVProgressHUD showWithStatus:@"请稍后..." maskType:SVProgressHUDMaskTypeBlack];
            [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
            [[GlobalPool sharedInstance].OAuth2Manager POST:LC_SETTINGS_UPDATE parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"%@",responseObject);
                
                NSString *status = [responseObject objectForKey:@"status"];
                if ([status intValue] == 200) {
                    NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
                    if ([applang isEqualToString:@"ko"]) {
                        [ProgressHUD showSuccess:@"정확히 변경되였습니다."];
                    }
                    if ([applang isEqualToString:@"cn"]) {
                        [ProgressHUD showSuccess:@"更改成功"];
                    }
                    
                    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
                    NSString *nickName = [[responseObject objectForKey:@"userinfo"] objectForKey:@"nickname"];
                    [defaults setObject:nickName forKey:@"nickname"];
                    [defaults setObject:@"YES" forKey:@"ischeckedNickname"];
                    [defaults synchronize];
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else if ([status intValue] == 1001){
                    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setObject:@"NO" forKey:@"isLoginState"];
                    [defaults synchronize];
                    [[AppDelegate sharedAppDelegate] runMain];
                }
                else{

                }
                [SVProgressHUD dismiss];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [SVProgressHUD showErrorWithStatus:@"Connection failed"];
            }];
        }
        else{
            NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
            if ([applang isEqualToString:@"ko"]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"이미 사용중인 닉네임입니다." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
            if ([applang isEqualToString:@"cn"]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"该用户名已被注册" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                [alert show];
            }
        }
    }
    else{
        NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
        if ([applang isEqualToString:@"ko"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"정확히 입력해주세요." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        if ([applang isEqualToString:@"cn"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请正确输入" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            [alert show];
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
