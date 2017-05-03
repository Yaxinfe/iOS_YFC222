//
//  EQNConnection.h
//  EQN
//
//  Created by Qingxin on 01/05/13.
//  Copyright 2012-2013 Qingxin, Inc. All rights reserved.
//  Permission to use this file is granted in EQNetworking/license.txt (apache v2).

#ifndef _EQNCONNECTION_H_
#define _EQNCONNECTION_H_

#import "EQN_categories.h"
#import "EQNData.h"


@class EQNConnection;

// block types
typedef id(^EQNParseBlock)(EQNConnection *, NSError **);
typedef void(^EQNCompletionBlock)(EQNConnection *);
typedef void(^EQNProgressBlock)(EQNConnection *);


// http methods
// add additional http methods as necessary
// non-http request methods could also go here
typedef enum {
    EQNRequestMethodGET = 0, // default
    EQNRequestMethodPOST,
} EQNRequestMethod;


// NSNotification names
extern NSString * const EQNConnectionActivityBegan;
extern NSString * const EQNConnectionActivityEnded;

// string function for request enum
NSString* stringForRequestMethod(EQNRequestMethod method);

@interface EQNConnection : NSObject <NSURLConnectionDelegate>

// NOTE: object property declarations in header are explicity 'strong' so that non-arc code may include the header.

@property (nonatomic, strong) NSURL *url;
@property (nonatomic) EQNRequestMethod method;

#if TARGET_OS_IPHONE
@property (nonatomic) BOOL shouldRunInBackground; // defaults to YES for POST method
#endif

@property (nonatomic, strong) NSDictionary *headers;    // optional custom http headers
@property (nonatomic, strong) NSDictionary *parameters; // GET or POST parameters, including POST form data

@property (nonatomic, copy) EQNParseBlock parseBlock;           // executed in background thread
@property (nonatomic, copy) EQNCompletionBlock completionBlock; // executed in main thread
@property (nonatomic, copy) EQNProgressBlock progressBlock;     // executed in main thread

@property (nonatomic, strong, readonly) NSURLResponse *response;        // response from NSURLConnection
@property (nonatomic, strong, readonly) NSHTTPURLResponse *httpResponse; // response or nil if not an http response
@property (nonatomic, strong, readonly) NSData *responseData;           // populated with data unless responseStream is set.
@property (nonatomic, strong) NSOutputStream *responseStream;           // if this is set then responseData will be nil

@property (nonatomic, strong, readonly) id<NSObject> parseResult;       // result of parseBlock; may be nil on success
@property (nonatomic, strong, readonly) NSError *error;                 // if set then the request or parse failed

@property (nonatomic, readonly) BOOL didStart;          // start was called
@property (nonatomic, readonly) BOOL didFinishLoading;  // underlying connection finished loading
@property (nonatomic, readonly) BOOL didComplete;       // underlying connection either finished or failed
@property (nonatomic, readonly) BOOL didSucceed;        // finished with no error

@property (nonatomic, readonly) long long uploadProgressBytes;
@property (nonatomic, readonly) long long uploadExpectedBytes;
@property (nonatomic, readonly) long long downloadProgressBytes;
@property (nonatomic, readonly) long long downloadExpectedBytes;
@property (nonatomic, readonly) float uploadProgress;
@property (nonatomic, readonly) float downloadProgress;

@property (nonatomic, readonly) int concurrencyCountAtStart;
@property (nonatomic, readonly) NSTimeInterval startTime;
@property (nonatomic, readonly) NSTimeInterval challengeInterval;
@property (nonatomic, readonly) NSTimeInterval responseInterval;
@property (nonatomic, readonly) NSTimeInterval finishOrFailInterval;
@property (nonatomic, readonly) NSTimeInterval parseInterval;


+ (id)withUrl:(NSURL *)url
       method:(EQNRequestMethod)method
      headers:(NSDictionary *)headers
   parameters:(NSDictionary *)parameters
   parseBlock:(EQNParseBlock)parseBlock
completionBlock:(EQNCompletionBlock)completionBlock
progressBlock:(EQNProgressBlock)progressBlock;


+ (NSSet *)connections;
+ (void)cancelAllConnections;


// call this method to allow the request to complete but ignore the response.
- (void)clearBlocks;

- (EQNConnection *)start; // returns self for chaining convenience, or nil if start fails.

- (void)cancel; // no blocks will be called after request is cancelled, unless a call to finish is already scheduled.

@end


#endif