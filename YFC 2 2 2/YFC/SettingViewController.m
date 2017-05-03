//
//  SettingViewController.m
//  YFC
//
//  Created by topone on 7/17/15.
//  Copyright (c) 2015 ming. All rights reserved.
//

#import "publicHeaders.h"

#import "SettingViewController.h"
#import "ProfileViewController.h"

#import "TheSidebarController.h"
#import "CenterViewController.h"

#import "FirstViewController.h"

@interface SettingViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *settingTable;
    
    UISegmentedControl *changeSeg_Lang;
    UISwitch           *switch_ctrl;
    
    UILabel *titleLbl;
}
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    backImageView.image = [UIImage imageNamed:@"settingBack.png"];
    [self.view addSubview:backImageView];
    
    UIButton *back_btn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + 23, 36, 33)];
    [back_btn setImage:[UIImage imageNamed:@"listIcon.png"] forState:UIControlStateNormal];
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
    
    NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
    if ([applang isEqualToString:@"ko"]) {
        titleLbl.text = SETTING_TITLE[0];
    }
    if ([applang isEqualToString:@"cn"]) {
        titleLbl.text = SETTING_TITLE[1];
    }
    
    settingTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 65, self.view.frame.size.width, self.view.frame.size.height - 65) style:UITableViewStylePlain];
    settingTable.dataSource = self;
    settingTable.delegate = self;
    settingTable.scrollEnabled = NO;
    [settingTable setBackgroundColor:[UIColor clearColor]];
    settingTable.userInteractionEnabled=YES;
    [settingTable setAllowsSelection:YES];
    if ([settingTable respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [settingTable setSeparatorInset:UIEdgeInsetsZero];
        
    }
    [settingTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:settingTable];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLang) name:@"menuLangChange" object:nil];
}

- (void)changeLang{
    NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
    if ([applang isEqualToString:@"ko"]) {
        titleLbl.text = SETTING_TITLE[0];
    }
    if ([applang isEqualToString:@"cn"]) {
        titleLbl.text = SETTING_TITLE[1];
    }
    
    [settingTable reloadData];
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
        [lbl_Title setFrame:CGRectMake(30, 10, self.view.frame.size.width - 180, 50)];
        [lbl_Title setTextAlignment:NSTextAlignmentLeft];
        [lbl_Title setTextColor:[UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0]];
        [lbl_Title setBackgroundColor:[UIColor clearColor]];
        [lbl_Title setFont:[UIFont boldSystemFontOfSize:18.0]];
        
        NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
        if ([applang isEqualToString:@"ko"]) {
            lbl_Title.text = SETTING_PROFILE[0];
        }
        if ([applang isEqualToString:@"cn"]) {
            lbl_Title.text = SETTING_PROFILE[1];
        }
        
        [cell.contentView addSubview:lbl_Title];
        
        UIImageView *setView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 35, 25, 13, 20)];
        setView.image = [UIImage imageNamed:@"setting1Btn.png"];
        [cell.contentView addSubview:setView];
        
        UIImageView *lineImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 69, self.view.frame.size.width - 20, 1)];
        lineImg.backgroundColor = [UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0];
        [cell.contentView addSubview:lineImg];
    }
    
    if (indexPath.row == 1) {
        UILabel *lbl_Title = [[UILabel alloc]init];
        [lbl_Title setFrame:CGRectMake(30, 10, self.view.frame.size.width - 180, 50)];
        [lbl_Title setTextAlignment:NSTextAlignmentLeft];
        [lbl_Title setTextColor:[UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0]];
        [lbl_Title setBackgroundColor:[UIColor clearColor]];
        [lbl_Title setFont:[UIFont boldSystemFontOfSize:18.0]];
        [cell.contentView addSubview:lbl_Title];
        
        NSArray *mySegments = [[NSArray alloc] initWithObjects: @"한 글",
                               @"汉 语", nil];
        changeSeg_Lang = [[UISegmentedControl alloc] initWithItems:mySegments];
        changeSeg_Lang.frame = CGRectMake(self.view.frame.size.width - 170, 18, 150, 40);
        changeSeg_Lang.tintColor = [UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0];
        [changeSeg_Lang addTarget:self action:@selector(valueChanged:) forControlEvents: UIControlEventValueChanged];
        UIFont *font = [UIFont boldSystemFontOfSize:18.0f];
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                               forKey:NSFontAttributeName];
        [changeSeg_Lang setTitleTextAttributes:attributes
                                      forState:UIControlStateNormal];
        [cell.contentView addSubview:changeSeg_Lang];
        
        NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
        if ([applang isEqualToString:@"ko"]) {
            lbl_Title.text = SETTING_LANG[0];
            changeSeg_Lang.selectedSegmentIndex = 0;
        }
        if ([applang isEqualToString:@"cn"]) {
            lbl_Title.text = SETTING_LANG[1];
            changeSeg_Lang.selectedSegmentIndex = 1;
        }
        
        UIImageView *lineImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 69, self.view.frame.size.width - 20, 1)];
        lineImg.backgroundColor = [UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0];
        [cell.contentView addSubview:lineImg];
    }
    
    if (indexPath.row == 2) {
        UILabel *lbl_Title = [[UILabel alloc]init];
        [lbl_Title setFrame:CGRectMake(30, 10, self.view.frame.size.width - 180, 50)];
        [lbl_Title setTextAlignment:NSTextAlignmentLeft];
        [lbl_Title setTextColor:[UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0]];
        [lbl_Title setBackgroundColor:[UIColor clearColor]];
        [lbl_Title setFont:[UIFont boldSystemFontOfSize:18.0]];
        
        NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
        if ([applang isEqualToString:@"ko"]) {
            lbl_Title.text = SETTING_CENTER[0];
        }
        if ([applang isEqualToString:@"cn"]) {
            lbl_Title.text = SETTING_CENTER[1];
        }
        
        [cell.contentView addSubview:lbl_Title];
        
        UIImageView *setView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 35, 25, 13, 20)];
        setView.image = [UIImage imageNamed:@"setting1Btn.png"];
        [cell.contentView addSubview:setView];
        
        UIImageView *lineImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 69, self.view.frame.size.width - 20, 1)];
        lineImg.backgroundColor = [UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0];
        [cell.contentView addSubview:lineImg];
    }
    
    return cell;
}

- (void)valueChanged:(UISegmentedControl *)segment {
    if(segment.selectedSegmentIndex == 0) {
        [[NSUserDefaults standardUserDefaults] setObject:@"ko" forKey:@"applanguage"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"menuLangChange" object:nil];
    }else if(segment.selectedSegmentIndex == 1){
        [[NSUserDefaults standardUserDefaults] setObject:@"cn" forKey:@"applanguage"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"menuLangChange" object:nil];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //Height of the rows
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.row == 0) {
        NSString *isFirstLogin = [[NSUserDefaults standardUserDefaults] objectForKey:@"isLoginState"];
        if ([isFirstLogin isEqualToString:@"NO"]) {
//            [[AppDelegate sharedAppDelegate] runLogin];
            FirstViewController *loginView = [[FirstViewController alloc] init];
            UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:loginView];
            navi.navigationBarHidden = YES;
            navi.modalPresentationStyle = UIModalPresentationCurrentContext;
            [self presentViewController:navi animated:YES completion:nil];
        }
        else{
            ProfileViewController *profile_view = [[ProfileViewController alloc] init];
            [self.navigationController pushViewController:profile_view animated:YES];
        }
    }
    
    if (indexPath.row == 2) {
        CenterViewController *profile_view = [[CenterViewController alloc] init];
        [self.navigationController pushViewController:profile_view animated:YES];
    }
}

- (void)backBtnClicked{
//    [self.navigationController popViewControllerAnimated:YES];
    if(self.sidebarController.sidebarIsPresenting)
    {
        [self.sidebarController dismissSidebarViewController];
    }
    else
    {
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
