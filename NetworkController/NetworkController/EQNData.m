//
//  EQNData.m
//  EQN
//
//  Created by Qingxin on 01/05/13.
//  Copyright 2012-2013 Qingxin, Inc. All rights reserved.
//  Permission to use this file is granted in EQNetworking/license.txt (apache v2).
//

#import "EQN_categories.h"
#import "EQNData.h"


NSString *stringForMimeType(MimeType type) {
    
    switch (type) {
        case MimeType_image_jpeg:       return @"image/jpeg";
        case MimeType_application_json: return @"application/json";
        case MimeType_unknown:          return nil;
        default:
            NSLog(@"ERROR: EQNData: unknown MimeType: %d", type);
            
            // do not return "application/octet-stream"; instead, let the recipient guess
            // http://en.wikipedia.org/wiki/Internet_media_type
            return nil;
    }
}

@implementation EQNData

- (id)description {
    NSString *fn = self.fileName ? [NSString stringWithFormat:@"; fileName=%@", self.fileName] : @"";
    
    return [NSString stringWithFormat:@"<EQNData: %p; data: %p; length: %lu; mimeType: %@%@>",
            self, _data, (unsigned long)_data.length, self.mimeTypeString, fn];
}

- (id)initWithData:(NSData *)data mimeType:(MimeType)mimeType fileName:(NSString*)fileName {
    self = [super init];
    if (!self) return nil;
    
    self.data = data;
    self.mimeType = mimeType;
    self.fileName = fileName;
    
    return self;
}

+ (id)withData:(NSData *)data mimeType:(MimeType)mimeType fileName:(NSString*)fileName {
    return [[self alloc] initWithData:data mimeType:mimeType fileName:fileName];
}


+ (id)withDataPath:(NSString*)path fileName:(NSString*)fileName {
    NSError *e = nil;
    NSData *d = [NSData dataWithContentsOfFile:path options:0 error:&e];
    if (e) {
        EQNLog(@"ERROR: failed to read from data path: %@", path);
        return nil;
    }
    return [self withData:d mimeType:MimeType_unknown fileName:fileName];
}


- (NSString *)mimeTypeString {
    return stringForMimeType(self.mimeType);
}

+ (id)withImage:(UIImage*)image jpegQuality:(NSString *) quality fileName:(NSString*)fileName {
    
    UIImage *originalImage = image;
    
    
    UIImage* newImage = originalImage;
    CGSize newSize = newImage.size;
        
    if (newSize.width > 1024.0f) {
            CGFloat aspect = newSize.width / newSize.height;
            newSize.width = 1024.0f;
            newSize.height = newSize.width / aspect;
            
            UIGraphicsBeginImageContext(newSize);
            [originalImage drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
            newImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
    }
        
    NSData *imageData = UIImageJPEGRepresentation(newImage, 0.5);
        
    return [self withData:imageData mimeType:MimeType_image_jpeg fileName:fileName];


}
@end
