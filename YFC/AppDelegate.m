//
//  AppDelegate.m
//  YFC
//
//  Created by topone on 7/14/15.
//  Copyright (c) 2015 ming. All rights reserved.
//

#import "AppDelegate.h"
#import "publicHeaders.h"
#import "FirstViewController.h"
#import "MainViewController.h"

#import "TheSidebarController.h"
#import "MenuViewController.h"
#import "StartViewController.h"
#import "BroadViewController.h"
#import "FanVoiceViewController.h"
#import "ShopDetailViewController.h"
#import "GameViewController.h"

#import "LDSDKManager.h"
#import "LDSDKRegisterService.h"
#import "LDSDKPayService.h"

#import "WXApi.h"
#import "Weibo.h"
#import <TencentOpenAPI/TencentOAuth.h>

@interface AppDelegate ()<TheSidebarControllerDelegate, WXApiDelegate>

@end

@implementation AppDelegate

static AppDelegate* sharedDelegate = nil;

+(AppDelegate*)sharedAppDelegate
{
    if (sharedDelegate == nil)
        sharedDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    
    return sharedDelegate;
}

- (void)runMain{
    MainViewController *mainViewController = [[MainViewController alloc] init];
    UINavigationController *contentNavigationController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
    contentNavigationController.navigationBar.hidden = YES;
    MenuViewController *leftSidebarViewController = [[MenuViewController alloc] init];
    leftSidebarViewController.view.backgroundColor = [UIColor whiteColor];
//    leftSidebarViewController.view.alpha = 1.0f;
    
    TheSidebarController *sidebarController = [[TheSidebarController alloc] initWithContentViewController:contentNavigationController
                                                                                leftSidebarViewController:leftSidebarViewController
                                                                               rightSidebarViewController:nil];
    sidebarController.view.backgroundColor = [UIColor whiteColor];
    sidebarController.delegate = self;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = sidebarController;
    [self.window makeKeyAndVisible];
}

- (void)runBroadCast{
    BroadViewController *mainViewController = [[BroadViewController alloc] init];
    UINavigationController *contentNavigationController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
    contentNavigationController.navigationBar.hidden = YES;
    MenuViewController *leftSidebarViewController = [[MenuViewController alloc] init];
    leftSidebarViewController.view.backgroundColor = [UIColor whiteColor];
    
    TheSidebarController *sidebarController = [[TheSidebarController alloc] initWithContentViewController:contentNavigationController
                                                                                leftSidebarViewController:leftSidebarViewController
                                                                               rightSidebarViewController:nil];
    sidebarController.view.backgroundColor = [UIColor whiteColor];
    sidebarController.delegate = self;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = sidebarController;
    [self.window makeKeyAndVisible];
}

- (void)runShop{
    ShopDetailViewController *mainViewController = [[ShopDetailViewController alloc] init];
    UINavigationController *contentNavigationController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
    contentNavigationController.navigationBar.hidden = YES;
    MenuViewController *leftSidebarViewController = [[MenuViewController alloc] init];
    leftSidebarViewController.view.backgroundColor = [UIColor whiteColor];
    //    leftSidebarViewController.view.alpha = 1.0f;
    
    TheSidebarController *sidebarController = [[TheSidebarController alloc] initWithContentViewController:contentNavigationController
                                                                                leftSidebarViewController:leftSidebarViewController
                                                                               rightSidebarViewController:nil];
    sidebarController.view.backgroundColor = [UIColor whiteColor];
    sidebarController.delegate = self;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = sidebarController;
    [self.window makeKeyAndVisible];
}

- (void)runGame{
    GameViewController *mainViewController = [[GameViewController alloc] init];
    UINavigationController *contentNavigationController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
    contentNavigationController.navigationBar.hidden = YES;
    MenuViewController *leftSidebarViewController = [[MenuViewController alloc] init];
    leftSidebarViewController.view.backgroundColor = [UIColor whiteColor];
    //    leftSidebarViewController.view.alpha = 1.0f;
    
    TheSidebarController *sidebarController = [[TheSidebarController alloc] initWithContentViewController:contentNavigationController
                                                                                leftSidebarViewController:leftSidebarViewController
                                                                               rightSidebarViewController:nil];
    sidebarController.view.backgroundColor = [UIColor whiteColor];
    sidebarController.delegate = self;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = sidebarController;
    [self.window makeKeyAndVisible];
}

- (void)runFanVoice{
    FanVoiceViewController *mainViewController = [[FanVoiceViewController alloc] init];
    UINavigationController *contentNavigationController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
    contentNavigationController.navigationBar.hidden = YES;
    MenuViewController *leftSidebarViewController = [[MenuViewController alloc] init];
    leftSidebarViewController.view.backgroundColor = [UIColor whiteColor];
    //    leftSidebarViewController.view.alpha = 1.0f;
    
    TheSidebarController *sidebarController = [[TheSidebarController alloc] initWithContentViewController:contentNavigationController
                                                                                leftSidebarViewController:leftSidebarViewController
                                                                               rightSidebarViewController:nil];
    sidebarController.view.backgroundColor = [UIColor whiteColor];
    sidebarController.delegate = self;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = sidebarController;
    [self.window makeKeyAndVisible];
}

- (void)runLogin{
    FirstViewController *mainViewController = [[FirstViewController alloc] init];
    UINavigationController *contentNavigationController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
    contentNavigationController.navigationBar.hidden = YES;
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = contentNavigationController;
    [self.window makeKeyAndVisible];
}

- (void)pageRun{
    StartViewController *startViewController = [[StartViewController alloc] init];
    UINavigationController *contentNavigationController = [[UINavigationController alloc] initWithRootViewController:startViewController];
    contentNavigationController.navigationBar.hidden = YES;
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = contentNavigationController;
    [self.window makeKeyAndVisible];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    sleep(1);
    
    [WXApi registerApp:kWeChat_KEY withDescription:@"wechat"];
    
    NSArray *regPlatformConfigList = @[
                                       @{
                                           LDSDKConfigAppIdKey : @"wx19f4270fcbb09a4a",
                                           LDSDKConfigAppSecretKey : @"0a94ef83120868cc39da33ff534b1817",
                                           LDSDKConfigAppDescriptionKey :
                                               [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"],
                                           LDSDKConfigAppPlatformTypeKey : @(LDSDKPlatformWeChat)
                                           },
                                       @{
                                           LDSDKConfigAppIdKey : @"1104746867",
                                           LDSDKConfigAppSecretKey : @"1sBOHkzbtn0pWH8H",
                                           LDSDKConfigAppPlatformTypeKey : @(LDSDKPlatformQQ)
                                           },
                                       @{
                                           LDSDKConfigAppIdKey : @"2962750961",
                                           LDSDKConfigAppSecretKey : @"0b755a1897e24605140951a41825999f",
                                           LDSDKConfigAppPlatformTypeKey : @(LDSDKPlatformWeibo) },
                                       ];
    
    [LDSDKManager registerWithPlatformConfigList:regPlatformConfigList];
    
//    Weibo *weibo = [[Weibo alloc] initWithAppKey:@"2962750961" withAppSecret:@"0b755a1897e24605140951a41825999f" withRedirectURI:@"http://api.weibo.com/oauth2/default.html"];
//    [Weibo setWeibo:weibo];
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"YES" forKey:@"doneRunApp"];
    [defaults synchronize];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"] == NULL) {
        [[NSUserDefaults standardUserDefaults] setObject:@"cn" forKey:@"applanguage"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"isFristRun"] == NULL) {
        [self pageRun];
    }
    else{
        [self runMain];
    }
    
    //push notification
#ifdef __IPHONE_8_0
    if(NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1) {
        UIUserNotificationSettings* notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
    } else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }
#else
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
#endif
    
    return YES;
}

#pragma mark - Push Notification Part
#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    //handle the actions
    if ([identifier isEqualToString:@"declineAction"]){
    }
    else if ([identifier isEqualToString:@"answerAction"]){
    }
}
#endif

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:token forKey:@"deviceToken"];
    [defaults synchronize];
    
    NSLog(@"token ============ %@", token);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //Push Notification
    NSLog(@"%@", userInfo);

    NSString *type = [userInfo objectForKey:@"type"];
    if ([type isEqualToString:@"NEWS"]) {
        [self runMain];
    }
    if ([type isEqualToString:@"RADIO"]) {
        [self runBroadCast];
    }
    if ([type isEqualToString:@"VIDEO"]) {
        [self runFanVoice];
    }
    if ([type isEqualToString:@"SHOP"]) {
        [self runShop];
    }
    if ([type isEqualToString:@"GAME"]) {
        [self runGame];
    }
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Failed to get token, error: %@", error);
}

+ (UIViewController*) topMostController {
    UIViewController *topController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    return topController;
}

-(NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"isFristRun"] == NULL)
    {
        return UIInterfaceOrientationMaskPortrait;
    }

    TheSidebarController *sideBarController = (TheSidebarController *)[AppDelegate topMostController];
    NSLog(@"topviewcontroller ---------  %@", [AppDelegate topMostController]);

    UINavigationController *controller = (UINavigationController *)[sideBarController contentViewController];
    NSArray *viewControllers = controller.viewControllers;
    UIViewController *rootViewController = (UIViewController *)[viewControllers firstObject];
    
    NSLog(@"rootviewcontroller ----------  %@", rootViewController);
    
    if ([rootViewController isKindOfClass:[BroadViewController class]])
    {
        return UIInterfaceOrientationMaskAll;
    }
    
    return UIInterfaceOrientationMaskPortrait;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark --WXApiDelegate--
//授权后回调
-(void) onReq:(BaseReq*)req{
    
}

-(void) onResp:(BaseResp*)resp
{
    SendAuthResp *aresp = (SendAuthResp *)resp;
    if (aresp.errCode== 0) {
        NSString *code = aresp.code;
        NSDictionary *dic = @{@"code":code};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WECHAT" object:nil userInfo:dic];
    }
    
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    NSString *strTitle = nil;
    
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
    }
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        strTitle = [NSString stringWithFormat:@"支付结果"];
        
        switch (resp.errCode) {
            case WXSuccess:
                strMsg = @"支付结果：成功！";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                [alert release];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"buySuccessDelegate" object:nil];
                break;
                
            default:
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                break;
        }
    }
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    [WXApi handleOpenURL:url delegate:self];
    return [LDSDKManager handleOpenURL:url] || [TencentOAuth HandleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    [WXApi handleOpenURL:url delegate:self];
    return [LDSDKManager handleOpenURL:url] || [TencentOAuth HandleOpenURL:url];
}

@end
