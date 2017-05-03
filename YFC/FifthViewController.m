//
//  FifthViewController.m
//  YFC
//
//  Created by topone on 7/14/15.
//  Copyright (c) 2015 ming. All rights reserved.
//
#import "publicHeaders.h"

#import "FifthViewController.h"
#import "MainViewController.h"

@interface FifthViewController ()

@end

@implementation FifthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    backImageView.image = [UIImage imageNamed:@"firstViewBack"];
    [self.view addSubview:backImageView];
    
    UILabel *lbl_Title = [[UILabel alloc] init];
    [lbl_Title setFrame:CGRectMake(self.view.frame.size.width - 100, 30, 80, 30)];
    [lbl_Title setTextAlignment:NSTextAlignmentCenter];
    [lbl_Title setTextColor:[UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0]];
    [lbl_Title setBackgroundColor:[UIColor clearColor]];
    [lbl_Title setFont:[UIFont systemFontOfSize:20.0]];
    lbl_Title.text = @"4. 完成";
    [self.view addSubview:lbl_Title];
    
    UILabel *lbl_Success = [[UILabel alloc] init];
    [lbl_Success setFrame:CGRectMake(self.view.frame.size.width/2 - 150, 150, 300, 20)];
    [lbl_Success setTextAlignment:NSTextAlignmentCenter];
    [lbl_Success setTextColor:[UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0]];
    [lbl_Success setBackgroundColor:[UIColor clearColor]];
    [lbl_Success setFont:[UIFont boldSystemFontOfSize:22.0]];
    lbl_Success.text = @"注册成功";
    [self.view addSubview:lbl_Success];
    
    UIButton *nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 50, lbl_Success.frame.origin.y + lbl_Success.frame.size.height + 30, 100, 60)];
    [nextBtn setTitle:@"完 成 >" forState:UIControlStateNormal];
    nextBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [nextBtn setTitleColor:[UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(nextBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [nextBtn setTintColor:[UIColor lightGrayColor]];
    nextBtn.alpha = 1.0;
    nextBtn.transform = CGAffineTransformMakeTranslation(10, 0);
    [self.view addSubview:nextBtn];
}

- (void)nextBtnClicked{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"YES" forKey:@"isLoginState"];
    [defaults setObject:@"NO" forKey:@"isQQSocialSignUp"];
    [defaults setObject:@"NO" forKey:@"isWechatSocialSignUp"];
    [defaults setObject:@"NO" forKey:@"isWeiboSocialSignUp"];
    [defaults setObject:@"NO" forKey:@"isUserSignUp"];
    [defaults synchronize];
//    [[AppDelegate sharedAppDelegate] runMain];
    [self dismissViewControllerAnimated:YES completion:nil];
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
