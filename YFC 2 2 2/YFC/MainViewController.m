//
//  MainViewController.m
//  YFC
//
//  Created by topone on 7/14/15.
//  Copyright (c) 2015 ming. All rights reserved.
//

#import "publicHeaders.h"

#import "MainViewController.h"
#import "MenuViewController.h"
#import "NewsDetailViewController.h"
#import "FillViewController.h"

#import "SwipeView.h"

#import "AllAroundPullView.h"
#import "YFGIFImageView.h"
#import "UIImageView+PlayGIF.h"

#import "TheSidebarController.h"

#import "CCMPopupSegue.h"
#import "CCMBorderView.h"
#import "CCMPopupTransitioning.h"
#import "AdsViewController.h"

#define kItemStartTag 1000

@interface MainViewController ()<UITableViewDataSource, UITableViewDelegate, SwipeViewDataSource, SwipeViewDelegate>
{
    UIScrollView *scrollView;
    UITableView *newsTable;
    
    NSMutableArray *newsListArray;
    NSMutableArray *bannerArray;
    
    int nSelectedTag;
    
    UIPageControl  *pageControl;
    
    YFGIFImageView *gifView_Load;
    
    NSTimer *_timer;
    NSInteger   memDetailNum;
}

@property (nonatomic, strong) SwipeView *bannerSwipeView;

@property (weak, nonatomic) UIImageView *imageViewTop;
@property (weak, nonatomic) UIImageView *imageViewBotton;
@property (weak, nonatomic) CCMBorderView *buttonContainerView;
@property (weak, nonatomic) CCMBorderView *secondButtonContainerView;
@property (weak) UIViewController *popupController;

@end

@implementation MainViewController
@synthesize bannerSwipeView;

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    bannerArray = [[NSMutableArray alloc] init];
    newsListArray = [[NSMutableArray alloc] init];
    
    nSelectedTag = -1;
    memDetailNum = 0;
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *markImageBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 90, 20, 180, 35)];
    [markImageBtn setImage:[UIImage imageNamed:@"markTitle.png"] forState:UIControlStateNormal];
    [markImageBtn addTarget:self action:@selector(markBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [markImageBtn setTintColor:[UIColor lightGrayColor]];
    markImageBtn.alpha = 1.0;
    markImageBtn.transform = CGAffineTransformMakeTranslation(10, 0);
    [self.view addSubview:markImageBtn];
    
    UIButton *list_btn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + 23, 36, 33)];
    [list_btn setImage:[UIImage imageNamed:@"listIcon.png"] forState:UIControlStateNormal];
    [list_btn addTarget:self action:@selector(listBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [list_btn setTintColor:[UIColor lightGrayColor]];
    list_btn.transform = CGAffineTransformMakeTranslation(10, 0);
    [self.view addSubview:list_btn];
    
    UIImageView *lineImg5 =[UIImageView new];
    lineImg5.frame=CGRectMake(0, 63, self.view.frame.size.width, 2);
    lineImg5.clipsToBounds = YES;
    lineImg5.userInteractionEnabled=YES;
    lineImg5.backgroundColor = [UIColor colorWithRed:216.0/255.0 green:229.0/255.0 blue:241.0/255.0 alpha:1.0];
    [self.view addSubview:lineImg5];
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 65, self.view.frame.size.width, self.view.frame.size.height - 65)];
    scrollView.alwaysBounceHorizontal = NO;
    scrollView.alwaysBounceVertical = YES;
    
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    backImageView.image = [UIImage imageNamed:@"mainBackImg.png"];
    [scrollView addSubview:backImageView];
    
    bannerSwipeView = [[SwipeView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width/16*9)];
    bannerSwipeView.pagingEnabled = YES;
    bannerSwipeView.delegate = self;
    bannerSwipeView.dataSource = self;
    [scrollView addSubview:bannerSwipeView];
    
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width/2 - 50, self.view.frame.size.width/16*9 - 30, 100, 30)];
    [pageControl setPageIndicatorTintColor:[UIColor lightGrayColor]];
    [pageControl setCurrentPageIndicatorTintColor:[UIColor whiteColor]];
    [pageControl setCurrentPage:0];
    [pageControl setEnabled:NO];
    [scrollView addSubview:pageControl];
    
    newsTable = [[UITableView alloc] initWithFrame:CGRectMake(0, bannerSwipeView.frame.origin.y + bannerSwipeView.frame.size.height, self.view.frame.size.width, newsListArray.count*145 + 10) style:UITableViewStylePlain];
    newsTable.dataSource = self;
    newsTable.delegate = self;
    [newsTable setBackgroundColor:[UIColor clearColor]];
    newsTable.scrollEnabled = NO;
    newsTable.userInteractionEnabled=YES;
    [newsTable setAllowsSelection:YES];
    if ([newsTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [newsTable setSeparatorInset:UIEdgeInsetsZero];
    }
    [newsTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [scrollView addSubview:newsTable];
    
    // top
    AllAroundPullView *topPullView = [[AllAroundPullView alloc] initWithScrollView:scrollView position:AllAroundPullViewPositionTop action:^(AllAroundPullView *view){
        NSLog(@"--");
        [view performSelector:@selector(finishedLoading) withObject:nil afterDelay:4.0f];
        [self refreshList];
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
        [self loadMoreGetRequest];
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
    
    NSString *doneRunApp = [[NSUserDefaults standardUserDefaults] objectForKey:@"doneRunApp"];
    if ([doneRunApp isEqualToString:@"YES"]) {
        self.imageViewTop.image = [self.imageViewTop.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        self.imageViewBotton.image = [self.imageViewBotton.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        self.buttonContainerView.layer.shadowColor = [UIColor blackColor].CGColor;
        self.buttonContainerView.layer.shadowRadius = 15;
        self.buttonContainerView.clipsToBounds = NO;
        self.buttonContainerView.layer.shadowOffset = CGSizeMake(0, 5);
        
        AdsViewController *presentingController = [[AdsViewController alloc] init];
        
        CCMPopupTransitioning *popup = [CCMPopupTransitioning sharedInstance];
        popup.destinationBounds = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        popup.presentedController = presentingController;
        popup.presentingController = self;
        self.popupController = presentingController;
        self.popupController.modalPresentationStyle = UIModalPresentationCurrentContext;
        [self presentViewController:presentingController animated:YES completion:nil];
    }
    
    NSData *gifData_Load = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Loading.gif" ofType:nil]];
    gifView_Load = [[YFGIFImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 50, self.view.frame.size.height/2 - 50, 100, 100)];
    gifView_Load.backgroundColor = [UIColor clearColor];
    gifView_Load.gifData = gifData_Load;
    [self.view addSubview:gifView_Load];
    gifView_Load.hidden = YES;
    gifView_Load.userInteractionEnabled = YES;
    
    [self getRequests];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:3.0f
                                              target:self
                                            selector:@selector(_timerFired:)
                                            userInfo:nil
                                             repeats:YES];
}

- (void)_timerFired:(NSTimer *)timer {
    if (memDetailNum == bannerArray.count) {
        memDetailNum = 0;
    }
    else{
        memDetailNum = memDetailNum + 1;
    }
    [bannerSwipeView scrollToItemAtIndex:memDetailNum duration:0.5];
}

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    [self.view layoutIfNeeded];
    if (size.height < 420) {
        [UIView animateWithDuration:[coordinator transitionDuration] animations:^{
            self.popupController.view.bounds = CGRectMake(0, 0, (size.height-20) * .75, size.height-20);
            [self.view layoutIfNeeded];
        }];
    } else {
        [UIView animateWithDuration:[coordinator transitionDuration] animations:^{
            self.popupController.view.bounds = CGRectMake(0, 0, 300, 400);
            [self.view layoutIfNeeded];
        }];
    }
}

#pragma mark -
#pragma mark iCarousel methods
- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{
    return bannerArray.count;
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    UIImageView *photoView = nil;

    if (view == nil)
    {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, bannerSwipeView.width, bannerSwipeView.height)];
        view.backgroundColor = [UIColor clearColor];
        view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        photoView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, bannerSwipeView.width - 10, bannerSwipeView.height)];
        photoView.backgroundColor = [UIColor clearColor];
        photoView.tag = kItemStartTag;
        
        [view addSubview:photoView];
    }
    else
    {
        //get a reference to the label in the recycled view
        photoView = (UIImageView *)[view viewWithTag:kItemStartTag];
    }
    
    NSString *path = [[bannerArray objectAtIndex:index] objectForKey:@"imageurl"];
    [photoView setImageWithURL:[NSURL URLWithString:path]];
    
    return view;
}

- (CGSize)swipeViewItemSize:(SwipeView *)swipeView
{
    return CGSizeMake(bannerSwipeView.width, bannerSwipeView.height);
}

- (void)swipeView:(SwipeView *)swipeView didSelectItemAtIndex:(NSInteger)index {
    NewsDetailViewController *detailView = [[NewsDetailViewController alloc] init];
    detailView.strNewsId = [[bannerArray objectAtIndex:index] objectForKey:@"newsid"];
    detailView.strNewsTitle = [[bannerArray objectAtIndex:index] objectForKey:@"title"];
    detailView.strNewsContent = [[bannerArray objectAtIndex:index] objectForKey:@"content"];
    detailView.strNewsImageUrl = [[bannerArray objectAtIndex:index] objectForKey:@"imageurl"];
    [self.navigationController pushViewController:detailView animated:YES];
}

- (void)loadMoreGetRequest{
    if (newsListArray.count == 0) {
        [self refreshList];
    }
    else{
        NSString *isFirstLogin = [[NSUserDefaults standardUserDefaults] objectForKey:@"isLoginState"];
        if ([isFirstLogin isEqualToString:@"NO"]) {
            NSString *lastNewsId = [[newsListArray objectAtIndex:newsListArray.count - 1] objectForKey:@"newsid"];
            NSDictionary *parameters = @{@"userid":@"0",
                                         @"lastnewsid": lastNewsId
                                         };
            
            [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
            [[GlobalPool sharedInstance].OAuth2Manager POST:LC_NEWS_LOADMORE parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                //        NSLog(@"%@",responseObject);
                
                [newsListArray addObjectsFromArray:[responseObject objectForKey:@"newslist"]];
                
                if ((self.view.frame.size.width/16*9 + newsListArray.count*110 + 10) < self.view.frame.size.height) {
                    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
                }
                else{
                    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.width/16*9 + newsListArray.count*110 + 10);
                }
                
                newsTable.frame = CGRectMake(0, bannerSwipeView.frame.origin.y + bannerSwipeView.frame.size.height, self.view.frame.size.width, newsListArray.count*110 + 10);
                [newsTable reloadData];
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [SVProgressHUD showErrorWithStatus:@"Connection failed"];
            }];
        }
        else{
            NSString *lastNewsId = [[newsListArray objectAtIndex:newsListArray.count - 1] objectForKey:@"newsid"];
            NSString *userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"];
            NSDictionary *parameters = @{@"userid":userid,
                                         @"lastnewsid": lastNewsId
                                         };
            
            [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
            [[GlobalPool sharedInstance].OAuth2Manager POST:LC_NEWS_LOADMORE parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                //        NSLog(@"%@",responseObject);
                
                [newsListArray addObjectsFromArray:[responseObject objectForKey:@"newslist"]];
                
                if ((self.view.frame.size.width/16*9 + newsListArray.count*110 + 10) < self.view.frame.size.height) {
                    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
                }
                else{
                    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.width/16*9 + newsListArray.count*110 + 10);
                }
                
                newsTable.frame = CGRectMake(0, bannerSwipeView.frame.origin.y + bannerSwipeView.frame.size.height, self.view.frame.size.width, newsListArray.count*110 + 10);
                [newsTable reloadData];
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [SVProgressHUD showErrorWithStatus:@"Connection failed"];
            }];
        }
    }
    
}

- (void)refreshList{
    NSString *isFirstLogin = [[NSUserDefaults standardUserDefaults] objectForKey:@"isLoginState"];
    if ([isFirstLogin isEqualToString:@"NO"]) {
        NSDictionary *parameters = @{@"userid":@"0",
                                     @"lastnewsid": @"0"
                                     };
        
        [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
        [[GlobalPool sharedInstance].OAuth2Manager POST:LC_NEWS parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            bannerArray = [NSMutableArray arrayWithArray:[responseObject objectForKey:@"bannernews"]];
            newsListArray = [NSMutableArray arrayWithArray:[responseObject objectForKey:@"newslist"]];
            
            if ((self.view.frame.size.width/16*9 + newsListArray.count*110 + 10) < self.view.frame.size.height) {
                scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
            }
            else{
                scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.width/16*9 + newsListArray.count*110 + 10);
            }
            
            newsTable.frame = CGRectMake(0, bannerSwipeView.frame.origin.y + bannerSwipeView.frame.size.height, self.view.frame.size.width, newsListArray.count*110 + 10);
            
            [newsTable reloadData];
            [bannerSwipeView reloadData];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"Connection failed"];
        }];
    }
    else{
        NSString *userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"];
        NSDictionary *parameters = @{@"userid":userid,
                                     @"lastnewsid": @"0"
                                     };
        
        [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
        [[GlobalPool sharedInstance].OAuth2Manager POST:LC_NEWS parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            bannerArray = [NSMutableArray arrayWithArray:[responseObject objectForKey:@"bannernews"]];
            newsListArray = [NSMutableArray arrayWithArray:[responseObject objectForKey:@"newslist"]];
            
            if ((self.view.frame.size.width/16*9 + newsListArray.count*110 + 10) < self.view.frame.size.height) {
                scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
            }
            else{
                scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.width/16*9 + newsListArray.count*110 + 10);
            }
            
            newsTable.frame = CGRectMake(0, bannerSwipeView.frame.origin.y + bannerSwipeView.frame.size.height, self.view.frame.size.width, newsListArray.count*110 + 10);
            
            [newsTable reloadData];
            [bannerSwipeView reloadData];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"Connection failed"];
        }];
    }
}

- (void)getRequests {
    gifView_Load.hidden = NO;
    [gifView_Load startGIF];
    [gifView_Load startAnimating];
    
    NSString *isFirstLogin = [[NSUserDefaults standardUserDefaults] objectForKey:@"isLoginState"];
    if ([isFirstLogin isEqualToString:@"NO"]) {
        NSDictionary *parameters = @{@"userid":@"0",
                                     @"lastnewsid": @"0"
                                     };
        
        [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
        [[GlobalPool sharedInstance].OAuth2Manager POST:LC_NEWS parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            gifView_Load.hidden = YES;
            [gifView_Load stopGIF];
            [gifView_Load stopAnimating];
            
            bannerArray = [NSMutableArray arrayWithArray:[responseObject objectForKey:@"bannernews"]];
            newsListArray = [NSMutableArray arrayWithArray:[responseObject objectForKey:@"newslist"]];
            
            pageControl.numberOfPages = bannerArray.count;
            
            if ((self.view.frame.size.width/16*9 + newsListArray.count*110 + 10) < self.view.frame.size.height) {
                scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
            }
            else{
                scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.width/16*9 + newsListArray.count*110 + 10);
            }
            
            newsTable.frame = CGRectMake(0, bannerSwipeView.frame.origin.y + bannerSwipeView.frame.size.height, self.view.frame.size.width, newsListArray.count*110 + 10);
            
            [newsTable reloadData];
            [bannerSwipeView reloadData];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"Connection failed"];
        }];
    }
    else{
        NSString *userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"];
        NSDictionary *parameters = @{@"userid":userid,
                                     @"lastnewsid": @"0"
                                     };
        
        [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
        [[GlobalPool sharedInstance].OAuth2Manager POST:LC_NEWS parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            gifView_Load.hidden = YES;
            [gifView_Load stopGIF];
            [gifView_Load stopAnimating];
            
            bannerArray = [NSMutableArray arrayWithArray:[responseObject objectForKey:@"bannernews"]];
            newsListArray = [NSMutableArray arrayWithArray:[responseObject objectForKey:@"newslist"]];
            
            pageControl.numberOfPages = bannerArray.count;
            
            if ((self.view.frame.size.width/16*9 + newsListArray.count*110 + 10) < self.view.frame.size.height) {
                scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
            }
            else{
                scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.width/16*9 + newsListArray.count*110 + 10);
            }
            
            newsTable.frame = CGRectMake(0, bannerSwipeView.frame.origin.y + bannerSwipeView.frame.size.height, self.view.frame.size.width, newsListArray.count*110 + 10);
            
            [newsTable reloadData];
            [bannerSwipeView reloadData];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"Connection failed"];
        }];
    }
}

- (void)swipeViewCurrentItemIndexDidChange:(SwipeView *)swipeView{
    NSInteger currentIndex = bannerSwipeView.currentItemIndex;
    
    memDetailNum = currentIndex;
    
    [pageControl setCurrentPage:currentIndex];
}

- (void)listBtnClicked{
    if(self.sidebarController.sidebarIsPresenting)
    {
        [self.sidebarController dismissSidebarViewController];
    }
    else
    {
        [_timer invalidate];
        _timer = nil;
        
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

- (void)markBtnClicked{
    [scrollView setContentOffset:CGPointZero animated:YES];
}

- (void)footBtnClicked{
    FillViewController *fillView = [[FillViewController alloc] init];
    [self.navigationController pushViewController:fillView animated:YES];
}

#pragma mark - tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return newsListArray.count;
}

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
    
    UILabel *lbl_Title = [[UILabel alloc]init];
    [lbl_Title setFrame:CGRectMake(10, 0, self.view.frame.size.width - 180, 35)];
    [lbl_Title setTextAlignment:NSTextAlignmentLeft];
    [lbl_Title setTextColor:[UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0]];
    [lbl_Title setBackgroundColor:[UIColor clearColor]];
    [lbl_Title setFont:[UIFont boldSystemFontOfSize:14.0]];
    lbl_Title.numberOfLines = 2;
    [cell.contentView addSubview:lbl_Title];
    
    UILabel *lbl_Content = [[UILabel alloc]init];
    [lbl_Content setFrame:CGRectMake(10, 35, self.view.frame.size.width - 180, 75)];
    [lbl_Content setTextAlignment:NSTextAlignmentLeft];
    [lbl_Content setTextColor:[UIColor colorWithRed:65.0/255.0 green:111.0/255.0 blue:155.0/255.0 alpha:1.0]];
    [lbl_Content setBackgroundColor:[UIColor clearColor]];
    [lbl_Content setFont:[UIFont systemFontOfSize:13.0]];
    lbl_Content.numberOfLines = 8;
    [cell.contentView addSubview:lbl_Content];
    
    UIImageView *image =[UIImageView new];
    image.frame=CGRectMake(self.view.frame.size.width - 165, 5, 160, 100);
    image.clipsToBounds = YES;
    image.userInteractionEnabled=YES;
    image.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:image];
    
    UIImageView *lineImg =[UIImageView new];
    lineImg.frame=CGRectMake(5, 109, self.view.frame.size.width - 10, 1);
    lineImg.clipsToBounds = YES;
    lineImg.userInteractionEnabled=YES;
    lineImg.backgroundColor = [UIColor colorWithRed:65.0/255.0 green:111.0/255.0 blue:155.0/255.0 alpha:1.0];
    [cell.contentView addSubview:lineImg];
    
    lbl_Title.text = [[newsListArray objectAtIndex:indexPath.row] objectForKey:@"title"];
    lbl_Content.text = [[newsListArray objectAtIndex:indexPath.row] objectForKey:@"content"];
    
    NSString *path = [[newsListArray objectAtIndex:indexPath.row] objectForKey:@"imageurl"];
    [image setImageWithURL:[NSURL URLWithString:path]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NewsDetailViewController *detailView = [[NewsDetailViewController alloc] init];
    detailView.strNewsTitle = [[newsListArray objectAtIndex:indexPath.row] objectForKey:@"title"];
    detailView.strNewsId = [[newsListArray objectAtIndex:indexPath.row] objectForKey:@"newsid"];
    detailView.strNewsContent = [[newsListArray objectAtIndex:indexPath.row] objectForKey:@"content"];
    detailView.strNewsImageUrl = [[newsListArray objectAtIndex:indexPath.row] objectForKey:@"imageurl"];
    [self.navigationController pushViewController:detailView animated:YES];
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
