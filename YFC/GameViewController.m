//
//  GameViewController.m
//  YFC
//
//  Created by topone on 7/17/15.
//  Copyright (c) 2015 ming. All rights reserved.
//

#import "GameViewController.h"
#import "FillViewController.h"
#import "RoundResultViewController.h"

#import "publicHeaders.h"
#import "TheSidebarController.h"

#import "AllAroundPullView.h"
#import "YFGIFImageView.h"
#import "UIImageView+PlayGIF.h"

@interface GameViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UIButton *gameResultBtn;
    UIButton *pointOrderBtn;
    UIButton *topPlayerBtn;
    
    UITableView *gameTable;
    
    NSMutableArray *gameListArray;
    NSMutableArray *pointOrderArray;
    NSMutableArray *topPlayerArray;
    
    BOOL isGameResult;
    BOOL isPointOrder;
    BOOL isTopPlayer;
    
    YFGIFImageView *gifView_Load;
}
@end

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    gameListArray = [[NSMutableArray alloc] init];
    pointOrderArray = [[NSMutableArray alloc] init];
    topPlayerArray = [[NSMutableArray alloc] init];
    
    isGameResult = TRUE;
    isPointOrder = FALSE;
    isTopPlayer = FALSE;
    
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
//    titleLbl.text = @"시 합 결 과";
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
    
    gameResultBtn = [[UIButton alloc] initWithFrame:CGRectMake(-5, 65, self.view.frame.size.width/3 - 10, 40)];
//    [gameResultBtn setTitle:@"战 绩" forState:UIControlStateNormal];
    [gameResultBtn setBackgroundColor:[UIColor colorWithRed:49.0/255.0 green:119.0/255.0 blue:187.0/255.0 alpha:1.0]];
    [gameResultBtn addTarget:self action:@selector(gameResultBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [gameResultBtn setTintColor:[UIColor lightGrayColor]];
    gameResultBtn.alpha = 1.0;
    gameResultBtn.transform = CGAffineTransformMakeTranslation(10, 0);
    [self.view addSubview:gameResultBtn];
    
    pointOrderBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/3 - 5, 65, self.view.frame.size.width/3 - 10, 40)];
//    [pointOrderBtn setTitle:@"积分榜" forState:UIControlStateNormal];
    [pointOrderBtn addTarget:self action:@selector(pointOrderBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [pointOrderBtn setBackgroundColor:[UIColor colorWithRed:224.0/255.0 green:233.0/255.0 blue:243.0/255.0 alpha:1.0]];
    [pointOrderBtn setTitleColor:[UIColor colorWithRed:49.0/255.0 green:119.0/255.0 blue:187.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [pointOrderBtn setTintColor:[UIColor lightGrayColor]];
    pointOrderBtn.alpha = 1.0;
    pointOrderBtn.transform = CGAffineTransformMakeTranslation(10, 0);
    [self.view addSubview:pointOrderBtn];
    
    topPlayerBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/3*2 - 5, 65, self.view.frame.size.width/3 - 10, 40)];
//    [topPlayerBtn setTitle:@"射手榜" forState:UIControlStateNormal];
    [topPlayerBtn addTarget:self action:@selector(topPlayerBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [topPlayerBtn setBackgroundColor:[UIColor colorWithRed:224.0/255.0 green:233.0/255.0 blue:243.0/255.0 alpha:1.0]];
    [topPlayerBtn setTitleColor:[UIColor colorWithRed:49.0/255.0 green:119.0/255.0 blue:187.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [topPlayerBtn setTintColor:[UIColor lightGrayColor]];
    topPlayerBtn.alpha = 1.0;
    topPlayerBtn.transform = CGAffineTransformMakeTranslation(10, 0);
    [self.view addSubview:topPlayerBtn];
    
    NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
    if ([applang isEqualToString:@"ko"]) {
        titleLbl.text = GAME_TITLE[0];
        [gameResultBtn setTitle:GAME_ROUND_BUTTON[0] forState:UIControlStateNormal];
        [pointOrderBtn setTitle:GAME_RESULT_BUTTON[0] forState:UIControlStateNormal];
        [topPlayerBtn setTitle:GAME_PLAYER_BUTTON[0] forState:UIControlStateNormal];
    }
    if ([applang isEqualToString:@"cn"]) {
        titleLbl.text = GAME_TITLE[1];
        [gameResultBtn setTitle:GAME_ROUND_BUTTON[1] forState:UIControlStateNormal];
        [pointOrderBtn setTitle:GAME_RESULT_BUTTON[1] forState:UIControlStateNormal];
        [topPlayerBtn setTitle:GAME_PLAYER_BUTTON[1] forState:UIControlStateNormal];
    }
    
    gameTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 110, self.view.frame.size.width, self.view.frame.size.height - 110) style:UITableViewStylePlain];
    gameTable.dataSource = self;
    gameTable.delegate = self;
    [gameTable setBackgroundColor:[UIColor clearColor]];
    gameTable.userInteractionEnabled=YES;
    [gameTable setAllowsSelection:YES];
    if ([gameTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [gameTable setSeparatorInset:UIEdgeInsetsZero];
    }
    [gameTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:gameTable];
    
    NSData *gifData_Load = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Loading.gif" ofType:nil]];
    gifView_Load = [[YFGIFImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 50, self.view.frame.size.height/2 - 50, 100, 100)];
    gifView_Load.backgroundColor = [UIColor clearColor];
    gifView_Load.gifData = gifData_Load;
    [self.view addSubview:gifView_Load];
    gifView_Load.hidden = YES;
    gifView_Load.userInteractionEnabled = YES;
    
    [self getGameResult];
}

/////////////////////////////////////////////////////////    API   ///////////////////////////////////////////////////////////////

- (void)getGameResult{
    gifView_Load.hidden = NO;
    [gifView_Load startGIF];
    [gifView_Load startAnimating];
    
    NSString *isFirstLogin = [[NSUserDefaults standardUserDefaults] objectForKey:@"isLoginState"];
    if ([isFirstLogin isEqualToString:@"NO"]) {
        NSDictionary *parameters = @{@"userid":@"0",
                                     @"lastid": @"0"
                                     };
        
        [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
        [[GlobalPool sharedInstance].OAuth2Manager POST:LC_GAME_GAMERESULT parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //        NSLog(@"%@",responseObject);
            gifView_Load.hidden = YES;
            [gifView_Load stopGIF];
            [gifView_Load stopAnimating];
            
            gameListArray = [NSMutableArray arrayWithArray:[responseObject objectForKey:@"result"]];
            [gameTable reloadData];
            
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
                                     @"lastid": @"0"
                                     };
        
        [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
        [[GlobalPool sharedInstance].OAuth2Manager POST:LC_GAME_GAMERESULT parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //        NSLog(@"%@",responseObject);
            gifView_Load.hidden = YES;
            [gifView_Load stopGIF];
            [gifView_Load stopAnimating];
            
            gameListArray = [NSMutableArray arrayWithArray:[responseObject objectForKey:@"result"]];
            [gameTable reloadData];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            gifView_Load.hidden = YES;
            [gifView_Load stopGIF];
            [gifView_Load stopAnimating];
            [SVProgressHUD showErrorWithStatus:@"Connection failed"];
        }];
    }
}

- (void)getPointOrder{
    gifView_Load.hidden = NO;
    [gifView_Load startGIF];
    [gifView_Load startAnimating];
    
    NSString *isFirstLogin = [[NSUserDefaults standardUserDefaults] objectForKey:@"isLoginState"];
    if ([isFirstLogin isEqualToString:@"NO"]) {
        NSDictionary *parameters = @{@"userid":@"0",
                                     };
        
        [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
        [[GlobalPool sharedInstance].OAuth2Manager POST:LC_GAME_POINTORDER parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //        NSLog(@"%@",responseObject);
            gifView_Load.hidden = YES;
            [gifView_Load stopGIF];
            [gifView_Load stopAnimating];
            
            pointOrderArray = [NSMutableArray arrayWithArray:[responseObject objectForKey:@"result"]];
            [gameTable reloadData];
            
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
                                     };
        
        [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
        [[GlobalPool sharedInstance].OAuth2Manager POST:LC_GAME_POINTORDER parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //        NSLog(@"%@",responseObject);
            gifView_Load.hidden = YES;
            [gifView_Load stopGIF];
            [gifView_Load stopAnimating];
            
            pointOrderArray = [NSMutableArray arrayWithArray:[responseObject objectForKey:@"result"]];
            [gameTable reloadData];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            gifView_Load.hidden = YES;
            [gifView_Load stopGIF];
            [gifView_Load stopAnimating];
            [SVProgressHUD showErrorWithStatus:@"Connection failed"];
        }];
    }
    
}

- (void)getTopPlayer{
    gifView_Load.hidden = NO;
    [gifView_Load startGIF];
    [gifView_Load startAnimating];
    
    NSString *isFirstLogin = [[NSUserDefaults standardUserDefaults] objectForKey:@"isLoginState"];
    if ([isFirstLogin isEqualToString:@"NO"]) {
        NSDictionary *parameters = @{@"userid":@"0",
                                     };
        
        [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
        [[GlobalPool sharedInstance].OAuth2Manager POST:LC_GAME_TOPPLAYER parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            gifView_Load.hidden = YES;
            [gifView_Load stopGIF];
            [gifView_Load stopAnimating];
            
            topPlayerArray = [NSMutableArray arrayWithArray:[responseObject objectForKey:@"result"]];
            [gameTable reloadData];
            
            [SVProgressHUD dismiss];
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
                                     };
        
        [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
        [[GlobalPool sharedInstance].OAuth2Manager POST:LC_GAME_TOPPLAYER parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            gifView_Load.hidden = YES;
            [gifView_Load stopGIF];
            [gifView_Load stopAnimating];
            
            topPlayerArray = [NSMutableArray arrayWithArray:[responseObject objectForKey:@"result"]];
            [gameTable reloadData];
            
            [SVProgressHUD dismiss];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            gifView_Load.hidden = YES;
            [gifView_Load stopGIF];
            [gifView_Load stopAnimating];
            [SVProgressHUD showErrorWithStatus:@"Connection failed"];
        }];
    }
    
}

- (void)backBtnClicked{
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

- (void)gameResultBtnClicked{
    isGameResult  = TRUE;
    isPointOrder  = FALSE;
    isTopPlayer   = FALSE;
    
    [gameResultBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [gameResultBtn setBackgroundColor:[UIColor colorWithRed:49.0/255.0 green:119.0/255.0 blue:187.0/255.0 alpha:1.0]];
    
    [pointOrderBtn setBackgroundColor:[UIColor colorWithRed:224.0/255.0 green:233.0/255.0 blue:243.0/255.0 alpha:1.0]];
    [pointOrderBtn setTitleColor:[UIColor colorWithRed:49.0/255.0 green:119.0/255.0 blue:187.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    
    [topPlayerBtn setBackgroundColor:[UIColor colorWithRed:224.0/255.0 green:233.0/255.0 blue:243.0/255.0 alpha:1.0]];
    [topPlayerBtn setTitleColor:[UIColor colorWithRed:49.0/255.0 green:119.0/255.0 blue:187.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    
    [self getGameResult];
}

- (void)pointOrderBtnClicked{
    isGameResult  = FALSE;
    isPointOrder  = TRUE;
    isTopPlayer   = FALSE;
    
    [pointOrderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [pointOrderBtn setBackgroundColor:[UIColor colorWithRed:49.0/255.0 green:119.0/255.0 blue:187.0/255.0 alpha:1.0]];
    
    [gameResultBtn setBackgroundColor:[UIColor colorWithRed:224.0/255.0 green:233.0/255.0 blue:243.0/255.0 alpha:1.0]];
    [gameResultBtn setTitleColor:[UIColor colorWithRed:49.0/255.0 green:119.0/255.0 blue:187.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    
    [topPlayerBtn setBackgroundColor:[UIColor colorWithRed:224.0/255.0 green:233.0/255.0 blue:243.0/255.0 alpha:1.0]];
    [topPlayerBtn setTitleColor:[UIColor colorWithRed:49.0/255.0 green:119.0/255.0 blue:187.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    
    [self getPointOrder];
}

- (void)topPlayerBtnClicked{
    isGameResult  = FALSE;
    isPointOrder  = FALSE;
    isTopPlayer   = TRUE;
    
    [topPlayerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [topPlayerBtn setBackgroundColor:[UIColor colorWithRed:49.0/255.0 green:119.0/255.0 blue:187.0/255.0 alpha:1.0]];
    
    [pointOrderBtn setBackgroundColor:[UIColor colorWithRed:224.0/255.0 green:233.0/255.0 blue:243.0/255.0 alpha:1.0]];
    [pointOrderBtn setTitleColor:[UIColor colorWithRed:49.0/255.0 green:119.0/255.0 blue:187.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    
    [gameResultBtn setBackgroundColor:[UIColor colorWithRed:224.0/255.0 green:233.0/255.0 blue:243.0/255.0 alpha:1.0]];
    [gameResultBtn setTitleColor:[UIColor colorWithRed:49.0/255.0 green:119.0/255.0 blue:187.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    
    [self getTopPlayer];
}

#pragma mark - tableViewDelegate
// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (isGameResult == TRUE) {
        return gameListArray.count;
    }
    if (isPointOrder == TRUE) {
        return pointOrderArray.count;
    }
    if (isTopPlayer == TRUE) {
        return topPlayerArray.count;
    }
    return gameListArray.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView;
    if (isGameResult == TRUE) {
        headerView = [[UIView alloc] init];
    }
    if (isPointOrder == TRUE) {
        headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
        headerView.backgroundColor = [UIColor whiteColor];
        
        UILabel *lbl_TeamName = [[UILabel alloc]init];
        [lbl_TeamName setFrame:CGRectMake(75, 5, 80, 20)];
        [lbl_TeamName setTextAlignment:NSTextAlignmentLeft];
        [lbl_TeamName setTextColor:[UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0]];
        [lbl_TeamName setBackgroundColor:[UIColor clearColor]];
        [lbl_TeamName setFont:[UIFont systemFontOfSize:13.0]];
        lbl_TeamName.text = @"球队";
        [headerView addSubview:lbl_TeamName];
        
        CGFloat padding = (self.view.frame.size.width - 160)/7;
        
        UILabel *lbl_Score1 = [[UILabel alloc]init];
        [lbl_Score1 setFrame:CGRectMake(160, 5, padding, 20)];
        [lbl_Score1 setTextAlignment:NSTextAlignmentCenter];
        [lbl_Score1 setTextColor:[UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0]];
        [lbl_Score1 setBackgroundColor:[UIColor clearColor]];
        [lbl_Score1 setFont:[UIFont systemFontOfSize:13.0]];
        lbl_Score1.text = @"赛"; // 경기회수
        [headerView addSubview:lbl_Score1];
        
        UILabel *lbl_Score2 = [[UILabel alloc]init];
        [lbl_Score2 setFrame:CGRectMake(lbl_Score1.frame.origin.x + lbl_Score1.frame.size.width, 5, padding, 20)];
        [lbl_Score2 setTextAlignment:NSTextAlignmentCenter];
        [lbl_Score2 setTextColor:[UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0]];
        [lbl_Score2 setBackgroundColor:[UIColor clearColor]];
        [lbl_Score2 setFont:[UIFont systemFontOfSize:13.0]];
        lbl_Score2.text = @"胜"; // 승
        [headerView addSubview:lbl_Score2];
        
        UILabel *lbl_Score3 = [[UILabel alloc]init];
        [lbl_Score3 setFrame:CGRectMake(lbl_Score2.frame.origin.x + lbl_Score2.frame.size.width, 5, padding, 20)];
        [lbl_Score3 setTextAlignment:NSTextAlignmentCenter];
        [lbl_Score3 setTextColor:[UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0]];
        [lbl_Score3 setBackgroundColor:[UIColor clearColor]];
        [lbl_Score3 setFont:[UIFont systemFontOfSize:13.0]];
        lbl_Score3.text = @"平"; // 비김
        [headerView addSubview:lbl_Score3];
        
        UILabel *lbl_Score4 = [[UILabel alloc]init];
        [lbl_Score4 setFrame:CGRectMake(lbl_Score3.frame.origin.x + lbl_Score3.frame.size.width, 5, padding, 20)];
        [lbl_Score4 setTextAlignment:NSTextAlignmentCenter];
        [lbl_Score4 setTextColor:[UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0]];
        [lbl_Score4 setBackgroundColor:[UIColor clearColor]];
        [lbl_Score4 setFont:[UIFont systemFontOfSize:13.0]];
        lbl_Score4.text = @"负"; // 패
        [headerView addSubview:lbl_Score4];
        
        UILabel *lbl_Score5 = [[UILabel alloc]init];
        [lbl_Score5 setFrame:CGRectMake(lbl_Score4.frame.origin.x + lbl_Score4.frame.size.width, 5, padding*2, 20)];
        [lbl_Score5 setTextAlignment:NSTextAlignmentCenter];
        [lbl_Score5 setTextColor:[UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0]];
        [lbl_Score5 setBackgroundColor:[UIColor clearColor]];
        [lbl_Score5 setFont:[UIFont systemFontOfSize:13.0]];
        lbl_Score5.text = @"进／失"; // 득점/실점
        [headerView addSubview:lbl_Score5];
        
        UILabel *lbl_Score6 = [[UILabel alloc]init];
        [lbl_Score6 setFrame:CGRectMake(lbl_Score5.frame.origin.x + lbl_Score5.frame.size.width, 5, padding, 20)];
        [lbl_Score6 setTextAlignment:NSTextAlignmentCenter];
        [lbl_Score6 setTextColor:[UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0]];
        [lbl_Score6 setBackgroundColor:[UIColor clearColor]];
        [lbl_Score6 setFont:[UIFont systemFontOfSize:13.0]];
        lbl_Score6.text = @"积分";    // 적분
        [headerView addSubview:lbl_Score6];
    }
    else{
        headerView = [[UIView alloc] init];
    }
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (isGameResult == TRUE) {
        return 0;
    }
    if (isTopPlayer == TRUE) {
        return 0;
    }
    return 30.0;
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
    
    if (isGameResult == TRUE) {
        UILabel *lbl_Time = [[UILabel alloc]init];
        [lbl_Time setFrame:CGRectMake(0, 5, self.view.frame.size.width, 20)];
        [lbl_Time setTextAlignment:NSTextAlignmentCenter];
        [lbl_Time setTextColor:[UIColor lightGrayColor]];
        [lbl_Time setBackgroundColor:[UIColor clearColor]];
        [lbl_Time setFont:[UIFont systemFontOfSize:14.0]];
        [cell.contentView addSubview:lbl_Time];
        
        UILabel *lbl_Round = [[UILabel alloc]init];
        [lbl_Round setFrame:CGRectMake(10, 5, 120, 20)];
        [lbl_Round setTextAlignment:NSTextAlignmentLeft];
        [lbl_Round setTextColor:[UIColor blackColor]];
        [lbl_Round setBackgroundColor:[UIColor clearColor]];
        [lbl_Round setFont:[UIFont boldSystemFontOfSize:14.0]];
        [cell.contentView addSubview:lbl_Round];
        
        UILabel *lbl_Place = [[UILabel alloc]init];
        [lbl_Place setFrame:CGRectMake(0, lbl_Time.frame.origin.y + lbl_Time.frame.size.height + 3, self.view.frame.size.width, 20)];
        [lbl_Place setTextAlignment:NSTextAlignmentCenter];
        [lbl_Place setTextColor:[UIColor lightGrayColor]];
        [lbl_Place setBackgroundColor:[UIColor clearColor]];
        [lbl_Place setFont:[UIFont systemFontOfSize:14.0]];
        [cell.contentView addSubview:lbl_Place];
        
        UILabel *lbl_VS = [[UILabel alloc]init];
        [lbl_VS setFrame:CGRectMake(0, 72, self.view.frame.size.width, 20)];
        [lbl_VS setTextAlignment:NSTextAlignmentCenter];
        [lbl_VS setTextColor:[UIColor grayColor]];
        [lbl_VS setBackgroundColor:[UIColor clearColor]];
        [lbl_VS setFont:[UIFont boldSystemFontOfSize:15.0]];
        [cell.contentView addSubview:lbl_VS];
        
        UILabel *lbl_Goal1 = [[UILabel alloc]init];
        [lbl_Goal1 setFrame:CGRectMake(self.view.frame.size.width/2 - 60, 60, 40, 40)];
        [lbl_Goal1 setTextAlignment:NSTextAlignmentCenter];
        [lbl_Goal1 setTextColor:[UIColor blackColor]];
        [lbl_Goal1 setBackgroundColor:[UIColor clearColor]];
        [lbl_Goal1 setFont:[UIFont systemFontOfSize:24.0]];
        [cell.contentView addSubview:lbl_Goal1];
        
        UILabel *lbl_Goal2 = [[UILabel alloc]init];
        [lbl_Goal2 setFrame:CGRectMake(self.view.frame.size.width/2 + 20, 60, 40, 40)];
        [lbl_Goal2 setTextAlignment:NSTextAlignmentCenter];
        [lbl_Goal2 setTextColor:[UIColor blackColor]];
        [lbl_Goal2 setBackgroundColor:[UIColor clearColor]];
        [lbl_Goal2 setFont:[UIFont systemFontOfSize:24.0]];
        [cell.contentView addSubview:lbl_Goal2];
        
        UIImageView *team1_Img =[UIImageView new];
        team1_Img.frame=CGRectMake(self.view.frame.size.width/2 - 150, lbl_Place.frame.origin.y + lbl_Place.frame.size.height - 10, 80, 80);
        [cell.contentView addSubview:team1_Img];
        
        UILabel *lbl_Team1 = [[UILabel alloc]init];
        [lbl_Team1 setFrame:CGRectMake(0, team1_Img.frame.origin.y + team1_Img.frame.size.height + 3, self.view.frame.size.width/2 - 40, 30)];
        [lbl_Team1 setTextAlignment:NSTextAlignmentCenter];
        [lbl_Team1 setTextColor:[UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0]];
        [lbl_Team1 setBackgroundColor:[UIColor clearColor]];
        [lbl_Team1 setFont:[UIFont systemFontOfSize:15.0]];
        [cell.contentView addSubview:lbl_Team1];
        
        UIImageView *team2_Img =[UIImageView new];
        team2_Img.frame=CGRectMake(self.view.frame.size.width/2 + 70, lbl_Place.frame.origin.y + lbl_Place.frame.size.height - 10, 80, 80);
        [cell.contentView addSubview:team2_Img];
        
        UILabel *lbl_Team2 = [[UILabel alloc]init];
        [lbl_Team2 setFrame:CGRectMake(self.view.frame.size.width/2 + 40, team2_Img.frame.origin.y + team2_Img.frame.size.height + 3, self.view.frame.size.width/2 - 60, 30)];
        [lbl_Team2 setTextAlignment:NSTextAlignmentCenter];
        [lbl_Team2 setTextColor:[UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0]];
        [lbl_Team2 setBackgroundColor:[UIColor clearColor]];
        [lbl_Team2 setFont:[UIFont systemFontOfSize:15.0]];
        [cell.contentView addSubview:lbl_Team2];
        
        UIImageView *setView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 25, 65, 13, 20)];
        setView.image = [UIImage imageNamed:@"setting1Btn.png"];
        [cell.contentView addSubview:setView];
        
        UIImageView *lineImg =[UIImageView new];
        lineImg.frame=CGRectMake(5, 149, self.view.frame.size.width - 10, 1);
        lineImg.clipsToBounds = YES;
        lineImg.userInteractionEnabled=YES;
        lineImg.backgroundColor = [UIColor colorWithRed:65.0/255.0 green:111.0/255.0 blue:155.0/255.0 alpha:1.0];
        [cell.contentView addSubview:lineImg];
        
        lbl_Time.text = [NSString stringWithFormat:@"%@ %@", [[gameListArray objectAtIndex:indexPath.row] objectForKey:@"plandate"], [[gameListArray objectAtIndex:indexPath.row] objectForKey:@"plantime"]];
        lbl_Place.text = [[gameListArray objectAtIndex:indexPath.row] objectForKey:@"place"];
        lbl_VS.text = @"VS";
        
        NSString *finishFlag = [[gameListArray objectAtIndex:indexPath.row] objectForKey:@"finishflag"];
        if ([finishFlag isEqualToString:@"0"]) {
            lbl_Goal1.text = @"--";
            lbl_Goal2.text = @"--";
        }
        else{
            lbl_Goal1.text = [[gameListArray objectAtIndex:indexPath.row] objectForKey:@"goal1"];
            lbl_Goal2.text = [[gameListArray objectAtIndex:indexPath.row] objectForKey:@"goal2"];
        }
        lbl_Round.text = [NSString stringWithFormat:@"%@Round", [[gameListArray objectAtIndex:indexPath.row] objectForKey:@"round"]];
        
        NSString *path1 = [[gameListArray objectAtIndex:indexPath.row] objectForKey:@"teamurl1"];
        [team1_Img setImageWithURL:[NSURL URLWithString:path1]];
        NSString *path2 = [[gameListArray objectAtIndex:indexPath.row] objectForKey:@"teamurl2"];
        [team2_Img setImageWithURL:[NSURL URLWithString:path2]];
        
        lbl_Team1.text = [[gameListArray objectAtIndex:indexPath.row] objectForKey:@"teamname1"];
        lbl_Team2.text = [[gameListArray objectAtIndex:indexPath.row] objectForKey:@"teamname2"];
    }
    if (isPointOrder == TRUE) {
        UILabel *lbl_Num = [[UILabel alloc]init];
        [lbl_Num setFrame:CGRectMake(0, 10, 25, 40)];
        [lbl_Num setTextAlignment:NSTextAlignmentCenter];
        [lbl_Num setTextColor:[UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0]];
        [lbl_Num setBackgroundColor:[UIColor clearColor]];
        [lbl_Num setFont:[UIFont systemFontOfSize:13.0]];
        [cell.contentView addSubview:lbl_Num];
        
        UIImageView *team_Img =[UIImageView new];
        team_Img.frame=CGRectMake(30, 10, 40, 40);
        [cell.contentView addSubview:team_Img];
        
        UILabel *lbl_TeamName = [[UILabel alloc]init];
        [lbl_TeamName setFrame:CGRectMake(75, 10, 80, 40)];
        [lbl_TeamName setTextAlignment:NSTextAlignmentLeft];
        [lbl_TeamName setTextColor:[UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0]];
        [lbl_TeamName setBackgroundColor:[UIColor clearColor]];
        [lbl_TeamName setFont:[UIFont systemFontOfSize:13.0]];
        [cell.contentView addSubview:lbl_TeamName];
        
        CGFloat padding = (self.view.frame.size.width - 160)/7;
        
        UILabel *lbl_Score1 = [[UILabel alloc]init];
        [lbl_Score1 setFrame:CGRectMake(160, 10, padding, 40)];
        [lbl_Score1 setTextAlignment:NSTextAlignmentCenter];
        [lbl_Score1 setTextColor:[UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0]];
        [lbl_Score1 setBackgroundColor:[UIColor clearColor]];
        [lbl_Score1 setFont:[UIFont systemFontOfSize:13.0]];
        [cell.contentView addSubview:lbl_Score1];
        
        UILabel *lbl_Score2 = [[UILabel alloc]init];
        [lbl_Score2 setFrame:CGRectMake(lbl_Score1.frame.origin.x + lbl_Score1.frame.size.width, 10, padding, 40)];
        [lbl_Score2 setTextAlignment:NSTextAlignmentCenter];
        [lbl_Score2 setTextColor:[UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0]];
        [lbl_Score2 setBackgroundColor:[UIColor clearColor]];
        [lbl_Score2 setFont:[UIFont systemFontOfSize:13.0]];
        [cell.contentView addSubview:lbl_Score2];
        
        UILabel *lbl_Score3 = [[UILabel alloc]init];
        [lbl_Score3 setFrame:CGRectMake(lbl_Score2.frame.origin.x + lbl_Score2.frame.size.width, 10, padding, 40)];
        [lbl_Score3 setTextAlignment:NSTextAlignmentCenter];
        [lbl_Score3 setTextColor:[UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0]];
        [lbl_Score3 setBackgroundColor:[UIColor clearColor]];
        [lbl_Score3 setFont:[UIFont systemFontOfSize:13.0]];
        [cell.contentView addSubview:lbl_Score3];
        
        UILabel *lbl_Score4 = [[UILabel alloc]init];
        [lbl_Score4 setFrame:CGRectMake(lbl_Score3.frame.origin.x + lbl_Score3.frame.size.width, 10, padding, 40)];
        [lbl_Score4 setTextAlignment:NSTextAlignmentCenter];
        [lbl_Score4 setTextColor:[UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0]];
        [lbl_Score4 setBackgroundColor:[UIColor clearColor]];
        [lbl_Score4 setFont:[UIFont systemFontOfSize:13.0]];
        [cell.contentView addSubview:lbl_Score4];
        
        UILabel *lbl_Score5 = [[UILabel alloc]init];
        [lbl_Score5 setFrame:CGRectMake(lbl_Score4.frame.origin.x + lbl_Score4.frame.size.width, 10, padding*2, 40)];
        [lbl_Score5 setTextAlignment:NSTextAlignmentCenter];
        [lbl_Score5 setTextColor:[UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0]];
        [lbl_Score5 setBackgroundColor:[UIColor clearColor]];
        [lbl_Score5 setFont:[UIFont systemFontOfSize:13.0]];
        [cell.contentView addSubview:lbl_Score5];
        
        UILabel *lbl_Score6 = [[UILabel alloc]init];
        [lbl_Score6 setFrame:CGRectMake(lbl_Score5.frame.origin.x + lbl_Score5.frame.size.width, 10, padding, 40)];
        [lbl_Score6 setTextAlignment:NSTextAlignmentCenter];
        [lbl_Score6 setTextColor:[UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0]];
        [lbl_Score6 setBackgroundColor:[UIColor clearColor]];
        [lbl_Score6 setFont:[UIFont systemFontOfSize:13.0]];
        [cell.contentView addSubview:lbl_Score6];
        
        UIImageView *lineImg =[UIImageView new];
        lineImg.frame=CGRectMake(5, 59, self.view.frame.size.width - 10, 1);
        lineImg.clipsToBounds = YES;
        lineImg.userInteractionEnabled=YES;
        lineImg.backgroundColor = [UIColor colorWithRed:65.0/255.0 green:111.0/255.0 blue:155.0/255.0 alpha:1.0];
        [cell.contentView addSubview:lineImg];
        
        lbl_Num.text = [NSString stringWithFormat:@"%ld", indexPath.row + 1];
        lbl_TeamName.text = [[pointOrderArray objectAtIndex:indexPath.row] objectForKey:@"teamname"];
        lbl_Score1.text = [[pointOrderArray objectAtIndex:indexPath.row] objectForKey:@"totalgamecount"];
        lbl_Score2.text = [[pointOrderArray objectAtIndex:indexPath.row] objectForKey:@"wincount"];
        lbl_Score3.text = [[pointOrderArray objectAtIndex:indexPath.row] objectForKey:@"drawncount"];
        
        NSString *failStr = [NSString stringWithFormat:@"%d", [lbl_Score1.text intValue] - [lbl_Score2.text intValue] - [lbl_Score3.text intValue]];
        lbl_Score4.text = failStr;
        
        lbl_Score5.text = [NSString stringWithFormat:@"%@/%@", [[pointOrderArray objectAtIndex:indexPath.row] objectForKey:@"scoregoal"], [[pointOrderArray objectAtIndex:indexPath.row] objectForKey:@"losegoal"]];
        lbl_Score6.text = [[pointOrderArray objectAtIndex:indexPath.row] objectForKey:@"score"];
        
        NSString *path1 = [[pointOrderArray objectAtIndex:indexPath.row] objectForKey:@"teamurl"];
        [team_Img setImageWithURL:[NSURL URLWithString:path1]];
    }
    if (isTopPlayer == TRUE) {
        UILabel *lbl_Num = [[UILabel alloc]init];
        [lbl_Num setFrame:CGRectMake(0, 10, 40, 40)];
        [lbl_Num setTextAlignment:NSTextAlignmentCenter];
        [lbl_Num setTextColor:[UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0]];
        [lbl_Num setBackgroundColor:[UIColor clearColor]];
        [lbl_Num setFont:[UIFont systemFontOfSize:14.0]];
        [cell.contentView addSubview:lbl_Num];
        
        UILabel *lbl_Name = [[UILabel alloc]init];
        [lbl_Name setFrame:CGRectMake(lbl_Num.frame.origin.x + lbl_Num.frame.size.width + 10, 10, self.view.frame.size.width/3 - (lbl_Num.frame.origin.x + lbl_Num.frame.size.width + 10), 40)];
        [lbl_Name setTextAlignment:NSTextAlignmentLeft];
        [lbl_Name setTextColor:[UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0]];
        [lbl_Name setBackgroundColor:[UIColor clearColor]];
        [lbl_Name setFont:[UIFont systemFontOfSize:14.0]];
        [cell.contentView addSubview:lbl_Name];
        
        UIImageView *team_Img =[UIImageView new];
        team_Img.frame=CGRectMake(self.view.frame.size.width/3, 5, 50, 50);
        [cell.contentView addSubview:team_Img];
        
        UILabel *lbl_TeamName = [[UILabel alloc]init];
        [lbl_TeamName setFrame:CGRectMake(team_Img.frame.origin.x + team_Img.frame.size.width + 5, 10, self.view.frame.size.width/3 - 30, 40)];
        [lbl_TeamName setTextAlignment:NSTextAlignmentLeft];
        [lbl_TeamName setTextColor:[UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0]];
        [lbl_TeamName setBackgroundColor:[UIColor clearColor]];
        [lbl_TeamName setFont:[UIFont systemFontOfSize:13.0]];
        [cell.contentView addSubview:lbl_TeamName];
        
        UILabel *lbl_Goal = [[UILabel alloc]init];
        [lbl_Goal setFrame:CGRectMake(self.view.frame.size.width/3*2, 10, self.view.frame.size.width/3, 40)];
        [lbl_Goal setTextAlignment:NSTextAlignmentCenter];
        [lbl_Goal setTextColor:[UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0]];
        [lbl_Goal setBackgroundColor:[UIColor clearColor]];
        [lbl_Goal setFont:[UIFont systemFontOfSize:14.0]];
        [cell.contentView addSubview:lbl_Goal];
        
        UIImageView *lineImg =[UIImageView new];
        lineImg.frame=CGRectMake(5, 59, self.view.frame.size.width - 10, 1);
        lineImg.clipsToBounds = YES;
        lineImg.userInteractionEnabled=YES;
        lineImg.backgroundColor = [UIColor colorWithRed:65.0/255.0 green:111.0/255.0 blue:155.0/255.0 alpha:1.0];
        [cell.contentView addSubview:lineImg];
        
        lbl_Num.text = [NSString stringWithFormat:@"%ld", indexPath.row + 1];
        lbl_Name.text = [[topPlayerArray objectAtIndex:indexPath.row] objectForKey:@"playername"];
        lbl_TeamName.text = [[topPlayerArray objectAtIndex:indexPath.row] objectForKey:@"teamname"];
        lbl_Goal.text = [[topPlayerArray objectAtIndex:indexPath.row] objectForKey:@"goalcount"];
        
        NSString *path1 = [[topPlayerArray objectAtIndex:indexPath.row] objectForKey:@"teamurl"];
        [team_Img setImageWithURL:[NSURL URLWithString:path1]];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //Height of the rows
    if (isGameResult == TRUE){
        return 150;
    }
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (isGameResult == TRUE) {
        RoundResultViewController *roundView = [[RoundResultViewController alloc] init];
        roundView.str_Round = [[gameListArray objectAtIndex:indexPath.row] objectForKey:@"round"];
        [self.navigationController pushViewController:roundView animated:YES];
    }
}

- (void)footBtnClicked{
    FillViewController *fillView = [[FillViewController alloc] init];
    [self.navigationController pushViewController:fillView animated:YES];
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
