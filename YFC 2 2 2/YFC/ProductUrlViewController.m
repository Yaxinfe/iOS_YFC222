//
//  ProductUrlViewController.m
//  YFC
//
//  Created by topone on 9/19/15.
//  Copyright (c) 2015 ming. All rights reserved.
//
#import "publicHeaders.h"
#import "ProductUrlViewController.h"

@interface ProductUrlViewController ()<UIWebViewDelegate>
{
    UIWebView      *detailWebView;
    NSString       *detailUrl;
}
@end

@implementation ProductUrlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    detailWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 105)];
    detailWebView.delegate = self;
    detailWebView.backgroundColor = [UIColor clearColor];
    [detailWebView setOpaque:NO];
    [self.view addSubview:detailWebView];
    
    [self getProductDetail];
}

- (void)getProductDetail{
    NSDictionary *parameters = @{@"pid":self.dProductId
                                 };
    [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
    [[GlobalPool sharedInstance].OAuth2Manager POST:LC_SHOP_PRODUCTDETAIL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        
        NSString *status = [responseObject objectForKey:@"status"];
        
        if ([status intValue] == 200) {
            NSDictionary *product_info = [responseObject objectForKey:@"productinfo"];
            detailUrl = [product_info objectForKey:@"detailurl"];
            
            NSString *url = [NSString stringWithFormat:@"%@%@", @"http://123.57.173.92/share/shop_intro.php?slID=", self.dProductId];
            NSURL *nsurl = [NSURL URLWithString:url];
            NSURLRequest *nsrequest = [NSURLRequest requestWithURL:nsurl];
            [detailWebView loadRequest:nsrequest];
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
            [alert show];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"Connection failed"];
    }];
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
