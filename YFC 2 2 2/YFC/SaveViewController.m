//
//  SaveViewController.m
//  YFC
//
//  Created by topone on 9/21/15.
//  Copyright (c) 2015 ming. All rights reserved.
//

#import "publicHeaders.h"
#import "SaveViewController.h"
#import "AddAddressViewController.h"

#import "AllAroundPullView.h"
#import "YFGIFImageView.h"
#import "UIImageView+PlayGIF.h"

@interface SaveViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *addressTable;
    NSMutableArray *addressArray;
}
@end

@implementation SaveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    addressArray = [[NSMutableArray alloc] init];
    //checkArray = [[NSMutableArray alloc] init];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    addressTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 160) style:UITableViewStylePlain];
    addressTable.dataSource = self;
    addressTable.delegate = self;
    [addressTable setBackgroundColor:[UIColor clearColor]];
    addressTable.userInteractionEnabled=YES;
    [addressTable setAllowsSelection:YES];
    if ([addressTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [addressTable setSeparatorInset:UIEdgeInsetsZero];
    }
    [addressTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self.view addSubview:addressTable];
    
    UIButton *addAddressBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 154, self.view.frame.size.width, 50)];
    NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
    if ([applang isEqualToString:@"ko"]) {
        [addAddressBtn setTitle:@"주소추가" forState:UIControlStateNormal];
    }
    if ([applang isEqualToString:@"cn"]) {
        [addAddressBtn setTitle:@"添加地址" forState:UIControlStateNormal];
    }
    
    [addAddressBtn setBackgroundColor:[UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0]];
    [addAddressBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addAddressBtn addTarget:self action:@selector(addAddressBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addAddressBtn];
    
    [self getAddressList];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshDelegate) name:@"refresh" object:nil];
}

- (void)refreshDelegate{
    [self getAddressList];
}

- (void)addAddressBtnClicked{
    AddAddressViewController *addView = [[AddAddressViewController alloc] init];
    [self.navigationController pushViewController:addView animated:YES];
}

- (void)getAddressList{
    NSString *userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"];
    NSString *sessionkey = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionkey"];
    
    NSDictionary *parameters = @{@"userid":userid,
                                 @"sessionkey":sessionkey
                                 };
    
    [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
    [[GlobalPool sharedInstance].OAuth2Manager POST:LC_SHOP_HISTORY_ADDRESS parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        
        NSString *status = [responseObject objectForKey:@"status"];
        
        if ([status intValue] == 200){
            addressArray = [NSMutableArray arrayWithArray:[responseObject objectForKey:@"result"]];
            [addressTable reloadData];
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
    return addressArray.count;
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
    
    UILabel *lbl_Name = [[UILabel alloc]init];
    [lbl_Name setFrame:CGRectMake(30, 20, 80, 20)];
    [lbl_Name setTextAlignment:NSTextAlignmentLeft];
    [lbl_Name setTextColor:[UIColor blackColor]];
    [lbl_Name setBackgroundColor:[UIColor clearColor]];
    [lbl_Name setFont:[UIFont systemFontOfSize:17.0]];
    [cell.contentView addSubview:lbl_Name];
    
    UILabel *lbl_Phone = [[UILabel alloc]init];
    [lbl_Phone setFrame:CGRectMake(lbl_Name.frame.size.width + lbl_Name.frame.origin.x + 5, 20, 300, 20)];
    [lbl_Phone setTextAlignment:NSTextAlignmentLeft];
    [lbl_Phone setTextColor:[UIColor blackColor]];
    [lbl_Phone setBackgroundColor:[UIColor clearColor]];
    [lbl_Phone setFont:[UIFont systemFontOfSize:17.0]];
    [cell.contentView addSubview:lbl_Phone];
    
    UILabel *lbl_Address = [[UILabel alloc]init];
    [lbl_Address setFrame:CGRectMake(30, lbl_Name.frame.origin.y + lbl_Name.frame.size.height + 20, 300, 20)];
    [lbl_Address setTextAlignment:NSTextAlignmentLeft];
    [lbl_Address setTextColor:[UIColor lightGrayColor]];
    [lbl_Address setBackgroundColor:[UIColor clearColor]];
    [lbl_Address setFont:[UIFont systemFontOfSize:15.0]];
    [cell.contentView addSubview:lbl_Address];
    
    UIButton *delBtn = [[UIButton alloc] init];
    [delBtn setFrame:CGRectMake(self.view.frame.size.width - 48, 5, 27, 27)];
    [delBtn setImage:[UIImage imageNamed:@"delBtn.png"] forState:UIControlStateNormal];
    [delBtn setTintColor:[UIColor lightGrayColor]];
    delBtn.alpha = 1.0;
    delBtn.transform = CGAffineTransformMakeTranslation(10, 0);
    delBtn.tag = indexPath.row;
    [delBtn addTarget:self action:@selector(delBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:delBtn];
    
    UIImageView *lineImg =[UIImageView new];
    lineImg.frame=CGRectMake(2, 89, self.view.frame.size.width - 4, 1);
    lineImg.clipsToBounds = YES;
    lineImg.userInteractionEnabled=YES;
    lineImg.backgroundColor = [UIColor colorWithRed:65.0/255.0 green:111.0/255.0 blue:155.0/255.0 alpha:1.0];
    [cell.contentView addSubview:lineImg];
    
    
    lbl_Name.text = [[addressArray objectAtIndex:indexPath.row] objectForKey:@"name"];
    lbl_Phone.text = [[addressArray objectAtIndex:indexPath.row] objectForKey:@"phone"];
    lbl_Address.text = [[addressArray objectAtIndex:indexPath.row] objectForKey:@"address"];
    
    return cell;
}

-(void)delBtnClicked:(id)sender{
    UIButton *btn = (UIButton *)sender;
    
    NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
    if ([applang isEqualToString:@"ko"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"정말 삭제하시겠습니까?" delegate:self cancelButtonTitle:@"예" otherButtonTitles:@"아니", nil];
        alert.tag = btn.tag;
        [alert show];
    }
    if ([applang isEqualToString:@"cn"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"确认删除?" delegate:self cancelButtonTitle:@"是" otherButtonTitles:@"否", nil];
        alert.tag = btn.tag;
        [alert show];
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        NSString *userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"];
        NSString *sessionkey = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionkey"];
        
        NSDictionary *parameters = @{@"userid":userid,
                                     @"receiverid":[[addressArray objectAtIndex:alertView.tag] objectForKey:@"receiverid"],
                                     @"sessionkey":sessionkey
                                     };
        
        [SVProgressHUD showWithStatus:@"请稍后..." maskType:SVProgressHUDMaskTypeBlack];
        
        [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
        [[GlobalPool sharedInstance].OAuth2Manager POST:LC_SHOP_ADDRESS_DELETE parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@",responseObject);
            
            NSString *status = [responseObject objectForKey:@"status"];
            
            if ([status intValue] == 200){
                [self getAddressList];
                NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
                if ([applang isEqualToString:@"ko"]) {
                    [ProgressHUD showSuccess:@"삭제!"];
                }
                if ([applang isEqualToString:@"cn"]) {
                    [ProgressHUD showSuccess:@"￼已删除"];
                }
            
            }
            else if ([status intValue] == 1001) {
                NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:@"NO" forKey:@"isLoginState"];
                [defaults synchronize];
                [[AppDelegate sharedAppDelegate] runMain];
            }
            else{
                
            }
            
            [SVProgressHUD dismiss];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"Connection failed"];
        }];
    }
    else{
        
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        //add code here for when you hit delete
//        [addressArray removeObjectAtIndex:indexPath.row];
//        [addressTable reloadData];
//    }
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //Height of the rows
    return 90;
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
