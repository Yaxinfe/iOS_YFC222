//
//  ProductCommentViewController.m
//  YFC
//
//  Created by topone on 9/20/15.
//  Copyright (c) 2015 ming. All rights reserved.
//
#import "publicHeaders.h"
#import "ProductCommentViewController.h"
#import "FirstViewController.h"

@interface ProductCommentViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    NSMutableArray *commentArray;
    UITableView    *commentTable;
    
    UIView *commentView;
    UITextField *sendText;
    
    NSString *buyID;
    NSString *leaveflag;
    
    UIButton *sendBtn;
}
@end

@implementation ProductCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    
    commentTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 65, self.view.frame.size.width, self.view.frame.size.height - 65) style:UITableViewStylePlain];
    commentTable.dataSource = self;
    commentTable.delegate = self;
    [commentTable setBackgroundColor:[UIColor clearColor]];
    commentTable.userInteractionEnabled=YES;
    [commentTable setAllowsSelection:YES];
    if ([commentTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [commentTable setSeparatorInset:UIEdgeInsetsZero];
    }
    [commentTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:commentTable];
    
    //CommentView
    commentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 51, self.view.frame.size.width, 50)];
    commentView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *lineImg1 = [[UIImageView alloc] initWithFrame:CGRectMake(20, 5, commentView.frame.size.width - 120, 40)];
    lineImg1.backgroundColor = [UIColor clearColor];
    lineImg1.layer.cornerRadius = 5;
    lineImg1.layer.borderColor = [UIColor lightGrayColor].CGColor;
    lineImg1.layer.borderWidth = 1;
    lineImg1.layer.masksToBounds = YES;
    [commentView addSubview:lineImg1];
    
    sendText = [[UITextField alloc] initWithFrame:CGRectMake(25, 8, commentView.frame.size.width - 130, 34)];
    sendText.backgroundColor = [UIColor whiteColor];
    sendText.textColor = [UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0];
    sendText.font = [UIFont systemFontOfSize:15.0];
    sendText.placeholder = @"Comment";
    sendText.keyboardType = UIKeyboardTypeDefault;
    sendText.delegate = self;
    [sendText setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [commentView addSubview:sendText];
    
    sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(commentView.frame.size.width - 100, 5, 80, 40)];
    [sendBtn setTitle:@"전 송" forState:UIControlStateNormal];
    sendBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [sendBtn setTitleColor:[UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(sendBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [sendBtn setTintColor:[UIColor lightGrayColor]];
    sendBtn.alpha = 1.0;
    sendBtn.transform = CGAffineTransformMakeTranslation(10, 0);
    [commentView addSubview:sendBtn];
    
    NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
    if ([applang isEqualToString:@"ko"]) {
        titleLbl.text = @"평 가";
        [sendBtn setTitle:NEWS_DETAIL_SEND_BUTTON[0] forState:UIControlStateNormal];
        sendText.placeholder = NEWS_DETAIL_COMMENT[0];
    }
    if ([applang isEqualToString:@"cn"]) {
        titleLbl.text = @"商品评价";
        [sendBtn setTitle:NEWS_DETAIL_SEND_BUTTON[1] forState:UIControlStateNormal];
        sendText.placeholder = NEWS_DETAIL_COMMENT[1];
    }
    
    commentView.layer.cornerRadius = 5;
    commentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    commentView.layer.borderWidth = 1;
    commentView.layer.masksToBounds = YES;
    
    [self.view addSubview:commentView];
    [self getComments];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(commentkeyboardDidShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(commentkeyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

-(void)commentkeyboardDidShow:(NSNotification *)notification {
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    //    int height = MIN(keyboardSize.height,keyboardSize.width);
    
    [UIView animateWithDuration:0.2 animations:^{
        commentView.frame = CGRectMake(0, self.view.frame.size.height - keyboardSize.height - 50, self.view.frame.size.width, 50);
    }completion:^(BOOL finished){
        
    }];
}

-(void)commentkeyboardWillHide:(NSNotification *)notification {
    [UIView animateWithDuration:0.2 animations:^{
        commentView.frame = CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50);
    }completion:^(BOOL finished){
        
    }];
}

- (void)getComments{
    NSString *isFirstLogin = [[NSUserDefaults standardUserDefaults] objectForKey:@"isLoginState"];
    if ([isFirstLogin isEqualToString:@"NO"]) {
        NSString *sessionkey = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionkey"];
        
        NSDictionary *parameters = @{@"userid":@"0",
                                     @"pid":self.productId,
                                     @"sessionkey":sessionkey,
                                     @"lastid":@"0"
                                     };
        
        [SVProgressHUD showWithStatus:@"请稍后..." maskType:SVProgressHUDMaskTypeBlack];
        
        [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
        [[GlobalPool sharedInstance].OAuth2Manager POST:LC_SHOP_PRODUCT_COMMENT parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@",responseObject);
            [SVProgressHUD dismiss];
            
            NSString *status = [responseObject objectForKey:@"status"];
            
            if ([status intValue] == 200){
                buyID = [responseObject objectForKey:@"buyid"];
                leaveflag = [responseObject objectForKey:@"leaveflag"];
                
                if ([leaveflag intValue] != 0) {
                    [sendBtn setTitle:@"이미함" forState:UIControlStateNormal];
                    [sendBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                    sendBtn.enabled = NO;
                }
                
                commentArray = [NSMutableArray arrayWithArray:[responseObject objectForKey:@"result"]];
                [commentTable reloadData];
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
    else{
        NSString *userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"];
        NSString *sessionkey = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionkey"];
        
        NSDictionary *parameters = @{@"userid":userid,
                                     @"pid":self.productId,
                                     @"sessionkey":sessionkey,
                                     @"lastid":@"0"
                                     };
        
        [SVProgressHUD showWithStatus:@"请稍后..." maskType:SVProgressHUDMaskTypeBlack];
        
        [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
        [[GlobalPool sharedInstance].OAuth2Manager POST:LC_SHOP_PRODUCT_COMMENT parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@",responseObject);
            [SVProgressHUD dismiss];
            
            NSString *status = [responseObject objectForKey:@"status"];
            
            if ([status intValue] == 200){
                buyID = [responseObject objectForKey:@"buyid"];
                leaveflag = [responseObject objectForKey:@"leaveflag"];
                
                if ([leaveflag intValue] != 0) {
                    [sendBtn setTitle:@"이미함" forState:UIControlStateNormal];
                    [sendBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                    sendBtn.enabled = NO;
                }
                
                commentArray = [NSMutableArray arrayWithArray:[responseObject objectForKey:@"result"]];
                [commentTable reloadData];
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
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [sendText resignFirstResponder];
    
    return YES;
}

- (void)sendBtnClicked{
    [sendText resignFirstResponder];
    
    if ([buyID intValue] > 0) {
        NSString *userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"];
        NSString *sessionkey = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionkey"];
        
        NSDictionary *parameters = @{@"userid":userid,
                                     @"buyid":buyID,
                                     @"comment":sendText.text,
                                     @"pid":self.productId,
                                     @"sessionkey":sessionkey,
                                     @"lastid":@"0"
                                     };
        [SVProgressHUD showWithStatus:@"请稍后..." maskType:SVProgressHUDMaskTypeBlack];
        
        [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
        [[GlobalPool sharedInstance].OAuth2Manager POST:LC_SHOP_LEAVE_COMMENT parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@",responseObject);
            [SVProgressHUD dismiss];
            
            sendText.text = @"";
            
            NSString *status = [responseObject objectForKey:@"status"];
            
            if ([status intValue] == 200){
                [self getComments];
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
    else{
        //        NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
        //        if ([applang isEqualToString:@"ko"]) {
        //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"주의" message:@"只能对购买过的商品进行评价" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        //            [alert show];
        //        }
        //        if ([applang isEqualToString:@"cn"]) {
        //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注意" message:@"只能对购买过的商品进行评价" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        //            [alert show];
        //        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注意" message:@"只能对购买过的商品进行评价" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        sendText.text = @"";
    }
    
}

#pragma mark - tableViewDelegate
// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return commentArray.count;
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
    
    UIImageView *image =[UIImageView new];
    image.frame=CGRectMake(10, 5, 70, 70);
    image.clipsToBounds = YES;
    image.userInteractionEnabled=YES;
    image.backgroundColor = [UIColor blackColor];
    image.contentMode = UIViewContentModeScaleToFill;
    [cell.contentView addSubview:image];
    
    UILabel *lbl_NickName = [[UILabel alloc]init];
    [lbl_NickName setFrame:CGRectMake(90, 5, self.view.frame.size.width - 95, 20)];
    [lbl_NickName setTextAlignment:NSTextAlignmentLeft];
    [lbl_NickName setTextColor:[UIColor colorWithRed:65.0/255.0 green:111.0/255.0 blue:155.0/255.0 alpha:1.0]];
    [lbl_NickName setBackgroundColor:[UIColor clearColor]];
    [lbl_NickName setFont:[UIFont boldSystemFontOfSize:16.0]];
    lbl_NickName.numberOfLines = 1;
    [cell.contentView addSubview:lbl_NickName];
    
    UILabel *lbl_Content = [[UILabel alloc]init];
    [lbl_Content setFrame:CGRectMake(90, 30, self.view.frame.size.width - 95, 45)];
    [lbl_Content setTextAlignment:NSTextAlignmentLeft];
    [lbl_Content setTextColor:[UIColor blackColor]];
    [lbl_Content setBackgroundColor:[UIColor clearColor]];
    [lbl_Content setFont:[UIFont systemFontOfSize:14.0]];
    lbl_Content.numberOfLines = 3;
    [cell.contentView addSubview:lbl_Content];
    
    UIImageView *cellLineImg1 =[UIImageView new];
    cellLineImg1.frame=CGRectMake(90, 79, self.view.frame.size.width - 92, 1);
    cellLineImg1.clipsToBounds = YES;
    cellLineImg1.userInteractionEnabled=YES;
    cellLineImg1.backgroundColor = [UIColor colorWithRed:215.0/255.0 green:223.0/255.0 blue:233.0/255.0 alpha:1.0];
    [cell.contentView addSubview:cellLineImg1];
    
    lbl_Content.text = [[commentArray objectAtIndex:indexPath.row] objectForKey:@"comment"];
    lbl_NickName.text = [[commentArray objectAtIndex:indexPath.row] objectForKey:@"nickname"];
    NSString *path = [[commentArray objectAtIndex:indexPath.row] objectForKey:@"photourl"];
    [image setImageWithURL:[NSURL URLWithString:path]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //Height of the rows
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)backBtnClicked{
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
