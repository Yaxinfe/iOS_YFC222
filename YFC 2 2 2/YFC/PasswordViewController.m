//
//  PasswordViewController.m
//  YFC
//
//  Created by topone on 9/1/15.
//  Copyright (c) 2015 ming. All rights reserved.
//
#import "publicHeaders.h"

#import "PasswordViewController.h"

@interface PasswordViewController ()<UITextFieldDelegate>
{
    UITextField *currentText;
    UITextField *resetText;
    UITextField *againText;
}
@end

@implementation PasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    
    currentText = [[UITextField alloc] initWithFrame:CGRectMake(lineImg1.frame.origin.x + 10, lineImg1.frame.origin.y + 3, lineImg1.frame.size.width - 20, lineImg1.frame.size.width/6 - 6)];
    currentText.delegate = self;
//    currentText.placeholder = @"현재비밀번호 입력";
    currentText.backgroundColor = [UIColor clearColor];
    currentText.textColor = [UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0];
    currentText.font = [UIFont systemFontOfSize:16];
    currentText.secureTextEntry = YES;
    [currentText setValue:[UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0] forKeyPath:@"_placeholderLabel.textColor"];
    [self.view addSubview:currentText];
    
    UIImageView *lineImg2 = [[UIImageView alloc] initWithFrame:CGRectMake(40, lineImg1.frame.origin.y + (self.view.frame.size.width - 80)/6 + 5, self.view.frame.size.width - 80, (self.view.frame.size.width - 80)/6)];
    lineImg2.backgroundColor = [UIColor clearColor];
    lineImg2.layer.cornerRadius = 5;
    lineImg2.layer.borderColor = [UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0].CGColor;
    lineImg2.layer.borderWidth = 1;
    lineImg2.layer.masksToBounds = YES;
    [self.view addSubview:lineImg2];
    
    resetText = [[UITextField alloc] initWithFrame:CGRectMake(lineImg2.frame.origin.x + 10, lineImg2.frame.origin.y + 3, lineImg2.frame.size.width - 20, lineImg2.frame.size.width/6 - 6)];
    resetText.delegate = self;
//    resetText.placeholder = @"수정할 비밀번호 입력";
    resetText.backgroundColor = [UIColor clearColor];
    resetText.textColor = [UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0];
    resetText.font = [UIFont systemFontOfSize:16];
    resetText.secureTextEntry = YES;
    [resetText setValue:[UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0] forKeyPath:@"_placeholderLabel.textColor"];
    [self.view addSubview:resetText];
    
    UIImageView *lineImg3 = [[UIImageView alloc] initWithFrame:CGRectMake(40, lineImg2.frame.origin.y + (self.view.frame.size.width - 80)/6 + 5, self.view.frame.size.width - 80, (self.view.frame.size.width - 80)/6)];
    lineImg3.backgroundColor = [UIColor clearColor];
    lineImg3.layer.cornerRadius = 5;
    lineImg3.layer.borderColor = [UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0].CGColor;
    lineImg3.layer.borderWidth = 1;
    lineImg3.layer.masksToBounds = YES;
    [self.view addSubview:lineImg3];
    
    againText = [[UITextField alloc] initWithFrame:CGRectMake(lineImg3.frame.origin.x + 10, lineImg3.frame.origin.y + 3, lineImg3.frame.size.width - 20, lineImg3.frame.size.width/6 - 6)];
    againText.delegate = self;
//    againText.placeholder = @"수정할 비밀번호 재입력";
    againText.backgroundColor = [UIColor clearColor];
    againText.textColor = [UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0];
    againText.font = [UIFont systemFontOfSize:16];
    againText.secureTextEntry = YES;
    [againText setValue:[UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0] forKeyPath:@"_placeholderLabel.textColor"];
    [self.view addSubview:againText];
    
    UIButton *finish_btn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 150, lineImg3.frame.origin.y + lineImg3.frame.size.height + 10, 150, 40)];
    [finish_btn setImage:[UIImage imageNamed:@"profinishBtn.png"] forState:UIControlStateNormal];
    [finish_btn addTarget:self action:@selector(finishBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [finish_btn setTintColor:[UIColor lightGrayColor]];
    finish_btn.alpha = 1.0;
    finish_btn.transform = CGAffineTransformMakeTranslation(10, 0);
    [self.view addSubview:finish_btn];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    [self.view addGestureRecognizer:tapGesture];
}

- (void)finishBtnClicked{
    if ([resetText.text isEqualToString:againText.text]) {
        NSString *userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"];
        NSString *sessionkey = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionkey"];
        
        NSDictionary *parameters = @{@"userid":userid,
                                     @"oldpass":currentText.text,
                                     @"newpass":resetText.text,
                                     @"sessionkey":sessionkey
                                     };
        
        [SVProgressHUD showWithStatus:@"请稍后..." maskType:SVProgressHUDMaskTypeBlack];
        [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
        [[GlobalPool sharedInstance].OAuth2Manager POST:LC_SETTINGS_CHANGEPASS parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@",responseObject);
            
            NSString *status = [responseObject objectForKey:@"status"];
            if ([status intValue] == 200) {
                [self.navigationController popViewControllerAnimated:YES];
                NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
                if ([applang isEqualToString:@"ko"]) {
                    [ProgressHUD showSuccess:@"정확히 변경되였습니다."];
                }
                if ([applang isEqualToString:@"cn"]) {
                    [ProgressHUD showSuccess:@"更改成功"];
                }
            }
            else if ([status intValue] == 1001){
                NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:@"NO" forKey:@"isLoginState"];
                [defaults synchronize];
                [[AppDelegate sharedAppDelegate] runMain];
            }
            else{
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
//                [alert show];
            }
            [SVProgressHUD dismiss];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"Connection failed"];
        }];
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

- (void)viewTapped:(UIGestureRecognizer *)gesture {
    [currentText resignFirstResponder];
    [resetText resignFirstResponder];
    [againText resignFirstResponder];
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
