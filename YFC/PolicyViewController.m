//
//  PolicyViewController.m
//  YFC
//
//  Created by topone on 9/4/15.
//  Copyright (c) 2015 ming. All rights reserved.
//

#import "PolicyViewController.h"

@interface PolicyViewController ()<UIWebViewDelegate>
{
    UIScrollView *scrollView;
    UIWebView      *detailWebView;
}
@end

@implementation PolicyViewController

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
    back_btn.alpha = 1.0;
    back_btn.transform = CGAffineTransformMakeTranslation(10, 0);
    [self.view addSubview:back_btn];
    
    UILabel *lbl_Title = [[UILabel alloc] init];
    [lbl_Title setFrame:CGRectMake(self.view.frame.origin.x + 0, self.view.frame.origin.y + 30, self.view.frame.size.width, 24)];
    [lbl_Title setTextAlignment:NSTextAlignmentCenter];
    [lbl_Title setTextColor:[UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0]];
    [lbl_Title setBackgroundColor:[UIColor clearColor]];
    [lbl_Title setFont:[UIFont boldSystemFontOfSize:17.0]];
    lbl_Title.text = @"同意《延边富德足球俱乐部使用协议";
    [self.view addSubview:lbl_Title];
    
    detailWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height - 60)];
    detailWebView.backgroundColor = [UIColor clearColor];
    [detailWebView setOpaque:NO];
    detailWebView.delegate = self;
    [self.view addSubview:detailWebView];
    NSString *url = @"http://123.57.173.92/upload/privacy/privacy.htm";
    NSURL *nsurl = [NSURL URLWithString:url];
    NSURLRequest *nsrequest = [NSURLRequest requestWithURL:nsurl];
    [detailWebView loadRequest:nsrequest];
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
