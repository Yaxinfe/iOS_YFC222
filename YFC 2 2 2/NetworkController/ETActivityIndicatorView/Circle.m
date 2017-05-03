//
//  Circle.m
//  EQActivityIndicatorView
//
//  LyChee
//
//  Created by Superman on 12/19/14.
//  Copyright (c) 2014 LyChee. All rights reserved.
//

#import "Circle.h"

@implementation Circle

@synthesize color;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        color = [UIColor whiteColor];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [color set];
    CGContextFillEllipseInRect(context, CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height));
    CGContextAddArc(context, self.frame.size.width/2.0, self.frame.size.height/2.0, self.frame.size.height/2.0 -1.0, 0.0, 2.0 * M_PI, YES);
    CGContextDrawPath(context, kCGPathFill);
}


@end
