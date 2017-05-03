//
//  AppDelegate.h
//  YFC
//
//  Created by topone on 7/14/15.
//  Copyright (c) 2015 ming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+(AppDelegate*)sharedAppDelegate;
-(void)runMain;
-(void)runLogin;
-(void)pageRun;
-(void)runBroadCast;
-(void)runFanVoice;
-(void)runShop;
-(void)runGame;

+ (UIViewController*) topMostController;

@end

