//
//  Product.h
//  YFC
//
//  Created by omar55d on 11/18/15.
//  Copyright (c) 2015 ming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Product : NSObject{
@private
    int     _price;
    NSString *_subject;
    NSString *_body;
    NSString *_orderId;
}

@property (nonatomic, assign) int price;
@property (nonatomic, copy) NSString *subject;
@property (nonatomic, copy) NSString *body;
@property (nonatomic, copy) NSString *orderId;

@end
