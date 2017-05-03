//
//  AddAddressViewController.m
//  YFC
//
//  Created by topone on 9/21/15.
//  Copyright (c) 2015 ming. All rights reserved.
//

#import "publicHeaders.h"
#import "AddAddressViewController.h"

#import "LPPopupListView.h"

@interface AddAddressViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, LPPopupListViewDelegate>
{
    UITableView *addressTable;
    
    UITextField *nameTxt;
    UITextField *phoneTxt;
    UITextField *addressTxt1;
    UITextField *addressTxt2;
    
    UIPickerView *addressSelect;
    NSMutableArray *pickerData;
    NSMutableArray *addressArray;
    
    int selectId;
}

@property (nonatomic, strong) NSMutableIndexSet *selectedIndexes;

@end

@implementation AddAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    addressArray = [[NSMutableArray alloc] init];
    
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *back_btn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.origin.x , self.view.frame.origin.y + 25, 27, 30)];
    [back_btn setImage:[UIImage imageNamed:@"backBtn.png"] forState:UIControlStateNormal];
    [back_btn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [back_btn setTintColor:[UIColor lightGrayColor]];
//    back_btn.alpha = 1.0;
    back_btn.transform = CGAffineTransformMakeTranslation(10, 0);
    [self.view addSubview:back_btn];
    
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 100, 30, 200, 24)];
//    titleLbl.text = @"주소추가";
    titleLbl.font = [UIFont boldSystemFontOfSize:22.0];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.textColor = [UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0];
    [self.view addSubview:titleLbl];
    
    UIImageView *lineImg =[UIImageView new];
    lineImg.frame=CGRectMake(0, 63, self.view.frame.size.width, 2);
    lineImg.clipsToBounds = YES;
    lineImg.userInteractionEnabled=YES;
    lineImg.backgroundColor = [UIColor colorWithRed:216.0/255.0 green:229.0/255.0 blue:241.0/255.0 alpha:1.0];
    [self.view addSubview:lineImg];
    
    addressTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 70, self.view.frame.size.width, 165) style:UITableViewStylePlain];
    addressTable.dataSource = self;
    addressTable.delegate = self;
    [addressTable setBackgroundColor:[UIColor clearColor]];
    addressTable.userInteractionEnabled=YES;
    addressTable.scrollEnabled = NO;
    [addressTable setAllowsSelection:YES];
    if ([addressTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [addressTable setSeparatorInset:UIEdgeInsetsZero];
    }
    [addressTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:addressTable];
    
    UIButton *addAddressBtn = [[UIButton alloc] initWithFrame:CGRectMake(50, 250, self.view.frame.size.width - 100, 50)];
//    [addAddressBtn setTitle:@"주소추가" forState:UIControlStateNormal];
    [addAddressBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addAddressBtn setBackgroundColor:[UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0]];
    addAddressBtn.layer.cornerRadius = 5;
    addAddressBtn.layer.borderColor = [UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0].CGColor;
    addAddressBtn.layer.borderWidth = 1;
    addAddressBtn.layer.masksToBounds = YES;
    [addAddressBtn addTarget:self action:@selector(addAddressBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addAddressBtn];
    
    NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
    if ([applang isEqualToString:@"ko"]) {
        titleLbl.text = ADDRESS_ADD_TITLE[0];
        [addAddressBtn setTitle:ADDRESS_ADD_ADDBUTTON[0] forState:UIControlStateNormal];
    }
    if ([applang isEqualToString:@"cn"]) {
        titleLbl.text = ADDRESS_ADD_TITLE[1];
        [addAddressBtn setTitle:ADDRESS_ADD_ADDBUTTON[1] forState:UIControlStateNormal];
    }
    
    [self getAddressList];
}

- (void)viewTapped:(UIGestureRecognizer *)gesture {
    [nameTxt resignFirstResponder];
    [phoneTxt resignFirstResponder];
    [addressTxt1 resignFirstResponder];
    [addressTxt2 resignFirstResponder];
}

- (void)getAddressList{
    [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
    [[GlobalPool sharedInstance].OAuth2Manager POST:LC_SHOP_GET_ADDRESS parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        
        pickerData = [NSMutableArray arrayWithArray:[responseObject objectForKey:@"result"]];
        
        for (int i = 0; i< pickerData.count; i++) {
            [addressArray addObject:[[pickerData objectAtIndex:i] objectForKey:@"name"]];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"Connection failed"];
    }];
}

- (void)addAddressBtnClicked{
    [nameTxt resignFirstResponder];
    [phoneTxt resignFirstResponder];
    [addressTxt1 resignFirstResponder];
    [addressTxt2 resignFirstResponder];
    
    if ([nameTxt.text  isEqual: @""] || [phoneTxt.text  isEqual: @""] || [addressTxt1.text  isEqual: @""] || [addressTxt2.text  isEqual: @""]) {
        NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
        if ([applang isEqualToString:@"ko"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"정확히 입력해주세요." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        if ([applang isEqualToString:@"cn"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请正确输入" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    else{
        NSString *userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"];
        NSString *sessionkey = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionkey"];
        NSString *destination = [NSString stringWithFormat:@"%@ %@", addressTxt1.text, addressTxt2.text];
        
        NSDictionary *parameters = @{@"userid":userid,
                                     @"name":nameTxt.text,
                                     @"phone":phoneTxt.text,
                                     @"destination":destination,
                                     @"areaid":[[pickerData objectAtIndex:selectId] objectForKey:@"id"],
                                     @"sessionkey":sessionkey
                                     };
        
        [SVProgressHUD showWithStatus:@"请稍后..." maskType:SVProgressHUDMaskTypeBlack];
        [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
        [[GlobalPool sharedInstance].OAuth2Manager POST:LC_SHOP_ADD_ADDRESS parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@",responseObject);
            
            NSString *status = [responseObject objectForKey:@"status"];
            if ([status intValue] == 200) {
                NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
                if ([applang isEqualToString:@"ko"]) {
                    [ProgressHUD showSuccess:@"정확히 추가되였습니다."];
                }
                if ([applang isEqualToString:@"cn"]) {
                    [ProgressHUD showSuccess:@"添加成功"];
                }
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refresh" object:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else if ([status intValue] == 1001) {
                NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:@"NO" forKey:@"isLoginState"];
                [defaults synchronize];
                [[AppDelegate sharedAppDelegate] runMain];
            }
            else{
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
//                [alert show];
            }
            
            [SVProgressHUD dismiss];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"Connection failed"];
        }];
    }
}

#pragma mark - tableViewDelegate
// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
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
    
    if (indexPath.row == 0) {
        UILabel *lbl_Name = [[UILabel alloc]init];
        [lbl_Name setFrame:CGRectMake(20, 5, 100, 30)];
        [lbl_Name setTextAlignment:NSTextAlignmentLeft];
        [lbl_Name setTextColor:[UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0]];
        [lbl_Name setBackgroundColor:[UIColor clearColor]];
        [lbl_Name setFont:[UIFont systemFontOfSize:15.0]];
//        lbl_Name.text = @"받을 사람이름";
        [cell.contentView addSubview:lbl_Name];
        
        nameTxt = [[UITextField alloc] initWithFrame:CGRectMake(120, 5, self.view.frame.size.width - 130, 30)];
        nameTxt.delegate = self;
//        nameTxt.placeholder = @"이름";
        nameTxt.backgroundColor = [UIColor clearColor];
        nameTxt.textColor = [UIColor blackColor];
        nameTxt.font = [UIFont systemFontOfSize:15];
        [nameTxt setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
        [cell.contentView addSubview:nameTxt];
        
        NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
        if ([applang isEqualToString:@"ko"]) {
            lbl_Name.text = ADDRESS_ADD_NAME[0];
            nameTxt.placeholder = ADDRESS_ADD_NAME_PLACE[0];
        }
        if ([applang isEqualToString:@"cn"]) {
            lbl_Name.text = ADDRESS_ADD_NAME[1];
            nameTxt.placeholder = ADDRESS_ADD_NAME_PLACE[1];
        }
    }
    
    if (indexPath.row == 1) {
        UILabel *lbl_Phone = [[UILabel alloc]init];
        [lbl_Phone setFrame:CGRectMake(20, 5, 100, 30)];
        [lbl_Phone setTextAlignment:NSTextAlignmentLeft];
        [lbl_Phone setTextColor:[UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0]];
        [lbl_Phone setBackgroundColor:[UIColor clearColor]];
        [lbl_Phone setFont:[UIFont systemFontOfSize:15.0]];
//        lbl_Phone.text = @"전화번호";
        [cell.contentView addSubview:lbl_Phone];
        
        phoneTxt = [[UITextField alloc] initWithFrame:CGRectMake(120, 5, self.view.frame.size.width - 130, 30)];
        phoneTxt.delegate = self;
//        phoneTxt.placeholder = @"전화번호";
        phoneTxt.backgroundColor = [UIColor clearColor];
        phoneTxt.textColor = [UIColor blackColor];
        phoneTxt.font = [UIFont systemFontOfSize:15];
        phoneTxt.keyboardType = UIKeyboardTypeNumberPad;
        [phoneTxt setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
        [cell.contentView addSubview:phoneTxt];
        
        NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
        if ([applang isEqualToString:@"ko"]) {
            lbl_Phone.text = ADDRESS_ADD_PHONE[0];
            phoneTxt.placeholder = ADDRESS_ADD_PHONE_PLACE[0];
        }
        if ([applang isEqualToString:@"cn"]) {
            lbl_Phone.text = ADDRESS_ADD_PHONE[1];
            phoneTxt.placeholder = ADDRESS_ADD_PHONE_PLACE[1];
        }
    }
    
    if (indexPath.row == 2) {
        UILabel *lbl_Address = [[UILabel alloc]init];
        [lbl_Address setFrame:CGRectMake(20, 5, 100, 30)];
        [lbl_Address setTextAlignment:NSTextAlignmentLeft];
        [lbl_Address setTextColor:[UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0]];
        [lbl_Address setBackgroundColor:[UIColor clearColor]];
        [lbl_Address setFont:[UIFont systemFontOfSize:15.0]];
//        lbl_Address.text = @"주소";
        [cell.contentView addSubview:lbl_Address];
        
        addressTxt1 = [[UITextField alloc] initWithFrame:CGRectMake(120, 5, 80, 30)];
//        addressTxt1.placeholder = @"성주소";
        addressTxt1.backgroundColor = [UIColor clearColor];
        addressTxt1.textColor = [UIColor blackColor];
        addressTxt1.font = [UIFont systemFontOfSize:15];
        [addressTxt1 setEnabled:NO];
        [addressTxt1 setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
        [cell.contentView addSubview:addressTxt1];
        
        NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
        if ([applang isEqualToString:@"ko"]) {
            lbl_Address.text = ADDRESS_ADD_ADDRESS[0];
            addressTxt1.placeholder = ADDRESS_ADD_SANG[0];
        }
        if ([applang isEqualToString:@"cn"]) {
            lbl_Address.text = ADDRESS_ADD_ADDRESS[1];
            addressTxt1.placeholder = ADDRESS_ADD_SANG[1];
        }
    }
    
    if (indexPath.row == 3) {
        addressTxt2 = [[UITextField alloc] initWithFrame:CGRectMake(120, 5, self.view.frame.size.width - 130, 30)];
        addressTxt2.delegate = self;
//        addressTxt2.placeholder = @"기본주소";
        addressTxt2.backgroundColor = [UIColor clearColor];
        addressTxt2.textColor = [UIColor blackColor];
        addressTxt2.font = [UIFont systemFontOfSize:15];
        [addressTxt2 setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
        [cell.contentView addSubview:addressTxt2];
        
        NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
        if ([applang isEqualToString:@"ko"]) {
            addressTxt2.placeholder = ADDRESS_ADD_MAINADDRESS[0];
        }
        if ([applang isEqualToString:@"cn"]) {
            addressTxt2.placeholder = ADDRESS_ADD_MAINADDRESS[1];
        }
    }
    
    UIImageView *lineImg =[UIImageView new];
    lineImg.frame=CGRectMake(20, 39, self.view.frame.size.width - 20, 1);
    lineImg.clipsToBounds = YES;
    lineImg.userInteractionEnabled=YES;
    lineImg.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0];
    [cell.contentView addSubview:lineImg];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //Height of the rows
    return 40;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 2) {
        [phoneTxt resignFirstResponder];
        
        float paddingTopBottom = 20.0f;
        float paddingLeftRight = 20.0f;
        
        CGPoint point = CGPointMake(paddingLeftRight, (self.navigationController.navigationBar.frame.size.height + paddingTopBottom) + paddingTopBottom);
        CGSize size = CGSizeMake((self.view.frame.size.width - (paddingLeftRight * 2)), self.view.frame.size.height - ((self.navigationController.navigationBar.frame.size.height + paddingTopBottom) + (paddingTopBottom * 2)));
        
        NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
        if ([applang isEqualToString:@"ko"]) {
            LPPopupListView *list = [[LPPopupListView alloc] initWithTitle:ADDRESS_ADD_SONG_SELECT[0] list:[self list] selectedIndexes:self.selectedIndexes point:point size:size multipleSelection:NO disableBackgroundInteraction:NO];
            list.delegate = self;
            
            [list showInView:self.navigationController.view animated:YES];
        }
        if ([applang isEqualToString:@"cn"]) {
            LPPopupListView *list = [[LPPopupListView alloc] initWithTitle:ADDRESS_ADD_SONG_SELECT[1] list:[self list] selectedIndexes:self.selectedIndexes point:point size:size multipleSelection:NO disableBackgroundInteraction:NO];
            list.delegate = self;
            
            [list showInView:self.navigationController.view animated:YES];
        }
    }
}

#pragma mark - LPPopupListViewDelegate

- (void)popupListView:(LPPopupListView *)popUpListView didSelectIndex:(NSInteger)index
{
    NSLog(@"popUpListView - didSelectIndex: %ld", (long)index);
    addressTxt1.text = [[self list] objectAtIndex:index];
}

- (void)popupListViewDidHide:(LPPopupListView *)popUpListView selectedIndexes:(NSIndexSet *)selectedIndexes
{
    NSLog(@"popupListViewDidHide - selectedIndexes: %@", selectedIndexes.description);
}

#pragma mark - Array List

- (NSArray *)list
{
    return [NSArray arrayWithArray:addressArray];
}

-(void)backBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)selectAddressBtnClicked{
    [UIView animateWithDuration:0.4 animations:^{
        addressSelect.frame = CGRectMake(0, self.view.frame.size.height - 200, self.view.frame.size.width, 200);
    }completion:^(BOOL finished){
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
