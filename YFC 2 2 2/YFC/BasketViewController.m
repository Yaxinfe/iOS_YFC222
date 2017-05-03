//
//  BasketViewController.m
//  YFC
//
//  Created by topone on 9/3/15.
//  Copyright (c) 2015 ming. All rights reserved.
//

#import "BasketViewController.h"
#import "RecordViewController.h"

#import "publicHeaders.h"

#import "BuyViewController.h"

@interface BasketViewController ()<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
{
    UITableView *basketTable;
    NSMutableArray *basketArray;
    
    UIButton *allCheckBtn;
    UILabel  *countLabel;
    
    NSMutableArray *checkArray;
    
    BOOL isAllCheck;
}
@end

@implementation BasketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    basketArray = [[NSMutableArray alloc] init];
    checkArray = [[NSMutableArray alloc] init];
    
    isAllCheck = NO;
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
    
    basketTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 70, self.view.frame.size.width, self.view.frame.size.height - 150) style:UITableViewStylePlain];
    basketTable.dataSource = self;
    basketTable.delegate = self;
    [basketTable setBackgroundColor:[UIColor clearColor]];
    basketTable.userInteractionEnabled=YES;
    [basketTable setAllowsSelection:YES];
    if ([basketTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [basketTable setSeparatorInset:UIEdgeInsetsZero];
    }
    [basketTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:basketTable];
    
    UIImageView *lineImg1 =[UIImageView new];
    lineImg1.frame=CGRectMake(2, self.view.frame.size.height - 61, self.view.frame.size.width - 4, 1);
    lineImg1.clipsToBounds = YES;
    lineImg1.userInteractionEnabled=YES;
    lineImg1.backgroundColor = [UIColor colorWithRed:65.0/255.0 green:111.0/255.0 blue:155.0/255.0 alpha:1.0];
    [self.view addSubview:lineImg1];
    
    allCheckBtn = [[UIButton alloc] init];
    [allCheckBtn setFrame:CGRectMake(5, self.view.frame.size.height - 40, 24, 24)];
    [allCheckBtn addTarget:self action:@selector(allCheckBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [allCheckBtn setImage:[UIImage imageNamed:@"uncheckBtn.png"] forState:UIControlStateNormal];
    [allCheckBtn setTintColor:[UIColor lightGrayColor]];
    allCheckBtn.alpha = 1.0;
    allCheckBtn.transform = CGAffineTransformMakeTranslation(10, 0);
    [self.view addSubview:allCheckBtn];
    
    UILabel *totalLbl = [[UILabel alloc] initWithFrame:CGRectMake(40, self.view.frame.size.height - 40, 40, 24)];
//    totalLbl.text = @"全 选";
    totalLbl.font = [UIFont systemFontOfSize:16.0];
    totalLbl.textAlignment = NSTextAlignmentCenter;
    totalLbl.textColor = [UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0];
    [self.view addSubview:totalLbl];
    
    UILabel *totalCountLbl = [[UILabel alloc] initWithFrame:CGRectMake(90, self.view.frame.size.height - 40, 50, 24)];
//    totalCountLbl.text = @"合 计:";
    totalCountLbl.font = [UIFont systemFontOfSize:16.0];
    totalCountLbl.textAlignment = NSTextAlignmentCenter;
    totalCountLbl.textColor = [UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0];
    [self.view addSubview:totalCountLbl];
    
    UIImageView *dballImg = [[UIImageView alloc] initWithFrame:CGRectMake(totalCountLbl.frame.origin.x + totalCountLbl.frame.size.width + 5, totalCountLbl.frame.origin.y, 24, 24)];
    dballImg.image = [UIImage imageNamed:@"blueBall.png"];
    [self.view addSubview:dballImg];
    
    countLabel = [[UILabel alloc] initWithFrame:CGRectMake(dballImg.frame.origin.x + dballImg.frame.size.width + 10, dballImg.frame.origin.y, 100, 24)];
    countLabel.font = [UIFont systemFontOfSize:16.0];
    countLabel.textAlignment = NSTextAlignmentLeft;
    countLabel.textColor = [UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0];
    countLabel.text = @"0";
    [self.view addSubview:countLabel];
    
    UIButton *gumaeBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 110, self.view.frame.size.height - 60, 100, 60)];
    [gumaeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [gumaeBtn setBackgroundImage:[UIImage imageNamed:@"addBasketBtnBack.png"] forState:UIControlStateNormal];
    [gumaeBtn addTarget:self action:@selector(gumaeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [gumaeBtn setTintColor:[UIColor lightGrayColor]];
    gumaeBtn.alpha = 1.0;
    gumaeBtn.transform = CGAffineTransformMakeTranslation(10, 0);
    [self.view addSubview:gumaeBtn];
    
    NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
    if ([applang isEqualToString:@"ko"]) {
        titleLbl.text = BASKET_TITLE[0];
        totalLbl.text = BASKET_ENTIRE_SELECT[0];
        totalCountLbl.text = BASKET_TOTAL[0];
        [gumaeBtn setTitle:BASKET_BUY_BUTTON[0] forState:UIControlStateNormal];
    }
    if ([applang isEqualToString:@"cn"]) {
        titleLbl.text = BASKET_TITLE[1];
        totalLbl.text = BASKET_ENTIRE_SELECT[1];
        totalCountLbl.text = BASKET_TOTAL[1];
        [gumaeBtn setTitle:BASKET_BUY_BUTTON[1] forState:UIControlStateNormal];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [allCheckBtn setImage:[UIImage imageNamed:@"uncheckBtn.png"] forState:UIControlStateNormal];
    isAllCheck = NO;
    
    int count = (int)checkArray.count;
    [checkArray removeAllObjects];
    
    for (int i = 0; i< count; i++) {
        [checkArray addObject:@"NO"];
    }
    
    countLabel.text = @"";
    
    [self getBasketList];
}

- (void)gumaeBtnClicked{
    NSMutableArray *selectArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < checkArray.count; i++) {
        if ([[checkArray objectAtIndex:i] isEqualToString:@"YES"]) {
            [selectArray addObject:[basketArray objectAtIndex:i]];
        }
    }
    
    if (selectArray.count == 0) {
        NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
        if ([applang isEqualToString:@"ko"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"상품을 선택하세요." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        if ([applang isEqualToString:@"cn"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请选择商品." delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    }
    else{
        BuyViewController *buy_view = [[BuyViewController alloc] init];
        buy_view.selectedArray = selectArray;
        [self.navigationController pushViewController:buy_view animated:YES];
    }
}

-(void)getBasketList{
    NSString *userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"];
    NSString *sessionkey = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionkey"];
    
    NSDictionary *parameters = @{@"userid":userid,
                                 @"sessionkey":sessionkey,
                                 @"lastid":@"0"
                                 };
    
    [SVProgressHUD showWithStatus:@"请稍后..." maskType:SVProgressHUDMaskTypeBlack];
    
    [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
    [[GlobalPool sharedInstance].OAuth2Manager POST:LC_SHOP_BASKETLIST parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"%@",responseObject);
        
        [SVProgressHUD dismiss];
        
        NSString *status = [responseObject objectForKey:@"status"];
        
        if ([status intValue] == 200) {
            basketArray = [NSMutableArray arrayWithArray:[responseObject objectForKey:@"result"]];
            [basketTable reloadData];
            
            for (int i = 0; i < basketArray.count; i++) {
                [checkArray addObject:@"NO"];
            }
            
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

#pragma mark - tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return basketArray.count;
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
    
    UIButton *checkBtn = [[UIButton alloc] init];
    [checkBtn setFrame:CGRectMake(5, 47, 26, 26)];
    if (![[checkArray objectAtIndex:indexPath.row] isEqualToString:@"NO"]) {
        [checkBtn setImage:[UIImage imageNamed:@"checkBtn.png"] forState:UIControlStateNormal];
    }
    else{
        [checkBtn setImage:[UIImage imageNamed:@"uncheckBtn.png"] forState:UIControlStateNormal];
    }
    [checkBtn setTintColor:[UIColor lightGrayColor]];
    checkBtn.alpha = 1.0;
    checkBtn.transform = CGAffineTransformMakeTranslation(10, 0);
    [cell.contentView addSubview:checkBtn];
    
    UIImageView *mainImage =[UIImageView new];
    mainImage.frame=CGRectMake(50, 10, 90, 100);
    mainImage.clipsToBounds = YES;
    mainImage.userInteractionEnabled=YES;
    mainImage.layer.cornerRadius = 1;
    mainImage.layer.borderColor = [UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0].CGColor;
    mainImage.layer.borderWidth = 1;
    mainImage.layer.masksToBounds = YES;
    mainImage.backgroundColor = [UIColor whiteColor];
    [cell.contentView addSubview:mainImage];
    
    UILabel *lbl_Title = [[UILabel alloc]init];
    [lbl_Title setFrame:CGRectMake(150, 5, self.view.frame.size.width - 160, 40)];
    [lbl_Title setTextAlignment:NSTextAlignmentLeft];
    [lbl_Title setTextColor:[UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0]];
    [lbl_Title setBackgroundColor:[UIColor clearColor]];
    [lbl_Title setFont:[UIFont systemFontOfSize:14.0]];
    lbl_Title.numberOfLines = 2;
    [cell.contentView addSubview:lbl_Title];
    
    UILabel *lbl_Color = [[UILabel alloc]init];
    [lbl_Color setFrame:CGRectMake(150, 55, self.view.frame.size.width - 150, 20)];
    [lbl_Color setTextAlignment:NSTextAlignmentLeft];
    [lbl_Color setTextColor:[UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0]];
    [lbl_Color setBackgroundColor:[UIColor clearColor]];
    [lbl_Color setFont:[UIFont systemFontOfSize:14.0]];
    [cell.contentView addSubview:lbl_Color];
    
    UIImageView *ballImage =[UIImageView new];
    ballImage.frame=CGRectMake(150, 90, 20, 20);
    ballImage.image = [UIImage imageNamed:@"blueBall.png"];
    ballImage.clipsToBounds = YES;
    ballImage.userInteractionEnabled=YES;
    ballImage.backgroundColor = [UIColor whiteColor];
    [cell.contentView addSubview:ballImage];
    
    UILabel *lbl_BallCount = [[UILabel alloc]init];
    [lbl_BallCount setFrame:CGRectMake(ballImage.frame.origin.x + ballImage.frame.size.width + 10, 90, self.view.frame.size.width - 150, 20)];
    [lbl_BallCount setTextAlignment:NSTextAlignmentLeft];
    [lbl_BallCount setTextColor:[UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0]];
    [lbl_BallCount setBackgroundColor:[UIColor clearColor]];
    [lbl_BallCount setFont:[UIFont systemFontOfSize:14.0]];
    [cell.contentView addSubview:lbl_BallCount];
    
    UIButton *plusBtn = [[UIButton alloc] init];
    [plusBtn setFrame:CGRectMake(self.view.frame.size.width - 50, 80, 35, 30)];
    [plusBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [plusBtn setTitle:@"+" forState:UIControlStateNormal];
    [plusBtn setTintColor:[UIColor lightGrayColor]];
    plusBtn.alpha = 1.0;
    plusBtn.transform = CGAffineTransformMakeTranslation(10, 0);
    plusBtn.tag = indexPath.row + 200;
    plusBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    plusBtn.layer.borderWidth = 1;
    plusBtn.layer.masksToBounds = YES;
    [plusBtn addTarget:self action:@selector(plusBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:plusBtn];
    
    UILabel *lbl_Count = [[UILabel alloc]init];
    [lbl_Count setFrame:CGRectMake(self.view.frame.size.width - 79, 80, 40, 30)];
    [lbl_Count setTextAlignment:NSTextAlignmentCenter];
    [lbl_Count setTextColor:[UIColor blackColor]];
    [lbl_Count setBackgroundColor:[UIColor clearColor]];
    [lbl_Count setFont:[UIFont systemFontOfSize:17.0]];
    lbl_Count.layer.borderColor = [UIColor lightGrayColor].CGColor;
    lbl_Count.layer.borderWidth = 1;
    lbl_Count.layer.masksToBounds = YES;
    [cell.contentView addSubview:lbl_Count];
    
    UIButton *minBtn = [[UIButton alloc] init];
    [minBtn setFrame:CGRectMake(self.view.frame.size.width - 123, 80, 35, 30)];
    [minBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [minBtn setTitle:@"-" forState:UIControlStateNormal];
    [minBtn setTintColor:[UIColor lightGrayColor]];
    minBtn.alpha = 1.0;
    minBtn.transform = CGAffineTransformMakeTranslation(10, 0);
    minBtn.tag = indexPath.row + 300;
    minBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    minBtn.layer.borderWidth = 1;
    minBtn.layer.masksToBounds = YES;
    [minBtn addTarget:self action:@selector(minBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:minBtn];
    
    UIImageView *lineImg =[UIImageView new];
    lineImg.frame=CGRectMake(2, 119, self.view.frame.size.width - 4, 1);
    lineImg.clipsToBounds = YES;
    lineImg.userInteractionEnabled=YES;
    lineImg.backgroundColor = [UIColor colorWithRed:65.0/255.0 green:111.0/255.0 blue:155.0/255.0 alpha:1.0];
    [cell.contentView addSubview:lineImg];
    
    lbl_Title.text = [[basketArray objectAtIndex:indexPath.row] objectForKey:@"title"];
    lbl_Color.text = [[basketArray objectAtIndex:indexPath.row] objectForKey:@"color"];
    lbl_BallCount.text = [[basketArray objectAtIndex:indexPath.row] objectForKey:@"price"];
    lbl_Count.text = [[basketArray objectAtIndex:indexPath.row] objectForKey:@"number"];
    
    if ([lbl_Count.text isEqualToString:@"1"]) {
        [minBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        minBtn.enabled = NO;
    }
    
    NSString *path = [[basketArray objectAtIndex:indexPath.row] objectForKey:@"mainurl"];
    [mainImage setImageWithURL:[NSURL URLWithString:path]];
    
    checkBtn.tag = indexPath.row;
    [checkBtn addTarget:self action:@selector(checkBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

-(void)delBtnClicked:(id)sender{
    UIButton *btn = (UIButton *)sender;
    
    NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
    if ([applang isEqualToString:@"ko"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"정말 삭제하시겠습니까?" delegate:self cancelButtonTitle:@"예" otherButtonTitles:@"아니", nil];
        alert.tag = btn.tag;
        [alert show];
    }
    if ([applang isEqualToString:@"cn"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"确认删除?" delegate:self cancelButtonTitle:@"是" otherButtonTitles:@"否", nil];
        alert.tag = btn.tag;
        [alert show];
    }
}

-(void)minBtnClicked:(id)sender{
    UIButton *btn = (UIButton *)sender;
    
    NSString *number = [[basketArray objectAtIndex:btn.tag - 300] objectForKey:@"number"];
    NSString *changeNum = [NSString stringWithFormat:@"%d", [number intValue] - 1];
    
    if ([changeNum isEqualToString:@"0"]) {
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        btn.enabled = NO;
    }
    else{
        NSDictionary *object = @{@"cartid": [[basketArray objectAtIndex:btn.tag - 300] objectForKey:@"cartid"],
                                 @"cdate": [[basketArray objectAtIndex:btn.tag - 300] objectForKey:@"cdate"],
                                 @"color": [[basketArray objectAtIndex:btn.tag - 300] objectForKey:@"color"],
                                 @"colorid": [[basketArray objectAtIndex:btn.tag - 300] objectForKey:@"colorid"],
                                 @"detailpid": [[basketArray objectAtIndex:btn.tag - 300] objectForKey:@"detailpid"],
                                 @"itemid": [[basketArray objectAtIndex:btn.tag - 300] objectForKey:@"itemid"],
                                 @"mainurl": [[basketArray objectAtIndex:btn.tag - 300] objectForKey:@"mainurl"],
                                 @"number": changeNum,
                                 @"pid": [[basketArray objectAtIndex:btn.tag - 300] objectForKey:@"pid"],
                                 @"price": [[basketArray objectAtIndex:btn.tag - 300] objectForKey:@"price"],
                                 @"remain": [[basketArray objectAtIndex:btn.tag - 300] objectForKey:@"remain"],
                                 @"size": [[basketArray objectAtIndex:btn.tag - 300] objectForKey:@"size"],
                                 @"sizeid": [[basketArray objectAtIndex:btn.tag - 300] objectForKey:@"sizeid"],
                                 @"title": [[basketArray objectAtIndex:btn.tag - 300] objectForKey:@"title"],
                                 @"url": [[basketArray objectAtIndex:btn.tag - 300] objectForKey:@"url"],
                                 @"brate": [[basketArray objectAtIndex:btn.tag - 300] objectForKey:@"brate"],
                                 @"bulk": [[basketArray objectAtIndex:btn.tag - 300] objectForKey:@"bulk"],
                                 @"chargeflag": [[basketArray objectAtIndex:btn.tag - 300] objectForKey:@"chargeflag"],
                                 @"initfare": [[basketArray objectAtIndex:btn.tag - 300] objectForKey:@"initfare"],
                                 @"weight": [[basketArray objectAtIndex:btn.tag - 300] objectForKey:@"weight"],
                                 @"wrate": [[basketArray objectAtIndex:btn.tag - 300] objectForKey:@"wrate"]
                                 };
        
        [basketArray replaceObjectAtIndex:btn.tag - 300 withObject:object];
        [basketTable reloadData];
    
        int totalNumber = 0;
        for (int i = 0; i < checkArray.count; i++) {
            if ([[checkArray objectAtIndex:i] isEqualToString:@"YES"]) {
                NSString *price = [[basketArray objectAtIndex:i] objectForKey:@"price"];
                NSString *number = [[basketArray objectAtIndex:i] objectForKey:@"number"];
                
                totalNumber = totalNumber + [price intValue]*[number intValue];
            }
        }
        countLabel.text = [NSString stringWithFormat:@"%d", totalNumber];
    }
}

-(void)plusBtnClicked:(id)sender{
    UIButton *btn = (UIButton *)sender;
    
    NSString *totalNum = [[basketArray objectAtIndex:btn.tag - 200] objectForKey:@"remain"];
    NSString *number = [[basketArray objectAtIndex:btn.tag - 200] objectForKey:@"number"];
    NSString *changeNum = [NSString stringWithFormat:@"%d", [number intValue] + 1];
    
    if ([changeNum intValue] > [totalNum intValue]) {
        
    }
    else{
        NSDictionary *object = @{@"cartid": [[basketArray objectAtIndex:btn.tag - 200] objectForKey:@"cartid"],
                                 @"cdate": [[basketArray objectAtIndex:btn.tag - 200] objectForKey:@"cdate"],
                                 @"color": [[basketArray objectAtIndex:btn.tag - 200] objectForKey:@"color"],
                                 @"colorid": [[basketArray objectAtIndex:btn.tag - 200] objectForKey:@"colorid"],
                                 @"detailpid": [[basketArray objectAtIndex:btn.tag - 200] objectForKey:@"detailpid"],
                                 @"itemid": [[basketArray objectAtIndex:btn.tag - 200] objectForKey:@"itemid"],
                                 @"mainurl": [[basketArray objectAtIndex:btn.tag - 200] objectForKey:@"mainurl"],
                                 @"number": changeNum,
                                 @"pid": [[basketArray objectAtIndex:btn.tag - 200] objectForKey:@"pid"],
                                 @"price": [[basketArray objectAtIndex:btn.tag - 200] objectForKey:@"price"],
                                 @"remain": [[basketArray objectAtIndex:btn.tag - 200] objectForKey:@"remain"],
                                 @"size": [[basketArray objectAtIndex:btn.tag - 200] objectForKey:@"size"],
                                 @"sizeid": [[basketArray objectAtIndex:btn.tag - 200] objectForKey:@"sizeid"],
                                 @"title": [[basketArray objectAtIndex:btn.tag - 200] objectForKey:@"title"],
                                 @"url": [[basketArray objectAtIndex:btn.tag - 200] objectForKey:@"url"],
                                 @"brate": [[basketArray objectAtIndex:btn.tag - 200] objectForKey:@"brate"],
                                 @"bulk": [[basketArray objectAtIndex:btn.tag - 200] objectForKey:@"bulk"],
                                 @"chargeflag": [[basketArray objectAtIndex:btn.tag - 200] objectForKey:@"chargeflag"],
                                 @"initfare": [[basketArray objectAtIndex:btn.tag - 200] objectForKey:@"initfare"],
                                 @"weight": [[basketArray objectAtIndex:btn.tag - 200] objectForKey:@"weight"],
                                 @"wrate": [[basketArray objectAtIndex:btn.tag - 200] objectForKey:@"wrate"]
                                 };
        
        [basketArray replaceObjectAtIndex:btn.tag - 200 withObject:object];
        [basketTable reloadData];
        
        int totalNumber = 0;
        for (int i = 0; i < checkArray.count; i++) {
            if ([[checkArray objectAtIndex:i] isEqualToString:@"YES"]) {
                NSString *price = [[basketArray objectAtIndex:i] objectForKey:@"price"];
                NSString *number = [[basketArray objectAtIndex:i] objectForKey:@"number"];
                
                totalNumber = totalNumber + [price intValue]*[number intValue];
            }
        }
        countLabel.text = [NSString stringWithFormat:@"%d", totalNumber];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        NSString *userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"];
        NSString *sessionkey = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionkey"];
        
        NSDictionary *parameters = @{@"userid":userid,
                                     @"cartid":[[basketArray objectAtIndex:alertView.tag - 100] objectForKey:@"cartid"],
                                     @"sessionkey":sessionkey
                                     };
        
        [SVProgressHUD showWithStatus:@"请稍后..." maskType:SVProgressHUDMaskTypeBlack];
        
        [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
        [[GlobalPool sharedInstance].OAuth2Manager POST:LC_SHOP_DELETEBASKET parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            NSLog(@"%@",responseObject);
            
            NSString *status = [responseObject objectForKey:@"status"];
            
            if ([status intValue] == 200) {
                [self getBasketList];
                NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
                if ([applang isEqualToString:@"ko"]) {
                    [ProgressHUD showSuccess:@"삭제!"];
                }
                if ([applang isEqualToString:@"cn"]) {
                    [ProgressHUD showSuccess:@"删除!"];
                }
            }
            else if ([status intValue] == 1001) {
                NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:@"NO" forKey:@"isLoginState"];
                [defaults synchronize];
                [[AppDelegate sharedAppDelegate] runMain];
            }
            else{
              
            }
            
            [SVProgressHUD dismiss];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"Connection failed"];
        }];
    }
    else{
        
    }
    
}

-(void)checkBtnClicked:(id)sender{
    UIButton *btn = (UIButton *)sender;
    
    if ([[checkArray objectAtIndex:btn.tag] isEqualToString:@"NO"]) {
        [checkArray removeObjectAtIndex:btn.tag];
        [checkArray insertObject:@"YES" atIndex:btn.tag];
    }
    else{
        [checkArray removeObjectAtIndex:btn.tag];
        [checkArray insertObject:@"NO" atIndex:btn.tag];
    }
    
    int nTotalNumber = 0;
    for (int i = 0; i < checkArray.count; i++) {
        if ([[checkArray objectAtIndex:i] isEqualToString:@"YES"]) {
            NSString *price = [[basketArray objectAtIndex:i] objectForKey:@"price"];
            NSString *number = [[basketArray objectAtIndex:i] objectForKey:@"number"];

            nTotalNumber = nTotalNumber + [price intValue]*[number intValue];
        }
    }
    countLabel.text = [NSString stringWithFormat:@"%d", nTotalNumber];
    
    [basketTable reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
        if ([applang isEqualToString:@"ko"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"정말 삭제하시겠습니까?" delegate:self cancelButtonTitle:@"예" otherButtonTitles:@"아니", nil];
            alert.tag = indexPath.row + 100;
            [alert show];
        }
        if ([applang isEqualToString:@"cn"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"确认删除?" delegate:self cancelButtonTitle:@"是" otherButtonTitles:@"否", nil];
            alert.tag = indexPath.row + 100;
            [alert show];
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
    if ([applang isEqualToString:@"ko"]) {
        return @"삭제";
    }
    if ([applang isEqualToString:@"cn"]) {
        return @"删除";
    }
    return @"删除";
}

- (void)recordBtnClicked{
    RecordViewController *record_view = [[RecordViewController alloc] init];
    [self.navigationController pushViewController:record_view animated:YES];
}

-(void)backBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)allCheckBtnClicked{
    if (isAllCheck == YES) {
        [allCheckBtn setImage:[UIImage imageNamed:@"uncheckBtn.png"] forState:UIControlStateNormal];
        isAllCheck = NO;
        
        int count = (int)checkArray.count;
        [checkArray removeAllObjects];
        
        for (int i = 0; i< count; i++) {
            [checkArray addObject:@"NO"];
        }
        
        countLabel.text = @"0";
        
        [basketTable reloadData];
    }
    else{
        [allCheckBtn setImage:[UIImage imageNamed:@"checkBtn.png"] forState:UIControlStateNormal];
        isAllCheck = YES;
        
        int count = (int)checkArray.count;
        [checkArray removeAllObjects];
        
        for (int i = 0; i< count; i++) {
            [checkArray addObject:@"YES"];
        }
        
        int totalNumber = 0;
        for (int i = 0; i < basketArray.count; i++) {
            NSString *price = [[basketArray objectAtIndex:i] objectForKey:@"price"];
            NSString *number = [[basketArray objectAtIndex:i] objectForKey:@"number"];
            
            totalNumber = totalNumber + [price intValue]*[number intValue];
        }
        
        countLabel.text = [NSString stringWithFormat:@"%d", totalNumber];
        
        [basketTable reloadData];
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
