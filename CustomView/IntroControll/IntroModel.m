#import "IntroModel.h"
#import "UIImageView+AFNetworking.h"

@implementation IntroModel

@synthesize titleText;
@synthesize descriptionText;
@synthesize image;

//- (id) initWithTitle:(NSString*)title description:(NSString*)desc image:(NSString*)imageText {
//    self = [super init];
//    if(self != nil) {
//        titleText = title;
//        descriptionText = desc;
////        image = [UIImage imageNamed:imageText];
//        [image setImageWithURL:[NSURL URLWithString:imageText]];
//    }
//    return self;
//}

- (id) initWithTitle:(NSString*)title description:(NSString*)desc image:(NSData*)imageData {
    self = [super init];
    if(self != nil) {
        titleText = title;
        descriptionText = desc;
        image = [UIImage imageWithData:imageData];
    }
    return self;
}

@end
