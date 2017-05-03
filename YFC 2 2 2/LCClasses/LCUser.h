//
//  LCUser.h
//  Lychee
//
//  Created by Superman on 12/29/14.
//  Copyright (c) 2014 LyChee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCUser : NSObject

typedef NS_ENUM(NSInteger, LCProviderType)
{ LCProviderEmail = 0,
    LCProviderFacebook,
    LCProviderTwitter,
    LCProviderInstagram
};

@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *token_type;
@property (nonatomic, strong) NSString *gender;

@property (nonatomic, assign) LCProviderType socialProvider;

@end
