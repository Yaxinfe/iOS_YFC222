//
//  ShopDetailViewController.m
//  YFC
//
//  Created by topone on 7/28/15.
//  Copyright (c) 2015 ming. All rights reserved.
//
#import "publicHeaders.h"

#import "ShopDetailViewController.h"
#import "FillViewController.h"
#import "DetailViewController.h"
#import "BasketViewController.h"
#import "RecordViewController.h"
#import "FirstViewController.h"

#import "TheSidebarController.h"

#import "AllAroundPullView.h"
#import "YFGIFImageView.h"
#import "UIImageView+PlayGIF.h"

@interface ShopDetailViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UIScrollView *scrollView;
    UICollectionView *_collectionView;
    
    NSMutableArray *listArray;
    
    UILabel *ballCntLbl;
    
    UILabel *basketLbl;
    NSString *strCartCount;
}
@end

@implementation ShopDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    listArray = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    backImageView.image = [UIImage imageNamed:@"shopBack.png"];
    [self.view addSubview:backImageView];
    
    UIButton *back_btn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + 23, 36, 33)];
    [back_btn setImage:[UIImage imageNamed:@"listIcon.png"] forState:UIControlStateNormal];
    [back_btn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [back_btn setTintColor:[UIColor lightGrayColor]];
    back_btn.alpha = 1.0;
    back_btn.transform = CGAffineTransformMakeTranslation(10, 0);
    [self.view addSubview:back_btn];
    
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 100, 30, 200, 24)];
//    titleLbl.text = @"팬 상점";
    titleLbl.font = [UIFont boldSystemFontOfSize:22.0];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.textColor = [UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0];
    [self.view addSubview:titleLbl];
    
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
    [self.view addSubview:basketLbl];
    
    UIImageView *ballImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x + 15, 75, 25, 25)];
    ballImageView.image = [UIImage imageNamed:@"blueBall.png"];
    [self.view addSubview:ballImageView];
    
    ballCntLbl = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.origin.x + 55, 75, 100, 25)];
    ballCntLbl.font = [UIFont systemFontOfSize:15.0];
    ballCntLbl.textAlignment = NSTextAlignmentLeft;
    ballCntLbl.textColor = [UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0];
    [self.view addSubview:ballCntLbl];
    
    UIButton *fill_btn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 140, 70, 140, 36)];
    [fill_btn setBackgroundImage:[UIImage imageNamed:@"fillBtn.png"] forState:UIControlStateNormal];
    [fill_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [fill_btn addTarget:self action:@selector(fillBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [fill_btn setTintColor:[UIColor lightGrayColor]];
    [fill_btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    fill_btn.alpha = 1.0;
    fill_btn.transform = CGAffineTransformMakeTranslation(10, 0);
    [self.view addSubview:fill_btn];
    
    NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
    if ([applang isEqualToString:@"ko"]) {
        titleLbl.text = FANSHOP_TITLE[0];
        [fill_btn setTitle:FANSHOP_QUNGJEN_BUTTON[0] forState:UIControlStateNormal];
    }
    if ([applang isEqualToString:@"cn"]) {
        titleLbl.text = FANSHOP_TITLE[1];
        [fill_btn setTitle:FANSHOP_QUNGJEN_BUTTON[1] forState:UIControlStateNormal];
    }
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 110, self.view.frame.size.width, self.view.frame.size.height - 110)];
    scrollView.alwaysBounceHorizontal = NO;
    scrollView.alwaysBounceVertical = YES;
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    _collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 110) collectionViewLayout:layout];
    [_collectionView setDataSource:self];
    [_collectionView setDelegate:self];
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [_collectionView setBackgroundColor:[UIColor clearColor]];
    _collectionView.scrollEnabled = NO;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 3;
    [scrollView addSubview:_collectionView];
    
    // top
    AllAroundPullView *topPullView = [[AllAroundPullView alloc] initWithScrollView:scrollView position:AllAroundPullViewPositionTop action:^(AllAroundPullView *view){
        NSLog(@"--");
        [view performSelector:@selector(finishedLoading) withObject:nil afterDelay:4.0f];
        [self getProductList];
    }];
    topPullView.backgroundColor = [UIColor clearColor];
    topPullView.activityView.hidden = YES;
    
    NSData *gifData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"football1.gif" ofType:nil]];
    YFGIFImageView *gifView = [[YFGIFImageView alloc] initWithFrame:CGRectMake(topPullView.frame.size.width/2 - 90, topPullView.frame.size.height - 50, 180, 50)];
    gifView.backgroundColor = [UIColor clearColor];
    gifView.gifData = gifData;
    [topPullView addSubview:gifView];
    [gifView startGIF];
    gifView.userInteractionEnabled = YES;
    
    [scrollView addSubview:topPullView];
    
    // bottom
    AllAroundPullView *bottomPullView = [[AllAroundPullView alloc] initWithScrollView:scrollView position:AllAroundPullViewPositionBottom action:^(AllAroundPullView *view){
        NSLog(@"--");
        [view performSelector:@selector(finishedLoading) withObject:nil afterDelay:4.0f];
        [self loadMoreList];
    }];
    bottomPullView.backgroundColor = [UIColor clearColor];
    bottomPullView.activityView.hidden = YES;
    
    NSData *gifData1 = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"football1.gif" ofType:nil]];
    YFGIFImageView *gifView1 = [[YFGIFImageView alloc] initWithFrame:CGRectMake(bottomPullView.frame.size.width/2 - 90, 0, 180, 50)];
    gifView1.backgroundColor = [UIColor clearColor];
    gifView1.gifData = gifData1;
    [bottomPullView addSubview:gifView1];
    [gifView1 startGIF];
    gifView1.userInteractionEnabled = YES;
    
    [scrollView addSubview:bottomPullView];
    
    [self.view addSubview:scrollView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self getProductList];
}

-(void)getProductList{
//    [listArray removeAllObjects];
    
    NSString *isFirstLogin = [[NSUserDefaults standardUserDefaults] objectForKey:@"isLoginState"];
    if ([isFirstLogin isEqualToString:@"NO"]) {
        NSDictionary *parameters = @{@"userid":@"0",
                                     @"lastid":@"0"
                                     };
        
        [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
        [[GlobalPool sharedInstance].OAuth2Manager POST:LC_SHOP_PRODUCTS parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

            ballCntLbl.text = @"0";
            basketLbl.text = @"0";
            
            strCartCount = [responseObject objectForKey:@"cartcount"];
            NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
            [userdefault setObject:strCartCount forKey:@"cartCount"];
            [userdefault synchronize];
            
            listArray = [NSMutableArray arrayWithArray:[responseObject objectForKey:@"result"]];
            
            NSUInteger count = listArray.count;
            if (count%2 == 0) {
                if (listArray.count*(self.view.frame.size.width/8*5)/2 < (self.view.frame.size.height - 110)) {
                    _collectionView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 110);
                }
                else{
                    _collectionView.frame = CGRectMake(0, 0, self.view.frame.size.width, listArray.count*(self.view.frame.size.width/8*5)/2 + 10);
                }
                
                scrollView.contentSize = CGSizeMake(self.view.frame.size.width, _collectionView.frame.size.height);
            }
            else{
                if ((listArray.count/2+1)*(self.view.frame.size.width/8*5) < (self.view.frame.size.height - 110)) {
                    _collectionView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 110);
                }
                else{
                    _collectionView.frame = CGRectMake(0, 0, self.view.frame.size.width, (listArray.count/2+1)*(self.view.frame.size.width/8*5) + 10);
                }
                
                scrollView.contentSize = CGSizeMake(self.view.frame.size.width, _collectionView.frame.size.height);
            }
            
            [_collectionView reloadData];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"Connection failed"];
        }];
    }
    else{
        NSString *userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"];
        NSDictionary *parameters = @{@"userid":userid,
                                     @"lastid":@"0"
                                     };
        
        [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
        [[GlobalPool sharedInstance].OAuth2Manager POST:LC_SHOP_PRODUCTS parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            ballCntLbl.text = [responseObject objectForKey:@"ballcount"];
            basketLbl.text = [responseObject objectForKey:@"cartcount"];
            
            strCartCount = [responseObject objectForKey:@"cartcount"];
            NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
            [userdefault setObject:strCartCount forKey:@"cartCount"];
            [userdefault synchronize];
            
            listArray = [NSMutableArray arrayWithArray:[responseObject objectForKey:@"result"]];
            
            NSUInteger count = listArray.count;
            if (count%2 == 0) {
                if (listArray.count*(self.view.frame.size.width/8*5)/2 < (self.view.frame.size.height - 110)) {
                    _collectionView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 110);
                }
                else{
                    _collectionView.frame = CGRectMake(0, 0, self.view.frame.size.width, listArray.count*(self.view.frame.size.width/8*5)/2 + 10);
                }
                
                scrollView.contentSize = CGSizeMake(self.view.frame.size.width, _collectionView.frame.size.height);
            }
            else{
                if ((listArray.count/2+1)*(self.view.frame.size.width/8*5) < (self.view.frame.size.height - 110)) {
                    _collectionView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 110);
                }
                else{
                    _collectionView.frame = CGRectMake(0, 0, self.view.frame.size.width, (listArray.count/2+1)*(self.view.frame.size.width/8*5) + 10);
                }
                
                scrollView.contentSize = CGSizeMake(self.view.frame.size.width, _collectionView.frame.size.height);
            }
            
            [_collectionView reloadData];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"Connection failed"];
        }];
    }
    
}

- (void)loadMoreList{
    if (listArray.count == 0) {
        [self getProductList];
    }
    else{
        NSString *isFirstLogin = [[NSUserDefaults standardUserDefaults] objectForKey:@"isLoginState"];
        if ([isFirstLogin isEqualToString:@"NO"]) {
            NSString *lastPId = [[listArray objectAtIndex:listArray.count - 1] objectForKey:@"pid"];
            NSDictionary *parameters = @{@"userid":@"0",
                                         @"lastid":lastPId
                                         };
            
            [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
            [[GlobalPool sharedInstance].OAuth2Manager POST:LC_SHOP_PRODUCTS parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                [listArray addObjectsFromArray:[responseObject objectForKey:@"result"]];
                
                NSUInteger count = listArray.count;
                if (count%2 == 0) {
                    if (listArray.count*(self.view.frame.size.width/8*5)/2 < (self.view.frame.size.height - 110)) {
                        _collectionView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 110);
                    }
                    else{
                        _collectionView.frame = CGRectMake(0, 0, self.view.frame.size.width, listArray.count*(self.view.frame.size.width/8*5)/2 + 10);
                    }
                    
                    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, _collectionView.frame.size.height);
                }
                else{
                    if ((listArray.count/2+1)*(self.view.frame.size.width/8*5) < (self.view.frame.size.height - 110)) {
                        _collectionView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 110);
                    }
                    else{
                        _collectionView.frame = CGRectMake(0, 0, self.view.frame.size.width, (listArray.count/2+1)*(self.view.frame.size.width/8*5) + 10);
                    }
                    
                    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, _collectionView.frame.size.height);
                }
                
                [_collectionView reloadData];
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [SVProgressHUD showErrorWithStatus:@"Connection failed"];
            }];
        }
        else{
            NSString *userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"];
            
            NSString *lastPId = [[listArray objectAtIndex:listArray.count - 1] objectForKey:@"pid"];
            NSDictionary *parameters = @{@"userid":userid,
                                         @"lastid":lastPId
                                         };
            
            [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
            [[GlobalPool sharedInstance].OAuth2Manager POST:LC_SHOP_PRODUCTS parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                [listArray addObjectsFromArray:[responseObject objectForKey:@"result"]];
                
                NSUInteger count = listArray.count;
                if (count%2 == 0) {
                    if (listArray.count*(self.view.frame.size.width/8*5)/2 < (self.view.frame.size.height - 110)) {
                        _collectionView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 110);
                    }
                    else{
                        _collectionView.frame = CGRectMake(0, 0, self.view.frame.size.width, listArray.count*(self.view.frame.size.width/8*5)/2 + 10);
                    }
                    
                    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, _collectionView.frame.size.height);
                }
                else{
                    if ((listArray.count/2+1)*(self.view.frame.size.width/8*5) < (self.view.frame.size.height - 110)) {
                        _collectionView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 110);
                    }
                    else{
                        _collectionView.frame = CGRectMake(0, 0, self.view.frame.size.width, (listArray.count/2+1)*(self.view.frame.size.width/8*5) + 10);
                    }
                    
                    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, _collectionView.frame.size.height);
                }
                
                [_collectionView reloadData];
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [SVProgressHUD showErrorWithStatus:@"Connection failed"];
            }];
        }
        
    }
}

#pragma mark - UICollectionView data source

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return listArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize retval;
    retval =  CGSizeMake(self.view.frame.size.width/2, self.view.frame.size.width/8*5);
    return retval;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    if (cell==nil){
        cell.backgroundColor=[UIColor clearColor];
    }
    else{
        for (UIView *view in cell.contentView.subviews)
            [view removeFromSuperview];
    }
    
    UIImageView *back = [[UIImageView alloc] init];
    back.backgroundColor = [UIColor clearColor];
    back.frame = CGRectMake(10, 10, cell.frame.size.width - 20, cell.frame.size.height - 80);
    back.layer.cornerRadius = 1;
    back.layer.borderColor = [UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0].CGColor;
    back.layer.borderWidth = 1;
    back.layer.masksToBounds = YES;
    [cell.contentView addSubview:back];
    
    UIImageView *productImg = [[UIImageView alloc] init];
    productImg.backgroundColor = [UIColor clearColor];
    productImg.frame = CGRectMake(back.frame.origin.x + 5, back.frame.origin.y + 2, cell.frame.size.width - 30, cell.frame.size.height - 84);
    productImg.contentMode = UIViewContentModeScaleAspectFit;
    [cell.contentView addSubview:productImg];
    
    UILabel *lbl_name = [[UILabel alloc]initWithFrame:CGRectMake(5, cell.frame.size.height - 70, cell.frame.size.width - 10, 40)];
    [lbl_name setTextColor:[UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0]];
    [lbl_name setBackgroundColor:[UIColor clearColor]];
    [lbl_name setFont:[UIFont systemFontOfSize:14.0]];
    [lbl_name setTextAlignment:NSTextAlignmentCenter];
    lbl_name.numberOfLines = 2;
    [cell.contentView addSubview:lbl_name];

    UILabel *lbl_price = [[UILabel alloc]initWithFrame:CGRectMake(0, cell.frame.size.height - 30, cell.frame.size.width/2, 20)];
    [lbl_price setTextColor:[UIColor redColor]];
    [lbl_price setBackgroundColor:[UIColor clearColor]];
    [lbl_price setFont:[UIFont systemFontOfSize:15.0]];
    [lbl_price setTextAlignment:NSTextAlignmentRight];
    [cell.contentView addSubview:lbl_price];

    UIImageView *ballImg = [[UIImageView alloc] init];
    ballImg.backgroundColor = [UIColor clearColor];
    ballImg.frame = CGRectMake(lbl_price.frame.origin.x + lbl_price.frame.size.width + 5, cell.frame.size.height - 30, 20, 20);
    ballImg.image = [UIImage imageNamed:@"blueBall.png"];
    [cell.contentView addSubview:ballImg];
    
    NSString *path = [[listArray objectAtIndex:indexPath.row] objectForKey:@"url1"];
    [productImg setImageWithURL:[NSURL URLWithString:path]];
    
    lbl_name.text = [[listArray objectAtIndex:indexPath.row] objectForKey:@"name"];
    lbl_price.text = [[listArray objectAtIndex:indexPath.row] objectForKey:@"price"];
    
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    DetailViewController *product_view = [[DetailViewController alloc] init];
    product_view.productId = [[listArray objectAtIndex:indexPath.row] objectForKey:@"pid"];
    [self.navigationController pushViewController:product_view animated:YES];
}

- (void)backBtnClicked{
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

- (void)fillBtnClicked{
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
        FillViewController *fillView = [[FillViewController alloc] init];
        [self.navigationController pushViewController:fillView animated:YES];
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
