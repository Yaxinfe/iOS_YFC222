//
//  MenuViewController.m
//  YFC
//
//  Created by topone on 7/15/15.
//  Copyright (c) 2015 ming. All rights reserved.
//

#import "MenuViewController.h"
#import "BroadViewController.h"
#import "ShopDetailViewController.h"
#import "FanVoiceViewController.h"
#import "SettingViewController.h"
#import "GameViewController.h"
#import "MoneyViewController.h"
#import "MemListViewController.h"
#import "MainViewController.h"

#import "TheSidebarController.h"

#import "AppLanguage.h"

@interface MenuViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UICollectionView *_collectionView;
    
    UIScrollView *scrollView;
    
    NSMutableArray *listArray;
    NSMutableArray *imageArray;
    
    UILabel *titleLbl;
}
@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    imageArray = [NSMutableArray arrayWithObjects:@"newsBtn.png", @"clubBtn.png", @"broadcastBtn.png", @"fanBtn.png", @"gameBtn.png", @"shopBtn.png", @"payBtn.png", @"settingBtn.png", nil];
    
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    backImageView.image = [UIImage imageNamed:@"menuBackImg.png"];
    [self.view addSubview:backImageView];
    
    titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 80, 30, 80, 24)];
    titleLbl.font = [UIFont boldSystemFontOfSize:22.0];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.textColor = [UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0];
    [self.view addSubview:titleLbl];
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    scrollView.alwaysBounceHorizontal = NO;
    scrollView.alwaysBounceVertical = YES;
    
    NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
    if ([applang isEqualToString:@"ko"]) {
        titleLbl.text = MENU_TITLE[0];
        listArray = [NSMutableArray arrayWithObjects:MENU_NEWS[0], MENU_CLUB[0], MENU_BROADCAST[0], MENU_FANVOICE[0], MENU_GAME[0], MENU_FANSHOP[0], MENU_JANGRE[0], MENU_SETTING[0], nil];
    }
    if ([applang isEqualToString:@"cn"]) {
        titleLbl.text = MENU_TITLE[1];
        listArray = [NSMutableArray arrayWithObjects:MENU_NEWS[1], MENU_CLUB[1], MENU_BROADCAST[1], MENU_FANVOICE[1], MENU_GAME[1], MENU_FANSHOP[1], MENU_JANGRE[1], MENU_SETTING[1], nil];
    }
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    _collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 80, self.view.frame.size.width, self.view.frame.size.height) collectionViewLayout:layout];
    [_collectionView setDataSource:self];
    [_collectionView setDelegate:self];
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [_collectionView setBackgroundColor:[UIColor clearColor]];
    _collectionView.scrollEnabled = NO;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 3;
    [scrollView addSubview:_collectionView];
    
    [self.view addSubview:scrollView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLang) name:@"menuLangChange" object:nil];
}

- (void)changeLang{
    NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
    if ([applang isEqualToString:@"ko"]) {
        titleLbl.text = MENU_TITLE[0];
        listArray = [NSMutableArray arrayWithObjects:MENU_NEWS[0], MENU_CLUB[0], MENU_BROADCAST[0], MENU_FANVOICE[0], MENU_GAME[0], MENU_FANSHOP[0], MENU_JANGRE[0], MENU_SETTING[0], nil];
    }
    if ([applang isEqualToString:@"cn"]) {
        titleLbl.text = MENU_TITLE[1];
        listArray = [NSMutableArray arrayWithObjects:MENU_NEWS[1], MENU_CLUB[1], MENU_BROADCAST[1], MENU_FANVOICE[1], MENU_GAME[1], MENU_FANSHOP[1], MENU_JANGRE[1], MENU_SETTING[1], nil];
    }
    
    [_collectionView reloadData];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UICollectionView data source

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 8;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize retval;
    retval =  CGSizeMake(self.view.frame.size.width/3, self.view.frame.size.width/3);
    return retval;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    if (cell==nil)
    {
        cell.backgroundColor=[UIColor clearColor];
        
    }
    else
    {
        for (UIView *view in cell.contentView.subviews)
            [view removeFromSuperview];
    }
    
    UIImageView *back = [[UIImageView alloc] init];
    back.backgroundColor = [UIColor clearColor];
    back.frame = CGRectMake(cell.frame.size.width/2 - 40, 10, 80, 80);
    back.layer.cornerRadius = 40;
    back.layer.masksToBounds = YES;
    [cell.contentView addSubview:back];
    
    UILabel *lbl_title = [[UILabel alloc]initWithFrame:CGRectMake(cell.frame.size.width/2 - 35, back.frame.origin.y + back.frame.size.height + 3 , 70, 20)];
    [lbl_title setTextColor:[UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0]];
    [lbl_title setBackgroundColor:[UIColor clearColor]];
    [lbl_title setFont:[UIFont systemFontOfSize:15.0]];
    [lbl_title setTextAlignment:NSTextAlignmentCenter];
    [cell.contentView addSubview:lbl_title];
    
    back.image = [UIImage imageNamed:[imageArray objectAtIndex:indexPath.row]];
    lbl_title.text = [listArray objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        MainViewController *mainViewController = [[MainViewController alloc] init];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:mainViewController];
        navi.navigationBar.hidden = YES;
        self.sidebarController.contentViewController = navi;
        [self.sidebarController dismissSidebarViewController];
    }
    if (indexPath.row == 1) {
        MemListViewController *clubView = [[MemListViewController alloc] init];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:clubView];
        navi.navigationBar.hidden = YES;
        self.sidebarController.contentViewController = navi;
        [self.sidebarController dismissSidebarViewController];
    }
    if (indexPath.row == 2) {
        BroadViewController *clubView = [[BroadViewController alloc] init];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:clubView];
        navi.navigationBar.hidden = YES;
        self.sidebarController.contentViewController = navi;
        [self.sidebarController dismissSidebarViewController];
    }
    if (indexPath.row == 3) {
        FanVoiceViewController *clubView = [[FanVoiceViewController alloc] init];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:clubView];
        navi.navigationBar.hidden = YES;
        self.sidebarController.contentViewController = navi;
        [self.sidebarController dismissSidebarViewController];
    }
    if (indexPath.row == 4) {
        GameViewController *clubView = [[GameViewController alloc] init];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:clubView];
        navi.navigationBar.hidden = YES;
        self.sidebarController.contentViewController = navi;
        [self.sidebarController dismissSidebarViewController];
    }
    if (indexPath.row == 5) {
        ShopDetailViewController *clubView = [[ShopDetailViewController alloc] init];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:clubView];
        navi.navigationBar.hidden = YES;
        self.sidebarController.contentViewController = navi;
        [self.sidebarController dismissSidebarViewController];
    }
    if (indexPath.row == 6) {
        MoneyViewController *clubView = [[MoneyViewController alloc] init];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:clubView];
        navi.navigationBar.hidden = YES;
        self.sidebarController.contentViewController = navi;
        [self.sidebarController dismissSidebarViewController];
    }
    if (indexPath.row == 7) {
        SettingViewController *clubView = [[SettingViewController alloc] init];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:clubView];
        navi.navigationBar.hidden = YES;
        self.sidebarController.contentViewController = navi;
        [self.sidebarController dismissSidebarViewController];
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)backBtnClicked{
    [self.sidebarController dismissSidebarViewController];
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
