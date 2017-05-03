//
//  SignupViewController.m
//  YFC
//
//  Created by topone on 9/4/15.
//  Copyright (c) 2015 ming. All rights reserved.
//
#import "publicHeaders.h"

#import "SignupViewController.h"
#import "PolicyViewController.h"
#import "ThirdViewController.h"
#import "AppDelegate.h"

@interface SignupViewController ()<UITextFieldDelegate>
{
    UITextField *resetTxt;
    UITextField *userTxt;
    UITextField *passTxt;
    
    UIButton *checkBtn;
    BOOL      isCheck;
}
@end

@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isCheck = NO;
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
    
    userTxt = [[UITextField alloc] initWithFrame:CGRectMake(lineImg1.frame.origin.x + 10, lineImg1.frame.origin.y + 3, lineImg1.frame.size.width - 20, lineImg1.frame.size.width/6 - 6)];
    userTxt.backgroundColor = [UIColor clearColor];
    userTxt.textColor = [UIColor blackColor];
    userTxt.font = [UIFont systemFontOfSize:15];
    userTxt.placeholder = @"请输入登录账号";
    userTxt.keyboardType = UIKeyboardTypeDefault;
    userTxt.delegate = self;
    [userTxt setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.view addSubview:userTxt];
    
    UIImageView *lineImg2 = [[UIImageView alloc] initWithFrame:CGRectMake(40, lineImg1.frame.origin.y + lineImg1.frame.size.height + 10, self.view.frame.size.width - 80, (self.view.frame.size.width - 80)/6)];
    lineImg2.backgroundColor = [UIColor clearColor];
    lineImg2.layer.cornerRadius = 5;
    lineImg2.layer.borderColor = [UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0].CGColor;
    lineImg2.layer.borderWidth = 1;
    lineImg2.layer.masksToBounds = YES;
    [self.view addSubview:lineImg2];
    
    passTxt = [[UITextField alloc] initWithFrame:CGRectMake(lineImg2.frame.origin.x + 10, lineImg2.frame.origin.y + 3, lineImg2.frame.size.width - 20, lineImg2.frame.size.width/6 - 6)];
    passTxt.backgroundColor = [UIColor clearColor];
    passTxt.textColor = [UIColor blackColor];
    passTxt.font = [UIFont systemFontOfSize:15];
    passTxt.placeholder = @"请输入登录密码";
    passTxt.secureTextEntry = YES;
    passTxt.delegate = self;
    [passTxt setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.view addSubview:passTxt];
    
    UIImageView *lineImg3 = [[UIImageView alloc] initWithFrame:CGRectMake(40, lineImg2.frame.origin.y + lineImg2.frame.size.height + 10, self.view.frame.size.width - 80, (self.view.frame.size.width - 80)/6)];
    lineImg3.backgroundColor = [UIColor clearColor];
    lineImg3.layer.cornerRadius = 5;
    lineImg3.layer.borderColor = [UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0].CGColor;
    lineImg3.layer.borderWidth = 1;
    lineImg3.layer.masksToBounds = YES;
    [self.view addSubview:lineImg3];
    
    resetTxt = [[UITextField alloc] initWithFrame:CGRectMake(lineImg3.frame.origin.x + 10, lineImg3.frame.origin.y + 3, lineImg3.frame.size.width - 20, lineImg3.frame.size.width/6 - 6)];
    resetTxt.backgroundColor = [UIColor clearColor];
    resetTxt.textColor = [UIColor blackColor];
    resetTxt.font = [UIFont systemFontOfSize:15];
    resetTxt.placeholder = @"请再输入登录密码";
    resetTxt.secureTextEntry = YES;
    resetTxt.delegate = self;
    [resetTxt setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.view addSubview:resetTxt];
    
    checkBtn = [[UIButton alloc] initWithFrame:CGRectMake(40, lineImg3.frame.origin.y + lineImg3.frame.size.height + 10, 30, 30)];
    checkBtn.layer.cornerRadius = 3;
    checkBtn.layer.borderColor = [UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0].CGColor;
    checkBtn.layer.borderWidth = 1;
    [checkBtn addTarget:self action:@selector(checkBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    checkBtn.layer.masksToBounds = YES;
    [self.view addSubview:checkBtn];
    
    UIButton *policyBtn = [[UIButton alloc] initWithFrame:CGRectMake(checkBtn.frame.origin.x + checkBtn.frame.size.width + 3, lineImg3.frame.origin.y + lineImg3.frame.size.height + 10, 250, 30)];
    [policyBtn setTitle:@"同意《延边富德足球俱乐部使用协议" forState:UIControlStateNormal];
    policyBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [policyBtn setTitleColor:[UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [policyBtn addTarget:self action:@selector(policyBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [policyBtn setTintColor:[UIColor lightGrayColor]];
    policyBtn.alpha = 1.0;
    policyBtn.transform = CGAffineTransformMakeTranslation(10, 0);
    [self.view addSubview:policyBtn];
    
    UIButton *nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 50, lineImg3.frame.origin.y + lineImg3.frame.size.height + 60, 100, 40)];
    [nextBtn setTitle:@"下一步 >" forState:UIControlStateNormal];
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

- (void)nextBtnClicked{
    if ([userTxt.text isEqualToString:@""] || [passTxt.text isEqualToString:@""] || [resetTxt.text isEqualToString:@""] || ![passTxt.text isEqualToString:resetTxt.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请输入正确的密码" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
    }
    else{
        if (isCheck == YES) {
            NSDictionary *parameters = @{@"username":userTxt.text
                                         };
            [SVProgressHUD showWithStatus:@"请稍后..." maskType:SVProgressHUDMaskTypeBlack];
            
            [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
            [[GlobalPool sharedInstance].OAuth2Manager POST:LC_SIGNUP_CHECKNAME parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"%@",responseObject);
                [SVProgressHUD dismiss];
                
                NSString *status = [responseObject objectForKey:@"status"];
                NSString *flag = [responseObject objectForKey:@"existflag"];
                if ([status intValue] == 200 && [flag intValue] == 0) {
                    ThirdViewController *thirdView = [[ThirdViewController alloc] init];
                    thirdView.username = userTxt.text;
                    thirdView.password = passTxt.text;
                    [self.navigationController pushViewController:thirdView animated:YES];
                }
                else{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"该账号已被注册" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                    [alert show];
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [SVProgressHUD showErrorWithStatus:@"Connection failed"];
            }];
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请查看协议" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}

- (void)policyBtnClicked{
    PolicyViewController *policyView = [[PolicyViewController alloc] init];
    [self.navigationController pushViewController:policyView animated:YES];
}

- (void)checkBtnClicked{
    if (isCheck == NO) {
        [checkBtn setImage:[UIImage imageNamed:@"checkmark1.png"] forState:UIControlStateNormal];
        isCheck = YES;
    }
    else{
        [checkBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [checkBtn setBackgroundColor:[UIColor whiteColor]];
        isCheck = NO;
    }
}

- (void)viewTapped:(UIGestureRecognizer *)gesture {
    [userTxt resignFirstResponder];
    [resetTxt resignFirstResponder];
    [passTxt resignFirstResponder];
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
