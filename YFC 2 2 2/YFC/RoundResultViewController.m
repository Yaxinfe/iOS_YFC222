//
//  RoundResultViewController.m
//  YFC
//
//  Created by topone on 9/12/15.
//  Copyright (c) 2015 ming. All rights reserved.
//

#import "RoundResultViewController.h"
#import "publicHeaders.h"

@interface RoundResultViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *gameTable;
    NSMutableArray *gameListArray;
}

@end

@implementation RoundResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    backImageView.image = [UIImage imageNamed:@"shopBack.png"];
    [self.view addSubview:backImageView];
    
    UIButton *back_btn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.origin.x , self.view.frame.origin.y + 25, 27, 30)];
    [back_btn setImage:[UIImage imageNamed:@"backBtn.png"] forState:UIControlStateNormal];
    [back_btn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [back_btn setTintColor:[UIColor lightGrayColor]];
    back_btn.alpha = 1.0;
    back_btn.transform = CGAffineTransformMakeTranslation(10, 0);
    [self.view addSubview:back_btn];
    
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 100, 30, 200, 24)];
    
    NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
    if ([applang isEqualToString:@"ko"]) {
        titleLbl.text = [NSString stringWithFormat:@"라운드 %@", self.str_Round];
    }
    if ([applang isEqualToString:@"cn"]) {
        titleLbl.text = [NSString stringWithFormat:@"Round %@", self.str_Round];
    }

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
    
    gameTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 65, self.view.frame.size.width, self.view.frame.size.height - 65) style:UITableViewStylePlain];
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
    
    [self getGameResult];
}

- (void)getGameResult{
    NSDictionary *parameters = @{@"round":self.str_Round
                                 };
    
    [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
    [[GlobalPool sharedInstance].OAuth2Manager POST:LC_GAME_GAMERESULT_ROUND parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"%@",responseObject);
        
        gameListArray = [NSMutableArray arrayWithArray:[responseObject objectForKey:@"result"]];
        [gameTable reloadData];
    
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"Connection failed"];
    }];
}

#pragma mark - tableViewDelegate
// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return gameListArray.count;
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
    
    UILabel *lbl_Time = [[UILabel alloc]init];
    [lbl_Time setFrame:CGRectMake(0, 5, self.view.frame.size.width, 20)];
    [lbl_Time setTextAlignment:NSTextAlignmentCenter];
    [lbl_Time setTextColor:[UIColor lightGrayColor]];
    [lbl_Time setBackgroundColor:[UIColor clearColor]];
    [lbl_Time setFont:[UIFont systemFontOfSize:13.0]];
    [cell.contentView addSubview:lbl_Time];
    
    UILabel *lbl_Place = [[UILabel alloc]init];
    [lbl_Place setFrame:CGRectMake(0, lbl_Time.frame.origin.y + lbl_Time.frame.size.height + 3, self.view.frame.size.width, 20)];
    [lbl_Place setTextAlignment:NSTextAlignmentCenter];
    [lbl_Place setTextColor:[UIColor lightGrayColor]];
    [lbl_Place setBackgroundColor:[UIColor clearColor]];
    [lbl_Place setFont:[UIFont systemFontOfSize:13.0]];
    [cell.contentView addSubview:lbl_Place];
    
    UILabel *lbl_VS = [[UILabel alloc]init];
    [lbl_VS setFrame:CGRectMake(0, 72, self.view.frame.size.width, 20)];
    [lbl_VS setTextAlignment:NSTextAlignmentCenter];
    [lbl_VS setTextColor:[UIColor grayColor]];
    [lbl_VS setBackgroundColor:[UIColor clearColor]];
    [lbl_VS setFont:[UIFont boldSystemFontOfSize:14.0]];
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
    
    NSString *path1 = [[gameListArray objectAtIndex:indexPath.row] objectForKey:@"teamurl1"];
    [team1_Img setImageWithURL:[NSURL URLWithString:path1]];
    NSString *path2 = [[gameListArray objectAtIndex:indexPath.row] objectForKey:@"teamurl2"];
    [team2_Img setImageWithURL:[NSURL URLWithString:path2]];
    
    lbl_Team1.text = [[gameListArray objectAtIndex:indexPath.row] objectForKey:@"teamname1"];
    lbl_Team2.text = [[gameListArray objectAtIndex:indexPath.row] objectForKey:@"teamname2"];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
