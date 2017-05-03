//
//  GlobalPool.h
//  LYchee
//
//  Created by Glenn Chiu on 1/31/13.
//  Copyright (c) 2013 Glenn Chiu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LCUser.h"
#import <CoreLocation/CoreLocation.h>
#import "AFOAuth2Manager.h"

@interface GlobalPool : NSObject

+ (GlobalPool *)sharedInstance;

@property (nonatomic, assign) BOOL isLoggedIn;
@property (nonatomic, assign) int viewStatus;
@property (nonatomic, strong) LCUser *user;
@property (nonatomic, strong) NSString *access_token;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) NSString *cityAddress;
@property (nonatomic, strong) AFOAuth2Manager *OAuth2Manager;
@property (nonatomic, strong) AFOAuthCredential *credential;

//My Info
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *userCity;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSURL *userPhotoUrl;
@property (nonatomic, strong) UIImage *userPhotoImage;
@property (nonatomic, strong) NSDictionary *myProfileInfo;
@property (nonatomic, strong) NSString *loginType;
- (void) showMessage :(NSString *) body;

@end