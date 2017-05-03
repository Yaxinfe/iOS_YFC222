//
//  MoneyViewController.m
//  YFC
//
//  Created by topone on 7/23/15.
//  Copyright (c) 2015 ming. All rights reserved.
//

#import "publicHeaders.h"

#import "MoneyViewController.h"
#import "FillViewController.h"
#import "FirstViewController.h"

#import "TheSidebarController.h"
#import "MyRecordViewController.h"

#import "AllAroundPullView.h"
#import "YFGIFImageView.h"
#import "UIImageView+PlayGIF.h"

@interface MoneyViewController ()<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
{
    UITableView *topGigumTable;
    UILabel *totalLbl;
    
    NSMutableArray *topGigumList;
    
    YFGIFImageView *gifView_Load;
}
@end

@implementation MoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    topGigumList = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
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
    titleLbl.font = [UIFont boldSystemFontOfSize:22.0];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.textColor = [UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0];
    [self.view addSubview:titleLbl];
    
    UIButton *recordBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 90, self.view.frame.origin.y + 30, 70, 27)];
    [recordBtn setTitleColor:[UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [recordBtn addTarget:self action:@selector(recordBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    recordBtn.alpha = 1.0;
    recordBtn.transform = CGAffineTransformMakeTranslation(10, 0);
    [recordBtn setFont:[UIFont systemFontOfSize:16.0]];
    [self.view addSubview:recordBtn];
    
    UIImageView *lineImg5 =[UIImageView new];
    lineImg5.frame=CGRectMake(0, 63, self.view.frame.size.width, 2);
    lineImg5.clipsToBounds = YES;
    lineImg5.userInteractionEnabled=YES;
    lineImg5.backgroundColor = [UIColor colorWithRed:216.0/255.0 green:229.0/255.0 blue:241.0/255.0 alpha:1.0];
    [self.view addSubview:lineImg5];
    
    UIImageView *moneyImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 65, self.view.frame.size.width, self.view.frame.size.width/5*2)];
    moneyImageView.image = [UIImage imageNamed:@"moneyImg.png"];
    [self.view addSubview:moneyImageView];
    
    UIButton *fill_btn = [[UIButton alloc] initWithFrame:CGRectMake(moneyImageView.frame.origin.x - 10, moneyImageView.frame.origin.y + moneyImageView.frame.size.height - 40, 140, 40)];
    [fill_btn setBackgroundImage:[UIImage imageNamed:@"qungjenBtn.png"] forState:UIControlStateNormal];
    [fill_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [fill_btn addTarget:self action:@selector(fill_btnClicked) forControlEvents:UIControlEventTouchUpInside];
    [fill_btn setTintColor:[UIColor lightGrayColor]];
    fill_btn.alpha = 1.0;
    fill_btn.transform = CGAffineTransformMakeTranslation(10, 0);
    [self.view addSubview:fill_btn];
    
    NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
    if ([applang isEqualToString:@"ko"]) {
        titleLbl.text = MONEY_TITLE[0];
        [recordBtn setTitle:MONEY_RECORD_BUTTON[0] forState:UIControlStateNormal];
        [fill_btn setTitle:MONEY_FILL_BUTTON[0] forState:UIControlStateNormal];
    }
    if ([applang isEqualToString:@"cn"]) {
        titleLbl.text = MONEY_TITLE[1];
        [recordBtn setTitle:MONEY_RECORD_BUTTON[1] forState:UIControlStateNormal];
        [fill_btn setTitle:MONEY_FILL_BUTTON[1] forState:UIControlStateNormal];
    }
    
    totalLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, moneyImageView.frame.origin.y + 20, 200, 60)];
    totalLbl.font = [UIFont boldSystemFontOfSize:40.0];
    totalLbl.textAlignment = NSTextAlignmentLeft;
    totalLbl.textColor = [UIColor whiteColor];
    [self.view addSubview:totalLbl];
    
    UIButton *ball10_btn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 40, moneyImageView.frame.origin.y + moneyImageView.frame.size.height + 10, 80, 40)];
    [ball10_btn setImage:[UIImage imageNamed:@"10BallBtn.png"] forState:UIControlStateNormal];
    [ball10_btn addTarget:self action:@selector(ball10_btnClicked) forControlEvents:UIControlEventTouchUpInside];
    [ball10_btn setTintColor:[UIColor lightGrayColor]];
    ball10_btn.alpha = 1.0;
    ball10_btn.tag = 1010;
    ball10_btn.transform = CGAffineTransformMakeTranslation(10, 0);
    [self.view addSubview:ball10_btn];
    
    UIButton *ball1_btn = [[UIButton alloc] initWithFrame:CGRectMake(ball10_btn.frame.origin.x - 110, moneyImageView.frame.origin.y + moneyImageView.frame.size.height + 10, 80, 40)];
    [ball1_btn setImage:[UIImage imageNamed:@"1BallBtn.png"] forState:UIControlStateNormal];
    [ball1_btn addTarget:self action:@selector(ball1_btnClicked) forControlEvents:UIControlEventTouchUpInside];
    [ball1_btn setTintColor:[UIColor lightGrayColor]];
    ball1_btn.alpha = 1.0;
    ball1_btn.transform = CGAffineTransformMakeTranslation(10, 0);
    ball1_btn.tag = 1001;
    [self.view addSubview:ball1_btn];
    
    UIButton *ball100_btn = [[UIButton alloc] initWithFrame:CGRectMake(ball10_btn.frame.origin.x + 90, moneyImageView.frame.origin.y + moneyImageView.frame.size.height + 10, 80, 40)];
    [ball100_btn setImage:[UIImage imageNamed:@"100BallBtn.png"] forState:UIControlStateNormal];
    [ball100_btn addTarget:self action:@selector(ball100_btnClicked) forControlEvents:UIControlEventTouchUpInside];
    [ball100_btn setTintColor:[UIColor lightGrayColor]];
    ball100_btn.alpha = 1.0;
    ball100_btn.transform = CGAffineTransformMakeTranslation(10, 0);
    ball100_btn.tag = 1100;
    [self.view addSubview:ball100_btn];
    
    topGigumTable = [[UITableView alloc] initWithFrame:CGRectMake(0, ball100_btn.frame.origin.y + ball100_btn.frame.size.height + 10, self.view.frame.size.width, self.view.frame.size.height - (ball100_btn.frame.origin.y + ball100_btn.frame.size.height + 10)) style:UITableViewStylePlain];
    topGigumTable.dataSource = self;
    topGigumTable.delegate = self;
    [topGigumTable setBackgroundColor:[UIColor clearColor]];
    topGigumTable.userInteractionEnabled=YES;
    [topGigumTable setAllowsSelection:YES];
    if ([topGigumTable respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [topGigumTable setSeparatorInset:UIEdgeInsetsZero];
        
    }
    [topGigumTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    // top
    AllAroundPullView *topPullView = [[AllAroundPullView alloc] initWithScrollView:topGigumTable position:AllAroundPullViewPositionTop action:^(AllAroundPullView *view){
        NSLog(@"--");
        [view performSelector:@selector(finishedLoading) withObject:nil afterDelay:4.0f];
        [self refreshList];
    }];
    topPullView.backgroundColor = [UIColor clearColor];
    topPullView.activityView.hidden = YES;
    
    NSData *gifData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"football1.gif" ofType:nil]];
    YFGIFImageView *gifView = [[YFGIFImageView alloc] initWithFrame:CGRectMake(topPullView.frame.size.width/2 - 90, topPullView.frame.size.height - 50, 180, 50)];
    gifView.backgroundColor = [UIColor clearColor];
    gifView.gifData = gifData;
    [topPullView addSubview:gifView];
    [gifView startGIF];
    gifView.userInteractionEnabled = YES;
    
    [topGigumTable addSubview:topPullView];
    [self.view addSubview:topGigumTable];
    
    NSData *gifData_Load = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Loading.gif" ofType:nil]];
    gifView_Load = [[YFGIFImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 50, self.view.frame.size.height/2 - 50, 100, 100)];
    gifView_Load.backgroundColor = [UIColor clearColor];
    gifView_Load.gifData = gifData_Load;
    [self.view addSubview:gifView_Load];
    gifView_Load.hidden = YES;
    gifView_Load.userInteractionEnabled = YES;
    
    [self getTopGigumList];
}

- (void)refreshList{
    NSString *isFirstLogin = [[NSUserDefaults standardUserDefaults] objectForKey:@"isLoginState"];
    if ([isFirstLogin isEqualToString:@"NO"]) {
        NSDictionary *parameters = @{@"userid":@"0",
                                     @"lastid":@"0",
                                     @"lastballcount":@"0"
                                     };
        
        [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
        [[GlobalPool sharedInstance].OAuth2Manager POST:LC_TOPGIGUM_LIST parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //        NSLog(@"%@",responseObject);
            
            topGigumList = [NSMutableArray arrayWithArray:[responseObject objectForKey:@"result"]];
            NSString *totalCount = [responseObject objectForKey:@"totalcount"];
            
            if (totalCount == (NSString *)[NSNull null] ) {
                totalLbl.text = @"0";
            }
            else{
                totalLbl.text = [responseObject objectForKey:@"totalcount"];
            }
            
            [topGigumTable reloadData];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"Connection failed"];
        }];
    }
    else{
        NSString *userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"];
        NSDictionary *parameters = @{@"userid":userid,
                                     @"lastid":@"0",
                                     @"lastballcount":@"0"
                                     };
        
        [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
        [[GlobalPool sharedInstance].OAuth2Manager POST:LC_TOPGIGUM_LIST parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //        NSLog(@"%@",responseObject);
            
            topGigumList = [NSMutableArray arrayWithArray:[responseObject objectForKey:@"result"]];
            NSString *totalCount = [responseObject objectForKey:@"totalcount"];
            
            if (totalCount == (NSString *)[NSNull null] ) {
                totalLbl.text = @"0";
            }
            else{
                totalLbl.text = [responseObject objectForKey:@"totalcount"];
            }
            
            [topGigumTable reloadData];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"Connection failed"];
        }];
    }
    
}

- (void)getTopGigumList{
    gifView_Load.hidden = NO;
    [gifView_Load startGIF];
    [gifView_Load startAnimating];
    
    NSString *isFirstLogin = [[NSUserDefaults standardUserDefaults] objectForKey:@"isLoginState"];
    if ([isFirstLogin isEqualToString:@"NO"]) {
        NSDictionary *parameters = @{@"userid":@"0",
                                     @"lastid":@"0",
                                     @"lastballcount":@"0"
                                     };
        
        [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
        [[GlobalPool sharedInstance].OAuth2Manager POST:LC_TOPGIGUM_LIST parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //        NSLog(@"%@",responseObject);
            gifView_Load.hidden = YES;
            [gifView_Load stopGIF];
            [gifView_Load stopAnimating];
            
            topGigumList = [NSMutableArray arrayWithArray:[responseObject objectForKey:@"result"]];
            NSString *totalCount = [responseObject objectForKey:@"totalcount"];
            
            if (totalCount == (NSString *)[NSNull null] ) {
                totalLbl.text = @"0";
            }
            else
            {
                totalLbl.text = [responseObject objectForKey:@"totalcount"];
            }
            
            [topGigumTable reloadData];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            gifView_Load.hidden = YES;
            [gifView_Load stopGIF];
            [gifView_Load stopAnimating];
            [SVProgressHUD showErrorWithStatus:@"Connection failed"];
        }];
    }
    else{
        NSString *userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"];
        NSDictionary *parameters = @{@"userid":userid,
                                     @"lastid":@"0",
                                     @"lastballcount":@"0"
                                     };
        
        [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
        [[GlobalPool sharedInstance].OAuth2Manager POST:LC_TOPGIGUM_LIST parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //        NSLog(@"%@",responseObject);
            gifView_Load.hidden = YES;
            [gifView_Load stopGIF];
            [gifView_Load stopAnimating];
            
            topGigumList = [NSMutableArray arrayWithArray:[responseObject objectForKey:@"result"]];
            NSString *totalCount = [responseObject objectForKey:@"totalcount"];
            
            if (totalCount == (NSString *)[NSNull null] ) {
                totalLbl.text = @"0";
            }
            else
            {
                totalLbl.text = [responseObject objectForKey:@"totalcount"];
            }
            
            [topGigumTable reloadData];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            gifView_Load.hidden = YES;
            [gifView_Load stopGIF];
            [gifView_Load stopAnimating];
            [SVProgressHUD showErrorWithStatus:@"Connection failed"];
        }];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        if (alertView.tag == 1001) {
            NSString *userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"];
            NSString *sessionkey = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionkey"];
            
            NSDictionary *parameters = @{@"userid":userid,
                                         @"ballnumber":@"1",
                                         @"sessionkey":sessionkey
                                         };
            
            [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
            [[GlobalPool sharedInstance].OAuth2Manager POST:LC_GENERAL_GIGUM parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"%@",responseObject);
                
                NSString *status = [responseObject objectForKey:@"status"];
                
                if ([status intValue] == 700) {
                    NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
                    if ([applang isEqualToString:@"ko"]) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"충전을 해야합니다." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        alert.tag = 2000;
                        [alert show];
                    }
                    if ([applang isEqualToString:@"cn"]) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请充值" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                        alert.tag = 2000;
                        [alert show];
                    }
                }
                else if ([status intValue] == 1001) {
                    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setObject:@"NO" forKey:@"isLoginState"];
                    [defaults synchronize];
                    [[AppDelegate sharedAppDelegate] runMain];
                }
                else{
                    [self getTopGigumList];
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [SVProgressHUD showErrorWithStatus:@"Connection failed"];
            }];
        }
        
        if (alertView.tag == 1010) {
            NSString *userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"];
            NSString *sessionkey = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionkey"];
            
            NSDictionary *parameters = @{@"userid":userid,
                                         @"ballnumber":@"10",
                                         @"sessionkey":sessionkey
                                         };
            
            [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
            [[GlobalPool sharedInstance].OAuth2Manager POST:LC_GENERAL_GIGUM parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"%@",responseObject);
                
                NSString *status = [responseObject objectForKey:@"status"];
                
                if ([status intValue] == 700) {
                    NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
                    if ([applang isEqualToString:@"ko"]) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"충전을 해야합니다." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        alert.tag = 2000;
                        [alert show];
                    }
                    if ([applang isEqualToString:@"cn"]) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请充值" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                        alert.tag = 2000;
                        [alert show];
                    }
                }
                else if ([status intValue] == 1001) {
                    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setObject:@"NO" forKey:@"isLoginState"];
                    [defaults synchronize];
                    [[AppDelegate sharedAppDelegate] runMain];
                }
                else{
                    [self getTopGigumList];
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [SVProgressHUD showErrorWithStatus:@"Connection failed"];
            }];
        }
        
        if (alertView.tag == 1100) {
            NSString *userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"];
            NSString *sessionkey = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionkey"];
            
            NSDictionary *parameters = @{@"userid":userid,
                                         @"ballnumber":@"100",
                                         @"sessionkey":sessionkey
                                         };
            
            [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
            [[GlobalPool sharedInstance].OAuth2Manager POST:LC_GENERAL_GIGUM parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"%@",responseObject);
                
                NSString *status = [responseObject objectForKey:@"status"];
                
                if ([status intValue] == 700) {
                    NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
                    if ([applang isEqualToString:@"ko"]) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"충전을 해야합니다." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        alert.tag = 2000;
                        [alert show];
                    }
                    if ([applang isEqualToString:@"cn"]) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请充值" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                        alert.tag = 2000;
                        [alert show];
                    }
                }
                else if ([status intValue] == 1001) {
                    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setObject:@"NO" forKey:@"isLoginState"];
                    [defaults synchronize];
                    [[AppDelegate sharedAppDelegate] runMain];
                }
                else{
                    [self getTopGigumList];
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [SVProgressHUD showErrorWithStatus:@"Connection failed"];
            }];
        }
        
        if (alertView.tag == 2000) {
            FillViewController *fillView = [[FillViewController alloc] init];
            [self.navigationController pushViewController:fillView animated:YES];
        }
    }
    else{
        
    }
    
}

- (void)ball1_btnClicked{
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
        NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
        if ([applang isEqualToString:@"ko"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"기금하시겠습니까?" delegate:self cancelButtonTitle:@"예" otherButtonTitles:@"아니", nil];
            alert.tag = 1001;
            [alert show];
        }
        if ([applang isEqualToString:@"cn"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"确定奖励吗?" delegate:self cancelButtonTitle:@"是" otherButtonTitles:@"否", nil];
            alert.tag = 1001;
            [alert show];
        }
    }
}

- (void)ball10_btnClicked{
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
        NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
        if ([applang isEqualToString:@"ko"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"기금하시겠습니까?" delegate:self cancelButtonTitle:@"예" otherButtonTitles:@"아니", nil];
            alert.tag = 1010;
            [alert show];
        }
        if ([applang isEqualToString:@"cn"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"确定奖励吗?" delegate:self cancelButtonTitle:@"是" otherButtonTitles:@"否", nil];
            alert.tag = 1010;
            [alert show];
        }
    }
    
}

- (void)ball100_btnClicked{
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
        NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
        if ([applang isEqualToString:@"ko"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"기금하시겠습니까?" delegate:self cancelButtonTitle:@"예" otherButtonTitles:@"아니", nil];
            alert.tag = 1100;
            [alert show];
        }
        if ([applang isEqualToString:@"cn"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"确定奖励吗?" delegate:self cancelButtonTitle:@"是" otherButtonTitles:@"否", nil];
            alert.tag = 1100;
            [alert show];
        }
    }
}

#pragma mark - tableViewDelegate
// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return topGigumList.count;
}
// Customize the appearance of table view cells.
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
    
    UILabel *lbl_Num = [[UILabel alloc]init];
    [lbl_Num setFrame:CGRectMake(10, 15, 30, 30)];
    [lbl_Num setTextAlignment:NSTextAlignmentCenter];
    [lbl_Num setTextColor:[UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0]];
    [lbl_Num setBackgroundColor:[UIColor clearColor]];
    [lbl_Num setFont:[UIFont systemFontOfSize:20.0]];
    lbl_Num.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row + 1];
    [cell.contentView addSubview:lbl_Num];
    
    UIImageView *profileImg = [[UIImageView alloc] initWithFrame:CGRectMake(lbl_Num.frame.origin.x + lbl_Num.frame.size.width + 7, 10, 40, 40)];
    profileImg.backgroundColor = [UIColor blackColor];
    [cell.contentView addSubview:profileImg];
    
    UILabel *lbl_Name = [[UILabel alloc]init];
    [lbl_Name setFrame:CGRectMake(profileImg.frame.origin.x + profileImg.frame.size.width + 5, 15, 140, 30)];
    [lbl_Name setTextAlignment:NSTextAlignmentCenter];
    [lbl_Name setTextColor:[UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0]];
    [lbl_Name setBackgroundColor:[UIColor clearColor]];
    [lbl_Name setFont:[UIFont systemFontOfSize:18.0]];
    [cell.contentView addSubview:lbl_Name];
    
    UILabel *lbl_Count = [[UILabel alloc]init];
    [lbl_Count setFrame:CGRectMake(self.view.frame.size.width - 65, 15, 60, 30)];
    [lbl_Count setTextAlignment:NSTextAlignmentCenter];
    [lbl_Count setTextColor:[UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0]];
    [lbl_Count setBackgroundColor:[UIColor clearColor]];
    [lbl_Count setFont:[UIFont systemFontOfSize:18.0]];
    [cell.contentView addSubview:lbl_Count];
    
    UIImageView *lineImg = [[UIImageView alloc] initWithFrame:CGRectMake(5, 59, self.view.frame.size.width - 10, 1)];
    lineImg.backgroundColor = [UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0];
    [cell.contentView addSubview:lineImg];
    
    lbl_Name.text = [[topGigumList objectAtIndex:indexPath.row] objectForKey:@"nickname"];
    lbl_Count.text = [[topGigumList objectAtIndex:indexPath.row] objectForKey:@"gigumnumber"];
    
    NSString *path1 = [[topGigumList objectAtIndex:indexPath.row] objectForKey:@"photourl"];
    [profileImg setImageWithURL:[NSURL URLWithString:path1]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //Height of the rows
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)recordBtnClicked{
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
        MyRecordViewController *fillView = [[MyRecordViewController alloc] init];
        [self.navigationController pushViewController:fillView animated:YES];
    }
}

-(void)fill_btnClicked{
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
        FillViewController *fillView = [[FillViewController alloc] init];
        [self.navigationController pushViewController:fillView animated:YES];
    }
}

- (void)backBtnClicked{
//    [self.navigationController popViewControllerAnimated:YES];
    if(self.sidebarController.sidebarIsPresenting)
    {
        [self.sidebarController dismissSidebarViewController];
    }
    else
    {
        [gifView_Load removeFromSuperview];
        
        NSString *isFirstLogin = [[NSUserDefaults standardUserDefaults] objectForKey:@"isLoginState"];
        if ([isFirstLogin isEqualToString:@"NO"]) {
            
        }
        else{
            NSString *userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"];
            NSDictionary *parameters = @{@"userid":userid
                                         };
            
            [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
            [[GlobalPool sharedInstance].OAuth2Manager POST:LC_ONLINE_STATE parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"%@",responseObject);
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [SVProgressHUD showErrorWithStatus:@"Connection failed"];
            }];
        }
        
        [self.sidebarController presentLeftSidebarViewController];
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
