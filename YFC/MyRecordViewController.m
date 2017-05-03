//
//  MyRecordViewController.m
//  YFC
//
//  Created by topone on 9/1/15.
//  Copyright (c) 2015 ming. All rights reserved.
//

#import "MyRecordViewController.h"
#import "publicHeaders.h"

@interface MyRecordViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *gigumArray;
    NSMutableArray *qungjenArray;
    
    UITableView    *historyTable;
    
    UIButton *gigumBtn;
    UIButton *qungjenBtn;
    
    BOOL isGigum;
    BOOL isQungjen;
}
@end

@implementation MyRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    gigumArray = [[NSMutableArray alloc] init];
    qungjenArray = [[NSMutableArray alloc] init];
    
    isGigum = TRUE;
    isQungjen = FALSE;
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
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
    titleLbl.text = @"我的记录";
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
    
    gigumBtn = [[UIButton alloc] initWithFrame:CGRectMake(-10, 65, self.view.frame.size.width/2, 40)];
    [gigumBtn setBackgroundColor:[UIColor colorWithRed:49.0/255.0 green:119.0/255.0 blue:187.0/255.0 alpha:1.0]];
    [gigumBtn addTarget:self action:@selector(gigumBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [gigumBtn setTintColor:[UIColor lightGrayColor]];
    gigumBtn.alpha = 1.0;
    gigumBtn.transform = CGAffineTransformMakeTranslation(10, 0);
    [self.view addSubview:gigumBtn];
    
    qungjenBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 10, 65, self.view.frame.size.width/2, 40)];
    [qungjenBtn addTarget:self action:@selector(qungjenBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [qungjenBtn setBackgroundColor:[UIColor colorWithRed:224.0/255.0 green:233.0/255.0 blue:243.0/255.0 alpha:1.0]];
    [qungjenBtn setTitleColor:[UIColor colorWithRed:49.0/255.0 green:119.0/255.0 blue:187.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [qungjenBtn setTintColor:[UIColor lightGrayColor]];
    qungjenBtn.alpha = 1.0;
    qungjenBtn.transform = CGAffineTransformMakeTranslation(10, 0);
    [self.view addSubview:qungjenBtn];
    
    NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
    if ([applang isEqualToString:@"ko"]) {
        titleLbl.text = RECORD_TITLE[0];
        [gigumBtn setTitle:RECORD_GIGUM_RECORD[0] forState:UIControlStateNormal];
        [qungjenBtn setTitle:RECORD_QUNGJEN_RECORD[0] forState:UIControlStateNormal];
    }
    if ([applang isEqualToString:@"cn"]) {
        titleLbl.text = RECORD_TITLE[1];
        [gigumBtn setTitle:RECORD_GIGUM_RECORD[1] forState:UIControlStateNormal];
        [qungjenBtn setTitle:RECORD_QUNGJEN_RECORD[1] forState:UIControlStateNormal];
    }
    
    historyTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 110, self.view.frame.size.width, self.view.frame.size.height - 110) style:UITableViewStylePlain];
    historyTable.dataSource = self;
    historyTable.delegate = self;
    [historyTable setBackgroundColor:[UIColor clearColor]];
    historyTable.userInteractionEnabled=YES;
    [historyTable setAllowsSelection:YES];
    if ([historyTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [historyTable setSeparatorInset:UIEdgeInsetsZero];
    }
    [historyTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:historyTable];
    
    [self getGigumHistory];
}

- (void)getGigumHistory{
    [gigumArray removeAllObjects];
    
    NSString *userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"];
    NSDictionary *parameters = @{@"userid":userid,
                                 @"lastid": @"0"
                                 };
    
    [SVProgressHUD showWithStatus:@"请稍后..." maskType:SVProgressHUDMaskTypeBlack];
    
    [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
    [[GlobalPool sharedInstance].OAuth2Manager POST:LC_GIGUM_HISTORY parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"%@",responseObject);
        
        gigumArray = [NSMutableArray arrayWithArray:[responseObject objectForKey:@"result"]];
        [historyTable reloadData];
        
        [SVProgressHUD dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"Connection failed"];
    }];
}

- (void)getQungjenHistory{
    [qungjenArray removeAllObjects];
    
    NSString *userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"];
    NSDictionary *parameters = @{@"userid":userid,
                                 @"lastid": @"0"
                                 };
    
    [SVProgressHUD showWithStatus:@"请稍后..." maskType:SVProgressHUDMaskTypeBlack];
    
    [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
    [[GlobalPool sharedInstance].OAuth2Manager POST:LC_QUNGJEN_HISTORY parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"%@",responseObject);
        
        qungjenArray = [NSMutableArray arrayWithArray:[responseObject objectForKey:@"result"]];
        [historyTable reloadData];
        
        [SVProgressHUD dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"Connection failed"];
    }];
}

- (void)gigumBtnClicked{
    isGigum  = TRUE;
    isQungjen  = FALSE;
    
    [gigumBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [gigumBtn setBackgroundColor:[UIColor colorWithRed:49.0/255.0 green:119.0/255.0 blue:187.0/255.0 alpha:1.0]];
    
    [qungjenBtn setBackgroundColor:[UIColor colorWithRed:224.0/255.0 green:233.0/255.0 blue:243.0/255.0 alpha:1.0]];
    [qungjenBtn setTitleColor:[UIColor colorWithRed:49.0/255.0 green:119.0/255.0 blue:187.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    
    [self getGigumHistory];
}

- (void)qungjenBtnClicked{
    isGigum  = FALSE;
    isQungjen  = TRUE;
    
    [qungjenBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [qungjenBtn setBackgroundColor:[UIColor colorWithRed:49.0/255.0 green:119.0/255.0 blue:187.0/255.0 alpha:1.0]];
    
    [gigumBtn setBackgroundColor:[UIColor colorWithRed:224.0/255.0 green:233.0/255.0 blue:243.0/255.0 alpha:1.0]];
    [gigumBtn setTitleColor:[UIColor colorWithRed:49.0/255.0 green:119.0/255.0 blue:187.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    
    [self getQungjenHistory];
}

#pragma mark - tableViewDelegate
// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (isGigum == TRUE) {
        return gigumArray.count;
    }
    if (isQungjen == TRUE) {
        return qungjenArray.count;
    }
    return gigumArray.count;
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
    
    if (isGigum == TRUE) {
        UILabel *lbl_Name = [[UILabel alloc]init];
        [lbl_Name setFrame:CGRectMake(15, 5, self.view.frame.size.width - 30, 25)];
        [lbl_Name setTextAlignment:NSTextAlignmentLeft];
        [lbl_Name setTextColor:[UIColor blackColor]];
        [lbl_Name setBackgroundColor:[UIColor clearColor]];
        [lbl_Name setFont:[UIFont systemFontOfSize:18.0]];
        [cell.contentView addSubview:lbl_Name];
        
        UILabel *lbl_PayType = [[UILabel alloc]init];
        [lbl_PayType setFrame:CGRectMake(15, 35, self.view.frame.size.width - 30, 25)];
        [lbl_PayType setTextAlignment:NSTextAlignmentLeft];
        [lbl_PayType setTextColor:[UIColor lightGrayColor]];
        [lbl_PayType setBackgroundColor:[UIColor clearColor]];
        [lbl_PayType setFont:[UIFont systemFontOfSize:15.0]];
        [cell.contentView addSubview:lbl_PayType];
        
        UILabel *lbl_Date = [[UILabel alloc]init];
        [lbl_Date setFrame:CGRectMake(15, 65, self.view.frame.size.width - 30, 25)];
        [lbl_Date setTextAlignment:NSTextAlignmentLeft];
        [lbl_Date setTextColor:[UIColor lightGrayColor]];
        [lbl_Date setBackgroundColor:[UIColor clearColor]];
        [lbl_Date setFont:[UIFont systemFontOfSize:15.0]];
        [cell.contentView addSubview:lbl_Date];
        
        UILabel *lbl_Price = [[UILabel alloc]init];
        [lbl_Price setFrame:CGRectMake(self.view.frame.size.width - 200, 10, 180, 30)];
        [lbl_Price setTextAlignment:NSTextAlignmentRight];
        [lbl_Price setTextColor:[UIColor blackColor]];
        [lbl_Price setBackgroundColor:[UIColor clearColor]];
        [lbl_Price setFont:[UIFont systemFontOfSize:22.0]];
        [cell.contentView addSubview:lbl_Price];
        
        UIImageView *lineImg =[UIImageView new];
        lineImg.frame=CGRectMake(5, 89, self.view.frame.size.width - 10, 1);
        lineImg.clipsToBounds = YES;
        lineImg.userInteractionEnabled=YES;
        lineImg.backgroundColor = [UIColor lightGrayColor];
        [cell.contentView addSubview:lineImg];
    
        NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
        if ([applang isEqualToString:@"ko"]) {
            lbl_Name.text = @"지불";
            lbl_PayType.text = @"지불성공";
        }
        if ([applang isEqualToString:@"cn"]) {
            lbl_Name.text = @"支付";
            lbl_PayType.text = @"成功支付";
        }
    
        lbl_Date.text = [[gigumArray objectAtIndex:indexPath.row] objectForKey:@"gdate"];
        lbl_Price.text = [[gigumArray objectAtIndex:indexPath.row] objectForKey:@"count"];
    }
    if (isQungjen == TRUE) {
        UILabel *lbl_Name = [[UILabel alloc]init];
        [lbl_Name setFrame:CGRectMake(15, 5, self.view.frame.size.width - 30, 25)];
        [lbl_Name setTextAlignment:NSTextAlignmentLeft];
        [lbl_Name setTextColor:[UIColor blackColor]];
        [lbl_Name setBackgroundColor:[UIColor clearColor]];
        [lbl_Name setFont:[UIFont systemFontOfSize:18.0]];
        [cell.contentView addSubview:lbl_Name];
        
        UILabel *lbl_PayType = [[UILabel alloc]init];
        [lbl_PayType setFrame:CGRectMake(15, 35, self.view.frame.size.width - 30, 25)];
        [lbl_PayType setTextAlignment:NSTextAlignmentLeft];
        [lbl_PayType setTextColor:[UIColor lightGrayColor]];
        [lbl_PayType setBackgroundColor:[UIColor clearColor]];
        [lbl_PayType setFont:[UIFont systemFontOfSize:15.0]];
        [cell.contentView addSubview:lbl_PayType];
        
        UILabel *lbl_Date = [[UILabel alloc]init];
        [lbl_Date setFrame:CGRectMake(15, 65, self.view.frame.size.width - 30, 25)];
        [lbl_Date setTextAlignment:NSTextAlignmentLeft];
        [lbl_Date setTextColor:[UIColor lightGrayColor]];
        [lbl_Date setBackgroundColor:[UIColor clearColor]];
        [lbl_Date setFont:[UIFont systemFontOfSize:15.0]];
        [cell.contentView addSubview:lbl_Date];
        
        UILabel *lbl_Price = [[UILabel alloc]init];
        [lbl_Price setFrame:CGRectMake(self.view.frame.size.width - 200, 10, 180, 30)];
        [lbl_Price setTextAlignment:NSTextAlignmentRight];
        [lbl_Price setTextColor:[UIColor redColor]];
        [lbl_Price setBackgroundColor:[UIColor clearColor]];
        [lbl_Price setFont:[UIFont systemFontOfSize:22.0]];
        [cell.contentView addSubview:lbl_Price];
        
        UIImageView *lineImg =[UIImageView new];
        lineImg.frame=CGRectMake(5, 89, self.view.frame.size.width - 10, 1);
        lineImg.clipsToBounds = YES;
        lineImg.userInteractionEnabled=YES;
        lineImg.backgroundColor = [UIColor lightGrayColor];
        [cell.contentView addSubview:lineImg];
        
        NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
        if ([applang isEqualToString:@"ko"]) {
            lbl_Name.text = @"Wechat지불";
            lbl_PayType.text = @"지불성공";
        }
        if ([applang isEqualToString:@"cn"]) {
            lbl_Name.text = @"微信支付";
            lbl_PayType.text = @"成功支付";
        }
        
        lbl_Date.text = [[qungjenArray objectAtIndex:indexPath.row] objectForKey:@"cdate"];
        lbl_Price.text = [[qungjenArray objectAtIndex:indexPath.row] objectForKey:@"count"];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //Height of the rows
    return 90;
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
