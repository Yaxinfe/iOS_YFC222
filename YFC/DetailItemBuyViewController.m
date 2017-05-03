//
//  DetailItemBuyViewController.m
//  YFC
//
//  Created by topone on 9/23/15.
//  Copyright (c) 2015 ming. All rights reserved.
//

#import "DetailItemBuyViewController.h"

#import "publicHeaders.h"
#import "EditAddressViewController.h"
#import "FillViewController.h"

@interface DetailItemBuyViewController ()<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
{
    UITableView *selectTable;
    
    UILabel *sendNameLbl;
    UILabel *sendPhoneLbl;
    UILabel *sendAddressLbl;
    
    UILabel *price_Lbl;
    UILabel *movePrice_Lbl;
    UILabel *countLbl;
    
    int totalCount;
}
@end

@implementation DetailItemBuyViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    totalCount = [_item_price intValue] * [_item_number intValue];
    
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
    
    UIImageView *lineImg9 =[UIImageView new];
    lineImg9.frame=CGRectMake(0, 63, self.view.frame.size.width, 2);
    lineImg9.clipsToBounds = YES;
    lineImg9.userInteractionEnabled=YES;
    lineImg9.backgroundColor = [UIColor colorWithRed:216.0/255.0 green:229.0/255.0 blue:241.0/255.0 alpha:1.0];
    [self.view addSubview:lineImg9];
    
    sendNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 70, 80, 20)];
    sendNameLbl.textColor = [UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0];
    sendNameLbl.backgroundColor = [UIColor clearColor];
    sendNameLbl.font = [UIFont systemFontOfSize:18.0];
    sendNameLbl.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:sendNameLbl];
    
    sendPhoneLbl = [[UILabel alloc] initWithFrame:CGRectMake(105, 70, 200, 20)];
    sendPhoneLbl.textColor = [UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0];
    sendPhoneLbl.backgroundColor = [UIColor clearColor];
    sendPhoneLbl.font = [UIFont systemFontOfSize:18.0];
    sendPhoneLbl.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:sendPhoneLbl];
    
    sendAddressLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 300, 20)];
    sendAddressLbl.textColor = [UIColor lightGrayColor];
    sendAddressLbl.backgroundColor = [UIColor clearColor];
    sendAddressLbl.font = [UIFont systemFontOfSize:16.0];
    sendAddressLbl.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:sendAddressLbl];
    
    UIButton *edit_btn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 50, 75, 30, 30)];
    [edit_btn setImage:[UIImage imageNamed:@"editBtn.png"] forState:UIControlStateNormal];
    [edit_btn addTarget:self action:@selector(editBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [edit_btn setTintColor:[UIColor lightGrayColor]];
    edit_btn.alpha = 1.0;
    edit_btn.transform = CGAffineTransformMakeTranslation(10, 0);
    [self.view addSubview:edit_btn];
    
    selectTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 130, self.view.frame.size.width, self.view.frame.size.height - 320) style:UITableViewStylePlain];
    selectTable.dataSource = self;
    selectTable.delegate = self;
    [selectTable setBackgroundColor:[UIColor clearColor]];
    selectTable.userInteractionEnabled=YES;
    [selectTable setAllowsSelection:YES];
    if ([selectTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [selectTable setSeparatorInset:UIEdgeInsetsZero];
    }
    [selectTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:selectTable];
    
    UILabel *priceLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, selectTable.frame.size.height + selectTable.frame.origin.y + 10, 100, 24)];
    priceLbl.font = [UIFont systemFontOfSize:16.0];
    priceLbl.textAlignment = NSTextAlignmentLeft;
    priceLbl.textColor = [UIColor lightGrayColor];
    [self.view addSubview:priceLbl];
    
    UIImageView *dballImg1 = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 140, priceLbl.frame.origin.y, 20, 20)];
    dballImg1.image = [UIImage imageNamed:@"blueBall.png"];
    [self.view addSubview:dballImg1];
    
    price_Lbl = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 110, priceLbl.frame.origin.y, 100, 20)];
    price_Lbl.font = [UIFont systemFontOfSize:16.0];
    price_Lbl.textAlignment = NSTextAlignmentLeft;
    price_Lbl.textColor = [UIColor redColor];
    [self.view addSubview:price_Lbl];
    price_Lbl.text = [NSString stringWithFormat:@"%d", totalCount];
    
    UILabel *movePriceLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, priceLbl.frame.size.height + priceLbl.frame.origin.y + 10, 200, 24)];
    movePriceLbl.font = [UIFont systemFontOfSize:16.0];
    movePriceLbl.textAlignment = NSTextAlignmentLeft;
    movePriceLbl.textColor = [UIColor lightGrayColor];
    [self.view addSubview:movePriceLbl];
    
    UIImageView *dballImg2 = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 140, movePriceLbl.frame.origin.y, 20, 20)];
    dballImg2.image = [UIImage imageNamed:@"blueBall.png"];
    [self.view addSubview:dballImg2];
    
    movePrice_Lbl = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 110, movePriceLbl.frame.origin.y, 100, 20)];
    movePrice_Lbl.font = [UIFont systemFontOfSize:16.0];
    movePrice_Lbl.textAlignment = NSTextAlignmentLeft;
    movePrice_Lbl.textColor = [UIColor redColor];
    movePrice_Lbl.text = @"0";
    [self.view addSubview:movePrice_Lbl];
    
    UIImageView *lineImg =[UIImageView new];
    lineImg.frame=CGRectMake(2, self.view.frame.size.height - 61, self.view.frame.size.width - 4, 1);
    lineImg.clipsToBounds = YES;
    lineImg.userInteractionEnabled=YES;
    lineImg.backgroundColor = [UIColor colorWithRed:65.0/255.0 green:111.0/255.0 blue:155.0/255.0 alpha:1.0];
    [self.view addSubview:lineImg];
    
    UILabel *totalCountLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, self.view.frame.size.height - 40, 80, 30)];
    totalCountLbl.font = [UIFont systemFontOfSize:20.0];
    totalCountLbl.textAlignment = NSTextAlignmentCenter;
    totalCountLbl.textColor = [UIColor redColor];
    [self.view addSubview:totalCountLbl];
    
    UIImageView *dballImg3 = [[UIImageView alloc] initWithFrame:CGRectMake(totalCountLbl.frame.origin.x + totalCountLbl.frame.size.width + 5, totalCountLbl.frame.origin.y + 3, 24, 24)];
    dballImg3.image = [UIImage imageNamed:@"blueBall.png"];
    [self.view addSubview:dballImg3];
    
    countLbl = [[UILabel alloc] initWithFrame:CGRectMake(dballImg3.frame.origin.x + dballImg3.frame.size.width + 10, dballImg3.frame.origin.y, 100, 24)];
    countLbl.font = [UIFont systemFontOfSize:18.0];
    countLbl.textAlignment = NSTextAlignmentLeft;
    countLbl.textColor = [UIColor redColor];
    [self.view addSubview:countLbl];
    
    countLbl.text = [NSString stringWithFormat:@"%d", totalCount + [movePrice_Lbl.text intValue]];
    
    UIButton *buyBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 110, self.view.frame.size.height - 60, 100, 60)];
    [buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buyBtn setBackgroundImage:[UIImage imageNamed:@"addBasketBtnBack.png"] forState:UIControlStateNormal];
    [buyBtn addTarget:self action:@selector(detailbuyBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [buyBtn setTintColor:[UIColor lightGrayColor]];
    buyBtn.alpha = 1.0;
    buyBtn.transform = CGAffineTransformMakeTranslation(10, 0);
    [self.view addSubview:buyBtn];
    
    NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
    if ([applang isEqualToString:@"ko"]) {
        titleLbl.text = BUY_TITLE[0];
        priceLbl.text = BUY_PRODUCT_PRICE[0];
        movePriceLbl.text = BUY_PRODUCT_MOVEPRICE[0];
        totalCountLbl.text = BUY_TOTAL_PRICE[0];
        [buyBtn setTitle:BUY_GUMAE_BUTTON[0] forState:UIControlStateNormal];
    }
    if ([applang isEqualToString:@"cn"]) {
        titleLbl.text = BUY_TITLE[1];
        priceLbl.text = BUY_PRODUCT_PRICE[1];
        movePriceLbl.text = BUY_PRODUCT_MOVEPRICE[1];
        totalCountLbl.text = BUY_TOTAL_PRICE[1];
        [buyBtn setTitle:BUY_GUMAE_BUTTON[1] forState:UIControlStateNormal];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectDelegate) name:@"select" object:nil];
}

- (void)selectDelegate{
    NSString *strName = [[NSUserDefaults standardUserDefaults] objectForKey:@"baedalName"];
    NSString *strPhone = [[NSUserDefaults standardUserDefaults] objectForKey:@"baedalPhone"];
    NSString *strAddress = [[NSUserDefaults standardUserDefaults] objectForKey:@"baedalAddress"];
    NSString *strDistance = [[NSUserDefaults standardUserDefaults] objectForKey:@"baedalDistance"];
    
    sendNameLbl.text = strName;
    sendPhoneLbl.text = strPhone;
    sendAddressLbl.text = strAddress;
    
    int moveCount = 0;
    
    moveCount = [_item_initfare intValue] + round([_item_wrate floatValue]*[_item_weight floatValue] + [_item_brate floatValue]*[_item_bulk floatValue] + [_item_drate floatValue]*[strDistance floatValue])*[_item_number intValue];
    
    movePrice_Lbl.text = [NSString stringWithFormat:@"%d", moveCount];
    countLbl.text = [NSString stringWithFormat:@"%d", [price_Lbl.text intValue] + [movePrice_Lbl.text intValue]];
}

-(void)detailbuyBtnClicked{
    NSLog(@"%@", sendAddressLbl.text);
    if (sendNameLbl.text != nil && sendPhoneLbl.text != nil && sendAddressLbl.text != nil) {
        
        NSString *userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"];
        NSString *sessionkey = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionkey"];
        
        NSDictionary *parameters = @{@"userid":userid,
                                     @"detailpid":_item_detailID,
                                     @"number":_item_number,
                                     @"ballnumber":countLbl.text,
                                     @"dname":sendNameLbl.text,
                                     @"dphone":sendPhoneLbl.text,
                                     @"daddress":sendAddressLbl.text,
                                     @"itemid":_item_itemID,
                                     @"sessionkey":sessionkey
                                     };
        
        [SVProgressHUD showWithStatus:@"请稍后..." maskType:SVProgressHUDMaskTypeBlack];
        
        [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
        [[GlobalPool sharedInstance].OAuth2Manager POST:LC_SHOP_BUY_ITEM parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@",responseObject);
            [SVProgressHUD dismiss];
            
            NSString *status = [responseObject objectForKey:@"status"];
            
            if ([status intValue] == 200) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"상품구입" message:@"상품을 정확히 구매하였습니다." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else if ([status intValue] == 701){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"상품오유" message:@"상품이 모자랍니다." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
            else if ([status intValue] == 1001) {
                NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:@"NO" forKey:@"isLoginState"];
                [defaults synchronize];
                [[AppDelegate sharedAppDelegate] runMain];
            }
            else{
                NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
                if ([applang isEqualToString:@"ko"]) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"충전을 해야합니다." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    alert.tag = 2000;
                    [alert show];
                }
                if ([applang isEqualToString:@"cn"]) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请充值" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                    alert.tag = 2000;
                    [alert show];
                }
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"Connection failed"];
        }];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"￼请输入配送地址" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        if (alertView.tag == 2000) {
            FillViewController *fillView = [[FillViewController alloc] init];
            [self.navigationController pushViewController:fillView animated:YES];
        }
    }
}

- (void)editBtnClicked{
    EditAddressViewController *edit_view = [[EditAddressViewController alloc] init];
    [self.navigationController pushViewController:edit_view animated:YES];
}

#pragma mark - tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
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
    
    UIImageView *mainImage =[UIImageView new];
    mainImage.frame=CGRectMake(20, 10, 90, 100);
    mainImage.clipsToBounds = YES;
    mainImage.userInteractionEnabled=YES;
    mainImage.layer.cornerRadius = 1;
    mainImage.layer.borderColor = [UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0].CGColor;
    mainImage.layer.borderWidth = 1;
    mainImage.layer.masksToBounds = YES;
    mainImage.backgroundColor = [UIColor whiteColor];
    [cell.contentView addSubview:mainImage];
    
    UILabel *lbl_Title = [[UILabel alloc]init];
    [lbl_Title setFrame:CGRectMake(120, 10, self.view.frame.size.width - 150, 20)];
    [lbl_Title setTextAlignment:NSTextAlignmentLeft];
    [lbl_Title setTextColor:[UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0]];
    [lbl_Title setBackgroundColor:[UIColor clearColor]];
    [lbl_Title setFont:[UIFont systemFontOfSize:14.0]];
    [cell.contentView addSubview:lbl_Title];
    
    UILabel *lbl_Color = [[UILabel alloc]init];
    [lbl_Color setFrame:CGRectMake(120, 50, self.view.frame.size.width - 150, 20)];
    [lbl_Color setTextAlignment:NSTextAlignmentLeft];
    [lbl_Color setTextColor:[UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0]];
    [lbl_Color setBackgroundColor:[UIColor clearColor]];
    [lbl_Color setFont:[UIFont systemFontOfSize:14.0]];
    [cell.contentView addSubview:lbl_Color];
    
    UIImageView *ballImage =[UIImageView new];
    ballImage.frame=CGRectMake(120, 90, 20, 20);
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
    
    UILabel *lbl_Count = [[UILabel alloc]init];
    [lbl_Count setFrame:CGRectMake(self.view.frame.size.width - 50, 90, 40, 20)];
    [lbl_Count setTextAlignment:NSTextAlignmentRight];
    [lbl_Count setTextColor:[UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0]];
    [lbl_Count setBackgroundColor:[UIColor clearColor]];
    [lbl_Count setFont:[UIFont systemFontOfSize:17.0]];
    [cell.contentView addSubview:lbl_Count];
    
    UIImageView *lineImg =[UIImageView new];
    lineImg.frame=CGRectMake(2, 119, self.view.frame.size.width - 4, 1);
    lineImg.clipsToBounds = YES;
    lineImg.userInteractionEnabled=YES;
    lineImg.backgroundColor = [UIColor colorWithRed:65.0/255.0 green:111.0/255.0 blue:155.0/255.0 alpha:1.0];
    [cell.contentView addSubview:lineImg];
    
    lbl_Title.text = _item_title;
    lbl_Color.text = _item_color;
    lbl_BallCount.text = _item_price;
    lbl_Count.text = _item_number;
    
    [mainImage setImageWithURL:[NSURL URLWithString:_item_imgUrl]];
    
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)backBtnClicked{
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
