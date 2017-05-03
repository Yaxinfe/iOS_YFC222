//
//  EditAddressViewController.m
//  YFC
//
//  Created by topone on 9/21/15.
//  Copyright (c) 2015 ming. All rights reserved.
//

#import "publicHeaders.h"
#import "EditAddressViewController.h"
#import "AddAddressViewController.h"

@interface EditAddressViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *addressTable;
    NSMutableArray *addressArray;
    
    NSMutableArray *checkArray;
}
@end

@implementation EditAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    checkArray = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *back_btn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.origin.x , self.view.frame.origin.y + 25, 27, 30)];
    [back_btn setImage:[UIImage imageNamed:@"backBtn.png"] forState:UIControlStateNormal];
    [back_btn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [back_btn setTintColor:[UIColor lightGrayColor]];
    back_btn.alpha = 1.0;
    back_btn.transform = CGAffineTransformMakeTranslation(10, 0);
    [self.view addSubview:back_btn];
    
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 100, 30, 200, 24)];
//    titleLbl.text = @"配送地址";
    titleLbl.font = [UIFont boldSystemFontOfSize:22.0];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.textColor = [UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0];
    [self.view addSubview:titleLbl];
    
    UIButton *add_btn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 50, 27, 27, 27)];
    [add_btn setImage:[UIImage imageNamed:@"plusBtn.png"] forState:UIControlStateNormal];
    [add_btn addTarget:self action:@selector(addAddressBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [add_btn setTintColor:[UIColor lightGrayColor]];
    add_btn.alpha = 1.0;
    add_btn.transform = CGAffineTransformMakeTranslation(10, 0);
    [self.view addSubview:add_btn];
    
    UIImageView *lineImg =[UIImageView new];
    lineImg.frame=CGRectMake(0, 63, self.view.frame.size.width, 2);
    lineImg.clipsToBounds = YES;
    lineImg.userInteractionEnabled=YES;
    lineImg.backgroundColor = [UIColor colorWithRed:216.0/255.0 green:229.0/255.0 blue:241.0/255.0 alpha:1.0];
    [self.view addSubview:lineImg];
    
    addressTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 65, self.view.frame.size.width, self.view.frame.size.height - 115) style:UITableViewStylePlain];
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
    
    UIButton *doneAddressBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50)];
//    [doneAddressBtn setTitle:@"완료" forState:UIControlStateNormal];
    [doneAddressBtn setBackgroundColor:[UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0]];
    [doneAddressBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [doneAddressBtn addTarget:self action:@selector(doneAddressBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:doneAddressBtn];
    
    [self getAddressList];
    
    NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
    if ([applang isEqualToString:@"ko"]) {
        titleLbl.text = ADDRESS_TITLE[0];
        [doneAddressBtn setTitle:ADDRESS_SELECT_BUTTON[0] forState:UIControlStateNormal];
    }
    if ([applang isEqualToString:@"cn"]) {
        titleLbl.text = ADDRESS_TITLE[1];
        [doneAddressBtn setTitle:ADDRESS_SELECT_BUTTON[1] forState:UIControlStateNormal];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshDelegate) name:@"refresh" object:nil];
}

- (void)refreshDelegate{
    [self getAddressList];
}

- (void)doneAddressBtn{
    NSString *strName = nil;
    NSString *strPhone = nil;
    NSString *strAddress = nil;
    NSString *strDistance = nil;
    
    for (int i = 0; i < checkArray.count; i++) {
        if ([[checkArray objectAtIndex:i] isEqualToString:@"YES"]) {
            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
            
            strName = [[addressArray objectAtIndex:i] objectForKey:@"name"];
            strPhone = [[addressArray objectAtIndex:i] objectForKey:@"phone"];
            strAddress = [[addressArray objectAtIndex:i] objectForKey:@"address"];
            strDistance = [[addressArray objectAtIndex:i] objectForKey:@"distance"];
            
            [defaults setObject:strName forKey:@"baedalName"];
            [defaults setObject:strPhone forKey:@"baedalPhone"];
            [defaults setObject:strAddress forKey:@"baedalAddress"];
            [defaults setObject:strDistance forKey:@"baedalDistance"];
            
            [defaults synchronize];
        }
    }
    
    if (strAddress != nil && strPhone != nil && strName != nil) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"select" object:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
        if ([applang isEqualToString:@"ko"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"배송할 주소를 선택하세요." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        if ([applang isEqualToString:@"cn"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请选择配送地址" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            [alert show];
        }
    
    }
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
    
    [SVProgressHUD showWithStatus:@"请稍后..." maskType:SVProgressHUDMaskTypeBlack];
    
    [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
    [[GlobalPool sharedInstance].OAuth2Manager POST:LC_SHOP_HISTORY_ADDRESS parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        
        NSString *status = [responseObject objectForKey:@"status"];
        
        if ([status intValue] == 200) {
            addressArray = [NSMutableArray arrayWithArray:[responseObject objectForKey:@"result"]];
            
            for (int i = 0; i < addressArray.count; i++) {
                [checkArray addObject:@"NO"];
            }
            
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
        
        [SVProgressHUD dismiss];
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
    
    UIButton *checkBtn = [[UIButton alloc] init];
    [checkBtn setFrame:CGRectMake(self.view.frame.size.width - 50, 32, 26, 26)];
    if (![[checkArray objectAtIndex:indexPath.row] isEqualToString:@"NO"]) {
        [checkBtn setImage:[UIImage imageNamed:@"checkBtn.png"] forState:UIControlStateNormal];
    }
    else{
        [checkBtn setImage:[UIImage imageNamed:@"uncheckBtn.png"] forState:UIControlStateNormal];
    }
    [checkBtn setTintColor:[UIColor lightGrayColor]];
    checkBtn.alpha = 1.0;
    checkBtn.transform = CGAffineTransformMakeTranslation(10, 0);
    checkBtn.tag = indexPath.row;
    [checkBtn addTarget:self action:@selector(checkBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:checkBtn];
    
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

-(void)checkBtnClicked:(id)sender{
    UIButton *btn = (UIButton *)sender;
    
    if ([[checkArray objectAtIndex:btn.tag] isEqualToString:@"NO"]) {
        [checkArray removeAllObjects];
        
        for (int i = 0; i < addressArray.count; i++) {
            if (i == btn.tag) {
                [checkArray addObject:@"YES"];
            }
            else{
                [checkArray addObject:@"NO"];
            }
        }
    }
    else{
        [checkArray removeAllObjects];
        
        for (int i = 0; i < addressArray.count; i++) {
            [checkArray addObject:@"NO"];
        }
    }
    
    [addressTable reloadData];
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
