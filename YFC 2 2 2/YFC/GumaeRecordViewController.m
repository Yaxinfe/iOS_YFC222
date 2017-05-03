//
//  GumaeRecordViewController.m
//  YFC
//
//  Created by topone on 9/21/15.
//  Copyright (c) 2015 ming. All rights reserved.
//

#import "publicHeaders.h"
#import "GumaeRecordViewController.h"

#import "AllAroundPullView.h"
#import "YFGIFImageView.h"
#import "UIImageView+PlayGIF.h"

@interface GumaeRecordViewController ()<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
{
    NSMutableArray *gumaeArray;
    UITableView    *gumaeTable;
}
@end

@implementation GumaeRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    gumaeArray = [[NSMutableArray alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    
    gumaeTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 110) style:UITableViewStylePlain];
    gumaeTable.dataSource = self;
    gumaeTable.delegate = self;
    [gumaeTable setBackgroundColor:[UIColor clearColor]];
    gumaeTable.userInteractionEnabled=YES;
    [gumaeTable setAllowsSelection:YES];
    if ([gumaeTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [gumaeTable setSeparatorInset:UIEdgeInsetsZero];
    }
    [gumaeTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
//    // top
//    AllAroundPullView *topPullView = [[AllAroundPullView alloc] initWithScrollView:gumaeTable position:AllAroundPullViewPositionTop action:^(AllAroundPullView *view){
//        NSLog(@"--");
//        [view performSelector:@selector(finishedLoading) withObject:nil afterDelay:4.0f];
//        [self getHistoryList];
//    }];
//    topPullView.backgroundColor = [UIColor clearColor];
//    topPullView.activityView.hidden = YES;
//    
//    NSData *gifData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"football1.gif" ofType:nil]];
//    YFGIFImageView *gifView = [[YFGIFImageView alloc] initWithFrame:CGRectMake(topPullView.frame.size.width/2 - 90, topPullView.frame.size.height - 50, 180, 50)];
//    gifView.backgroundColor = [UIColor clearColor];
//    gifView.gifData = gifData;
//    [topPullView addSubview:gifView];
//    [gifView startGIF];
//    gifView.userInteractionEnabled = YES;
//    
//    [gumaeTable addSubview:topPullView];
    
    [self.view addSubview:gumaeTable];
    
    [self getHistoryList];
}

- (void)getHistoryList{
    NSString *userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"];
    NSString *sessionkey = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionkey"];
    
    NSDictionary *parameters = @{@"userid":userid,
                                 @"lastid":@"0",
                                 @"sessionkey":sessionkey
                                 };
    
    [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
    [[GlobalPool sharedInstance].OAuth2Manager POST:LC_SHOP_HISTORY_COMPLETE parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        
        NSString *status = [responseObject objectForKey:@"status"];
        
        if ([status intValue] == 200) {
            gumaeArray = [NSMutableArray arrayWithArray:[responseObject objectForKey:@"result"]];
            [gumaeTable reloadData];
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
    return gumaeArray.count;
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
    
    UIImageView *mainImage =[UIImageView new];
    mainImage.frame=CGRectMake(20, 10, 90, 100);
    mainImage.clipsToBounds = YES;
    mainImage.userInteractionEnabled=YES;
    mainImage.layer.cornerRadius = 1;
    mainImage.layer.borderColor = [UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0].CGColor;
    mainImage.layer.borderWidth = 1;
    mainImage.layer.masksToBounds = YES;
    mainImage.backgroundColor = [UIColor whiteColor];
    [cell.contentView addSubview:mainImage];
    
    UILabel *lbl_Title = [[UILabel alloc]init];
    [lbl_Title setFrame:CGRectMake(120, 10, self.view.frame.size.width - 150, 20)];
    [lbl_Title setTextAlignment:NSTextAlignmentLeft];
    [lbl_Title setTextColor:[UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0]];
    [lbl_Title setBackgroundColor:[UIColor clearColor]];
    [lbl_Title setFont:[UIFont systemFontOfSize:14.0]];
    [cell.contentView addSubview:lbl_Title];
    
    UILabel *lbl_Color = [[UILabel alloc]init];
    [lbl_Color setFrame:CGRectMake(120, 50, self.view.frame.size.width - 150, 20)];
    [lbl_Color setTextAlignment:NSTextAlignmentLeft];
    [lbl_Color setTextColor:[UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0]];
    [lbl_Color setBackgroundColor:[UIColor clearColor]];
    [lbl_Color setFont:[UIFont systemFontOfSize:14.0]];
    [cell.contentView addSubview:lbl_Color];
    
    UIImageView *ballImage =[UIImageView new];
    ballImage.frame=CGRectMake(120, 90, 20, 20);
    ballImage.image = [UIImage imageNamed:@"blueBall.png"];
    ballImage.clipsToBounds = YES;
    ballImage.userInteractionEnabled=YES;
    ballImage.backgroundColor = [UIColor whiteColor];
    [cell.contentView addSubview:ballImage];
    
    UILabel *lbl_BallCount = [[UILabel alloc]init];
    [lbl_BallCount setFrame:CGRectMake(ballImage.frame.origin.x + ballImage.frame.size.width + 10, 90, self.view.frame.size.width - 150, 20)];
    [lbl_BallCount setTextAlignment:NSTextAlignmentLeft];
    [lbl_BallCount setTextColor:[UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0]];
    [lbl_BallCount setBackgroundColor:[UIColor clearColor]];
    [lbl_BallCount setFont:[UIFont systemFontOfSize:14.0]];
    [cell.contentView addSubview:lbl_BallCount];
    
    UIButton *delBtn = [[UIButton alloc] init];
    [delBtn setFrame:CGRectMake(self.view.frame.size.width - 48, 5, 27, 27)];
    [delBtn setImage:[UIImage imageNamed:@"delBtn.png"] forState:UIControlStateNormal];
    [delBtn setTintColor:[UIColor lightGrayColor]];
    delBtn.alpha = 1.0;
    delBtn.transform = CGAffineTransformMakeTranslation(10, 0);
    delBtn.tag = indexPath.row;
    [delBtn addTarget:self action:@selector(delBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:delBtn];
    
    UIImageView *doneImg =[UIImageView new];
    doneImg.backgroundColor = [UIColor clearColor];
    doneImg.frame=CGRectMake(self.view.frame.size.width - 70, 50, 70, 70);
    doneImg.image = [UIImage imageNamed:@"gumaeDoneImg.png"];
    doneImg.clipsToBounds = YES;
    doneImg.userInteractionEnabled=YES;
    [cell.contentView addSubview:doneImg];
    
    UIImageView *lineImg =[UIImageView new];
    lineImg.frame=CGRectMake(2, 119, self.view.frame.size.width - 4, 1);
    lineImg.clipsToBounds = YES;
    lineImg.userInteractionEnabled=YES;
    lineImg.backgroundColor = [UIColor colorWithRed:65.0/255.0 green:111.0/255.0 blue:155.0/255.0 alpha:1.0];
    [cell.contentView addSubview:lineImg];
    
    lbl_Title.text = [[gumaeArray objectAtIndex:indexPath.row] objectForKey:@"title"];
    lbl_Color.text = [[gumaeArray objectAtIndex:indexPath.row] objectForKey:@"color"];
    lbl_BallCount.text = [[gumaeArray objectAtIndex:indexPath.row] objectForKey:@"price"];
    
    NSString *path = [[gumaeArray objectAtIndex:indexPath.row] objectForKey:@"mainurl"];
    [mainImage setImageWithURL:[NSURL URLWithString:path]];
    
    return cell;
}

-(void)delBtnClicked:(id)sender{
    UIButton *btn = (UIButton *)sender;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"주의" message:@"정말 삭제하시겠습니까?" delegate:self cancelButtonTitle:@"예" otherButtonTitles:@"아니", nil];
    alert.tag = btn.tag;
    [alert show];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        NSString *userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"];
        NSString *sessionkey = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionkey"];
        
        NSDictionary *parameters = @{@"userid":userid,
                                     @"buyid":[[gumaeArray objectAtIndex:alertView.tag] objectForKey:@"buyid"],
                                     @"sessionkey":sessionkey
                                     };
        
        [SVProgressHUD showWithStatus:@"请稍后..." maskType:SVProgressHUDMaskTypeBlack];
        
        [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
        [[GlobalPool sharedInstance].OAuth2Manager POST:LC_SHOP_HISTORY_DELETE parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@",responseObject);
            
            NSString *status = [responseObject objectForKey:@"status"];
            
            if ([status intValue] == 200){
                [self getHistoryList];
            }
            else if ([status intValue] == 1001) {
                NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:@"NO" forKey:@"isLoginState"];
                [defaults synchronize];
                [[AppDelegate sharedAppDelegate] runMain];
            }
            else{
                
            }
            NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
            if ([applang isEqualToString:@"ko"]) {
                [ProgressHUD showSuccess:@"삭제!"];
            }
            if ([applang isEqualToString:@"cn"]) {
                [ProgressHUD showSuccess:@"￼已删除"];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"Connection failed"];
        }];
    }
    else{
        
    }
    
}

//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    // Return YES if you want the specified item to be editable.
//    return YES;
//}

//// Override to support editing the table view.
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        //add code here for when you hit delete
//        [gumaeArray removeObjectAtIndex:indexPath.row];
//        [gumaeTable reloadData];
//    }
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //Height of the rows
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
