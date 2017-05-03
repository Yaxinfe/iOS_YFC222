//
//  PayMethodViewController.m
//  YFC
//
//  Created by iOS on 06/08/15.
//  Copyright (c) 2015 ming. All rights reserved.
//

#import "publicHeaders.h"

#import "PayMethodViewController.h"

//APP端签名相关头文件
#import "payRequsestHandler.h"
//
////服务端签名只需要用到下面一个头文件
////#import "ApiXml.h"
//#import <QuartzCore/QuartzCore.h>
//
//#import "LDSDKManager.h"
//
//#import "LDSDKRegisterService.h"
//#import "LDSDKPayService.h"
//#import "LDSDKAuthService.h"
//#import "LDSDKShareService.h"
//
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>

#import "APAuthV2Info.h"
#import "Product.h"

@interface PayMethodViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *methodTable;
    NSMutableArray *imageArray;
    NSMutableArray *listArray;
}
@end

@implementation PayMethodViewController

- (id)init{
    if(self = [super init]){
        _scene = WXSceneSession;
    }
    return self;
}

-(void) changeScene:(NSInteger )scene
{
    _scene = (enum WXScene)scene;
}

- (void)sendPay_demo
{
    NSString *ballNumber = [NSString stringWithFormat:@"%d", _ballCount];
    [[NSUserDefaults standardUserDefaults] setObject:ballNumber forKey:@"buyBallNumber"];
    //{{{
    //本实例只是演示签名过程， 请将该过程在商户服务器上实现
    
    //创建支付签名对象
    payRequsestHandler *req = [[payRequsestHandler alloc] autorelease];
    //初始化支付签名对象
    [req init:APP_ID mch_id:MCH_ID];
    //设置密钥
    [req setKey:PARTNER_ID];
    
    //}}}
    
    //获取到实际调起微信支付的参数后，在app端调起支付
    NSMutableDictionary *dict = [req sendPay_demo];
    
    if(dict == nil){
        //错误提示
        NSString *debug = [req getDebugifo];
        
        [self alert:@"提示信息" msg:debug];
        
        NSLog(@"%@\n\n",debug);
    }
    else{
        NSLog(@"%@\n\n",[req getDebugifo]);
        //[self alert:@"确认" msg:@"下单成功，点击OK后调起支付！"];
        
        NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
        
        //调起微信支付
        PayReq* req             = [[[PayReq alloc] init]autorelease];
        req.openID              = [dict objectForKey:@"appid"];
        req.partnerId           = [dict objectForKey:@"partnerid"];
        req.prepayId            = [dict objectForKey:@"prepayid"];
        req.nonceStr            = [dict objectForKey:@"noncestr"];
        req.timeStamp           = stamp.intValue;
        req.package             = [dict objectForKey:@"package"];
        req.sign                = [dict objectForKey:@"sign"];
        
        [WXApi sendReq:req];
    }
}

//客户端提示信息
- (void)alert:(NSString *)title msg:(NSString *)msg
{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alter show];
    [alter release];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    imageArray = [NSMutableArray arrayWithObjects:@"wechatPayIcon.png", @"juboIcon.png", nil];
    
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    backImageView.image = [UIImage imageNamed:@"shopBack.png"];
    [self.view addSubview:backImageView];
    
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
    
    NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
    if ([applang isEqualToString:@"ko"]) {
        listArray = [NSMutableArray arrayWithObjects:@"Wechat 지불", @"Alipay 지불", nil];
        titleLbl.text = PAYMETHOD_TITLE[0];
    }
    if ([applang isEqualToString:@"cn"]) {
        listArray = [NSMutableArray arrayWithObjects:@"微信支付", @"支付宝支付", nil];
        titleLbl.text = PAYMETHOD_TITLE[1];
    }
    
    UIImageView *lineImg5 =[UIImageView new];
    lineImg5.frame=CGRectMake(0, 63, self.view.frame.size.width, 2);
    lineImg5.clipsToBounds = YES;
    lineImg5.userInteractionEnabled=YES;
    lineImg5.backgroundColor = [UIColor colorWithRed:216.0/255.0 green:229.0/255.0 blue:241.0/255.0 alpha:1.0];
    [self.view addSubview:lineImg5];
    
    methodTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 70, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    methodTable.dataSource = self;
    methodTable.delegate = self;
    [methodTable setBackgroundColor:[UIColor clearColor]];
    methodTable.userInteractionEnabled=YES;
    methodTable.scrollEnabled = NO;
    [methodTable setAllowsSelection:YES];
    if ([methodTable respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [methodTable setSeparatorInset:UIEdgeInsetsZero];
        
    }
    [methodTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:methodTable];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buySuccessDelegate) name:@"buySuccessDelegate" object:nil];
}

- (void)buySuccessDelegate{
    NSString *ballNumber = [NSString stringWithFormat:@"%d", _ballCount];

    NSString *userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"];
    NSString *sessionkey = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionkey"];
    
    NSDictionary *parameters = @{@"userid":userid,
                                 @"ballnumber":ballNumber,
                                 @"type":@"1",
                                 @"sessionkey":sessionkey
                                 };

    [SVProgressHUD showWithStatus:@"请稍后..." maskType:SVProgressHUDMaskTypeBlack];

    [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
    [[GlobalPool sharedInstance].OAuth2Manager POST:LC_CHARGE_BALL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        [SVProgressHUD dismiss];
        
        NSString *status = [responseObject objectForKey:@"status"];
        
        if ([status intValue] == 200) {
            [self.navigationController popViewControllerAnimated:YES];
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
// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
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
    
    UIImageView *iconImg = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 40, 40)];
    iconImg.backgroundColor = [UIColor clearColor];
    iconImg.image = [UIImage imageNamed:[imageArray objectAtIndex:indexPath.row]];
    [cell.contentView addSubview:iconImg];
    
    UILabel *lbl_Title = [[UILabel alloc]init];
    [lbl_Title setFrame:CGRectMake(iconImg.frame.origin.x + iconImg.frame.size.width + 20, 10, self.view.frame.size.width - (iconImg.frame.origin.x + iconImg.frame.size.width + 10), 40)];
    [lbl_Title setTextAlignment:NSTextAlignmentLeft];
    [lbl_Title setTextColor:[UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0]];
    [lbl_Title setBackgroundColor:[UIColor clearColor]];
    [lbl_Title setFont:[UIFont boldSystemFontOfSize:18.0]];
    lbl_Title.text = [listArray objectAtIndex:indexPath.row];
    [cell.contentView addSubview:lbl_Title];
    
    UIImageView *lineImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 59, self.view.frame.size.width - 20, 1)];
    lineImg.backgroundColor = [UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0];
    [cell.contentView addSubview:lineImg];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //Height of the rows
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        [self payWechat];
    }
    if (indexPath.row == 1) {
        [self payJupoo];
    }
}

- (void)payWechat{
    [self sendPay_demo];
}

- (NSString *)generateTradeNO
{
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand(time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}

- (void)payJupoo{
    Product *product = [[Product alloc] init];
    product.subject = @"Ball Charge";
    product.body = @"延边世灵科技开发有限公司";
    product.price = _ballCount;

    NSString *partner = @"2088021466756724";
    NSString *seller = @"57278630@qq.com";
    NSString *privateKey = @"MIICeAIBADANBgkqhkiG9w0BAQEFAASCAmIwggJeAgEAAoGBAO4UGT0deuWgwnFlValNKpeDMT0la07WJ2CQ7bQ6wLq1VIgjDEqPtyD1FK7LPYGkw0jzo52c1FqfMiDwHZ+oBQpoCsD3JGVCEw/r8X6A8TZks7YrM7z201Uoodj0070P0tYcWC2pv8bzdFN/inGvvUKgRRhoAU0SuSl3ivHYHx3BAgMBAAECgYEAqQyeazXumPSQfMJOk/uWHaVrJhbW3lDT/w6Jqqr5RNoS3uO8C4mGqCE+AWuRDeg3Piq55+V/J6XYi2jUMBS3FjDcxwp5AdxA64SN7/zbTPETgmqWK5jlIOTkk795vNXEACvOOU8TZ94obm1uVR7cjRgntNMUNEXWMi2o3owbu10CQQD87hQbSc+Af1hSqtIECu5PjvnFDoxAPz7P8pwJpLVj67KbIf9FgcYaAFmDGhTN7BPt84Zh8Ftdn+h+mIIVyCOnAkEA8PffW9hnmAcDagYA90uBYwtEm+wQf2LV/MMEUlnpD1J2b9pjEHLuVxVGZ44HJ8ApbZC2tQWWcntKjm/1BW0AVwJATJmt7TXFah0nGqIxSJgm5GFgs5VcVHjTBRdsul7vsHtJdEIvlVVgMa+5bEMR2euNfZsrL64jfY9YUj7N5treMQJBAJsWrccrLOGIAgaG/rArBId+hRXlhWi3cApSacGm5H1cEaZD5GZ90jByHPIhUzGeWAuQjEdN5VqhR4cNP6HSWdkCQQD57VUe1sQPq/jFexptHZdPqRiyclYufjAliLMySbI/Z8TqqH2W9vLdIkDGMOLRSSkNo4WwFuKkSBHNYql3NpmV";

    
    //partner和seller获取失败,提示
    if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    

    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = [self generateTradeNO]; //订单ID（由商家自行制定）
    order.productName = product.subject; //商品标题
    order.productDescription = product.body; //商品描述
    order.amount = [NSString stringWithFormat:@"%d", product.price]; //商品价格
    order.notifyURL =  @"http://notify.msp.hk/notify.htm"; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"YBFC";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
            
            NSString *resultStatus = [resultDic objectForKey:@"resultStatus"];
            
            if ([resultStatus intValue] == 9000) {
                NSString *ballNumber = [NSString stringWithFormat:@"%d", _ballCount];
                
                NSString *userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"];
                NSString *sessionkey = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionkey"];
                
                NSDictionary *parameters = @{@"userid":userid,
                                             @"ballnumber":ballNumber,
                                             @"type":@"2",
                                             @"sessionkey":sessionkey
                                             };
                
                [SVProgressHUD showWithStatus:@"请稍后..." maskType:SVProgressHUDMaskTypeBlack];
                
                [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
                [[GlobalPool sharedInstance].OAuth2Manager POST:LC_CHARGE_BALL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSLog(@"%@",responseObject);
                    [SVProgressHUD dismiss];
                    
                    NSString *status = [responseObject objectForKey:@"status"];
                    
                    if ([status intValue] == 200) {
                        [self.navigationController popViewControllerAnimated:YES];
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
        }];
        
    }
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
