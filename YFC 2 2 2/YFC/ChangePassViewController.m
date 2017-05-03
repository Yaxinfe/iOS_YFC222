//
//  ChangePassViewController.m
//  YFC
//
//  Created by topone on 9/4/15.
//  Copyright (c) 2015 ming. All rights reserved.
//
#import "publicHeaders.h"

#import "ChangePassViewController.h"
#import "PassChangeViewController.h"

@interface ChangePassViewController ()<UITextFieldDelegate>
{
    UITextField *passTxt;
    UITextField *resetTxt;
}
@end

@implementation ChangePassViewController

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
    [lbl_Title setFont:[UIFont systemFontOfSize:18.0]];
    lbl_Title.text = @"4. 修改密码";
    [self.view addSubview:lbl_Title];
    
    UIImageView *lineImg1 = [[UIImageView alloc] initWithFrame:CGRectMake(40, 80, self.view.frame.size.width - 80, (self.view.frame.size.width - 80)/6)];
    lineImg1.backgroundColor = [UIColor clearColor];
    lineImg1.layer.cornerRadius = 5;
    lineImg1.layer.borderColor = [UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0].CGColor;
    lineImg1.layer.borderWidth = 1;
    lineImg1.layer.masksToBounds = YES;
    [self.view addSubview:lineImg1];
    
    passTxt = [[UITextField alloc] initWithFrame:CGRectMake(lineImg1.frame.origin.x + 10, lineImg1.frame.origin.y + 3, lineImg1.frame.size.width - 20, lineImg1.frame.size.width/6 - 6)];
    passTxt.backgroundColor = [UIColor clearColor];
    passTxt.textColor = [UIColor blackColor];
    passTxt.font = [UIFont systemFontOfSize:15];
    passTxt.placeholder = @"请输入新的登录密码";
    passTxt.secureTextEntry = YES;
    passTxt.delegate = self;
    [passTxt setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.view addSubview:passTxt];
    
    UIImageView *lineImg2 = [[UIImageView alloc] initWithFrame:CGRectMake(40, lineImg1.frame.origin.y + lineImg1.frame.size.height + 10, self.view.frame.size.width - 80, (self.view.frame.size.width - 80)/6)];
    lineImg2.backgroundColor = [UIColor clearColor];
    lineImg2.layer.cornerRadius = 5;
    lineImg2.layer.borderColor = [UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0].CGColor;
    lineImg2.layer.borderWidth = 1;
    lineImg2.layer.masksToBounds = YES;
    [self.view addSubview:lineImg2];
    
    resetTxt = [[UITextField alloc] initWithFrame:CGRectMake(lineImg2.frame.origin.x + 10, lineImg2.frame.origin.y + 3, lineImg2.frame.size.width - 20, lineImg2.frame.size.width/6 - 6)];
    resetTxt.backgroundColor = [UIColor clearColor];
    resetTxt.textColor = [UIColor blackColor];
    resetTxt.font = [UIFont systemFontOfSize:15];
    resetTxt.placeholder = @"请重新输入新的登录密码";
    resetTxt.secureTextEntry = YES;
    resetTxt.delegate = self;
    [resetTxt setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.view addSubview:resetTxt];
    
    UIButton *nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 50, lineImg2.frame.origin.y + lineImg2.frame.size.height + 10, 100, 40)];
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

- (void)viewTapped:(UIGestureRecognizer *)gesture {
    [passTxt resignFirstResponder];
    [resetTxt resignFirstResponder];
}

- (void)nextBtnClicked{
    
    if ([passTxt.text isEqualToString:@""] || [resetTxt.text isEqualToString:@""] || ![passTxt.text isEqualToString:resetTxt.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请正确输入" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
    }
    else{
        NSString *userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"];
        
        NSDictionary *parameters = @{@"userid":userid,
                                     @"password":passTxt.text,
                                     @"uptype":@"1"
                                     };
        
        [SVProgressHUD showWithStatus:@"请稍后..." maskType:SVProgressHUDMaskTypeBlack];
        
        [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
        [[GlobalPool sharedInstance].OAuth2Manager POST:LC_SETTINGS_UPDATE parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@",responseObject);
            
            NSString *status = [responseObject objectForKey:@"status"];
            [SVProgressHUD dismiss];
            if ([status intValue] == 200) {
                PassChangeViewController *nextView = [[PassChangeViewController alloc] init];
                [self.navigationController pushViewController:nextView animated:YES];
            }
            else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"修改密码失败" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
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
