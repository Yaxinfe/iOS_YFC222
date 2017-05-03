//
//  SVAnnotation.m
//  SVPulsingAnnotationView
//
//  Created by Sam Vermette on 04.03.13.
//  Copyright (c) 2013 Sam Vermette. All rights reserved.
//

#import "LCAnnotation.h"

@implementation LCAnnotation

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate {
    if(self = [super init])
        self.coordinate = coordinate;
    return self;
}

@end
