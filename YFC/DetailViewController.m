//
//  DetailViewController.m
//  YFC
//
//  Created by topone on 9/3/15.
//  Copyright (c) 2015 ming. All rights reserved.
//

#import "publicHeaders.h"
#import "DetailViewController.h"
#import "BasketViewController.h"
#import "RecordViewController.h"
#import "FirstViewController.h"

#import "YSLContainerViewController.h"
#import "ProductDetailViewController.h"
#import "ProductUrlViewController.h"
#import "AdsDetailViewController.h"

@interface DetailViewController ()<YSLContainerViewControllerDelegate>
{
    UILabel *basketLbl;
    UIView *bannerView;
    UIImageView *bannerImg;
    
    UILabel *titleLbl;
    
    NSMutableArray *adsArray;
    NSString *adsDetailUrl;
    NSString *adsDetailTitle;
}
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    adsArray = [[NSMutableArray alloc] init];
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    // SetUp ViewControllers
    ProductDetailViewController *allVC = [[ProductDetailViewController alloc] init];
    allVC.dProductId = self.productId;
//    allVC.title = @"基本信息";
    
    ProductUrlViewController *matchVC = [[ProductUrlViewController alloc] init];
    matchVC.dProductId = self.productId;
//    matchVC.title = @"商品详情";
    
    NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
    if ([applang isEqualToString:@"ko"]) {
        allVC.title = PRODUCT_DETAIL_DETAIL[0];
        matchVC.title = PRODUCT_DETAIL_URL[0];
    }
    if ([applang isEqualToString:@"cn"]) {
        allVC.title = PRODUCT_DETAIL_DETAIL[1];
        matchVC.title = PRODUCT_DETAIL_URL[1];
    }
    
    // ContainerView
    float statusHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    float navigationHeight = self.navigationController.navigationBar.frame.size.height;
    
    YSLContainerViewController *containerVC = [[YSLContainerViewController alloc] initWithControllers:@[allVC,matchVC]
                                                                                         topBarHeight:statusHeight + navigationHeight
                                                                                 parentViewController:self];
    containerVC.delegate = self;
    containerVC.menuItemFont = [UIFont systemFontOfSize:16];
    
    [self.view addSubview:containerVC.view];
    
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
    
    if ([applang isEqualToString:@"ko"]) {
        titleLbl.text = PRODUCT_DETAIL_TITLE[0];
    }
    if ([applang isEqualToString:@"cn"]) {
        titleLbl.text = PRODUCT_DETAIL_TITLE[1];
    }
    
    UIButton *basket_btn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 55, self.view.frame.origin.y + 27, 32, 30)];
    [basket_btn setImage:[UIImage imageNamed:@"basketBtn.png"] forState:UIControlStateNormal];
    [basket_btn addTarget:self action:@selector(basketBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [basket_btn setTintColor:[UIColor lightGrayColor]];
    basket_btn.alpha = 1.0;
    basket_btn.transform = CGAffineTransformMakeTranslation(10, 0);
    [self.view addSubview:basket_btn];
    
    UIButton *dingdan_btn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 90, self.view.frame.origin.y + 27, 32, 30)];
    [dingdan_btn setImage:[UIImage imageNamed:@"dingdan.png"] forState:UIControlStateNormal];
    [dingdan_btn addTarget:self action:@selector(dingdanBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [dingdan_btn setTintColor:[UIColor lightGrayColor]];
    dingdan_btn.alpha = 1.0;
    dingdan_btn.transform = CGAffineTransformMakeTranslation(10, 0);
    [self.view addSubview:dingdan_btn];
    
    UIImageView *lineImg =[UIImageView new];
    lineImg.frame=CGRectMake(0, 63, self.view.frame.size.width, 2);
    lineImg.clipsToBounds = YES;
    lineImg.userInteractionEnabled=YES;
    lineImg.backgroundColor = [UIColor colorWithRed:216.0/255.0 green:229.0/255.0 blue:241.0/255.0 alpha:1.0];
    [self.view addSubview:lineImg];
    
    basketLbl = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 25, 25, 16, 16)];
    basketLbl.font = [UIFont systemFontOfSize:10.0];
    basketLbl.backgroundColor = [UIColor redColor];
    basketLbl.layer.cornerRadius = 8;
    basketLbl.layer.masksToBounds = YES;
    basketLbl.textAlignment = NSTextAlignmentCenter;
    basketLbl.textColor = [UIColor whiteColor];
    basketLbl.text = @"0";
    [self.view addSubview:basketLbl];
    
    //BannerView
    bannerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 60, self.view.frame.size.width, 60)];
    bannerView.backgroundColor = [UIColor whiteColor];
    bannerView.layer.cornerRadius = 3;
    bannerView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    bannerView.layer.borderWidth = 1;
    bannerView.layer.masksToBounds = YES;
    
    bannerImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, bannerView.frame.size.width, bannerView.frame.size.height)];
    bannerImg.backgroundColor = [UIColor clearColor];
    [bannerView addSubview:bannerImg];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    [bannerView addGestureRecognizer:tapGesture];
    
    UIButton *dismissBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 50, 5, 35, 35)];
    [dismissBtn setImage:[UIImage imageNamed:@"closeBtn.png"] forState:UIControlStateNormal];
    [dismissBtn addTarget:self action:@selector(dismissBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [dismissBtn setTintColor:[UIColor lightGrayColor]];
    dismissBtn.alpha = 1.0;
    dismissBtn.transform = CGAffineTransformMakeTranslation(10, 0);
    [bannerView addSubview:dismissBtn];
    
    [self.view addSubview:bannerView];
    
    [self getProductDetail];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBasketCountDelegate) name:@"changeBasketCount" object:nil];
}

- (void)getProductDetail{
    NSDictionary *parameters = @{@"pid":self.productId
                                 };
    [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
    [[GlobalPool sharedInstance].OAuth2Manager POST:LC_SHOP_PRODUCTDETAIL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        
        NSString *status = [responseObject objectForKey:@"status"];
        
        if ([status intValue] == 200) {
            adsArray = [[NSMutableArray alloc] initWithArray:[responseObject objectForKey:@"adinfo"]];
            
            if (adsArray.count == 0) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissBtnClicked" object:nil];
                bannerView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 60);
            }
            else{
                NSString *bannerUrl = [[adsArray firstObject] objectForKey:@"imageurl"];
                [bannerImg setImageWithURL:[NSURL URLWithString:bannerUrl]];
                adsDetailUrl = [[adsArray firstObject] objectForKey:@"url"];
                adsDetailTitle = [[adsArray firstObject] objectForKey:@"title"];
            }
        }
        else{
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
//            [alert show];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"Connection failed"];
    }];
}

- (void)viewTapped:(UIGestureRecognizer *)gesture {
    AdsDetailViewController *detail_view = [[AdsDetailViewController alloc] init];
    detail_view.adsTitle = adsDetailTitle;
    detail_view.adsUrl = adsDetailUrl;
    [self.navigationController pushViewController:detail_view animated:YES];
}

- (void)dismissBtnClicked{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissBtnClicked" object:nil];
    [UIView animateWithDuration:0.1 animations:^{
        bannerView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 60);
    }completion:^(BOOL finished){
        
    }];
}

#pragma mark -- YSLContainerViewControllerDelegate
- (void)containerViewItemIndex:(NSInteger)index currentController:(UIViewController *)controller
{
    [controller viewWillAppear:YES];
}

- (void)changeBasketCountDelegate{
    NSString *strCount = [[NSUserDefaults standardUserDefaults] objectForKey:@"cartCount"];
    basketLbl.text = strCount;
}

- (void)basketBtnClicked{
    NSString *isFirstLogin = [[NSUserDefaults standardUserDefaults] objectForKey:@"isLoginState"];
    if ([isFirstLogin isEqualToString:@"NO"]) {
//        [[AppDelegate sharedAppDelegate] runLogin];
        FirstViewController *loginView = [[FirstViewController alloc] init];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:loginView];
        navi.navigationBarHidden = YES;
        navi.modalPresentationStyle = UIModalPresentationCurrentContext;
        [self presentViewController:navi animated:YES completion:nil];
    }
    else{
        BasketViewController *basketView = [[BasketViewController alloc] init];
        [self.navigationController pushViewController:basketView animated:YES];
    }
}

- (void)dingdanBtnClicked{
    NSString *isFirstLogin = [[NSUserDefaults standardUserDefaults] objectForKey:@"isLoginState"];
    if ([isFirstLogin isEqualToString:@"NO"]) {
//        [[AppDelegate sharedAppDelegate] runLogin];
        FirstViewController *loginView = [[FirstViewController alloc] init];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:loginView];
        navi.navigationBarHidden = YES;
        navi.modalPresentationStyle = UIModalPresentationCurrentContext;
        [self presentViewController:navi animated:YES completion:nil];
    }
    else{
        RecordViewController *record_view = [[RecordViewController alloc] init];
        [self.navigationController pushViewController:record_view animated:YES];
    }
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
