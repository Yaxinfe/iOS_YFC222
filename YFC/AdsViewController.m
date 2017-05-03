//
//  AdsViewController.m
//  YFC
//
//  Created by topone on 9/14/15.
//  Copyright (c) 2015 ming. All rights reserved.
//

#import "publicHeaders.h"

#import "AdsViewController.h"

@interface AdsViewController ()
{
    NSMutableArray *adArray;
    UIImageView *adsImg;
    
    UILabel *timeLbl;
}
@end

@implementation AdsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    adsImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:adsImg];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 130, 25, 120, 40)];
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha = 0.5;
//    [self.view addSubview:backView];
    
    timeLbl = [[UILabel alloc] init];
    [timeLbl setFrame:CGRectMake(5, 5, 20, 30)];
    [timeLbl setTextAlignment:NSTextAlignmentCenter];
    [timeLbl setTextColor:[UIColor whiteColor]];
    [timeLbl setBackgroundColor:[UIColor clearColor]];
    [timeLbl setFont:[UIFont systemFontOfSize:24.0]];
    timeLbl.text = @"3";
//    [backView addSubview:timeLbl];
    
//    UILabel *strtimeLbl = [[UILabel alloc] init];
//    [strtimeLbl setFrame:CGRectMake(27, 5, 110, 30)];
//    [strtimeLbl setTextAlignment:NSTextAlignmentLeft];
//    [strtimeLbl setTextColor:[UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0]];
//    [strtimeLbl setBackgroundColor:[UIColor clearColor]];
//    [strtimeLbl setFont:[UIFont systemFontOfSize:20.0]];
//    strtimeLbl.text = @"秒后结束";
//    [backView addSubview:strtimeLbl];
    
    [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(targetMethod:)
                                   userInfo:nil
                                    repeats:YES];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    [self.view addGestureRecognizer:tapGesture];
    
    [self getAdList];
}

- (void) targetMethod:(NSTimer *)timer
{
    int count = [timeLbl.text intValue];
    
    if (count == 0) {
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@"NO" forKey:@"doneRunApp"];
        [defaults synchronize];
        
        [timer invalidate];
        timer = nil;
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else{
        NSString *lable = [NSString stringWithFormat:@"%d", count-1];
        timeLbl.text = lable;
    }

}

- (void)getAdList{
    [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
    [[GlobalPool sharedInstance].OAuth2Manager POST:LC_DAILY_ADSLIST parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        adArray = [NSMutableArray arrayWithArray:[responseObject objectForKey:@"adinfo"]];
        int count = (int)adArray.count;
        int r = arc4random_uniform(count);
        NSString *path = [[adArray objectAtIndex:r] objectForKey:@"imageurl"];
        [adsImg setImageWithURL:[NSURL URLWithString:path]];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"Connection failed"];
    }];
}

- (void)dismissBtnClicked{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"NO" forKey:@"doneRunApp"];
    [defaults synchronize];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewTapped:(UIGestureRecognizer *)gesture {
//    [self dismissViewControllerAnimated:YES completion:nil];
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
