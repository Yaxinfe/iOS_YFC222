//
//  RecordViewController.m
//  YFC
//
//  Created by topone on 9/3/15.
//  Copyright (c) 2015 ming. All rights reserved.
//

#import "RecordViewController.h"

#import "YSLContainerViewController.h"

#import "GumaeRecordViewController.h"
#import "SaveViewController.h"
#import "BaedalViewController.h"

#import "AppLanguage.h"

@interface RecordViewController ()<YSLContainerViewControllerDelegate>
{
    UILabel *titleLbl;
}
@end

@implementation RecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    // SetUp ViewControllers
    GumaeRecordViewController *gumaeView = [[GumaeRecordViewController alloc] init];
//    gumaeView.title = @"购买记录";
    
    BaedalViewController *baedalView = [[BaedalViewController alloc] init];
//    baedalView.title = @"配送信息";
    
    SaveViewController *saveView = [[SaveViewController alloc] init];
//    saveView.title = @"￼收货地址管理";
    
    NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
    if ([applang isEqualToString:@"ko"]) {
        baedalView.title = INFO_PROCESS[0];
        gumaeView.title = INFO_FINISH[0];
        saveView.title = INFO_ADDRESS[0];
    }
    if ([applang isEqualToString:@"cn"]) {
        baedalView.title = INFO_PROCESS[1];
        gumaeView.title = INFO_FINISH[1];
        saveView.title = INFO_ADDRESS[1];
    }
    
    // ContainerView
    float statusHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    float navigationHeight = self.navigationController.navigationBar.frame.size.height;
    
    YSLContainerViewController *containerVC = [[YSLContainerViewController alloc] initWithControllers:@[baedalView, gumaeView,saveView]
                                                                                         topBarHeight:statusHeight + navigationHeight
                                                                                 parentViewController:self];
    containerVC.delegate = self;
    containerVC.menuItemFont = [UIFont systemFontOfSize:14];
    
    [self.view addSubview:containerVC.view];
    
    UIButton *back_btn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.origin.x , self.view.frame.origin.y + 25, 27, 30)];
    [back_btn setImage:[UIImage imageNamed:@"backBtn.png"] forState:UIControlStateNormal];
    [back_btn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [back_btn setTintColor:[UIColor lightGrayColor]];
    back_btn.alpha = 1.0;
    back_btn.transform = CGAffineTransformMakeTranslation(10, 0);
    [self.view addSubview:back_btn];
    
    titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 100, 30, 200, 24)];
//    titleLbl.text = @"购物信息";
    titleLbl.font = [UIFont boldSystemFontOfSize:22.0];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.textColor = [UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0];
    [self.view addSubview:titleLbl];
    
    if ([applang isEqualToString:@"ko"]) {
        titleLbl.text = INFO_TITLE[0];
    }
    if ([applang isEqualToString:@"cn"]) {
        titleLbl.text = INFO_TITLE[1];
    }
    
    UIImageView *lineImg =[UIImageView new];
    lineImg.frame=CGRectMake(0, 63, self.view.frame.size.width, 2);
    lineImg.clipsToBounds = YES;
    lineImg.userInteractionEnabled=YES;
    lineImg.backgroundColor = [UIColor colorWithRed:216.0/255.0 green:229.0/255.0 blue:241.0/255.0 alpha:1.0];
    [self.view addSubview:lineImg];
}

#pragma mark -- YSLContainerViewControllerDelegate
- (void)containerViewItemIndex:(NSInteger)index currentController:(UIViewController *)controller
{
    [controller viewWillAppear:YES];
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
