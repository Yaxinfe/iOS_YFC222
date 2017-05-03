//
//  BaedalViewController.m
//  YFC
//
//  Created by topone on 9/21/15.
//  Copyright (c) 2015 ming. All rights reserved.
//

#import "publicHeaders.h"
#import "BaedalViewController.h"

#import "AllAroundPullView.h"
#import "YFGIFImageView.h"
#import "UIImageView+PlayGIF.h"

#import "StatusViewController.h"

@interface BaedalViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *baedalTable;
    NSMutableArray *baedalArray;
}
@end

@implementation BaedalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    baedalArray = [[NSMutableArray alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    
    baedalTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 110) style:UITableViewStylePlain];
    baedalTable.dataSource = self;
    baedalTable.delegate = self;
    [baedalTable setBackgroundColor:[UIColor clearColor]];
    baedalTable.userInteractionEnabled=YES;
    [baedalTable setAllowsSelection:YES];
    if ([baedalTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [baedalTable setSeparatorInset:UIEdgeInsetsZero];
    }
    [baedalTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    // top
    AllAroundPullView *topPullView = [[AllAroundPullView alloc] initWithScrollView:baedalTable position:AllAroundPullViewPositionTop action:^(AllAroundPullView *view){
        NSLog(@"--");
        [view performSelector:@selector(finishedLoading) withObject:nil afterDelay:4.0f];
        [self getBaedalList];
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
    
    [baedalTable addSubview:topPullView];
    [self.view addSubview:baedalTable];
    
    [self getBaedalList];
}

- (void)getBaedalList{
    NSString *userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"];
    NSString *sessionkey = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionkey"];
    
    NSDictionary *parameters = @{@"userid":userid,
                                 @"sessionkey":sessionkey
                                 };
    
    [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
    [[GlobalPool sharedInstance].OAuth2Manager POST:LC_SHOP_HISTORY_BAEDAL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        
        NSString *status = [responseObject objectForKey:@"status"];
        
        if ([status intValue] == 200){
            baedalArray = [NSMutableArray arrayWithArray:[responseObject objectForKey:@"result"]];
            [baedalTable reloadData];
        }
        else if ([status intValue] == 1001) {
            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:@"NO" forKey:@"isLoginState"];
            [defaults synchronize];
            [[AppDelegate sharedAppDelegate] runMain];
        }
        else{
            
        }
    
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"Connection failed"];
    }];
}

#pragma mark - tableViewDelegate
// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return baedalArray.count;
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
    
    UILabel *lbl_Status = [[UILabel alloc]init];
    [lbl_Status setFrame:CGRectMake(20, 10, self.view.frame.size.width - 40, 20)];
    [lbl_Status setTextAlignment:NSTextAlignmentLeft];
    [lbl_Status setTextColor:[UIColor blackColor]];
    [lbl_Status setBackgroundColor:[UIColor clearColor]];
    [lbl_Status setFont:[UIFont systemFontOfSize:14.0]];
    [cell.contentView addSubview:lbl_Status];
    
    UILabel *lbl_Date = [[UILabel alloc]init];
    [lbl_Date setFrame:CGRectMake(20, 40, self.view.frame.size.width - 40, 20)];
    [lbl_Date setTextAlignment:NSTextAlignmentLeft];
    [lbl_Date setTextColor:[UIColor lightGrayColor]];
    [lbl_Date setBackgroundColor:[UIColor clearColor]];
    [lbl_Date setFont:[UIFont systemFontOfSize:14.0]];
    [cell.contentView addSubview:lbl_Date];
    
    UIImageView *setView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 35, 20, 20, 30)];
    setView.image = [UIImage imageNamed:@"setting1Btn.png"];
    [cell.contentView addSubview:setView];
    
    UIImageView *lineImg1 =[UIImageView new];
    lineImg1.frame=CGRectMake(20, 69, self.view.frame.size.width - 20, 1);
    lineImg1.clipsToBounds = YES;
    lineImg1.userInteractionEnabled=YES;
    lineImg1.backgroundColor = [UIColor colorWithRed:233.0/255.0 green:233.0/255.0 blue:233.0/255.0 alpha:1.0];
    [cell.contentView addSubview:lineImg1];
    
    UIImageView *mainImage =[UIImageView new];
    mainImage.frame=CGRectMake(20, 80, 50, 50);
    mainImage.clipsToBounds = YES;
    mainImage.userInteractionEnabled=YES;
    mainImage.layer.cornerRadius = 1;
    mainImage.layer.borderColor = [UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0].CGColor;
    mainImage.layer.borderWidth = 1;
    mainImage.layer.masksToBounds = YES;
    mainImage.backgroundColor = [UIColor whiteColor];
    [cell.contentView addSubview:mainImage];
    
    UILabel *lbl_Title = [[UILabel alloc]init];
    [lbl_Title setFrame:CGRectMake(80, 80, self.view.frame.size.width - 90, 50)];
    [lbl_Title setTextAlignment:NSTextAlignmentLeft];
    [lbl_Title setTextColor:[UIColor blackColor]];
    [lbl_Title setBackgroundColor:[UIColor clearColor]];
    [lbl_Title setFont:[UIFont systemFontOfSize:14.0]];
    [cell.contentView addSubview:lbl_Title];
    
    UIImageView *lineImg2 =[UIImageView new];
    lineImg2.frame=CGRectMake(20, 139, self.view.frame.size.width - 20, 1);
    lineImg2.clipsToBounds = YES;
    lineImg2.userInteractionEnabled=YES;
    lineImg2.backgroundColor = [UIColor colorWithRed:233.0/255.0 green:233.0/255.0 blue:233.0/255.0 alpha:1.0];
    [cell.contentView addSubview:lineImg2];
    
    UILabel *lbl_Price = [[UILabel alloc]init];
    [lbl_Price setFrame:CGRectMake(20, 150, 50, 20)];
    [lbl_Price setTextAlignment:NSTextAlignmentLeft];
    [lbl_Price setTextColor:[UIColor blackColor]];
    [lbl_Price setBackgroundColor:[UIColor clearColor]];
    [lbl_Price setFont:[UIFont systemFontOfSize:14.0]];
    lbl_Price.text = @"가격: ";
    [cell.contentView addSubview:lbl_Price];
    
    UILabel *lbl_BallCount = [[UILabel alloc]init];
    [lbl_BallCount setFrame:CGRectMake(lbl_Price.frame.origin.x + lbl_Price.frame.size.width + 10, 150, 120, 20)];
    [lbl_BallCount setTextAlignment:NSTextAlignmentLeft];
    [lbl_BallCount setTextColor:[UIColor redColor]];
    [lbl_BallCount setBackgroundColor:[UIColor clearColor]];
    [lbl_BallCount setFont:[UIFont systemFontOfSize:14.0]];
    [cell.contentView addSubview:lbl_BallCount];
    
    UIImageView *lineImg3 =[UIImageView new];
    lineImg3.frame=CGRectMake(20, 179, self.view.frame.size.width - 20, 1);
    lineImg3.clipsToBounds = YES;
    lineImg3.userInteractionEnabled=YES;
    lineImg3.backgroundColor = [UIColor colorWithRed:233.0/255.0 green:233.0/255.0 blue:233.0/255.0 alpha:1.0];
    [cell.contentView addSubview:lineImg3];
    
    UIImageView *lineImg =[UIImageView new];
    lineImg.frame=CGRectMake(2, 199, self.view.frame.size.width - 4, 1);
    lineImg.clipsToBounds = YES;
    lineImg.userInteractionEnabled=YES;
    lineImg.backgroundColor = [UIColor colorWithRed:65.0/255.0 green:111.0/255.0 blue:155.0/255.0 alpha:1.0];
    [cell.contentView addSubview:lineImg];
    
    NSString *path = [[baedalArray objectAtIndex:indexPath.row] objectForKey:@"mainurl"];
    [mainImage setImageWithURL:[NSURL URLWithString:path]];
    
    lbl_Title.text = [[baedalArray objectAtIndex:indexPath.row] objectForKey:@"title"];
    lbl_Status.text = [[baedalArray objectAtIndex:indexPath.row] objectForKey:@"dstatus"];
    lbl_Date.text = [[baedalArray objectAtIndex:indexPath.row] objectForKey:@"buydate"];
    lbl_BallCount.text = [[baedalArray objectAtIndex:indexPath.row] objectForKey:@"ballnumber"];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //Height of the rows
    return 200;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    StatusViewController *status_view = [[StatusViewController alloc] init];
    status_view.baedalID = [[baedalArray objectAtIndex:indexPath.row] objectForKey:@"deliverynumber"];
    status_view.baedalCompany = [[baedalArray objectAtIndex:indexPath.row] objectForKey:@"dcompanyname"];
    [self.navigationController pushViewController:status_view animated:YES];
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
