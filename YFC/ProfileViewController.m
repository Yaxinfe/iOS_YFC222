//
//  ProfileViewController.m
//  YFC
//
//  Created by iOS on 05/08/15.
//  Copyright (c) 2015 ming. All rights reserved.
//

#import "publicHeaders.h"

#import "ProfileViewController.h"

#import "NickNameViewController.h"
#import "PasswordViewController.h"

#import "AppDelegate.h"

#import "YFGIFImageView.h"
#import "UIImageView+PlayGIF.h"

@interface ProfileViewController ()<UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate, UIActionSheetDelegate>
{
    AppDelegate *delegate;
    UITableView *profileTable;
    UIImageView *profileImg;
    
    UIButton *finish_btn;
    
    YFGIFImageView *gifView_Load;
    
    UILabel *titleLbl;
}
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    backImageView.image = [UIImage imageNamed:@"settingBack.png"];
    [self.view addSubview:backImageView];
    
    UIButton *back_btn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.origin.x , self.view.frame.origin.y + 25, 27, 30)];
    [back_btn setImage:[UIImage imageNamed:@"backBtn.png"] forState:UIControlStateNormal];
    [back_btn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [back_btn setTintColor:[UIColor lightGrayColor]];
    back_btn.alpha = 1.0;
    back_btn.transform = CGAffineTransformMakeTranslation(10, 0);
    [self.view addSubview:back_btn];
    
    titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 100, 30, 200, 24)];
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
    
    profileTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 65, self.view.frame.size.width, 230) style:UITableViewStylePlain];
    profileTable.dataSource = self;
    profileTable.delegate = self;
    profileTable.scrollEnabled = NO;
    [profileTable setBackgroundColor:[UIColor clearColor]];
    profileTable.userInteractionEnabled=YES;
    [profileTable setAllowsSelection:YES];
    if ([profileTable respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [profileTable setSeparatorInset:UIEdgeInsetsZero];
        
    }
    [profileTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:profileTable];
    
    finish_btn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 180, 300, 180, 40)];
    [finish_btn setBackgroundImage:[UIImage imageNamed:@"logoutBtn.png"] forState:UIControlStateNormal];
    [finish_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [finish_btn addTarget:self action:@selector(finishBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [finish_btn setTintColor:[UIColor lightGrayColor]];
    finish_btn.alpha = 1.0;
    finish_btn.transform = CGAffineTransformMakeTranslation(10, 0);
    [self.view addSubview:finish_btn];
    
    NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
    if ([applang isEqualToString:@"ko"]) {
        [finish_btn setTitle:PROFILE_LOGOUT_BUTTON[0] forState:UIControlStateNormal];
    }
    if ([applang isEqualToString:@"cn"]) {
        [finish_btn setTitle:PROFILE_LOGOUT_BUTTON[1] forState:UIControlStateNormal];
    }
    
    NSData *gifData_Load = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Loading.gif" ofType:nil]];
    gifView_Load = [[YFGIFImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 50, self.view.frame.size.height/2 - 50, 100, 100)];
    gifView_Load.backgroundColor = [UIColor clearColor];
    gifView_Load.gifData = gifData_Load;
    [self.view addSubview:gifView_Load];
    gifView_Load.hidden = YES;
    gifView_Load.userInteractionEnabled = YES;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
    if ([applang isEqualToString:@"ko"]) {
        titleLbl.text = PROFILE_TITLE[0];
    }
    if ([applang isEqualToString:@"cn"]) {
        titleLbl.text = PROFILE_TITLE[1];
    }
    
    [profileTable reloadData];
}

#pragma mark - tableViewDelegate
// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
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
        UILabel *lbl_Title = [[UILabel alloc]init];
        [lbl_Title setFrame:CGRectMake(30, 10, self.view.frame.size.width - 90, 50)];
        [lbl_Title setTextAlignment:NSTextAlignmentLeft];
        [lbl_Title setTextColor:[UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0]];
        [lbl_Title setBackgroundColor:[UIColor clearColor]];
        [lbl_Title setFont:[UIFont boldSystemFontOfSize:18.0]];
        [cell.contentView addSubview:lbl_Title];
        
        NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
        if ([applang isEqualToString:@"ko"]) {
            lbl_Title.text = PROFILE_CHANGE_NAME[0];
        }
        if ([applang isEqualToString:@"cn"]) {
            lbl_Title.text = PROFILE_CHANGE_NAME[1];
        }
        
        profileImg = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 90, 5, 60, 60)];
        profileImg.backgroundColor = [UIColor blackColor];
        NSString *userphotoURL = [[NSUserDefaults standardUserDefaults] objectForKey:@"userphoto"];
        [profileImg setImageWithURL:[NSURL URLWithString:userphotoURL]];
        [cell.contentView addSubview:profileImg];
        
        UIImageView *lineImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 69, self.view.frame.size.width - 20, 1)];
        lineImg.backgroundColor = [UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0];
        [cell.contentView addSubview:lineImg];
    }
    
    if (indexPath.row == 1) {
        UILabel *lbl_Title = [[UILabel alloc]init];
        [lbl_Title setFrame:CGRectMake(30, 10, 60, 50)];
        [lbl_Title setTextAlignment:NSTextAlignmentLeft];
        [lbl_Title setTextColor:[UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0]];
        [lbl_Title setBackgroundColor:[UIColor clearColor]];
        [lbl_Title setFont:[UIFont boldSystemFontOfSize:18.0]];
        [cell.contentView addSubview:lbl_Title];
        
        NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
        if ([applang isEqualToString:@"ko"]) {
            lbl_Title.text = PROFILE_NICKNAME[0];
        }
        if ([applang isEqualToString:@"cn"]) {
            lbl_Title.text = PROFILE_NICKNAME[1];
        }
        
        UILabel *lbl_Nickname = [[UILabel alloc]init];
        [lbl_Nickname setFrame:CGRectMake(80, 10, self.view.frame.size.width - 125, 50)];
        [lbl_Nickname setTextAlignment:NSTextAlignmentRight];
        [lbl_Nickname setTextColor:[UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0]];
        [lbl_Nickname setBackgroundColor:[UIColor clearColor]];
        [lbl_Nickname setFont:[UIFont boldSystemFontOfSize:18.0]];
        NSString *nickName = [[NSUserDefaults standardUserDefaults] objectForKey:@"nickname"];
        lbl_Nickname.text = nickName;
        [cell.contentView addSubview:lbl_Nickname];
        
        UIImageView *setView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 35, 25, 13, 20)];
        setView.image = [UIImage imageNamed:@"setting1Btn.png"];
        [cell.contentView addSubview:setView];
        
        UIImageView *lineImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 69, self.view.frame.size.width - 20, 1)];
        lineImg.backgroundColor = [UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0];
        [cell.contentView addSubview:lineImg];
    }
    
    if (indexPath.row == 2) {
        UILabel *lbl_Title = [[UILabel alloc]init];
        [lbl_Title setFrame:CGRectMake(30, 10, 90, 50)];
        [lbl_Title setTextAlignment:NSTextAlignmentLeft];
        [lbl_Title setTextColor:[UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0]];
        [lbl_Title setBackgroundColor:[UIColor clearColor]];
        [lbl_Title setFont:[UIFont boldSystemFontOfSize:18.0]];
        [cell.contentView addSubview:lbl_Title];
        
        NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
        if ([applang isEqualToString:@"ko"]) {
            lbl_Title.text = PROFILE_USERID[0];
        }
        if ([applang isEqualToString:@"cn"]) {
            lbl_Title.text = PROFILE_USERID[1];
        }
        
        UILabel *lbl_username = [[UILabel alloc]init];
        [lbl_username setFrame:CGRectMake(120, 10, self.view.frame.size.width - 165, 50)];
        [lbl_username setTextAlignment:NSTextAlignmentRight];
        [lbl_username setTextColor:[UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0]];
        [lbl_username setBackgroundColor:[UIColor clearColor]];
        [lbl_username setFont:[UIFont boldSystemFontOfSize:18.0]];
        NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
        lbl_username.text = username;
        [cell.contentView addSubview:lbl_username];
        
        UIImageView *lineImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 69, self.view.frame.size.width - 20, 1)];
        lineImg.backgroundColor = [UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0];
        [cell.contentView addSubview:lineImg];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //Height of the rows
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
        if ([applang isEqualToString:@"ko"]) {
            UIActionSheet *actionSheet_popupQuery = [[UIActionSheet alloc] initWithTitle:@"Select a picture from" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Photo Library", @"Camera", nil];
            actionSheet_popupQuery.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
            [actionSheet_popupQuery showInView:self.view];
        }
        if ([applang isEqualToString:@"cn"]) {
            UIActionSheet *actionSheet_popupQuery = [[UIActionSheet alloc] initWithTitle:@"Select a picture from" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"图片库", @"拍照", nil];
            actionSheet_popupQuery.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
            [actionSheet_popupQuery showInView:self.view];
        }
        
    }
    
    if (indexPath.row == 1) {
        NSString *ischeckedNickname = [[NSUserDefaults standardUserDefaults] objectForKey:@"ischeckedNickname"];
        if ([ischeckedNickname isEqualToString:@"NO"]) {
            NickNameViewController *profile_view = [[NickNameViewController alloc] init];
            [self.navigationController pushViewController:profile_view animated:YES];
        }
        else{
            NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
            if ([applang isEqualToString:@"ko"]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"이미 한번 변경하였습니다." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
            if ([applang isEqualToString:@"cn"]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"通知" message:@"已更改过用户名" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                [alert show];
            }
        }
    }
    
}

#pragma mark - ACTION SHEET DELEGATE
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 0)
    {
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
        {
            UIImagePickerController*imgPicker = [[UIImagePickerController alloc] init];
            UIColor* color = [UIColor colorWithRed:46.0/255 green:127.0/255 blue:244.0/255 alpha:1];
            [imgPicker.navigationBar setTintColor:color];
            imgPicker.delegate = self;
            imgPicker.allowsEditing = YES;
            imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imgPicker.modalPresentationStyle = UIModalPresentationCurrentContext;
            [self presentViewController:imgPicker animated:NO completion:Nil];
        }
    }
    else if(buttonIndex == 1)
    {
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            UIImagePickerController*imgPicker = [[UIImagePickerController alloc] init];
            UIColor* color = [UIColor colorWithRed:46.0/255 green:127.0/255 blue:244.0/255 alpha:1];
            [imgPicker.navigationBar setTintColor:color];
            imgPicker.delegate = self;
            imgPicker.allowsEditing = YES;
            imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            imgPicker.modalPresentationStyle = UIModalPresentationCurrentContext;
            [self presentViewController:imgPicker animated:NO completion:Nil];
        }
        else
        {
//            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Device does not support camera" delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [alert show];
        }
    }
}

#pragma mark - Image Picker Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    profileImg.image = image;
    
    NSData *photoData = UIImageJPEGRepresentation(image, 0.3);
    NSString *userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"];
    NSString *sessionkey = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionkey"];
    
    NSDictionary *parameters = @{@"userid":userid,
                                 @"sessionkey":sessionkey
                                 };
    
    [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
    [[GlobalPool sharedInstance].OAuth2Manager POST:LC_SETTINGS_CHANGEIMAGE parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (image) {
            [formData appendPartWithFileData:photoData name:@"photo" fileName:@"photo.jpg" mimeType:@"image/jpeg"];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        
        NSString *status = [responseObject objectForKey:@"status"];
        if ([status intValue] == 200) {
            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
            NSString *userPhoto = [[responseObject objectForKey:@"userinfo"] objectForKey:@"photourl"];
            [defaults setObject:userPhoto forKey:@"userphoto"];
            [defaults synchronize];
            
            [profileTable reloadData];
        }
        else if ([status intValue] == 1001){
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
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)backBtnClicked{
    [gifView_Load removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)finishBtnClicked{
    finish_btn.enabled = NO;
    gifView_Load.hidden = NO;
    [gifView_Load startGIF];
    
    NSString *userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"];
    NSString *sessionkey = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionkey"];
    
    NSDictionary *parameters = @{@"userid":userid,
                                 @"sessionkey":sessionkey
                                 };
    
    [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
    [[GlobalPool sharedInstance].OAuth2Manager POST:LC_SIGNOUT parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        
        NSString *status = [responseObject objectForKey:@"status"];
        if ([status intValue] == 200) {
            gifView_Load.hidden = YES;
            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:@"NO" forKey:@"isLoginState"];
            [defaults synchronize];
            [[AppDelegate sharedAppDelegate] runMain];
            [ProgressHUD showSuccess:@"已退出"];
        }
        else{

        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"Connection failed"];
    }];
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
