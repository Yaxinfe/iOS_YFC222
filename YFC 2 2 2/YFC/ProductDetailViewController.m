//
//  ProductDetailViewController.m
//  YFC
//
//  Created by topone on 9/19/15.
//  Copyright (c) 2015 ming. All rights reserved.
//
#import "publicHeaders.h"
#import "ProductDetailViewController.h"
#import "ProductCommentViewController.h"
#import "FirstViewController.h"

#import "SwipeView.h"

#import "BuyViewController.h"
#import "DetailItemBuyViewController.h"

#import "LXActivity.h"

#import "LDSDKManager.h"

#import "LDSDKRegisterService.h"
#import "LDSDKPayService.h"
#import "LDSDKAuthService.h"
#import "LDSDKShareService.h"

#define kItemStartTag 1000

#define COMMON_COLOR [UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0]
#define SELECT_COLOR [UIColor redColor]
#define UNCOLOR      [UIColor lightGrayColor]

@interface ProductDetailViewController ()<SwipeViewDataSource, SwipeViewDelegate, LXActivityDelegate>
{
    NSMutableArray *baseColorArray;
    NSMutableArray *baseSizeArray;
    NSString       *detailUrl;
    NSMutableArray *itemInfoArray;
    NSDictionary   *productInfo;
    NSMutableArray *productImgArray;
    
    UIPageControl  *pageControl;
    
    UILabel        *titleLbl;
    UILabel        *priceLbl;
    UILabel        *baedalLbl;
    UILabel        *monthGumaeLbl;
    UILabel        *sizeLbl;
    UILabel        *colorLbl;
    
    UIButton *commentBtn;
    UIButton *shareBtn;
    
    UIView      *product_view;
    UIImageView *product_Img;
    UILabel     *product_priceLbl;
    UILabel     *product_jaegoLbl;
    UILabel     *product_numberLbl;
    UIButton    *plusBtn;
    UIButton    *minBtn;
    
    NSMutableArray *sizeSelectArray;
    NSMutableArray *colorSelectArray;
    
    UISegmentedControl *changeSeg_Size;
    UISegmentedControl *changeSeg_Color;
    
    int addBasketItem;
    NSString *shareURL;
    
    UILabel *basketLbl;
    UIButton *addBasketBtn;
    
    NSString *itemID;
    
    NSMutableArray *sizeBtnArray;
    NSMutableArray *colorBtnArray;
    NSMutableArray *enableColorArray;
    
    NSString *selectedSizeID;
    NSString *selectedColorID;
    
    UIView *buttonView;
    
    UIButton *buyBtn;
    UIButton *selectBtn1;
    
    UIImage *shopShareImg;
    
    NSString *shareDetail;
}

@property (nonatomic, strong) SwipeView *detailImgSwipeView;

@end

@implementation ProductDetailViewController
@synthesize detailImgSwipeView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    baseColorArray = [[NSMutableArray alloc] init];
    baseSizeArray = [[NSMutableArray alloc] init];
    itemInfoArray = [[NSMutableArray alloc] init];
    productImgArray = [[NSMutableArray alloc] init];
    sizeSelectArray = [[NSMutableArray alloc] init];
    colorSelectArray = [[NSMutableArray alloc] init];
    sizeBtnArray = [[NSMutableArray alloc] init];
    colorBtnArray = [[NSMutableArray alloc] init];
    enableColorArray = [[NSMutableArray alloc] init];
    
    addBasketItem = 0;
    // Do any additional setup after loading the view.
    
    detailImgSwipeView = [[SwipeView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width/3*2 - 20)];
    detailImgSwipeView.pagingEnabled = YES;
    detailImgSwipeView.delegate = self;
    detailImgSwipeView.dataSource = self;
    [self.view addSubview:detailImgSwipeView];
    
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width/2 - 50, detailImgSwipeView.frame.size.height, 100, 30)];
    [pageControl setPageIndicatorTintColor:[UIColor lightGrayColor]];
    [pageControl setCurrentPageIndicatorTintColor:[UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0]];
    [pageControl setCurrentPage:0];
    [pageControl setEnabled:NO];
    [self.view addSubview:pageControl];
    
//    [self getProductDetail];
    
    titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, pageControl.frame.origin.y + pageControl.frame.size.height, self.view.frame.size.width - 40, 50)];
    titleLbl.textColor = [UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0];
    titleLbl.backgroundColor = [UIColor clearColor];
    titleLbl.numberOfLines = 2;
    [self.view addSubview:titleLbl];
    
    UIImageView *ballImg = [[UIImageView alloc] initWithFrame:CGRectMake(20, titleLbl.frame.origin.y + titleLbl.frame.size.height + 10, 36, 36)];
    ballImg.image = [UIImage imageNamed:@"blueBall.png"];
    [self.view addSubview:ballImg];
    
    priceLbl = [[UILabel alloc] initWithFrame:CGRectMake(ballImg.frame.origin.x + ballImg.frame.size.width + 15, ballImg.frame.origin.y, 150, 36)];
    priceLbl.textColor = [UIColor redColor];
    priceLbl.backgroundColor = [UIColor clearColor];
    priceLbl.textAlignment = NSTextAlignmentLeft;
    priceLbl.font = [UIFont systemFontOfSize:24.0];
    [self.view addSubview:priceLbl];
    
    UIView *lineImg1 = [[UIView alloc] initWithFrame:CGRectMake(10, ballImg.frame.origin.y + ballImg.frame.size.height + 10, self.view.frame.size.width - 20, 1)];
    lineImg1.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:235.0/255.0 blue:245.0/255.0 alpha:1.0];
    [self.view addSubview:lineImg1];
    
    UILabel *gumae = [[UILabel alloc] initWithFrame:CGRectMake(20, lineImg1.frame.origin.y + lineImg1.frame.size.height + 5, 100, 20)];
    gumae.text = @"月销售量: ";
    gumae.textColor = [UIColor colorWithRed:147.0/255.0 green:147.0/255.0 blue:147.0/255.0 alpha:1.0];
    gumae.backgroundColor = [UIColor clearColor];
    gumae.textAlignment = NSTextAlignmentLeft;
    gumae.font = [UIFont systemFontOfSize:15.0];
    [self.view addSubview:gumae];
    
    monthGumaeLbl = [[UILabel alloc] initWithFrame:CGRectMake(gumae.frame.size.width + gumae.frame.origin.x, gumae.frame.origin.y, 100, 20)];
    monthGumaeLbl.textColor = [UIColor colorWithRed:147.0/255.0 green:147.0/255.0 blue:147.0/255.0 alpha:1.0];
    monthGumaeLbl.backgroundColor = [UIColor clearColor];
    monthGumaeLbl.textAlignment = NSTextAlignmentLeft;
    monthGumaeLbl.font = [UIFont systemFontOfSize:15.0];
    [self.view addSubview:monthGumaeLbl];
    
    UIView *lineImg2 = [[UIView alloc] initWithFrame:CGRectMake(10, monthGumaeLbl.frame.origin.y + monthGumaeLbl.frame.size.height + 5, self.view.frame.size.width - 20, 1)];
    lineImg2.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:235.0/255.0 blue:245.0/255.0 alpha:1.0];
    [self.view addSubview:lineImg2];
    
    UILabel *select = [[UILabel alloc] initWithFrame:CGRectMake(20, lineImg2.frame.origin.y + 10, 40, 20)];
    select.text = @"选择: ";
    select.textColor = [UIColor colorWithRed:147.0/255.0 green:147.0/255.0 blue:147.0/255.0 alpha:1.0];
    select.backgroundColor = [UIColor clearColor];
    select.textAlignment = NSTextAlignmentLeft;
    select.font = [UIFont systemFontOfSize:15.0];
    [self.view addSubview:select];
    
    sizeLbl = [[UILabel alloc] initWithFrame:CGRectMake(select.frame.size.width + select.frame.origin.x + 10, select.frame.origin.y, 80, 20)];
    sizeLbl.textColor = [UIColor colorWithRed:147.0/255.0 green:147.0/255.0 blue:147.0/255.0 alpha:1.0];
    sizeLbl.backgroundColor = [UIColor clearColor];
    sizeLbl.textAlignment = NSTextAlignmentLeft;
    sizeLbl.text = @"大小";
    sizeLbl.font = [UIFont systemFontOfSize:15.0];
    [self.view addSubview:sizeLbl];
    
    colorLbl = [[UILabel alloc] initWithFrame:CGRectMake(sizeLbl.frame.size.width + sizeLbl.frame.origin.x, sizeLbl.frame.origin.y, 100, 20)];
    colorLbl.textColor = [UIColor colorWithRed:147.0/255.0 green:147.0/255.0 blue:147.0/255.0 alpha:1.0];
    colorLbl.backgroundColor = [UIColor clearColor];
    colorLbl.textAlignment = NSTextAlignmentLeft;
    colorLbl.font = [UIFont systemFontOfSize:15.0];
    colorLbl.text = @"颜色";
    [self.view addSubview:colorLbl];
    
    UIButton *selectBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 40, colorLbl.frame.origin.y, 15, 25)];
    [selectBtn setImage:[UIImage imageNamed:@"setting1Btn.png"] forState:UIControlStateNormal];
    [selectBtn addTarget:self action:@selector(selectBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [selectBtn setTintColor:[UIColor lightGrayColor]];
    selectBtn.alpha = 1.0;
    selectBtn.transform = CGAffineTransformMakeTranslation(10, 0);
    [self.view addSubview:selectBtn];
    
    selectBtn1 = [[UIButton alloc] initWithFrame:CGRectMake(0, colorLbl.frame.origin.y, self.view.frame.size.width, 25)];
    [selectBtn1 addTarget:self action:@selector(selectBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [selectBtn1 setTintColor:[UIColor lightGrayColor]];
    selectBtn1.alpha = 1.0;
    selectBtn1.transform = CGAffineTransformMakeTranslation(10, 0);
    [self.view addSubview:selectBtn1];
    
    UIView *lineImg3 = [[UIView alloc] initWithFrame:CGRectMake(10, selectBtn.frame.origin.y + selectBtn.frame.size.height + 10, self.view.frame.size.width - 20, 1)];
    lineImg3.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:235.0/255.0 blue:245.0/255.0 alpha:1.0];
    [self.view addSubview:lineImg3];
    
    buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 209, self.view.frame.size.width, 45)];
    buttonView.backgroundColor = [UIColor clearColor];
    
    commentBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 5, 30, 30)];
    [commentBtn setImage:[UIImage imageNamed:@"comment.png"] forState:UIControlStateNormal];
    [commentBtn addTarget:self action:@selector(commentBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [commentBtn setTintColor:[UIColor lightGrayColor]];
    commentBtn.alpha = 1.0;
    commentBtn.transform = CGAffineTransformMakeTranslation(10, 0);
    [buttonView addSubview:commentBtn];
    
    shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(commentBtn.frame.size.width + commentBtn.frame.origin.x + 20, 5, 27, 30)];
    [shareBtn setImage:[UIImage imageNamed:@"shareIcon.png"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [shareBtn setTintColor:[UIColor lightGrayColor]];
    shareBtn.alpha = 1.0;
    shareBtn.transform = CGAffineTransformMakeTranslation(10, 0);
    [buttonView addSubview:shareBtn];
    
    UIImageView *lineImg =[UIImageView new];
    lineImg.frame=CGRectMake(0, self.view.frame.size.height - 149, self.view.frame.size.width, 2);
    lineImg.clipsToBounds = YES;
    lineImg.userInteractionEnabled=YES;
    lineImg.backgroundColor = [UIColor colorWithRed:216.0/255.0 green:229.0/255.0 blue:241.0/255.0 alpha:1.0];
    [self.view addSubview:lineImg];
    
    buyBtn = [[UIButton alloc] initWithFrame:CGRectMake(buttonView.frame.size.width - 110, 0, 100, 45)];
    [buyBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    [buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buyBtn setBackgroundImage:[UIImage imageNamed:@"buyBtnBack.png"] forState:UIControlStateNormal];
    [buyBtn addTarget:self action:@selector(buyBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [buyBtn setTintColor:[UIColor lightGrayColor]];
    buyBtn.alpha = 1.0;
    buyBtn.transform = CGAffineTransformMakeTranslation(10, 0);
    [buttonView addSubview:buyBtn];
    
    addBasketBtn = [[UIButton alloc] initWithFrame:CGRectMake(buyBtn.frame.origin.x - 110, 0, 100, 45)];
    [addBasketBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
    [addBasketBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addBasketBtn setBackgroundImage:[UIImage imageNamed:@"addBasketBtnBack.png"] forState:UIControlStateNormal];
    [addBasketBtn addTarget:self action:@selector(addBasketBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [addBasketBtn setTintColor:[UIColor lightGrayColor]];
    addBasketBtn.alpha = 1.0;
    addBasketBtn.transform = CGAffineTransformMakeTranslation(10, 0);
    [buttonView addSubview:addBasketBtn];
    
    [self.view addSubview:buttonView];
    
    product_view = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - 100)];
    product_view.backgroundColor = [UIColor clearColor];
    
    UIView *productback_view = [[UIView alloc] initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, product_view.frame.size.height - 30)];
    productback_view.backgroundColor = [UIColor whiteColor];
    productback_view.layer.borderColor = [UIColor lightGrayColor].CGColor;
    productback_view.layer.borderWidth = 1;
    productback_view.layer.masksToBounds = YES;
    [product_view addSubview:productback_view];
    
    product_Img = [[UIImageView alloc] initWithFrame:CGRectMake(30, 0, 90, 90)];
    product_Img.backgroundColor = [UIColor whiteColor];
    product_Img.layer.cornerRadius = 3;
    product_Img.layer.borderColor = [UIColor lightGrayColor].CGColor;
    product_Img.layer.borderWidth = 1;
    product_Img.layer.masksToBounds = YES;
    [product_view addSubview:product_Img];
    
    UIButton *delBtn = [[UIButton alloc] init];
    [delBtn setFrame:CGRectMake(productback_view.frame.size.width - 50, 5, 32, 32)];
    [delBtn setImage:[UIImage imageNamed:@"delBtn.png"] forState:UIControlStateNormal];
    [delBtn setTintColor:[UIColor lightGrayColor]];
    delBtn.alpha = 1.0;
    delBtn.transform = CGAffineTransformMakeTranslation(10, 0);
    [delBtn addTarget:self action:@selector(delBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [productback_view addSubview:delBtn];
    
    UIImageView *dballImg = [[UIImageView alloc] initWithFrame:CGRectMake(product_Img.frame.origin.x + product_Img.frame.size.width + 20, productback_view.frame.origin.y + 10, 25, 25)];
    dballImg.image = [UIImage imageNamed:@"blueBall.png"];
    [product_view addSubview:dballImg];
    
    product_priceLbl = [[UILabel alloc] initWithFrame:CGRectMake(dballImg.frame.origin.x + dballImg.frame.size.width + 15, dballImg.frame.origin.y, 150, 25)];
    product_priceLbl.textColor = [UIColor redColor];
    product_priceLbl.backgroundColor = [UIColor clearColor];
    product_priceLbl.textAlignment = NSTextAlignmentLeft;
    product_priceLbl.font = [UIFont systemFontOfSize:15.0];
    [product_view addSubview:product_priceLbl];
    
    UILabel *jaego = [[UILabel alloc] initWithFrame:CGRectMake(product_Img.frame.origin.x + product_Img.frame.size.width + 20, product_priceLbl.frame.size.height + product_priceLbl.frame.origin.y + 10, 40, 20)];
    jaego.textColor = [UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0];
    jaego.backgroundColor = [UIColor clearColor];
    jaego.text = @"库存: ";
    jaego.textAlignment = NSTextAlignmentLeft;
    jaego.font = [UIFont systemFontOfSize:15.0];
    [product_view addSubview:jaego];
    
    product_jaegoLbl = [[UILabel alloc] initWithFrame:CGRectMake(jaego.frame.origin.x + jaego.frame.size.width, jaego.frame.origin.y, 150, 20)];
    product_jaegoLbl.textColor = [UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0];
    product_jaegoLbl.backgroundColor = [UIColor clearColor];
    product_jaegoLbl.textAlignment = NSTextAlignmentLeft;
    product_jaegoLbl.font = [UIFont systemFontOfSize:15.0];
    [product_view addSubview:product_jaegoLbl];
    
    UILabel *size = [[UILabel alloc] initWithFrame:CGRectMake(30, product_Img.frame.size.height + product_Img.frame.origin.y + 10, 80, 20)];
    size.textColor = [UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0];
    size.backgroundColor = [UIColor clearColor];
    size.text = @"尺 码:";
    size.textAlignment = NSTextAlignmentLeft;
    size.font = [UIFont systemFontOfSize:14.0];
    [product_view addSubview:size];
    
    UIView *lineImg4 = [[UIView alloc] initWithFrame:CGRectMake(10, product_Img.frame.size.height + product_Img.frame.origin.y + 130, self.view.frame.size.width - 20, 1)];
    lineImg4.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:235.0/255.0 blue:245.0/255.0 alpha:1.0];
    [product_view addSubview:lineImg4];
    
    UILabel *color = [[UILabel alloc] initWithFrame:CGRectMake(30, size.frame.size.height + size.frame.origin.y + 40, 80, 20)];
    color.textColor = [UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0];
    color.backgroundColor = [UIColor clearColor];
    color.text = @"颜色分类：";
    color.textAlignment = NSTextAlignmentLeft;
    color.font = [UIFont systemFontOfSize:14.0];
    [product_view addSubview:color];
    
    UILabel *number = [[UILabel alloc] initWithFrame:CGRectMake(30, lineImg4.frame.size.height + lineImg4.frame.origin.y + 10, 80, 20)];
    number.textColor = [UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0];
    number.backgroundColor = [UIColor clearColor];
    number.text = @"数 量：";
    number.textAlignment = NSTextAlignmentLeft;
    number.font = [UIFont systemFontOfSize:14.0];
    [product_view addSubview:number];
    
    minBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, number.frame.origin.y + number.frame.size.height + 10, 30, 30)];
    minBtn.backgroundColor = [UIColor clearColor];
    [minBtn setTitleColor:[UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [minBtn setTitle:@"-" forState:UIControlStateNormal];
    minBtn.layer.borderColor = [UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0].CGColor;
    minBtn.layer.borderWidth = 1;
    minBtn.layer.masksToBounds = YES;
    [minBtn addTarget:self action:@selector(minBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [product_view addSubview:minBtn];
    
    product_numberLbl = [[UILabel alloc] initWithFrame:CGRectMake(minBtn.frame.origin.x + minBtn.frame.size.width, minBtn.frame.origin.y, 60, 30)];
    product_numberLbl.textColor = [UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0];
    product_numberLbl.backgroundColor = [UIColor clearColor];
    product_numberLbl.textAlignment = NSTextAlignmentCenter;
    product_numberLbl.font = [UIFont systemFontOfSize:15.0];
    product_numberLbl.text = @"1";
    product_numberLbl.layer.borderColor = [UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0].CGColor;
    product_numberLbl.layer.borderWidth = 1;
    product_numberLbl.layer.masksToBounds = YES;
    [product_view addSubview:product_numberLbl];
    
    plusBtn = [[UIButton alloc] initWithFrame:CGRectMake(product_numberLbl.frame.origin.x + product_numberLbl.frame.size.width, product_numberLbl.frame.origin.y, 30, 30)];
    plusBtn.backgroundColor = [UIColor clearColor];
    [plusBtn setTitleColor:[UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [plusBtn setTitle:@"+" forState:UIControlStateNormal];
    plusBtn.layer.borderColor = [UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0].CGColor;
    plusBtn.layer.borderWidth = 1;
    plusBtn.layer.masksToBounds = YES;
    [plusBtn addTarget:self action:@selector(plusBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [product_view addSubview:plusBtn];
    
    UIButton *soonBuyBtn = [[UIButton alloc] initWithFrame:CGRectMake(-10, product_view.frame.size.height - 154, self.view.frame.size.width, 50)];
    [soonBuyBtn setTitle:@"确 认" forState:UIControlStateNormal];
    [soonBuyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [soonBuyBtn setBackgroundImage:[UIImage imageNamed:@"buyBtnBack.png"] forState:UIControlStateNormal];
    [soonBuyBtn addTarget:self action:@selector(soonBuyBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [soonBuyBtn setTintColor:[UIColor lightGrayColor]];
    soonBuyBtn.alpha = 1.0;
    soonBuyBtn.transform = CGAffineTransformMakeTranslation(10, 0);
    [product_view addSubview:soonBuyBtn];
    
    [self.view addSubview:product_view];
    
    basketLbl = [[UILabel alloc] initWithFrame:CGRectMake(addBasketBtn.frame.origin.x + 10, addBasketBtn.frame.origin.y, 30, 30)];
    basketLbl.font = [UIFont systemFontOfSize:10.0];
    basketLbl.backgroundColor = [UIColor redColor];
    basketLbl.layer.cornerRadius = 15;
    basketLbl.layer.masksToBounds = YES;
    basketLbl.textAlignment = NSTextAlignmentCenter;
    basketLbl.textColor = [UIColor whiteColor];
    basketLbl.text = product_numberLbl.text;
    basketLbl.hidden = YES;
    [self.view addSubview:basketLbl];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissAdsBanner) name:@"dismissBtnClicked" object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [sizeBtnArray removeAllObjects];
    [colorBtnArray removeAllObjects];
    
    [self getProductDetail];
}

- (void)dismissAdsBanner{
    buttonView.frame = CGRectMake(0, self.view.frame.size.height - 45, self.view.frame.size.width, 45);
}

- (void)delBtnClicked{
    [UIView animateWithDuration:0.3 animations:^{
        product_view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - 100);
    }completion:^(BOOL finished){
        
    }];
}

- (void)shareBtnClicked{
    NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
    if ([applang isEqualToString:@"ko"]) {
        NSArray* aryBtns = @[@"icon1.png", @"icon2.png", @"icon4.png", @"icon3.png"];
        NSArray* titleAry = @[@"微博", @"QQ", @"朋友圈", @"微信"];
        
        LXActivity *lxActivity = [[LXActivity alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"취소" ShareButtonTitles:titleAry withShareButtonImagesName:aryBtns];
        [lxActivity show];
    }
    if ([applang isEqualToString:@"cn"]) {
        NSArray* aryBtns = @[@"icon1.png", @"icon2.png", @"icon4.png", @"icon3.png"];
        NSArray* titleAry = @[@"微博", @"QQ", @"微信朋友圈", @"微信好友"];
        
        LXActivity *lxActivity = [[LXActivity alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"￼取消" ShareButtonTitles:titleAry withShareButtonImagesName:aryBtns];
        [lxActivity show];
    }
}

#pragma mark - LXActivityDelegate

- (void)didClickOnImageIndex:(NSInteger *)imageIndex
{
    UIGraphicsBeginImageContext(CGSizeMake(300,200));
    CGContextRef  context = UIGraphicsGetCurrentContext();
    [shopShareImg drawInRect: CGRectMake(0, 0, 300, 200)];
    UIImage *shareImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if (imageIndex == 0)
    {
        NSLog(@"shareByWeibo");
        
        NSString *shop = [NSString stringWithFormat:@"%@ %@", @"", shareURL];
        
        NSDictionary *shareDict = [NSDictionary
                                   dictionaryWithObjectsAndKeys:
                                   titleLbl.text, LDSDKShareContentTitleKey,
                                   titleLbl.text, LDSDKShareContentDescriptionKey,
                                   shareURL, LDSDKShareContentWapUrlKey,
                                   shareImg, LDSDKShareContentImageKey,
                                   shop, LDSDKShareContentTextKey,
                                   nil];
        [[LDSDKManager getShareService:LDSDKPlatformWeibo]
         shareWithContent:shareDict
         shareModule:LDSDKShareToContact
         onComplete:^(BOOL success, NSError *error) {
             if (success) {

             } else {
                 
             }
         }];
        
    }
    else if ((int)imageIndex == 1)
    {
        NSLog(@"shareByQQ");
        NSDictionary *shareDict = [NSDictionary
                                   dictionaryWithObjectsAndKeys:
                                   titleLbl.text, LDSDKShareContentTitleKey,
                                   shareDetail, LDSDKShareContentDescriptionKey,
                                   shareURL, LDSDKShareContentWapUrlKey,
                                   shareImg, LDSDKShareContentImageKey,
                                   @"Fan Shop", LDSDKShareContentTextKey,
                                   nil];
        [[LDSDKManager getShareService:LDSDKPlatformQQ]
         shareWithContent:shareDict
         shareModule:LDSDKShareToContact
         onComplete:^(BOOL success, NSError *error) {
             if (success) {

             } else {
                 
             }
         }];
        
    }
    else if ((int)imageIndex == 2){
        NSLog(@"shareByWX");
        NSDictionary *shareDict = [NSDictionary
                                   dictionaryWithObjectsAndKeys:
                                   titleLbl.text, LDSDKShareContentTitleKey,
                                   shareDetail, LDSDKShareContentDescriptionKey,
                                   shareURL, LDSDKShareContentWapUrlKey,
                                   shareImg,LDSDKShareContentImageKey,
                                   @"Fan Shop", LDSDKShareContentTextKey,
                                   nil];
        [[LDSDKManager getShareService:LDSDKPlatformWeChat]
         shareWithContent:shareDict
         shareModule:LDSDKShareToTimeLine
         onComplete:^(BOOL success, NSError *error) {
             if (success) {

             }
             else {
                 
             }
         }];
    }
    else if ((int)imageIndex == 3){
        NSLog(@"shareByWX");
        NSDictionary *shareDict = [NSDictionary
                                   dictionaryWithObjectsAndKeys:
                                   titleLbl.text, LDSDKShareContentTitleKey,
                                   shareDetail, LDSDKShareContentDescriptionKey,
                                   shareURL, LDSDKShareContentWapUrlKey,
                                   shareImg,LDSDKShareContentImageKey,
                                   @"Fan Shop", LDSDKShareContentTextKey,
                                   nil];
        [[LDSDKManager getShareService:LDSDKPlatformWeChat]
         shareWithContent:shareDict
         shareModule:LDSDKShareToContact
         onComplete:^(BOOL success, NSError *error) {
             if (success) {

             }
             else {
                 
             }
         }];
    }
    else{
        
    }
    
}

- (void)plusBtnClicked{
    int jaegoNum = [product_jaegoLbl.text intValue];
    
    int count = [product_numberLbl.text intValue];
    count = count + 1;
    
    if (count > jaegoNum) {
        
    }
    else{
        product_numberLbl.text = [NSString stringWithFormat:@"%d", count];
    }
}

- (void)minBtnClicked{
    int count = [product_numberLbl.text intValue];
    if (count == 1) {
        
    }
    else{
        count = count - 1;
        product_numberLbl.text = [NSString stringWithFormat:@"%d", count];
    }
}

- (void)soonBuyBtnClicked{
    NSString *isFirstLogin = [[NSUserDefaults standardUserDefaults] objectForKey:@"isLoginState"];
    if ([isFirstLogin isEqualToString:@"NO"]) {
//        [[AppDelegate sharedAppDelegate] runLogin];
        FirstViewController *loginView = [[FirstViewController alloc] init];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:loginView];
        navi.navigationBarHidden = YES;
        navi.modalPresentationStyle = UIModalPresentationCurrentContext;
        [self presentViewController:navi animated:YES completion:nil];
    }
    else{
        [UIView animateWithDuration:0.3 animations:^{
            product_view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - 100);
        }completion:^(BOOL finished){
            
        }];
    }
    
}

- (void)selectBtnClicked{
    NSString *isFirstLogin = [[NSUserDefaults standardUserDefaults] objectForKey:@"isLoginState"];
    if ([isFirstLogin isEqualToString:@"NO"]) {
//        [[AppDelegate sharedAppDelegate] runLogin];
        FirstViewController *loginView = [[FirstViewController alloc] init];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:loginView];
        navi.navigationBarHidden = YES;
        navi.modalPresentationStyle = UIModalPresentationCurrentContext;
        [self presentViewController:navi animated:YES completion:nil];
    }
    else{
        [UIView animateWithDuration:0.4 animations:^{
            product_view.frame = CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height - 100);
        }completion:^(BOOL finished){
            
        }];
    }
}

- (void)commentBtnClicked{
    NSString *isFirstLogin = [[NSUserDefaults standardUserDefaults] objectForKey:@"isLoginState"];
    if ([isFirstLogin isEqualToString:@"NO"]) {
//        [[AppDelegate sharedAppDelegate] runLogin];
        FirstViewController *loginView = [[FirstViewController alloc] init];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:loginView];
        navi.navigationBarHidden = YES;
        navi.modalPresentationStyle = UIModalPresentationCurrentContext;
        [self presentViewController:navi animated:YES completion:nil];
    }
    else{
        ProductCommentViewController *commentView = [[ProductCommentViewController alloc] init];
        commentView.productId = self.dProductId;
        [self.navigationController pushViewController:commentView animated:YES];
    }
    
}

- (void)buyBtnClicked{
    NSString *isFirstLogin = [[NSUserDefaults standardUserDefaults] objectForKey:@"isLoginState"];
    if ([isFirstLogin isEqualToString:@"NO"]) {
//        [[AppDelegate sharedAppDelegate] runLogin];
        FirstViewController *loginView = [[FirstViewController alloc] init];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:loginView];
        navi.navigationBarHidden = YES;
        navi.modalPresentationStyle = UIModalPresentationCurrentContext;
        [self presentViewController:navi animated:YES completion:nil];
    }
    else{
        if ([sizeLbl.text isEqualToString:@"大小"] || [colorLbl.text isEqualToString:@"颜色"]) {
            
            [UIView animateWithDuration:0.4 animations:^{
                product_view.frame = CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height - 100);
            }completion:^(BOOL finished){
                
            }];
        }
        else{
            if ([product_jaegoLbl.text isEqualToString:@"0"]) {
                NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
                if ([applang isEqualToString:@"ko"]) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"상품이 없습니다." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                }
                if ([applang isEqualToString:@"cn"]) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"商品已下架" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                    [alert show];
                }
                
            }
            else{
                DetailItemBuyViewController *buy_view = [[DetailItemBuyViewController alloc] init];
                
                buy_view.item_color = colorLbl.text;
                buy_view.item_detailID = [[itemInfoArray objectAtIndex:addBasketItem] objectForKey:@"detailpid"];
                
                buy_view.item_brate = [productInfo objectForKey:@"brate"];
                buy_view.item_bulk = [productInfo objectForKey:@"bulk"];
                buy_view.item_drate = [productInfo objectForKey:@"drate"];
                buy_view.item_initfare = [productInfo objectForKey:@"initfare"];
                buy_view.item_weight = [productInfo objectForKey:@"weight"];
                buy_view.item_wrate = [productInfo objectForKey:@"wrate"];
                
                NSString *path = [[itemInfoArray objectAtIndex:addBasketItem] objectForKey:@"url"];
                buy_view.item_imgUrl = path;
                buy_view.item_number = product_numberLbl.text;
                buy_view.item_price = product_priceLbl.text;
                buy_view.item_title = titleLbl.text;
                buy_view.item_itemID = itemID;
                
                for (int i = 0; i < sizeBtnArray.count; i++) {
                    UIButton *sizeBtn = (UIButton*)[sizeBtnArray objectAtIndex:i];
                    [sizeBtn removeFromSuperview];
                }
                for (int i = 0; i < colorBtnArray.count; i++) {
                    UIButton *sizeBtn = (UIButton*)[colorBtnArray objectAtIndex:i];
                    [sizeBtn removeFromSuperview];
                }
                
                [self.navigationController pushViewController:buy_view animated:YES];
            }
        }
    }
}

- (void)addBasketBtnClicked{
    NSString *isFirstLogin = [[NSUserDefaults standardUserDefaults] objectForKey:@"isLoginState"];
    if ([isFirstLogin isEqualToString:@"NO"]) {
//        [[AppDelegate sharedAppDelegate] runLogin];
        FirstViewController *loginView = [[FirstViewController alloc] init];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:loginView];
        navi.navigationBarHidden = YES;
        navi.modalPresentationStyle = UIModalPresentationCurrentContext;
        [self presentViewController:navi animated:YES completion:nil];
    }
    else{
        if ([sizeLbl.text isEqualToString:@"大小"] || [colorLbl.text isEqualToString:@"颜色"]) {
            NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
            if ([applang isEqualToString:@"ko"]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"색갈과 크기 선택해야합니다." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
            if ([applang isEqualToString:@"cn"]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请选择颜色和大小" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                [alert show];
            }
            
        }
        else{
            if ([product_jaegoLbl.text isEqualToString:@"0"]) {
                NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
                if ([applang isEqualToString:@"ko"]) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"상품이 없습니다." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                }
                if ([applang isEqualToString:@"cn"]) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"商品已下架" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                    [alert show];
                }
            }
            else{
                basketLbl.frame = CGRectMake(self.view.frame.size.width - 200, buttonView.frame.origin.y + 5, 30, 30);
                
                NSString *userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"];
                NSString *sessionkey = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionkey"];
                
                NSDictionary *parameters = @{@"userid":userid,
                                             @"detailpid":[[itemInfoArray objectAtIndex:addBasketItem] objectForKey:@"detailpid"],
                                             @"number":product_numberLbl.text,
                                             @"sessionkey":sessionkey
                                             };
                
                NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
                if ([applang isEqualToString:@"ko"]) {
                    [ProgressHUD show:@"장바구니추가중..."];
                }
                if ([applang isEqualToString:@"cn"]) {
                    [ProgressHUD show:@"加入购物车中..."];
                }
                
                [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
                [[GlobalPool sharedInstance].OAuth2Manager POST:LC_SHOP_ADDBASKET parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSLog(@"%@",responseObject);
                    
                    NSString *status = [responseObject objectForKey:@"status"];
                    
                    if ([status intValue] == 200) {
                        
                        NSString *cartCount = [[NSUserDefaults standardUserDefaults] objectForKey:@"cartCount"];
                        int count = [cartCount intValue] + 1;
                        cartCount = [NSString stringWithFormat:@"%d", count];
                        
                        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                        [userDefault setObject:cartCount forKey:@"cartCount"];
                        [userDefault synchronize];
                        
                        [UIView animateWithDuration:0.4 animations:^{
                            basketLbl.hidden = NO;
                            basketLbl.frame = CGRectMake(self.view.frame.size.width - 60, 0, 30, 30);
                        }completion:^(BOOL finished){
                            basketLbl.hidden = YES;
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"changeBasketCount" object:nil];
                            
                            NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
                            if ([applang isEqualToString:@"ko"]) {
                                [ProgressHUD showSuccess:@"장바구니추가 성공!"];
                            }
                            if ([applang isEqualToString:@"cn"]) {
                                [ProgressHUD showSuccess:@"成功加入购物车!"];
                            }
                        }];
                        
                    }
                    else if ([status intValue] == 1001) {
                        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
                        [defaults setObject:@"NO" forKey:@"isLoginState"];
                        [defaults synchronize];
                        [[AppDelegate sharedAppDelegate] runMain];
                    }
                    else{
                        NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
                        if ([applang isEqualToString:@"ko"]) {
                            [ProgressHUD showError:@"장바구니추가 실패!"];
                        }
                        if ([applang isEqualToString:@"cn"]) {
                            [ProgressHUD showError:@"加入购物车失败!"];
                        }
                    }
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [SVProgressHUD showErrorWithStatus:@"Connection failed"];
                }];
            }
        }
    }
}

#pragma mark -
#pragma mark iCarousel methods
- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{
    //return the total number of items in the carousel
    return productImgArray.count;
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    UIImageView *photoView = nil;
    
    //create new view if no view is available for recycling
    if (view == nil)
    {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, detailImgSwipeView.width, detailImgSwipeView.height)];
        view.backgroundColor = [UIColor clearColor];
        view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        photoView = [[UIImageView alloc] initWithFrame:CGRectMake(detailImgSwipeView.width/2 - 100, 0, 200, detailImgSwipeView.height)];
        photoView.backgroundColor = [UIColor clearColor];
        photoView.contentMode = UIViewContentModeScaleAspectFit;
        photoView.tag = kItemStartTag;
        
        [view addSubview:photoView];
    }
    else
    {
        //get a reference to the label in the recycled view
        photoView = (UIImageView *)[view viewWithTag:kItemStartTag];
    }
    
    NSString *path = [productImgArray objectAtIndex:index];
    [photoView setImageWithURL:[NSURL URLWithString:path]];
    
    return view;
}

- (void)swipeViewCurrentItemIndexDidChange:(SwipeView *)swipeView{
    NSInteger currentIndex = detailImgSwipeView.currentItemIndex;
    
    NSString *path = [productImgArray objectAtIndex:currentIndex];
    [product_Img setImageWithURL:[NSURL URLWithString:path]];
    
    [pageControl setCurrentPage:currentIndex];
}

- (CGSize)swipeViewItemSize:(SwipeView *)swipeView
{
    return CGSizeMake(detailImgSwipeView.width, detailImgSwipeView.height);
}

- (void)swipeView:(SwipeView *)swipeView didSelectItemAtIndex:(NSInteger)index {
    
}

- (void)getProductDetail{
    [productImgArray removeAllObjects];
    product_numberLbl.text = @"1";
    
    NSDictionary *parameters = @{@"pid":self.dProductId
                                 };
    [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
    [[GlobalPool sharedInstance].OAuth2Manager POST:LC_SHOP_PRODUCTDETAIL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        
        NSString *status = [responseObject objectForKey:@"status"];
        
        if ([status intValue] == 200) {
            NSDictionary *product_info = [responseObject objectForKey:@"productinfo"];
            
            if (product_info.count == 0) {
                [self.navigationController popViewControllerAnimated:YES];
            }
            else{
                shareURL = [product_info objectForKey:@"detailurl"];
                productInfo = [product_info objectForKey:@"productinfo"];
                
                itemID = [productInfo objectForKey:@"itemid"];
                monthGumaeLbl.text = [productInfo objectForKey:@"number"];
                
                if (![[productInfo objectForKey:@"url1"] isEqualToString:@""]) {
                    [productImgArray addObject:[productInfo objectForKey:@"url1"]];
                }
                if (![[productInfo objectForKey:@"url2"] isEqualToString:@""]) {
                    [productImgArray addObject:[productInfo objectForKey:@"url2"]];
                }
                if (![[productInfo objectForKey:@"url3"] isEqualToString:@""]) {
                    [productImgArray addObject:[productInfo objectForKey:@"url3"]];
                }
                if (![[productInfo objectForKey:@"url4"] isEqualToString:@""]) {
                    [productImgArray addObject:[productInfo objectForKey:@"url4"]];
                }
                if (![[productInfo objectForKey:@"url5"] isEqualToString:@""]) {
                    [productImgArray addObject:[productInfo objectForKey:@"url5"]];
                }
                
                NSString *path = [productImgArray objectAtIndex:0];
                shopShareImg = [UIImage imageWithData: [NSData dataWithContentsOfURL:[NSURL URLWithString:path]]];
                
                pageControl.numberOfPages = productImgArray.count;
                
                titleLbl.text = [productInfo objectForKey:@"name"];
                priceLbl.text = [productInfo objectForKey:@"price"];
                
                shareDetail = [productInfo objectForKey:@"productdetail"];
                
                baseColorArray = [NSMutableArray arrayWithArray:[product_info objectForKey:@"basecolor"]];
                baseSizeArray = [NSMutableArray arrayWithArray:[product_info objectForKey:@"basesize"]];
                itemInfoArray = [NSMutableArray arrayWithArray:[product_info objectForKey:@"iteminfo"]];
                
                if (itemInfoArray.count != 0) {
                    NSString *path = [[itemInfoArray objectAtIndex:0] objectForKey:@"url"];
                    [product_Img setImageWithURL:[NSURL URLWithString:path]];
                    
                    product_priceLbl.text = [[itemInfoArray objectAtIndex:0] objectForKey:@"price"];
                    product_jaegoLbl.text = [[itemInfoArray objectAtIndex:0] objectForKey:@"number"];
                    
                    if ([product_jaegoLbl.text isEqualToString:@"0"] || [product_jaegoLbl.text isEqualToString:@"1"]) {
                        minBtn.enabled = NO;
                        plusBtn.enabled = NO;
                        product_numberLbl.enabled = NO;
                    }
                    
                    for (int i = 0; i < baseSizeArray.count; i++) {
                        UIButton *selectSizeBtn = [[UIButton alloc] initWithFrame:CGRectMake(30 + i*70, product_Img.frame.origin.y + product_Img.frame.size.height + 40, 60, 25)];
                        [selectSizeBtn setTitle:[[baseSizeArray objectAtIndex:i] objectForKey:@"size"] forState:UIControlStateNormal];
                        [selectSizeBtn setTitleColor:COMMON_COLOR forState:UIControlStateNormal];
                        [selectSizeBtn addTarget:self action:@selector(selectedSizeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                        [selectSizeBtn setTintColor:[UIColor lightGrayColor]];
                        selectSizeBtn.alpha = 1.0;
                        selectSizeBtn.tag = [[[baseSizeArray objectAtIndex:i] objectForKey:@"sizeid"] intValue] + 1000;
                        selectSizeBtn.transform = CGAffineTransformMakeTranslation(10, 0);
                        [product_view addSubview:selectSizeBtn];
                        
                        selectSizeBtn.layer.cornerRadius = 3;
                        selectSizeBtn.layer.borderColor = COMMON_COLOR.CGColor;
                        selectSizeBtn.layer.borderWidth = 1;
                        selectSizeBtn.layer.masksToBounds = YES;
                        
                        [sizeBtnArray addObject:selectSizeBtn];
                    }
                    
                    for (int i = 0; i < baseColorArray.count; i++) {
                        UIButton *selectColorBtn = [[UIButton alloc] initWithFrame:CGRectMake(30 + i*70, product_Img.frame.origin.y + product_Img.frame.size.height + 100, 60, 25)];
                        [selectColorBtn setTitle:[[baseColorArray objectAtIndex:i] objectForKey:@"name"] forState:UIControlStateNormal];
                        [selectColorBtn setTitleColor:COMMON_COLOR forState:UIControlStateNormal];
                        [selectColorBtn addTarget:self action:@selector(selectedColorBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                        [selectColorBtn setTintColor:[UIColor lightGrayColor]];
                        selectColorBtn.alpha = 1.0;
                        selectColorBtn.tag = [[[baseColorArray objectAtIndex:i] objectForKey:@"colorid"] intValue] + 2000;
                        selectColorBtn.transform = CGAffineTransformMakeTranslation(10, 0);
                        [product_view addSubview:selectColorBtn];
                        
                        selectColorBtn.layer.cornerRadius = 3;
                        selectColorBtn.layer.borderColor = COMMON_COLOR.CGColor;
                        selectColorBtn.layer.borderWidth = 1;
                        selectColorBtn.layer.masksToBounds = YES;
                        
                        [colorBtnArray addObject:selectColorBtn];
                    }
                    
                    //            sizeLbl.text = [[baseSizeArray objectAtIndex:0] objectForKey:@"size"];
                    //            colorLbl.text = [[baseColorArray objectAtIndex:0] objectForKey:@"name"];
                    
                }
                else{
                    selectBtn1.enabled = NO;
                    addBasketBtn.enabled = NO;
                    buyBtn.enabled = NO;
                }
            }
            
            [detailImgSwipeView reloadData];
        }
        else{
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
//            [alert show];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"Connection failed"];
    }];
}

- (void)selectedSizeBtnClicked:(id)sender{
    [enableColorArray removeAllObjects];
    
    UIButton *btn = (UIButton *)sender;
    sizeLbl.text = btn.titleLabel.text;
    NSString *sizeID = [NSString stringWithFormat:@"%ld", btn.tag - 1000];
    selectedSizeID = sizeID;
    
    for (int i = 0; i< sizeBtnArray.count; i++) {
        UIButton *sizeBtn = (UIButton*)[sizeBtnArray objectAtIndex:i];
        if ([sizeBtn.titleLabel.text isEqualToString:btn.titleLabel.text]) {
            [sizeBtn setTitleColor:SELECT_COLOR forState:UIControlStateNormal];
            sizeBtn.layer.borderColor = SELECT_COLOR.CGColor;
        }
        else{
            [sizeBtn setTitleColor:COMMON_COLOR forState:UIControlStateNormal];
            sizeBtn.layer.borderColor = COMMON_COLOR.CGColor;
        }
    }
    
    for (int i = 0; i < itemInfoArray.count; i++) {
        if ([[[itemInfoArray objectAtIndex:i] objectForKey:@"sizeid"] isEqualToString:sizeID]) {
            [enableColorArray addObject:[[itemInfoArray objectAtIndex:i] objectForKey:@"colorid"]];
        }
    }
    
    for (int i = 0; i < colorBtnArray.count; i++) {
        UIButton *colorBtn = (UIButton*)[colorBtnArray objectAtIndex:i];
        NSString *colorID = [NSString stringWithFormat:@"%ld", colorBtn.tag - 2000];
        
        for (int j = 0; j < enableColorArray.count; j++) {
            if ([colorID isEqualToString:[enableColorArray objectAtIndex:j]]) {
                [colorBtn setTitleColor:COMMON_COLOR forState:UIControlStateNormal];
                colorBtn.layer.borderColor = COMMON_COLOR.CGColor;
                colorBtn.enabled = YES;
            }
            else{
                [colorBtn setTitleColor:UNCOLOR forState:UIControlStateNormal];
                colorBtn.layer.borderColor = UNCOLOR.CGColor;
                colorBtn.enabled = NO;
            }
        }
    }
}

- (void)selectedColorBtnClicked:(id)sender{
    UIButton *btn = (UIButton *)sender;
    colorLbl.text = btn.titleLabel.text;
    NSString *colorID = [NSString stringWithFormat:@"%ld", btn.tag - 2000];
    selectedColorID = colorID;
    
    for (int i = 0; i < colorBtnArray.count; i++) {
        UIButton *colorBtn = (UIButton*)[colorBtnArray objectAtIndex:i];
        NSString *sColorID = [NSString stringWithFormat:@"%ld", colorBtn.tag - 2000];
        
        if ([colorID isEqualToString:sColorID]) {
            [colorBtn setTitleColor:SELECT_COLOR forState:UIControlStateNormal];
            colorBtn.layer.borderColor = SELECT_COLOR.CGColor;
        }
    }
    
    for (int i = 0; i < itemInfoArray.count; i++) {
        NSString *sid = [[itemInfoArray objectAtIndex:i] objectForKey:@"sizeid"];
        NSString *cid = [[itemInfoArray objectAtIndex:i] objectForKey:@"colorid"];
        
        if ([sid isEqualToString:selectedSizeID] && [cid isEqualToString:selectedColorID]) {
            product_priceLbl.text = [[itemInfoArray objectAtIndex:i] objectForKey:@"price"];
            product_jaegoLbl.text = [[itemInfoArray objectAtIndex:i] objectForKey:@"number"];
        
            if ([product_jaegoLbl.text isEqualToString:@"0"] || [product_jaegoLbl.text isEqualToString:@"1"]) {
                minBtn.enabled = NO;
                plusBtn.enabled = NO;
                product_numberLbl.text = product_jaegoLbl.text;
                product_numberLbl.enabled = NO;
            }
            else{
                minBtn.enabled = YES;
                plusBtn.enabled = YES;
                product_numberLbl.enabled = YES;
            }
        
            NSString *path = [[itemInfoArray objectAtIndex:i] objectForKey:@"url"];
            [product_Img setImageWithURL:[NSURL URLWithString:path]];
            
            addBasketItem = i;
        }
    }
    
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
