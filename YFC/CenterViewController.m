//
//  CenterViewController.m
//  YFC
//
//  Created by topone on 9/1/15.
//  Copyright (c) 2015 ming. All rights reserved.
//

#import "CenterViewController.h"
#import "AppLanguage.h"

@interface CenterViewController ()<UIActionSheetDelegate>

@end

@implementation CenterViewController

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
    
    UIImageView *markImg =[UIImageView new];
    markImg.frame=CGRectMake(self.view.frame.size.width/2 - 60, 100, 120, 120);
    markImg.backgroundColor = [UIColor clearColor];
    markImg.image = [UIImage imageNamed:@"mark.png"];
    [self.view addSubview:markImg];
    
    UILabel *appLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, markImg.frame.origin.y + markImg.frame.size.height + 5, self.view.frame.size.width, 24)];
    appLbl.font = [UIFont boldSystemFontOfSize:22.0];
    appLbl.textAlignment = NSTextAlignmentCenter;
    appLbl.textColor = [UIColor blackColor];
    [self.view addSubview:appLbl];
    
    UILabel *versionLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, appLbl.frame.origin.y + appLbl.frame.size.height + 5, self.view.frame.size.width, 24)];
    versionLbl.text = @"V1.0.0";
    versionLbl.font = [UIFont boldSystemFontOfSize:22.0];
    versionLbl.textAlignment = NSTextAlignmentCenter;
    versionLbl.textColor = [UIColor blackColor];
    [self.view addSubview:versionLbl];
    
    UIButton *phoneNumberBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 110, versionLbl.frame.origin.y + versionLbl.frame.size.height + 20, 200, 40)];
    [phoneNumberBtn setTitleColor:[UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [phoneNumberBtn addTarget:self action:@selector(phoneNumberBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    phoneNumberBtn.alpha = 1.0;
    phoneNumberBtn.transform = CGAffineTransformMakeTranslation(10, 0);
    phoneNumberBtn.layer.cornerRadius = 5;
    phoneNumberBtn.layer.borderWidth = 1;
    phoneNumberBtn.layer.borderColor = [UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0].CGColor;
    phoneNumberBtn.layer.masksToBounds = YES;
    [self.view addSubview:phoneNumberBtn];

    UILabel *companyLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, phoneNumberBtn.frame.origin.y + phoneNumberBtn.frame.size.height + 5, self.view.frame.size.width, 24)];
    companyLbl.font = [UIFont boldSystemFontOfSize:14.0];
    companyLbl.textAlignment = NSTextAlignmentCenter;
    companyLbl.textColor = [UIColor lightGrayColor];
    [self.view addSubview:companyLbl];
    
    NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
    if ([applang isEqualToString:@"ko"]) {
        titleLbl.text = CENTER_TITLE[0];
        appLbl.text = CENTER_NAME[0];
        companyLbl.text = CENTER_COMPANY_NAME[0];
        [phoneNumberBtn setTitle:CENTER_CALL_BUTTON[0] forState:UIControlStateNormal];
    }
    if ([applang isEqualToString:@"cn"]) {
        titleLbl.text = CENTER_TITLE[1];
        appLbl.text = CENTER_NAME[1];
        companyLbl.text = CENTER_COMPANY_NAME[1];
        [phoneNumberBtn setTitle:CENTER_CALL_BUTTON[1] forState:UIControlStateNormal];
    }
}

- (void)callBtnClicked{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel:04332831989"]])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:04332831989"]];
}

- (void)phoneNumberBtnClicked{
    NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
    if ([applang isEqualToString:@"ko"]) {
        UIActionSheet *actionSheet_popupQuery = [[UIActionSheet alloc] initWithTitle:@"￼번호 : 04332831989" delegate:self cancelButtonTitle:@"취소" destructiveButtonTitle:nil otherButtonTitles:@"전화걸기", nil];
        actionSheet_popupQuery.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        [actionSheet_popupQuery showInView:self.view];
    }
    if ([applang isEqualToString:@"cn"]) {
        UIActionSheet *actionSheet_popupQuery = [[UIActionSheet alloc] initWithTitle:@"￼电话 : 04332831989" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"拨打电话", nil];
        actionSheet_popupQuery.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        [actionSheet_popupQuery showInView:self.view];
    }
}

#pragma mark - ACTION SHEET DELEGATE
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 0)
    {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel:04332831989"]])
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:04332831989"]];
    }
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
