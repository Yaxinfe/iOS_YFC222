//
//  EQActivityIndicatorView.h
//  EQActivityIndicatorView
//
//  LyChee
//
//  Created by Superman on 12/19/14.
//  Copyright (c) 2014 LyChee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EQActivityIndicatorView : UIView
{
    BOOL isAnimating;
    int circleNumber;
    int maxCircleNumber;
    float circleSize;
    float radius;
    UIColor *color;
    NSTimer *circleDelay;
}

@property (nonatomic,retain) UIColor *color;

-(id)initWithFrame:(CGRect)frame andColor:(UIColor*)theColor;

-(void)startAnimating;

-(void)stopAnimating;

-(BOOL)isAnimating;

@end
