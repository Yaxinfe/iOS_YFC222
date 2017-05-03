//
//  GlobalPool.m
//  LYchee
//
//  Created by Glenn Chiu on 1/31/13.
//  Copyright (c) 2013 Glenn Chiu. All rights reserved.
//

#import "GlobalPool.h"

#define LCClientID          @"ybfcApp"
#define LCClientSecret      @"1234567890"
#define LCGrantType         @"password"

@implementation GlobalPool

+ (GlobalPool *)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    
    dispatch_once(&once, ^
                  {
                      sharedInstance = [self new];
                  });
    
    return sharedInstance;
}

- (id)init {
    
    if(self = [super init]) {
        self.user = [[LCUser alloc] init];
        
        NSURL *baseURL = [NSURL URLWithString: @"http://123.57.173.92/backend/index.php"];
        self.OAuth2Manager =  [[AFOAuth2Manager alloc] initWithBaseURL:baseURL
                                                              clientID:LCClientID
                                                                secret:LCClientSecret];
        
    }
    return self;
    
}

- (void) showMessage :(NSString *) body {
    
    UIAlertView *alert_view = [[UIAlertView alloc] initWithTitle:@"YBFC Error" message:body delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert_view show];
    
}

@end
