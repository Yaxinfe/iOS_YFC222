//
//  PayMethodViewController.h
//  YFC
//
//  Created by iOS on 06/08/15.
//  Copyright (c) 2015 ming. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WXApi.h"

@interface PayMethodViewController : UIViewController<WXApiDelegate>
{
    enum WXScene _scene;
}
@property int ballCount;

@end
