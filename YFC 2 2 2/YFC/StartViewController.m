//
//  StartViewController.m
//  YFC
//
//  Created by topone on 9/14/15.
//  Copyright (c) 2015 ming. All rights reserved.
//

#import "StartViewController.h"
#import "IntroControll.h"
#import "AppDelegate.h"

#import "publicHeaders.h"

@interface StartViewController ()
{
    NSMutableArray *adArray;
    UIButton *btnGetStarted;
}
@end

@implementation StartViewController

- (id)init
{
    self = [super initWithNibName:nil bundle:nil];
    self.modalPresentationStyle = UIModalPresentationFullScreen;
    return self;
}

- (void) loadView {
    [super loadView];
    
    [self getAdList];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = [UIColor blackColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pageBtnDelegate) name:@"pageBtnDelegate" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pageBtnHiddenDelegate) name:@"pageBtnHiddenDelegate" object:nil];
}

- (void)pageBtnHiddenDelegate{
    btnGetStarted.hidden = YES;
}

- (void)pageBtnDelegate{
    btnGetStarted.hidden = NO;
}

- (void)getAdList{
    [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
    [[GlobalPool sharedInstance].OAuth2Manager POST:LC_FIRST_ADSLIST parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        adArray = [NSMutableArray arrayWithArray:[responseObject objectForKey:@"adinfo"]];
        
        NSMutableArray *modelArray = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < adArray.count; i++) {
            NSString *title = [[adArray objectAtIndex:i] objectForKey:@"title"];
            NSString *imageUrl = [[adArray objectAtIndex:i] objectForKey:@"imageurl"];
            IntroModel *model1 = [[IntroModel alloc] initWithTitle:title description:@"" image:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]]];
            
            [modelArray addObject:model1];
        }
        
        self.view = [[IntroControll alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) pages:modelArray];
        
        btnGetStarted = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 50, self.view.frame.size.height - 100, 100, 30)];
        btnGetStarted.layer.cornerRadius = 3;
        btnGetStarted.layer.borderWidth = 1;
        btnGetStarted.layer.borderColor = [UIColor whiteColor].CGColor;
        [btnGetStarted setTitle:@"Skip" forState:UIControlStateNormal];
        btnGetStarted.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [btnGetStarted setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btnGetStarted.tintColor = [UIColor lightGrayColor];
        [btnGetStarted addTarget:self action:@selector(getStartedBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        btnGetStarted.alpha = 1.0;
        btnGetStarted.transform = CGAffineTransformMakeTranslation(10,0);
        btnGetStarted.hidden = YES;
        [self.view addSubview:btnGetStarted];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"Connection failed"];
    }];
}

- (void)getStartedBtnClicked{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"YES" forKey:@"isFristRun"];
    [defaults setObject:@"NO" forKey:@"isLoginState"];
    [defaults synchronize];
    
    [[AppDelegate sharedAppDelegate] runMain];
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
