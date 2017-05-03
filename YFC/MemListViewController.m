//
//  MemListViewController.m
//  YFC
//
//  Created by topone on 7/16/15.
//  Copyright (c) 2015 ming. All rights reserved.
//

#import "MemListViewController.h"
#import "MemDetailViewController.h"

#import "publicHeaders.h"
#import "SwipeView.h"

#import "TheSidebarController.h"

#import "YFGIFImageView.h"
#import "UIImageView+PlayGIF.h"

#define kItemStartTag 1000

@interface MemListViewController ()<SwipeViewDataSource, SwipeViewDelegate>
{
    NSMutableArray *memListArray;
    NSMutableArray *teacherArray;
    NSMutableArray *totalArray;
    
    UIImageView *memDetailImg;
    UILabel     *name_Lbl;
    UILabel     *mem_Num;
    
    UIButton    *prev_btn;
    UIButton    *next_btn;
    NSInteger   memDetailNum;
    
    YFGIFImageView *gifView_Load;
}

@property (nonatomic, strong) SwipeView *smallListSwipeView;
@property (nonatomic, strong) SwipeView *largeListSwipeView;

@end

@implementation MemListViewController
@synthesize largeListSwipeView, smallListSwipeView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    totalArray = [[NSMutableArray alloc] init];
    
    memDetailNum = 0;
    
    UIButton *back_btn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + 23, 36, 33)];
    [back_btn setImage:[UIImage imageNamed:@"listIcon.png"] forState:UIControlStateNormal];
    [back_btn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [back_btn setTintColor:[UIColor lightGrayColor]];
    back_btn.alpha = 1.0;
    back_btn.transform = CGAffineTransformMakeTranslation(10, 0);
    [self.view addSubview:back_btn];
    
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 100, 30, 200, 24)];
    titleLbl.text = @"선 수 명 단";
    titleLbl.font = [UIFont boldSystemFontOfSize:22.0];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.textColor = [UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0];
    [self.view addSubview:titleLbl];
    
    NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
    if ([applang isEqualToString:@"ko"]) {
        titleLbl.text = CLUB_TITLE[0];
    }
    if ([applang isEqualToString:@"cn"]) {
        titleLbl.text = CLUB_TITLE[1];
    }
    
    UIImageView *lineImg5 =[UIImageView new];
    lineImg5.frame=CGRectMake(0, 63, self.view.frame.size.width, 2);
    lineImg5.clipsToBounds = YES;
    lineImg5.userInteractionEnabled=YES;
    lineImg5.backgroundColor = [UIColor colorWithRed:216.0/255.0 green:229.0/255.0 blue:241.0/255.0 alpha:1.0];
    [self.view addSubview:lineImg5];
    
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(prev_btn.frame.origin.x + 22, 100, self.view.frame.size.width - (prev_btn.frame.origin.x + 22)*2, self.view.frame.size.height - 270)];
    backImageView.image = [UIImage imageNamed:@"memBack.png"];
    [self.view addSubview:backImageView];
    
    smallListSwipeView = [[SwipeView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 150, self.view.frame.size.width, 150)];
    smallListSwipeView.pagingEnabled = YES;
    smallListSwipeView.delegate = self;
    smallListSwipeView.dataSource = self;
    [self.view addSubview:smallListSwipeView];
    
    largeListSwipeView = [[SwipeView alloc] initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height - 210)];
    largeListSwipeView.pagingEnabled = YES;
    largeListSwipeView.delegate = self;
    largeListSwipeView.dataSource = self;
    [self.view addSubview:largeListSwipeView];
    
    prev_btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 60, 60, self.view.frame.size.height - 210)];
    [prev_btn setImage:[UIImage imageNamed:@"previousBtn.png"] forState:UIControlStateNormal];
    [prev_btn addTarget:self action:@selector(previousBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [prev_btn setTintColor:[UIColor lightGrayColor]];
    prev_btn.alpha = 1.0;
    prev_btn.transform = CGAffineTransformMakeTranslation(10, 0);
    prev_btn.hidden = YES;
    [self.view addSubview:prev_btn];
    
    next_btn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 70, 60, 60, self.view.frame.size.height - 210)];
    [next_btn setImage:[UIImage imageNamed:@"nextBtn.png"] forState:UIControlStateNormal];
    [next_btn addTarget:self action:@selector(nextBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [next_btn setTintColor:[UIColor lightGrayColor]];
    next_btn.alpha = 1.0;
    next_btn.transform = CGAffineTransformMakeTranslation(10, 0);
    [self.view addSubview:next_btn];
    
    NSData *gifData_Load = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Loading.gif" ofType:nil]];
    gifView_Load = [[YFGIFImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 50, self.view.frame.size.height/2 - 50, 100, 100)];
    gifView_Load.backgroundColor = [UIColor clearColor];
    gifView_Load.gifData = gifData_Load;
    [self.view addSubview:gifView_Load];
    gifView_Load.hidden = YES;
    gifView_Load.userInteractionEnabled = YES;
    
    [self getMemList];
}

- (void)getMemList{
    gifView_Load.hidden = NO;
    [gifView_Load startGIF];
    [gifView_Load startAnimating];
    
    NSString *isFirstLogin = [[NSUserDefaults standardUserDefaults] objectForKey:@"isLoginState"];
    if ([isFirstLogin isEqualToString:@"NO"]) {
        NSDictionary *parameters = @{@"userid":@"0",
                                     };
        
        [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
        [[GlobalPool sharedInstance].OAuth2Manager POST:LC_MEMBER_LIST parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //        NSLog(@"%@",responseObject);
            gifView_Load.hidden = YES;
            [gifView_Load stopGIF];
            [gifView_Load stopAnimating];
            
            //memListArray = [NSMutableArray arrayWithArray:[responseObject objectForKey:@"playerlist"]];
            totalArray = [NSMutableArray arrayWithArray:[responseObject objectForKey:@"teacherlist"]];
            [totalArray addObjectsFromArray:[responseObject objectForKey:@"playerlist"]];
            
            NSString *path = [[totalArray objectAtIndex:memDetailNum] objectForKey:@"photourl"];
            [memDetailImg setImageWithURL:[NSURL URLWithString:path]];
            name_Lbl.text = [[totalArray objectAtIndex:memDetailNum] objectForKey:@"name"];
            mem_Num.text = [[totalArray objectAtIndex:memDetailNum] objectForKey:@"number"];
            
            [smallListSwipeView reloadData];
            [largeListSwipeView reloadData];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            gifView_Load.hidden = YES;
            [gifView_Load stopGIF];
            [gifView_Load stopAnimating];
            [SVProgressHUD showErrorWithStatus:@"Connection failed"];
        }];
    }
    else{
        NSString *userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"];
        NSDictionary *parameters = @{@"userid":userid,
                                     };
        
        [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
        [[GlobalPool sharedInstance].OAuth2Manager POST:LC_MEMBER_LIST parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //        NSLog(@"%@",responseObject);
            gifView_Load.hidden = YES;
            [gifView_Load stopGIF];
            [gifView_Load stopAnimating];
            
            //memListArray = [NSMutableArray arrayWithArray:[responseObject objectForKey:@"playerlist"]];
            totalArray = [NSMutableArray arrayWithArray:[responseObject objectForKey:@"teacherlist"]];
            [totalArray addObjectsFromArray:[responseObject objectForKey:@"playerlist"]];
            
            NSString *path = [[totalArray objectAtIndex:memDetailNum] objectForKey:@"photourl"];
            [memDetailImg setImageWithURL:[NSURL URLWithString:path]];
            name_Lbl.text = [[totalArray objectAtIndex:memDetailNum] objectForKey:@"name"];
            mem_Num.text = [[totalArray objectAtIndex:memDetailNum] objectForKey:@"number"];
            
            [smallListSwipeView reloadData];
            [largeListSwipeView reloadData];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            gifView_Load.hidden = YES;
            [gifView_Load stopGIF];
            [gifView_Load stopAnimating];
            [SVProgressHUD showErrorWithStatus:@"Connection failed"];
        }];
    }
    
}

#pragma mark -
#pragma mark iCarousel methods
- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{
    //return the total number of items in the carousel
    return totalArray.count;
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    if (swipeView == largeListSwipeView) {
        UIImageView *photoView = nil;
        UILabel     *nameLbl = nil;
        UILabel     *numberLbl = nil;
        
        //create new view if no view is available for recycling
        if (view == nil)
        {
            view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, smallListSwipeView.width, smallListSwipeView.height)];
            view.backgroundColor = [UIColor clearColor];
            view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            
            photoView = [[UIImageView alloc] initWithFrame:CGRectMake(prev_btn.frame.origin.x + 40, 40, (self.view.frame.size.height - 300)/2, self.view.frame.size.height - 300)];
            photoView.backgroundColor = [UIColor clearColor];
            photoView.contentMode = UIViewContentModeScaleAspectFit;
            photoView.tag = kItemStartTag + 2;
            
            nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(photoView.frame.origin.x + photoView.frame.size.width, photoView.frame.origin.y + 50, 100, 20)];
            nameLbl.backgroundColor = [UIColor clearColor];
            nameLbl.textColor = [UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0];
            nameLbl.font = [UIFont boldSystemFontOfSize:18.0];
            nameLbl.textAlignment = NSTextAlignmentLeft;
            nameLbl.tag = kItemStartTag;
            
            numberLbl = [[UILabel alloc] initWithFrame:CGRectMake(photoView.frame.origin.x + photoView.frame.size.width - 10, photoView.frame.origin.y + photoView.frame.size.height - 80, 80, 50)];
            numberLbl.backgroundColor = [UIColor clearColor];
            numberLbl.textColor = [UIColor blackColor];
            numberLbl.font = [UIFont boldSystemFontOfSize:54.0];
            numberLbl.textAlignment = NSTextAlignmentCenter;
            numberLbl.tag = kItemStartTag + 1;
            
            [view addSubview:nameLbl];
            [view addSubview:numberLbl];
            [view addSubview:photoView];
        }
        else
        {
            //get a reference to the label in the recycled view
            nameLbl = (UILabel *)[view viewWithTag:kItemStartTag];
            numberLbl = (UILabel *)[view viewWithTag:kItemStartTag+1];
            photoView = (UIImageView *)[view viewWithTag:kItemStartTag+2];
        }
        
        nameLbl.text = [[totalArray objectAtIndex:index] objectForKey:@"name"];
        numberLbl.text = [[totalArray objectAtIndex:index] objectForKey:@"number"];
        NSString *path = [[totalArray objectAtIndex:index] objectForKey:@"photourl"];
        [photoView setImageWithURL:[NSURL URLWithString:path]];
    }
    else{
        UIImageView *photoView = nil;
        UILabel     *nameLbl = nil;
        UIImageView *backImg = nil;
        
        //create new view if no view is available for recycling
        if (view == nil)
        {
            view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, smallListSwipeView.width/4, smallListSwipeView.height)];
            view.backgroundColor = [UIColor clearColor];
            view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            
            nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, view.width, 20)];
            nameLbl.backgroundColor = [UIColor clearColor];
            nameLbl.textColor = [UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0];
            nameLbl.font = [UIFont systemFontOfSize:15.0];
            nameLbl.textAlignment = NSTextAlignmentCenter;
            nameLbl.tag = kItemStartTag;
            
            backImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 25, view.width, view.height - 25)];
            backImg.backgroundColor = [UIColor clearColor];
            backImg.image = [UIImage imageNamed:@"memBack.png"];
            backImg.tag = kItemStartTag + 1;
            
            photoView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 30, view.width - 20, view.height - 35)];
            photoView.backgroundColor = [UIColor clearColor];
            photoView.contentMode = UIViewContentModeScaleAspectFit;
            photoView.tag = kItemStartTag + 2;
            
            [view addSubview:nameLbl];
            [view addSubview:backImg];
            [view addSubview:photoView];
        }
        else
        {
            //get a reference to the label in the recycled view
            nameLbl = (UILabel *)[view viewWithTag:kItemStartTag];
            backImg = (UIImageView *)[view viewWithTag:kItemStartTag+1];
            photoView = (UIImageView *)[view viewWithTag:kItemStartTag+2];
        }
        
        nameLbl.text = [[totalArray objectAtIndex:index] objectForKey:@"name"];
        NSString *path = [[totalArray objectAtIndex:index] objectForKey:@"thumburl"];
        [photoView setImageWithURL:[NSURL URLWithString:path]];
    }
    
    return view;
}

- (CGSize)swipeViewItemSize:(SwipeView *)swipeView
{
    if (swipeView == largeListSwipeView) {
        return CGSizeMake(largeListSwipeView.width, largeListSwipeView.height);
    }
    return CGSizeMake(smallListSwipeView.width/4, smallListSwipeView.height);
}

- (void)swipeViewCurrentItemIndexDidChange:(SwipeView *)swipeView{
    if (swipeView == largeListSwipeView) {
        memDetailNum = swipeView.currentItemIndex;
        
        if (memDetailNum == 0) {
            prev_btn.hidden = YES;
        }
        else{
            prev_btn.hidden = NO;
        }
        
        if (memDetailNum == totalArray.count - 1) {
            next_btn.hidden = YES;
        }
        else{
            next_btn.hidden = NO;
        }
        
        if (memDetailNum == totalArray.count || memDetailNum == totalArray.count - 1 || memDetailNum == totalArray.count - 2 || memDetailNum == totalArray.count - 3 || memDetailNum == totalArray.count - 4) {
            [smallListSwipeView scrollToItemAtIndex:totalArray.count - 4 duration:0.5];
        }
        else if (memDetailNum == 0 || memDetailNum == 1 || memDetailNum == 2){
            [smallListSwipeView scrollToItemAtIndex:0 duration:0.5];
        }
        else{
            [smallListSwipeView scrollToItemAtIndex:memDetailNum duration:0.5];
        }
    }
    else{
        NSLog(@"%d", (int)swipeView.currentItemIndex);
        
//        [largeListSwipeView scrollToItemAtIndex:memDetailNum duration:0.5];
    }
}

- (void)swipeView:(SwipeView *)swipeView didSelectItemAtIndex:(NSInteger)index {
    if (swipeView == smallListSwipeView) {
        NSString *path = [[totalArray objectAtIndex:index] objectForKey:@"photourl"];
        [memDetailImg setImageWithURL:[NSURL URLWithString:path]];
        name_Lbl.text = [[totalArray objectAtIndex:index] objectForKey:@"name"];
        mem_Num.text = [[totalArray objectAtIndex:index] objectForKey:@"number"];
        
        memDetailNum = index;
        
        if (memDetailNum == 0) {
            prev_btn.hidden = YES;
        }
        else{
            prev_btn.hidden = NO;
        }
        
        if (memDetailNum == memListArray.count - 1) {
            next_btn.hidden = YES;
        }
        else{
            next_btn.hidden = NO;
        }
        
        [largeListSwipeView scrollToItemAtIndex:index duration:0.5];
    }
    else{
        memDetailNum = index;
        MemDetailViewController *detailView = [[MemDetailViewController alloc] init];
        
        detailView.str_Name = [[totalArray objectAtIndex:memDetailNum] objectForKey:@"name"];
        detailView.str_PhotoURL = [[totalArray objectAtIndex:memDetailNum] objectForKey:@"photourl"];
        detailView.str_Pos = [[totalArray objectAtIndex:memDetailNum] objectForKey:@"birthday"];
        detailView.str_Height = [[totalArray objectAtIndex:memDetailNum] objectForKey:@"height"];
        detailView.str_Weight = [[totalArray objectAtIndex:memDetailNum] objectForKey:@"weight"];
        detailView.str_Spec = [[totalArray objectAtIndex:memDetailNum] objectForKey:@"role"];
        detailView.str_VideoURL = [[totalArray objectAtIndex:memDetailNum] objectForKey:@"videourl"];
        detailView.str_Detail = [[totalArray objectAtIndex:memDetailNum] objectForKey:@"speciality"];
        
        [self.navigationController pushViewController:detailView animated:YES];
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
        [gifView_Load removeFromSuperview];
        
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

- (void)previousBtnClicked{
    memDetailNum = memDetailNum - 1;
    
    [largeListSwipeView scrollToItemAtIndex:memDetailNum duration:0.5];
    
    if (memDetailNum < 0) {
        memDetailNum = memDetailNum + 1;
    }
    
    NSString *path = [[totalArray objectAtIndex:memDetailNum] objectForKey:@"photourl"];
    [memDetailImg setImageWithURL:[NSURL URLWithString:path]];
    name_Lbl.text = [[totalArray objectAtIndex:memDetailNum] objectForKey:@"name"];
    mem_Num.text = [[totalArray objectAtIndex:memDetailNum] objectForKey:@"number"];
    
    if (memDetailNum == 0) {
        prev_btn.hidden = YES;
    }
    else{
        prev_btn.hidden = NO;
    }
    
    if (memDetailNum == totalArray.count - 1) {
        next_btn.hidden = YES;
    }
    else{
        next_btn.hidden = NO;
    }
}

- (void)nextBtnClicked{
    memDetailNum = memDetailNum + 1;
    
    [largeListSwipeView scrollToItemAtIndex:memDetailNum duration:0.5];
    
    if (memDetailNum > totalArray.count - 1) {
        memDetailNum = memDetailNum - 1;
    }
    
    NSString *path = [[totalArray objectAtIndex:memDetailNum] objectForKey:@"photourl"];
    [memDetailImg setImageWithURL:[NSURL URLWithString:path]];
    name_Lbl.text = [[totalArray objectAtIndex:memDetailNum] objectForKey:@"name"];
    mem_Num.text = [[totalArray objectAtIndex:memDetailNum] objectForKey:@"number"];
    
    if (memDetailNum == 0) {
        prev_btn.hidden = YES;
    }
    else{
        prev_btn.hidden = NO;
    }
    
    if (memDetailNum == totalArray.count - 1) {
        next_btn.hidden = YES;
    }
    else{
        next_btn.hidden = NO;
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
