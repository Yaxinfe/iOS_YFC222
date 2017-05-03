//
//  MemDetailViewController.m
//  YFC
//
//  Created by topone on 7/20/15.
//  Copyright (c) 2015 ming. All rights reserved.
//
#import "publicHeaders.h"
#import "MemDetailViewController.h"

#import "PlayerView.h"
#import <AVFoundation/AVFoundation.h>

@interface MemDetailViewController ()<PlayerViewDelegate>
{
    UIScrollView *scrollView;
}

@property (strong, nonatomic) PlayerView *playerView;

@end

@implementation MemDetailViewController
@synthesize str_Name, str_PhotoURL, str_VideoURL, str_Detail, str_Spec, str_Weight, str_Height, str_Pos;
@synthesize playerView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    backImageView.image = [UIImage imageNamed:@"memDetailBack.png"];
    [self.view addSubview:backImageView];
    
    UIButton *back_btn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.origin.x , self.view.frame.origin.y + 25, 27, 30)];
    [back_btn setImage:[UIImage imageNamed:@"backBtn.png"] forState:UIControlStateNormal];
    [back_btn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [back_btn setTintColor:[UIColor lightGrayColor]];
    back_btn.alpha = 1.0;
    back_btn.transform = CGAffineTransformMakeTranslation(10, 0);
    [self.view addSubview:back_btn];
    
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 100, 30, 200, 24)];
    titleLbl.text = str_Name;
    titleLbl.font = [UIFont boldSystemFontOfSize:22.0];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.textColor = [UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0];
    [self.view addSubview:titleLbl];
    
    UIImageView *lineImg5 =[UIImageView new];
    lineImg5.frame=CGRectMake(0, 63, self.view.frame.size.width, 2);
    lineImg5.clipsToBounds = YES;
    lineImg5.userInteractionEnabled=YES;
    lineImg5.backgroundColor = [UIColor colorWithRed:216.0/255.0 green:229.0/255.0 blue:241.0/255.0 alpha:1.0];
    [self.view addSubview:lineImg5];
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 65, self.view.frame.size.width, self.view.frame.size.height - 65)];
    scrollView.alwaysBounceHorizontal = NO;
    scrollView.alwaysBounceVertical = YES;
    
    UIImageView *photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x + 10, 10, self.view.frame.size.width/2 - 20, (self.view.frame.size.width/2 - 10)/9.0f*16.0f)];
    NSString *path = str_PhotoURL;
    [photoImageView setImageWithURL:[NSURL URLWithString:path]];
    [scrollView addSubview:photoImageView];
    
    UIImageView *textBack1 = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 98, 40, 98, 40)];
    textBack1.image = [UIImage imageNamed:@"textBack1.png"];
    [scrollView addSubview:textBack1];
    
    UILabel *typeLbl = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 98, 40, 98, 40)];
    typeLbl.font = [UIFont systemFontOfSize:15.0];
    typeLbl.textAlignment = NSTextAlignmentCenter;
    typeLbl.textColor = [UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0];
    [scrollView addSubview:typeLbl];
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger year = [components year];
    
    NSString *birthday = [str_Pos substringToIndex:4];
    NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
    if ([applang isEqualToString:@"ko"]) {
        typeLbl.text = [NSString stringWithFormat:@"%ld세", year - [birthday integerValue]];
    }
    if ([applang isEqualToString:@"cn"]) {
        typeLbl.text = [NSString stringWithFormat:@"%ld岁", year - [birthday integerValue]];
    }
    
    UIImageView *textBack2 = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 110, 80, 110, 40)];
    textBack2.image = [UIImage imageNamed:@"textBack2.png"];
    [scrollView addSubview:textBack2];
    
    UILabel *heightLbl = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 110, 80, 110, 40)];
    heightLbl.text = [NSString stringWithFormat:@"%@cm", str_Height];
    heightLbl.font = [UIFont systemFontOfSize:15.0];
    heightLbl.textAlignment = NSTextAlignmentCenter;
    heightLbl.textColor = [UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0];
    [scrollView addSubview:heightLbl];
    
    UIImageView *textBack3 = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 117, 120, 117, 40)];
    textBack3.image = [UIImage imageNamed:@"textBack3.png"];
    [scrollView addSubview:textBack3];
    
    UILabel *weightLbl = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 117, 120, 117, 40)];
    weightLbl.text = [NSString stringWithFormat:@"%@kg", str_Weight];
    weightLbl.font = [UIFont systemFontOfSize:15.0];
    weightLbl.textAlignment = NSTextAlignmentCenter;
    weightLbl.textColor = [UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0];
    [scrollView addSubview:weightLbl];
    
    UIImageView *textBack4 = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 126, 160, 126, 45)];
    textBack4.image = [UIImage imageNamed:@"textBack4.png"];
    [scrollView addSubview:textBack4];
    
    UILabel *specLbl = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 126, 160, 126, 45)];
    specLbl.text = str_Spec;
    specLbl.font = [UIFont systemFontOfSize:15.0];
    specLbl.textAlignment = NSTextAlignmentCenter;
    specLbl.textColor = [UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0];
    [scrollView addSubview:specLbl];
    
    if ([str_VideoURL isEqualToString:@""]) {
        UILabel *detailLbl = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.origin.x + 10, photoImageView.frame.origin.y + photoImageView.frame.size.height + 20, self.view.frame.size.width - 20, 80)];
        detailLbl.text = str_Detail;
        detailLbl.font = [UIFont systemFontOfSize:13.0];
        detailLbl.textAlignment = NSTextAlignmentLeft;
        detailLbl.textColor = [UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0];
        detailLbl.numberOfLines = 100;
        
        CGSize constrainedSize = CGSizeMake(detailLbl.frame.size.width, 9999);
        NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                              [UIFont systemFontOfSize:13.0], NSFontAttributeName,
                                              nil];
        
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:str_Detail attributes:attributesDictionary];
        CGRect requiredHeight = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        CGRect newFrame = detailLbl.frame;
        newFrame.size.height = requiredHeight.size.height;
        detailLbl.frame = newFrame;
        
        [scrollView addSubview:detailLbl];
        
        scrollView.contentSize = CGSizeMake(self.view.frame.size.width, detailLbl.frame.origin.y + detailLbl.frame.size.height + 20);
        [self.view addSubview:scrollView];
    }
    else{
        UILabel *detailLbl = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.origin.x + 10, photoImageView.frame.origin.y + photoImageView.frame.size.height + 20, self.view.frame.size.width - 20, 80)];
        detailLbl.text = str_Detail;
        detailLbl.font = [UIFont boldSystemFontOfSize:12.0];
        detailLbl.textAlignment = NSTextAlignmentLeft;
        detailLbl.textColor = [UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0];
        detailLbl.numberOfLines = 100;
        
        CGSize constrainedSize = CGSizeMake(detailLbl.frame.size.width, 9999);
        NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                              [UIFont systemFontOfSize:13.0], NSFontAttributeName,
                                              nil];
        
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:str_Detail attributes:attributesDictionary];
        CGRect requiredHeight = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        CGRect newFrame = detailLbl.frame;
        newFrame.size.height = requiredHeight.size.height;
        detailLbl.frame = newFrame;
        
        [scrollView addSubview:detailLbl];
        scrollView.frame = CGRectMake(0, 65, self.view.frame.size.width, self.view.frame.size.height - 65 - (self.view.frame.size.width - 10)*9.0f/16.0f);
        scrollView.contentSize = CGSizeMake(self.view.frame.size.width, detailLbl.frame.origin.y + detailLbl.frame.size.height + 20);

        [self.view addSubview:scrollView];
        
        playerView = [[PlayerView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x + 10, self.view.frame.size.height - (self.view.frame.size.width - 10)*9.0f/16.0f, self.view.frame.size.width - 20, (self.view.frame.size.width - 10)*9.0f/16.0f - 10)];
        [playerView setDelegate:self];
        playerView.backgroundColor = [UIColor blackColor];
        
        [self.view addSubview:playerView];
        
        [playerView setVideoURL:[NSURL URLWithString:str_VideoURL]];
        [playerView prepareAndPlayAutomatically:NO];
    }
}

- (void)backBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
    [playerView clean];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
