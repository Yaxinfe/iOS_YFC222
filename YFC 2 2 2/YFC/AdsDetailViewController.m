//
//  AdsDetailViewController.m
//  YFC
//
//  Created by omar55d on 10/31/15.
//  Copyright (c) 2015 ming. All rights reserved.
//

#import "AdsDetailViewController.h"
#import "publicHeaders.h"

#import "YFGIFImageView.h"
#import "UIImageView+PlayGIF.h"

@interface AdsDetailViewController ()<UIWebViewDelegate>
{
    UIWebView      *detailWebView;
    YFGIFImageView *gifView_Load;
}
@end

@implementation AdsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    backImageView.image = [UIImage imageNamed:@"menuBackImg.png"];
    [self.view addSubview:backImageView];
    
    UIButton *back_btn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.origin.x , self.view.frame.origin.y + 25, 27, 30)];
    [back_btn setImage:[UIImage imageNamed:@"backBtn.png"] forState:UIControlStateNormal];
    [back_btn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [back_btn setTintColor:[UIColor lightGrayColor]];
    back_btn.transform = CGAffineTransformMakeTranslation(10, 0);
    [self.view addSubview:back_btn];
    
    UILabel *lbl_Title = [[UILabel alloc] init];
    [lbl_Title setFrame:CGRectMake(self.view.frame.origin.x + 0, self.view.frame.origin.y + 30, self.view.frame.size.width, 20)];
    [lbl_Title setTextAlignment:NSTextAlignmentCenter];
    [lbl_Title setTextColor:[UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0]];
    [lbl_Title setBackgroundColor:[UIColor clearColor]];
    [lbl_Title setFont:[UIFont boldSystemFontOfSize:18.0]];
    lbl_Title.text = self.adsTitle;
    [self.view addSubview:lbl_Title];
    
    detailWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height - 60)];
    detailWebView.backgroundColor = [UIColor clearColor];
    [detailWebView setOpaque:NO];
    detailWebView.delegate = self;
    [self.view addSubview:detailWebView];
    NSString *url = self.adsUrl;
    NSURL *nsurl = [NSURL URLWithString:url];
    NSURLRequest *nsrequest = [NSURLRequest requestWithURL:nsurl];
    [detailWebView loadRequest:nsrequest];
    
    NSData *gifData_Load = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Loading.gif" ofType:nil]];
    gifView_Load = [[YFGIFImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 50, self.view.frame.size.height/2 - 50, 100, 100)];
    gifView_Load.backgroundColor = [UIColor clearColor];
    gifView_Load.gifData = gifData_Load;
    [self.view addSubview:gifView_Load];
    gifView_Load.hidden = YES;
    gifView_Load.userInteractionEnabled = YES;
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //Start the progressbar..
//    [SVProgressHUD showWithStatus:@"" maskType:SVProgressHUDMaskTypeBlack];
    gifView_Load.hidden = NO;
    [gifView_Load startGIF];
    [gifView_Load startAnimating];
    
    return YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
//    [SVProgressHUD dismiss];
    gifView_Load.hidden = YES;
    [gifView_Load stopGIF];
    [gifView_Load stopAnimating];
    //Stop or remove progressbar
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    //Stop or remove progressbar and show error
//    [SVProgressHUD dismiss];
    gifView_Load.hidden = YES;
    [gifView_Load stopGIF];
    [gifView_Load stopAnimating];
}

- (void)backBtnClicked{
    [gifView_Load removeFromSuperview];
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
