//
//  EQN_categories.m
//  EQN
//
//  Created by Qingxin on 01/05/13.
//  Copyright 2012-2013 Qingxin, Inc. All rights reserved.
//  Permission to use this file is granted in EQNetworking/license.txt (apache v2).
//


#import "EQN_categories.h"


NSString * const EQNConnectionErrorDomain = @"EQNConnectionErrorDomain";


BOOL httpCodeIsOfClass(int httpCode, EQNHTTPCodeClass httpClass) {
    return (httpCode / 100) == httpClass;
}


@implementation NSDictionary (EQN)


BOOL isValueAcceptable(id val) {
    static NSArray* acceptableValueClasses = nil;
    if (!acceptableValueClasses) {
        acceptableValueClasses = @[[NSArray class], [NSNumber class], [NSString class]];
    }
    for (Class klass in acceptableValueClasses) {
        if ([val isKindOfClass:klass])
            return YES;
    }
    return NO;
};


- (NSString *)urlQueryString {
    NSMutableString *string = [NSMutableString string];
    BOOL first = YES;

    for (id key in self) {
        id val = [self objectForKey:key];
        if (![key isKindOfClass:[NSString class]] || !isValueAcceptable(val)) {
            EQNLogError(@"skipping bad parameter: key class: %@ key: %@; value class: %@; value: %@",
                        [key class], key, [val class], val);
            NSAssert(0, @"bad parameter type");
            continue;
        }
        [string appendFormat:@"%@%@=%@", (first ? @"" : @"&"), [key urlEncodedString], [val urlEncodedString]];
        first = NO;
    }
    return string;
}

@end



@implementation NSData (EQN)

- (id)dictionaryFromJSONWithError:(NSError **)error {
    
    NSAssert(error, @"nil error pointer");
    
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:self options:0 error:error];
    
    if (*error) {
        return nil;
    }
    
    if (![dict isKindOfClass:[NSDictionary class]]) {
        NSDictionary* userInfo =
        [NSDictionary dictionaryWithObjectsAndKeys:
         [NSString stringWithFormat:@"JSON result is not a dictionary; type: %@", [dict class]], @"description",
         dict, @"result",
         nil];
        
        *error =
        [NSError errorWithDomain:EQNConnectionErrorDomain code:EQNConnectionErrorCodeJSONResultType userInfo:userInfo];
        
        return nil;
    }
    
    *error = nil;
    return dict;
}


- (id)arrayFromJSONWithError:(NSError **)error {
  
  NSAssert(error, @"nil error pointer");
  
  NSDictionary *array = [NSJSONSerialization JSONObjectWithData:self options:0 error:error];
  
  if (*error) {
    return nil;
  }
  
  if (![array isKindOfClass:[NSArray class]]) {
    NSDictionary* userInfo =
    [NSDictionary dictionaryWithObjectsAndKeys:
     [NSString stringWithFormat:@"JSON result is not an array; type: %@", [array class]], @"description",
     array, @"result",
     nil];
    
    *error =
    [NSError errorWithDomain:EQNConnectionErrorDomain code:EQNConnectionErrorCodeJSONResultType userInfo:userInfo];
    
    return nil;
  }
  
  *error = nil;
  return array;
}


- (NSString *)stringFromUTF8 {
    return [NSString withUTF8Data:self];
}


- (NSString *)debugString {
    NSUInteger length = self.length;
    const char* bytes = self.bytes;
    char* debugBytes = malloc(length);
    
    // convert problematic characters to readable characters in iso latin 1
    for (int i = 0; i < length; i++) {
        int c = bytes[i];
        switch (c) {
            case 0:     c = 0xD8; break;    // null -> capital O slashed (looks like null symbol)
            case '\t':  c = 0xAC; break;    // tab -> not sign
            case '\n':  break;
            case '\r':  c = 0xAE; break;    // carriage return -> registered trademark sign
            default:
                if (iscntrl(c)) c = 0xA9;   // c < 0x20, 0x7F (C0 code) -> copyright sign
                else if (isprint(c)) break; // ascii
                else c = 0xB7;              // c > ascii -> dot
        }
        debugBytes[i] = c;
    }
    
    NSString *s = [[NSString alloc] initWithBytesNoCopy:debugBytes
                                                  length:length
                                                encoding:NSISOLatin1StringEncoding
                                            freeWhenDone:YES];
    if (!s) {
        EQNLogError0(@"string encoding failed");
        free(debugBytes);
    }
    return s;
}


@end



@implementation NSDate (EQN)


+ (NSTimeInterval)posixTime {
    return [[NSDate date] timeIntervalSince1970];
}


@end



@implementation NSString (EQN)


+ (NSString *)withUTF8Data:(NSData*)data {
    return [[self alloc] initWithBytes:data.bytes length:data.length encoding:NSUTF8StringEncoding];
}


- (NSString *)urlEncodedString {
    return (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                (__bridge CFStringRef) self,
                                                                NULL,
                                                                (CFStringRef) @"!*'();:@&=+$,/?%#[]",
                                                                kCFStringEncodingUTF8);
}


- (NSData *)UTF8Data {
    return [self dataUsingEncoding:NSUTF8StringEncoding];
}


@end

@implementation NSArray (EQN)

- (NSString *)urlEncodedString {
    BOOL firstPass = YES;
    NSMutableString *base = [NSMutableString new];
    for (id obj in self) {
        if (!firstPass)
            [base appendString:@","];
        [base appendString:[obj urlEncodedString]];
        firstPass = NO;
    }
    return base;
}

@end

@implementation NSNumber (EQN)


- (NSString *)urlEncodedString {
  return self.stringValue;
}


@end



@implementation NSURLResponse (EQN)


- (NSInteger)statusCode {
    return -1;
}


@end

