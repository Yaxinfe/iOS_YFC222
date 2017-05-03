//
//  NewsDetailViewController.m
//  YFC
//
//  Created by topone on 7/15/15.
//  Copyright (c) 2015 ming. All rights reserved.
//

#import "publicHeaders.h"
#import "NewsDetailViewController.h"

#import "AllAroundPullView.h"

#import "YFGIFImageView.h"
#import "UIImageView+PlayGIF.h"

#import "LXActivity.h"
#import "WXApi.h"

#import "LDSDKManager.h"

#import "LDSDKRegisterService.h"
#import "LDSDKPayService.h"
#import "LDSDKAuthService.h"
#import "LDSDKShareService.h"

#import "CommentTableViewCell.h"
#import "ReplyTableViewCell.h"

#import "AdsDetailViewController.h"
#import "FirstViewController.h"

#define PADDING_HEIGHT1 10
#define PADDING_HEIGHT2 10

#define PADDING_WIDTH  110

@interface NewsDetailViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, LXActivityDelegate, WXApiDelegate>
{
    NSArray *activity;
    
    UITableView *commentTable;
    UITableView *contentTable;
    
    NSMutableArray *contentArray;
    NSMutableArray *commentArray;
    NSMutableArray *replyArrayForReply;
    NSMutableArray *adsArray;
    
    NSDictionary *newsInfo;
    
    UIScrollView *scrollView;
    
    UIView   *shareView;
    UIButton *likeBtn;
    UIButton *commentBtn;
    UIButton *shareBtn;
    
    NSString *shareURL;
    int likeCount;
    int commentCount;
    BOOL isLike;
    
    UIView *commentView;
    UITextField *sendText;
    
    UIView *leftWordView;
    UITextField *sendWord;
    
    UIView *replyWordView;
    UITextField *sendReply;
    
    NSString *lastReplyID;
    NSString *commentID;
    
    UIView *bannerView;
    UIImageView *bannerImg;
    
    UILabel *title_lbl;
    UILabel *lbl_DetailContent;
    UIImageView *detailimage;
    NSString *adsDetailUrl;
    NSString *adsDetailTitle;
    
    BOOL isComment;
    BOOL isLeft;
    BOOL isReply;
}

@property (nonatomic, strong) UIImageView *lineImg;
@property (nonatomic, strong) UILabel     *newsLikes;
@property (nonatomic, strong) UILabel     *newsComment;

@end

@implementation NewsDetailViewController

@synthesize lineImg;

@synthesize newsComment, newsLikes;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    commentArray = [[NSMutableArray alloc] init];
    contentArray = [[NSMutableArray alloc] init];
    adsArray = [[NSMutableArray alloc] init];
    
    isComment = NO;
    isLeft = NO;
    isReply = NO;
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    backImageView.image = [UIImage imageNamed:@"newsBackImg.png"];
    [self.view addSubview:backImageView];
    
    UIButton *back_btn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.origin.x , self.view.frame.origin.y + 25, 27, 30)];
    [back_btn setImage:[UIImage imageNamed:@"backBtn.png"] forState:UIControlStateNormal];
    [back_btn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [back_btn setTintColor:[UIColor lightGrayColor]];
//    back_btn.alpha = 1.0;
    back_btn.transform = CGAffineTransformMakeTranslation(10, 0);
    [self.view addSubview:back_btn];
    
    UILabel *lbl_Title = [[UILabel alloc] init];
    [lbl_Title setFrame:CGRectMake(self.view.frame.origin.x + 0, self.view.frame.origin.y + 30, self.view.frame.size.width, 24)];
    [lbl_Title setTextAlignment:NSTextAlignmentCenter];
    [lbl_Title setTextColor:[UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0]];
    [lbl_Title setBackgroundColor:[UIColor clearColor]];
    [lbl_Title setFont:[UIFont boldSystemFontOfSize:22.0]];
//    lbl_Title.text = @"NEWS";
    [self.view addSubview:lbl_Title];
    
    UIImageView *lineImg5 =[UIImageView new];
    lineImg5.frame=CGRectMake(0, 63, self.view.frame.size.width, 2);
    lineImg5.clipsToBounds = YES;
    lineImg5.userInteractionEnabled=YES;
    lineImg5.backgroundColor = [UIColor colorWithRed:216.0/255.0 green:229.0/255.0 blue:241.0/255.0 alpha:1.0];
    [self.view addSubview:lineImg5];
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 65, self.view.frame.size.width, self.view.frame.size.height - 185)];
    scrollView.alwaysBounceHorizontal = NO;
    scrollView.alwaysBounceVertical = YES;
    
    title_lbl = [[UILabel alloc]init];
    [title_lbl setFrame:CGRectMake(10, 2, self.view.frame.size.width - 20, 40)];
    [title_lbl setTextAlignment:NSTextAlignmentLeft];
    [title_lbl setTextColor:[UIColor colorWithRed:65.0/255.0 green:111.0/255.0 blue:155.0/255.0 alpha:1.0]];
    [title_lbl setBackgroundColor:[UIColor clearColor]];
    [title_lbl setFont:[UIFont boldSystemFontOfSize:16.0]];
    title_lbl.numberOfLines = 2;
    [scrollView addSubview:title_lbl];
    title_lbl.text = _strNewsTitle;
    
    detailimage =[UIImageView new];
    detailimage.frame=CGRectMake(10, title_lbl.frame.origin.y + title_lbl.frame.size.height, self.view.frame.size.width - 20, (self.view.frame.size.width - 20)/16*9 - 4);
    detailimage.clipsToBounds = YES;
    detailimage.userInteractionEnabled=YES;
    detailimage.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:detailimage];
    [detailimage setImageWithURL:[NSURL URLWithString:_strNewsImageUrl]];
    
    lbl_DetailContent = [[UILabel alloc]init];
    [lbl_DetailContent setFrame:CGRectMake(10, detailimage.frame.origin.y + detailimage.frame.size.height + 10, self.view.frame.size.width - 20, 300)];
    [lbl_DetailContent setTextAlignment:NSTextAlignmentLeft];
    [lbl_DetailContent setTextColor:[UIColor colorWithRed:65.0/255.0 green:111.0/255.0 blue:155.0/255.0 alpha:1.0]];
    [lbl_DetailContent setBackgroundColor:[UIColor clearColor]];
    [lbl_DetailContent setFont:[UIFont systemFontOfSize:17.0]];
    lbl_DetailContent.numberOfLines = 100;
    [scrollView addSubview:lbl_DetailContent];
    lbl_DetailContent.text = _strNewsContent;
    
    CGSize constrainedSize = CGSizeMake(lbl_DetailContent.frame.size.width, 9999);
    
    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                          [UIFont systemFontOfSize:17.0], NSFontAttributeName,
                                          nil];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:_strNewsContent attributes:attributesDictionary];
    CGRect requiredHeight = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    CGRect newFrame = lbl_DetailContent.frame;
    newFrame.size.height = requiredHeight.size.height;
    lbl_DetailContent.frame = newFrame;
    
    contentTable = [[UITableView alloc] initWithFrame:CGRectMake(0, lbl_DetailContent.frame.origin.y + lbl_DetailContent.frame.size.height, self.view.frame.size.width, contentArray.count*200 + 10) style:UITableViewStylePlain];
    contentTable.dataSource = self;
    contentTable.delegate = self;
    contentTable.scrollEnabled = NO;
    [contentTable setBackgroundColor:[UIColor clearColor]];
    contentTable.userInteractionEnabled=YES;
    [contentTable setAllowsSelection:YES];
    contentTable.scrollEnabled = NO;
    if ([contentTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [contentTable setSeparatorInset:UIEdgeInsetsZero];
    }
    [contentTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [scrollView addSubview:contentTable];
    
    lineImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, contentTable.frame.origin.y + contentTable.frame.size.height + 5, self.view.frame.size.width - 20, 1)];
    lineImg.backgroundColor = [UIColor lightGrayColor];
    [scrollView addSubview:lineImg];
    
    commentTable = [[UITableView alloc] initWithFrame:CGRectMake(0, lineImg.frame.origin.y + lineImg.frame.size.height + 10, self.view.frame.size.width, commentArray.count*85 + 10) style:UITableViewStylePlain];
    [commentTable registerClass:[CommentTableViewCell class] forCellReuseIdentifier:@"CommentCell"];
    commentTable.delegate = self;
    commentTable.dataSource = self;
    commentTable.backgroundColor = [UIColor clearColor];
    commentTable.scrollEnabled = NO;
    [commentTable setSeparatorInset:UIEdgeInsetsZero];
    [commentTable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [commentTable setSeparatorColor:[UIColor colorWithRed:216.0/255.0 green:229.0/255.0 blue:241.0/255.0 alpha:1.0]];
    [scrollView addSubview:commentTable];
    
    // top
    AllAroundPullView *topPullView = [[AllAroundPullView alloc] initWithScrollView:scrollView position:AllAroundPullViewPositionTop action:^(AllAroundPullView *view){
        NSLog(@"--");
        [view performSelector:@selector(finishedLoading) withObject:nil afterDelay:4.0f];
        [self getRequests];
    }];
    topPullView.backgroundColor = [UIColor clearColor];
    topPullView.activityView.hidden = YES;
    
    NSData *gifData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"football1.gif" ofType:nil]];
    YFGIFImageView *gifView = [[YFGIFImageView alloc] initWithFrame:CGRectMake(topPullView.frame.size.width/2 - 90, topPullView.frame.size.height - 50, 180, 50)];
    gifView.backgroundColor = [UIColor clearColor];
    gifView.gifData = gifData;
    [topPullView addSubview:gifView];
    [gifView startGIF];
    gifView.userInteractionEnabled = YES;
    
    [scrollView addSubview:topPullView];
    
    // bottom
    AllAroundPullView *bottomPullView = [[AllAroundPullView alloc] initWithScrollView:scrollView position:AllAroundPullViewPositionBottom action:^(AllAroundPullView *view){
        NSLog(@"--");
        [view performSelector:@selector(finishedLoading) withObject:nil afterDelay:4.0f];
        [self getLoadMoreComments];
    }];
    bottomPullView.backgroundColor = [UIColor clearColor];
    bottomPullView.activityView.hidden = YES;
    
    NSData *gifData1 = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"football1.gif" ofType:nil]];
    YFGIFImageView *gifView1 = [[YFGIFImageView alloc] initWithFrame:CGRectMake(bottomPullView.frame.size.width/2 - 90, 0, 180, 50)];
    gifView1.backgroundColor = [UIColor clearColor];
    gifView1.gifData = gifData1;
    [bottomPullView addSubview:gifView1];
    [gifView1 startGIF];
    gifView1.userInteractionEnabled = YES;
    
    [scrollView addSubview:bottomPullView];
    
    [self.view addSubview:scrollView];
    
    //CommentView
    commentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 50)];
    commentView.backgroundColor = [UIColor whiteColor];
    
    UIButton *sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(commentView.frame.size.width - 100, 5, 80, 40)];
    sendBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [sendBtn setTitleColor:[UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(sendBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [sendBtn setTintColor:[UIColor lightGrayColor]];
    sendBtn.alpha = 1.0;
    sendBtn.transform = CGAffineTransformMakeTranslation(10, 0);
    [commentView addSubview:sendBtn];
    
    UIImageView *lineImg1 = [[UIImageView alloc] initWithFrame:CGRectMake(20, 5, commentView.frame.size.width - 120, 40)];
    lineImg1.backgroundColor = [UIColor clearColor];
    lineImg1.layer.cornerRadius = 5;
    lineImg1.layer.borderColor = [UIColor lightGrayColor].CGColor;
    lineImg1.layer.borderWidth = 1;
    lineImg1.layer.masksToBounds = YES;
    [commentView addSubview:lineImg1];
    
    sendText = [[UITextField alloc] initWithFrame:CGRectMake(25, 8, commentView.frame.size.width - 130, 34)];
    sendText.backgroundColor = [UIColor whiteColor];
    sendText.textColor = [UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0];
    sendText.font = [UIFont systemFontOfSize:15.0];
    sendText.keyboardType = UIKeyboardTypeDefault;
    sendText.delegate = self;
    [sendText setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [commentView addSubview:sendText];
    
    commentView.layer.cornerRadius = 5;
    commentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    commentView.layer.borderWidth = 1;
    commentView.layer.masksToBounds = YES;
    
    [self.view addSubview:commentView];
    
    //LeftWordView
    leftWordView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 50)];
    leftWordView.backgroundColor = [UIColor whiteColor];
    
    UIButton *sendWordBtn = [[UIButton alloc] initWithFrame:CGRectMake(leftWordView.frame.size.width - 100, 5, 80, 40)];
    sendWordBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [sendWordBtn setTitleColor:[UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [sendWordBtn addTarget:self action:@selector(sendWordBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [sendWordBtn setTintColor:[UIColor lightGrayColor]];
    sendWordBtn.alpha = 1.0;
    sendWordBtn.transform = CGAffineTransformMakeTranslation(10, 0);
    [leftWordView addSubview:sendWordBtn];
    
    UIImageView *lineImg2 = [[UIImageView alloc] initWithFrame:CGRectMake(20, 5, leftWordView.frame.size.width - 120, 40)];
    lineImg2.backgroundColor = [UIColor clearColor];
    lineImg2.layer.cornerRadius = 5;
    lineImg2.layer.borderColor = [UIColor lightGrayColor].CGColor;
    lineImg2.layer.borderWidth = 1;
    lineImg2.layer.masksToBounds = YES;
    [leftWordView addSubview:lineImg2];
    
    sendWord = [[UITextField alloc] initWithFrame:CGRectMake(25, 8, leftWordView.frame.size.width - 130, 34)];
    sendWord.backgroundColor = [UIColor whiteColor];
    sendWord.font = [UIFont systemFontOfSize:15.0];
    sendWord.keyboardType = UIKeyboardTypeDefault;
    sendWord.delegate = self;
    [sendWord setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [leftWordView addSubview:sendWord];
    
    leftWordView.layer.cornerRadius = 5;
    leftWordView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    leftWordView.layer.borderWidth = 1;
    leftWordView.layer.masksToBounds = YES;
    
    [self.view addSubview:leftWordView];
    
    //ReplyWordView
    replyWordView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 50)];
    replyWordView.backgroundColor = [UIColor whiteColor];
    
    UIButton *sendReplyBtn = [[UIButton alloc] initWithFrame:CGRectMake(leftWordView.frame.size.width - 100, 5, 80, 40)];
    sendReplyBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [sendReplyBtn setTitleColor:[UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [sendReplyBtn addTarget:self action:@selector(sendReplyBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [sendReplyBtn setTintColor:[UIColor lightGrayColor]];
    sendReplyBtn.alpha = 1.0;
    sendReplyBtn.transform = CGAffineTransformMakeTranslation(10, 0);
    [replyWordView addSubview:sendReplyBtn];
    
    NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
    if ([applang isEqualToString:@"ko"]) {
        lbl_Title.text = NEWS_DETAIL_TITLE[0];
        [sendBtn setTitle:NEWS_DETAIL_SEND_BUTTON[0] forState:UIControlStateNormal];
        sendText.placeholder = NEWS_DETAIL_COMMENT[0];
        [sendWordBtn setTitle:NEWS_DETAIL_SEND_BUTTON[0] forState:UIControlStateNormal];
        [sendReplyBtn setTitle:NEWS_DETAIL_SEND_BUTTON[0] forState:UIControlStateNormal];
    }
    if ([applang isEqualToString:@"cn"]) {
        lbl_Title.text = NEWS_DETAIL_TITLE[1];
        [sendBtn setTitle:NEWS_DETAIL_SEND_BUTTON[1] forState:UIControlStateNormal];
        sendText.placeholder = NEWS_DETAIL_COMMENT[1];
        [sendWordBtn setTitle:NEWS_DETAIL_SEND_BUTTON[1] forState:UIControlStateNormal];
        [sendReplyBtn setTitle:NEWS_DETAIL_SEND_BUTTON[1] forState:UIControlStateNormal];
    }
    
    UIImageView *lineImg4 = [[UIImageView alloc] initWithFrame:CGRectMake(20, 5, leftWordView.frame.size.width - 120, 40)];
    lineImg4.backgroundColor = [UIColor clearColor];
    lineImg4.layer.cornerRadius = 5;
    lineImg4.layer.borderColor = [UIColor lightGrayColor].CGColor;
    lineImg4.layer.borderWidth = 1;
    lineImg4.layer.masksToBounds = YES;
    [replyWordView addSubview:lineImg4];
    
    sendReply = [[UITextField alloc] initWithFrame:CGRectMake(25, 8, leftWordView.frame.size.width - 130, 34)];
    sendReply.backgroundColor = [UIColor whiteColor];
    sendReply.font = [UIFont systemFontOfSize:15.0];
    sendReply.keyboardType = UIKeyboardTypeDefault;
    sendReply.delegate = self;
    [sendReply setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [replyWordView addSubview:sendReply];
    
    replyWordView.layer.cornerRadius = 5;
    replyWordView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    replyWordView.layer.borderWidth = 1;
    replyWordView.layer.masksToBounds = YES;
    
    [self.view addSubview:replyWordView];
    
    //ShareView
    shareView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 120, self.view.frame.size.width, 60)];
    shareView.backgroundColor = [UIColor whiteColor];
    shareView.layer.cornerRadius = 3;
    shareView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    shareView.layer.borderWidth = 1;
    shareView.layer.masksToBounds = YES;
    
    likeBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 15, 30, 30)];
    [likeBtn setImage:[UIImage imageNamed:@"likeIcon.png"] forState:UIControlStateNormal];
    [likeBtn addTarget:self action:@selector(likeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [likeBtn setTintColor:[UIColor lightGrayColor]];
    likeBtn.alpha = 1.0;
    likeBtn.transform = CGAffineTransformMakeTranslation(10, 0);
    [shareView addSubview:likeBtn];
    
    newsLikes = [[UILabel alloc] init];
    [newsLikes setFrame:CGRectMake(likeBtn.frame.origin.x + likeBtn.frame.size.width + 10, 15, 50, 30)];
    [newsLikes setTextAlignment:NSTextAlignmentLeft];
    [newsLikes setTextColor:[UIColor lightGrayColor]];
    [newsLikes setBackgroundColor:[UIColor clearColor]];
    [newsLikes setFont:[UIFont systemFontOfSize:12.0]];
    [shareView addSubview:newsLikes];
    
    commentBtn = [[UIButton alloc] initWithFrame:CGRectMake(newsLikes.frame.origin.x + newsLikes.frame.size.width + 10, 15, 30, 30)];
    [commentBtn setImage:[UIImage imageNamed:@"comment.png"] forState:UIControlStateNormal];
    [commentBtn addTarget:self action:@selector(commentBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [commentBtn setTintColor:[UIColor lightGrayColor]];
    commentBtn.alpha = 1.0;
    commentBtn.transform = CGAffineTransformMakeTranslation(10, 0);
    [shareView addSubview:commentBtn];
    
    newsComment = [[UILabel alloc] init];
    [newsComment setFrame:CGRectMake(commentBtn.frame.origin.x + commentBtn.frame.size.width + 10, 15, 50, 30)];
    [newsComment setTextAlignment:NSTextAlignmentLeft];
    [newsComment setTextColor:[UIColor lightGrayColor]];
    [newsComment setBackgroundColor:[UIColor clearColor]];
    [newsComment setFont:[UIFont systemFontOfSize:12.0]];
    [shareView addSubview:newsComment];
    
    shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 50, 15, 27, 30)];
    [shareBtn setImage:[UIImage imageNamed:@"shareIcon.png"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [shareBtn setTintColor:[UIColor lightGrayColor]];
    shareBtn.alpha = 1.0;
    shareBtn.transform = CGAffineTransformMakeTranslation(10, 0);
    [shareView addSubview:shareBtn];
    
    [self.view addSubview:shareView];
    
    //BannerView
    bannerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 60, self.view.frame.size.width, 60)];
    bannerView.backgroundColor = [UIColor whiteColor];
    bannerView.layer.cornerRadius = 3;
    bannerView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    bannerView.layer.borderWidth = 1;
    bannerView.layer.masksToBounds = YES;
    
    bannerImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, bannerView.frame.size.width, bannerView.frame.size.height)];
    bannerImg.backgroundColor = [UIColor clearColor];
    [bannerView addSubview:bannerImg];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    [bannerView addGestureRecognizer:tapGesture];
    
    UIButton *dismissBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 50, 5, 35, 35)];
    [dismissBtn setImage:[UIImage imageNamed:@"closeBtn.png"] forState:UIControlStateNormal];
    [dismissBtn addTarget:self action:@selector(dismissBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [dismissBtn setTintColor:[UIColor lightGrayColor]];
    dismissBtn.alpha = 1.0;
    dismissBtn.transform = CGAffineTransformMakeTranslation(10, 0);
    [bannerView addSubview:dismissBtn];
    
    [self.view addSubview:bannerView];
    
    [self getRequests];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(replyDelegate) name:@"replyDelegate" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(newskeyboardDidShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(newskeyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    replyWordView.hidden = YES;
    commentView.hidden = YES;
    leftWordView.hidden = YES;
}

- (void)viewTapped:(UIGestureRecognizer *)gesture {
    AdsDetailViewController *detail_view = [[AdsDetailViewController alloc] init];
    detail_view.adsTitle = adsDetailTitle;
    detail_view.adsUrl = adsDetailUrl;
    [self.navigationController pushViewController:detail_view animated:YES];
}

-(void)newskeyboardDidShow:(NSNotification *)notification {
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
//    int height = MIN(keyboardSize.height,keyboardSize.width);
    
    [UIView animateWithDuration:0.2 animations:^{
        commentView.frame = CGRectMake(0, self.view.frame.size.height - keyboardSize.height - 50, self.view.frame.size.width, 50);
    }completion:^(BOOL finished){
        
    }];
    
    [UIView animateWithDuration:0.2 animations:^{
        replyWordView.frame = CGRectMake(0, self.view.frame.size.height - keyboardSize.height - 50, self.view.frame.size.width, 50);
    }completion:^(BOOL finished){
        
    }];
    
    [UIView animateWithDuration:0.2 animations:^{
        leftWordView.frame = CGRectMake(0, self.view.frame.size.height - keyboardSize.height - 50, self.view.frame.size.width, 50);
    }completion:^(BOOL finished){
        
    }];
}

-(void)newskeyboardWillHide:(NSNotification *)notification {
    [UIView animateWithDuration:0.2 animations:^{
        replyWordView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 50);
        commentView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 50);
        leftWordView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 50);
    }completion:^(BOOL finished){
        
    }];
}

- (void)replyDelegate{
    isReply = YES;
    isComment = NO;
    isLeft = NO;
    
    NSString *replyNickname = [[NSUserDefaults standardUserDefaults] objectForKey:@"replyNickname"];
    sendReply.placeholder = [NSString stringWithFormat:@"@%@", replyNickname];
    
    replyWordView.hidden = NO;
    commentView.hidden = YES;
    leftWordView.hidden = YES;
    
    [sendReply becomeFirstResponder];
}

- (void)dismissBtnClicked{
    [UIView animateWithDuration:0.2 animations:^{
        bannerView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 60);
        shareView.frame = CGRectMake(0, self.view.frame.size.height - 60, self.view.frame.size.width, 60);
        scrollView.frame = CGRectMake(0, 65, self.view.frame.size.width, self.view.frame.size.height - 125);
    }completion:^(BOOL finished){
        
    }];
}

- (void)getLoadMoreComments{
    if (commentArray.count == 0) {
        [self getRequests];
    }
    else{
        NSString *isFirstLogin = [[NSUserDefaults standardUserDefaults] objectForKey:@"isLoginState"];
        if ([isFirstLogin isEqualToString:@"NO"]) {
            
            NSString *lastCommentId = [[commentArray objectAtIndex:commentArray.count - 1] objectForKey:@"commentid"];
            NSDictionary *parameters = @{@"newsid":_strNewsId,
                                         @"userid":@"0",
                                         @"lastid":lastCommentId
                                         };
            
            [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
            [[GlobalPool sharedInstance].OAuth2Manager POST:LC_NEWS_LOAD_MORE_COMMENT parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                //            NSLog(@"%@",responseObject);
                
                [commentArray addObjectsFromArray:[responseObject objectForKey:@"comments"]];
                
                CGFloat commentTableHeight = 0.0;
                for (int i = 0; i < commentArray.count; i++) {
                    NSString *strComment = [[commentArray objectAtIndex:i] objectForKey:@"content"];
                    
                    CGSize constrainedSize = CGSizeMake(self.view.frame.size.width - PADDING_WIDTH, 9999);
                    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                                          [UIFont systemFontOfSize:14.0], NSFontAttributeName,
                                                          nil];
                    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:strComment attributes:attributesDictionary];
                    CGRect requiredCommentHeight = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
                    
                    NSMutableArray *replyArray = [[NSMutableArray alloc] initWithArray:[[commentArray objectAtIndex:i] objectForKey:@"replylist"]];
                    int height = 0;
                    for (int i = 0; i < replyArray.count; i++) {
                        NSString *content_str = nil;
                        NSString *replyName = nil;
                        NSString *replyNickname = nil;
                        NSString *reply_str = nil;
                        
                        reply_str = [[replyArray objectAtIndex:i] objectForKey:@"content"];
                        if ([[replyArray objectAtIndex:i] objectForKey:@"rnickname"] == [NSNull null]) {
                            replyNickname = [[replyArray objectAtIndex:i] objectForKey:@"nickname"];
                            content_str = [NSString stringWithFormat:@"%@: %@", replyNickname, reply_str];
                        }
                        else{
                            replyNickname = [[replyArray objectAtIndex:i] objectForKey:@"rnickname"];
                            replyName = [[replyArray objectAtIndex:i] objectForKey:@"nickname"];
                            content_str = [NSString stringWithFormat:@"%@回复%@: %@", replyNickname, replyName, reply_str];
                        }
                        
                        CGSize constrainedSize = CGSizeMake(self.view.frame.size.width - PADDING_WIDTH, 9999);
                        NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                                              [UIFont systemFontOfSize:14.0], NSFontAttributeName,
                                                              nil];
                        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:content_str attributes:attributesDictionary];
                        CGRect requiredHeight = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
                        
                        height = height + requiredHeight.size.height + PADDING_HEIGHT1;
                    }
                    
                    if ((25 + requiredCommentHeight.size.height + 5 + height + PADDING_HEIGHT2) < 80) {
                        commentTableHeight = commentTableHeight + 80;
                    }
                    else{
                        commentTableHeight = commentTableHeight + 25 + requiredCommentHeight.size.height + 5 + height + PADDING_HEIGHT2;
                    }
                    
                }
                
                commentTable.frame = CGRectMake(0, lineImg.frame.origin.y + lineImg.frame.size.height, self.view.frame.size.width, commentTableHeight + 10);
                
                if ((lineImg.frame.origin.y + lineImg.frame.size.height + 10 + commentTableHeight) < self.view.frame.size.height) {
                    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height - 125);
                }
                else{
                    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, lineImg.frame.origin.y + lineImg.frame.size.height + commentTableHeight + 10);
                }
                
                [commentTable reloadData];
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [SVProgressHUD showErrorWithStatus:@"Connection failed"];
            }];
        }
        else{
            NSString *userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"];
            
            NSString *lastCommentId = [[commentArray objectAtIndex:commentArray.count - 1] objectForKey:@"commentid"];
            NSDictionary *parameters = @{@"newsid":_strNewsId,
                                         @"userid":userid,
                                         @"lastid":lastCommentId
                                         };
            
            [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
            [[GlobalPool sharedInstance].OAuth2Manager POST:LC_NEWS_LOAD_MORE_COMMENT parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                //            NSLog(@"%@",responseObject);
                
                [commentArray addObjectsFromArray:[responseObject objectForKey:@"comments"]];
                
                CGFloat commentTableHeight = 0.0;
                for (int i = 0; i < commentArray.count; i++) {
                    NSString *strComment = [[commentArray objectAtIndex:i] objectForKey:@"content"];
                    
                    CGSize constrainedSize = CGSizeMake(self.view.frame.size.width - PADDING_WIDTH, 9999);
                    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                                          [UIFont systemFontOfSize:14.0], NSFontAttributeName,
                                                          nil];
                    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:strComment attributes:attributesDictionary];
                    CGRect requiredCommentHeight = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
                    
                    NSMutableArray *replyArray = [[NSMutableArray alloc] initWithArray:[[commentArray objectAtIndex:i] objectForKey:@"replylist"]];
                    int height = 0;
                    for (int i = 0; i < replyArray.count; i++) {
                        NSString *content_str = nil;
                        NSString *replyName = nil;
                        NSString *replyNickname = nil;
                        NSString *reply_str = nil;
                        
                        reply_str = [[replyArray objectAtIndex:i] objectForKey:@"content"];
                        if ([[replyArray objectAtIndex:i] objectForKey:@"rnickname"] == [NSNull null]) {
                            replyNickname = [[replyArray objectAtIndex:i] objectForKey:@"nickname"];
                            content_str = [NSString stringWithFormat:@"%@: %@", replyNickname, reply_str];
                        }
                        else{
                            replyNickname = [[replyArray objectAtIndex:i] objectForKey:@"rnickname"];
                            replyName = [[replyArray objectAtIndex:i] objectForKey:@"nickname"];
                            content_str = [NSString stringWithFormat:@"%@回复%@: %@", replyNickname, replyName, reply_str];
                        }
                        
                        CGSize constrainedSize = CGSizeMake(self.view.frame.size.width - PADDING_WIDTH, 9999);
                        NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                                              [UIFont systemFontOfSize:14.0], NSFontAttributeName,
                                                              nil];
                        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:content_str attributes:attributesDictionary];
                        CGRect requiredHeight = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
                        
                        height = height + requiredHeight.size.height + PADDING_HEIGHT1;
                    }
                    
                    if ((25 + requiredCommentHeight.size.height + 5 + height + PADDING_HEIGHT2) < 80) {
                        commentTableHeight = commentTableHeight + 80;
                    }
                    else{
                        commentTableHeight = commentTableHeight + 25 + requiredCommentHeight.size.height + 5 + height + PADDING_HEIGHT2;
                    }
                    
                }
                
                commentTable.frame = CGRectMake(0, lineImg.frame.origin.y + lineImg.frame.size.height, self.view.frame.size.width, commentTableHeight + 10);
                
                if ((lineImg.frame.origin.y + lineImg.frame.size.height + 10 + commentTableHeight) < self.view.frame.size.height) {
                    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height - 125);
                }
                else{
                    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, lineImg.frame.origin.y + lineImg.frame.size.height + commentTableHeight + 10);
                }
                
                [commentTable reloadData];
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [SVProgressHUD showErrorWithStatus:@"Connection failed"];
            }];
        }
    }
}

- (void)getComments{
    NSString *isFirstLogin = [[NSUserDefaults standardUserDefaults] objectForKey:@"isLoginState"];
    if ([isFirstLogin isEqualToString:@"NO"]) {
        NSDictionary *parameters = @{@"newsid":_strNewsId,
                                     @"userid":@"0",
                                     @"lastid":@"0"
                                     };
        
        [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
        [[GlobalPool sharedInstance].OAuth2Manager POST:LC_NEWS_COMMENTS parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //        NSLog(@"%@",responseObject);
            
            commentArray = [NSMutableArray arrayWithArray:[responseObject objectForKey:@"comments"]];
            
            CGFloat commentTableHeight = 0.0;
            for (int i = 0; i < commentArray.count; i++) {
                NSString *strComment = [[commentArray objectAtIndex:i] objectForKey:@"content"];
                
                CGSize constrainedSize = CGSizeMake(self.view.frame.size.width - PADDING_WIDTH, 9999);
                NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                                      [UIFont systemFontOfSize:14.0], NSFontAttributeName,
                                                      nil];
                NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:strComment attributes:attributesDictionary];
                CGRect requiredCommentHeight = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
                
                NSMutableArray *replyArray = [[NSMutableArray alloc] initWithArray:[[commentArray objectAtIndex:i] objectForKey:@"replylist"]];
                int height = 0;
                for (int i = 0; i < replyArray.count; i++) {
                    NSString *content_str = nil;
                    NSString *replyName = nil;
                    NSString *replyNickname = nil;
                    NSString *reply_str = nil;
                    
                    reply_str = [[replyArray objectAtIndex:i] objectForKey:@"content"];
                    if ([[replyArray objectAtIndex:i] objectForKey:@"rnickname"] == [NSNull null]) {
                        replyNickname = [[replyArray objectAtIndex:i] objectForKey:@"nickname"];
                        content_str = [NSString stringWithFormat:@"%@: %@", replyNickname, reply_str];
                    }
                    else{
                        replyNickname = [[replyArray objectAtIndex:i] objectForKey:@"rnickname"];
                        replyName = [[replyArray objectAtIndex:i] objectForKey:@"nickname"];
                        content_str = [NSString stringWithFormat:@"%@回复%@: %@", replyNickname, replyName, reply_str];
                    }
                    
                    CGSize constrainedSize = CGSizeMake(self.view.frame.size.width - PADDING_WIDTH, 9999);
                    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                                          [UIFont systemFontOfSize:14.0], NSFontAttributeName,
                                                          nil];
                    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:content_str attributes:attributesDictionary];
                    CGRect requiredHeight = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
                    
                    height = height + requiredHeight.size.height + PADDING_HEIGHT1;
                }
                
                if ((25 + requiredCommentHeight.size.height + 5 + height + PADDING_HEIGHT2) < 80) {
                    commentTableHeight = commentTableHeight + 80;
                }
                else{
                    commentTableHeight = commentTableHeight + 25 + requiredCommentHeight.size.height + 5 + height + PADDING_HEIGHT2;
                }
                
            }
            
            commentTable.frame = CGRectMake(0, lineImg.frame.origin.y + lineImg.frame.size.height, self.view.frame.size.width, commentTableHeight + 10);
            
            if ((lineImg.frame.origin.y + lineImg.frame.size.height + 10 + commentTableHeight) < self.view.frame.size.height) {
                scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height - 125);
            }
            else{
                scrollView.contentSize = CGSizeMake(self.view.frame.size.width, lineImg.frame.origin.y + lineImg.frame.size.height + commentTableHeight + 10);
            }
            
            [commentTable reloadData];
            
        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"Connection failed"];
        }];
    }
    else{
        NSString *userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"];
        NSDictionary *parameters = @{@"newsid":_strNewsId,
                                     @"userid":userid,
                                     @"lastid":@"0"
                                     };
        
        [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
        [[GlobalPool sharedInstance].OAuth2Manager POST:LC_NEWS_COMMENTS parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //        NSLog(@"%@",responseObject);
            
            commentArray = [NSMutableArray arrayWithArray:[responseObject objectForKey:@"comments"]];
            
            CGFloat commentTableHeight = 0.0;
            for (int i = 0; i < commentArray.count; i++) {
                NSString *strComment = [[commentArray objectAtIndex:i] objectForKey:@"content"];
                
                CGSize constrainedSize = CGSizeMake(self.view.frame.size.width - PADDING_WIDTH, 9999);
                NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                                      [UIFont systemFontOfSize:14.0], NSFontAttributeName,
                                                      nil];
                NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:strComment attributes:attributesDictionary];
                CGRect requiredCommentHeight = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
                
                NSMutableArray *replyArray = [[NSMutableArray alloc] initWithArray:[[commentArray objectAtIndex:i] objectForKey:@"replylist"]];
                int height = 0;
                for (int i = 0; i < replyArray.count; i++) {
                    NSString *content_str = nil;
                    NSString *replyName = nil;
                    NSString *replyNickname = nil;
                    NSString *reply_str = nil;
                    
                    reply_str = [[replyArray objectAtIndex:i] objectForKey:@"content"];
                    if ([[replyArray objectAtIndex:i] objectForKey:@"rnickname"] == [NSNull null]) {
                        replyNickname = [[replyArray objectAtIndex:i] objectForKey:@"nickname"];
                        content_str = [NSString stringWithFormat:@"%@: %@", replyNickname, reply_str];
                    }
                    else{
                        replyNickname = [[replyArray objectAtIndex:i] objectForKey:@"rnickname"];
                        replyName = [[replyArray objectAtIndex:i] objectForKey:@"nickname"];
                        content_str = [NSString stringWithFormat:@"%@回复%@: %@", replyNickname, replyName, reply_str];
                    }
                    
                    CGSize constrainedSize = CGSizeMake(self.view.frame.size.width - PADDING_WIDTH, 9999);
                    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                                          [UIFont systemFontOfSize:14.0], NSFontAttributeName,
                                                          nil];
                    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:content_str attributes:attributesDictionary];
                    CGRect requiredHeight = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
                    
                    height = height + requiredHeight.size.height + PADDING_HEIGHT1;
                }
                
                if ((25 + requiredCommentHeight.size.height + 5 + height + PADDING_HEIGHT2) < 80) {
                    commentTableHeight = commentTableHeight + 80;
                }
                else{
                    commentTableHeight = commentTableHeight + 25 + requiredCommentHeight.size.height + 5 + height + PADDING_HEIGHT2;
                }
                
            }
            
            commentTable.frame = CGRectMake(0, lineImg.frame.origin.y + lineImg.frame.size.height, self.view.frame.size.width, commentTableHeight + 10);
            
            if ((lineImg.frame.origin.y + lineImg.frame.size.height + 10 + commentTableHeight) < self.view.frame.size.height) {
                scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height - 125);
            }
            else{
                scrollView.contentSize = CGSizeMake(self.view.frame.size.width, lineImg.frame.origin.y + lineImg.frame.size.height + commentTableHeight + 10);
            }
            
            [commentTable reloadData];
            
        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"Connection failed"];
        }];
    }
}

- (void)getRequests {
    NSString *isFirstLogin = [[NSUserDefaults standardUserDefaults] objectForKey:@"isLoginState"];
    if ([isFirstLogin isEqualToString:@"NO"]) {
        NSDictionary *parameters = @{@"userid":@"0",
                                     @"newsid":_strNewsId,
                                     };
        
        [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
        [[GlobalPool sharedInstance].OAuth2Manager POST:LC_NEWS_DETAIL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //        NSLog(@"%@",responseObject);
            
            newsInfo = [responseObject objectForKey:@"newsinfo"];
            shareURL = [responseObject objectForKey:@"shareurl"];
            adsArray = [responseObject objectForKey:@"adinfo"];
            
            if (adsArray.count == 0) {
                bannerView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 60);
                shareView.frame = CGRectMake(0, self.view.frame.size.height - 60, self.view.frame.size.width, 60);
                scrollView.frame = CGRectMake(0, 65, self.view.frame.size.width, self.view.frame.size.height - 125);
            }
            else{
                NSString *bannerUrl = [[adsArray firstObject] objectForKey:@"imageurl"];
                [bannerImg setImageWithURL:[NSURL URLWithString:bannerUrl]];
                adsDetailUrl = [[adsArray firstObject] objectForKey:@"url"];
                adsDetailTitle = [[adsArray firstObject] objectForKey:@"title"];
            }
            
            int height = 0;
            if (newsInfo.count == 0) {
                contentTable.frame = CGRectMake(0, lbl_DetailContent.frame.origin.y + lbl_DetailContent.frame.size.height, self.view.frame.size.width, height + 10);
                
                if ((lbl_DetailContent.frame.origin.y + lbl_DetailContent.frame.size.height + height + 10) < self.view.frame.size.height) {
                    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height - 125);
                }
                else{
                    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, lbl_DetailContent.frame.origin.y + lbl_DetailContent.frame.size.height + height + 10);
                }
                
                newsLikes.text = @"0";
                newsComment.text = @"0";
                likeCount = 0;
                
                lineImg.frame = CGRectMake(10, contentTable.frame.origin.y + contentTable.frame.size.height + 5, self.view.frame.size.width - 20, 1);
                [likeBtn setImage:[UIImage imageNamed:@"likeIcon.png"] forState:UIControlStateNormal];
                isLike = FALSE;
                
                NSString *userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"];
                NSDictionary *parameters = @{@"newsid":_strNewsId,
                                             @"userid":userid,
                                             @"lastid":@"0"
                                             };
                
                [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
                [[GlobalPool sharedInstance].OAuth2Manager POST:LC_NEWS_COMMENTS parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    //                NSLog(@"%@",responseObject);
                    
                    commentArray = [NSMutableArray arrayWithArray:[responseObject objectForKey:@"comments"]];
                    
                    CGFloat commentTableHeight = 0.0;
                    for (int i = 0; i < commentArray.count; i++) {
                        NSString *strComment = [[commentArray objectAtIndex:i] objectForKey:@"content"];
                        
                        CGSize constrainedSize = CGSizeMake(self.view.frame.size.width - PADDING_WIDTH, 9999);
                        NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                                              [UIFont systemFontOfSize:14.0], NSFontAttributeName,
                                                              nil];
                        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:strComment attributes:attributesDictionary];
                        CGRect requiredCommentHeight = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
                        
                        NSMutableArray *replyArray = [[NSMutableArray alloc] initWithArray:[[commentArray objectAtIndex:i] objectForKey:@"replylist"]];
                        int height = 0;
                        for (int i = 0; i < replyArray.count; i++) {
                            NSString *content_str = nil;
                            NSString *replyName = nil;
                            NSString *replyNickname = nil;
                            NSString *reply_str = nil;
                            
                            reply_str = [[replyArray objectAtIndex:i] objectForKey:@"content"];
                            if ([[replyArray objectAtIndex:i] objectForKey:@"rnickname"] == [NSNull null]) {
                                replyNickname = [[replyArray objectAtIndex:i] objectForKey:@"nickname"];
                                content_str = [NSString stringWithFormat:@"%@: %@", replyNickname, reply_str];
                            }
                            else{
                                replyNickname = [[replyArray objectAtIndex:i] objectForKey:@"rnickname"];
                                replyName = [[replyArray objectAtIndex:i] objectForKey:@"nickname"];
                                content_str = [NSString stringWithFormat:@"%@回复%@: %@", replyNickname, replyName, reply_str];
                            }
                            
                            CGSize constrainedSize = CGSizeMake(self.view.frame.size.width - PADDING_WIDTH, 9999);
                            NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                  [UIFont systemFontOfSize:14.0], NSFontAttributeName,
                                                                  nil];
                            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:content_str attributes:attributesDictionary];
                            CGRect requiredHeight = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
                            
                            height = height + requiredHeight.size.height + PADDING_HEIGHT1;
                        }
                        
                        if ((25 + requiredCommentHeight.size.height + 5 + height + PADDING_HEIGHT2) < 80) {
                            commentTableHeight = commentTableHeight + 80;
                        }
                        else{
                            commentTableHeight = commentTableHeight + 25 + requiredCommentHeight.size.height + 5 + height + PADDING_HEIGHT2;
                        }
                        
                    }
                    
                    commentTable.frame = CGRectMake(0, lineImg.frame.origin.y + lineImg.frame.size.height, self.view.frame.size.width, commentTableHeight + 10);
                    
                    if ((lineImg.frame.origin.y + lineImg.frame.size.height + 10 + commentTableHeight) < self.view.frame.size.height) {
                        scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height - 125);
                    }
                    else{
                        scrollView.contentSize = CGSizeMake(self.view.frame.size.width, lineImg.frame.origin.y + lineImg.frame.size.height + commentTableHeight + 10);
                    }
                    
                    [contentTable reloadData];
                    [commentTable reloadData];
                    
                }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [SVProgressHUD showErrorWithStatus:@"Connection failed"];
                }];
            }
            else{
                contentArray = [NSMutableArray arrayWithArray:[newsInfo objectForKey:@"contentlist"]];
                
                for (int i = 0; i < contentArray.count; i++) {
                    if ([[[contentArray objectAtIndex:i] objectForKey:@"type"] isEqualToString:@"IMAGE"]) {
                        height = height + self.view.frame.size.width/16*9;
                    }
                    else{
                        CGSize constrainedSize = CGSizeMake(self.view.frame.size.width - 20, 9999);
                        NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                                              [UIFont systemFontOfSize:17.0], NSFontAttributeName,
                                                              nil];
                        NSString *contentStr = [[contentArray objectAtIndex:i] objectForKey:@"content"];
                        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:contentStr attributes:attributesDictionary];
                        CGRect requiredHeight = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
                        
                        height = height + requiredHeight.size.height;
                    }
                }
                
                contentTable.frame = CGRectMake(0, lbl_DetailContent.frame.origin.y + lbl_DetailContent.frame.size.height, self.view.frame.size.width, height + 10);
                
                if ((lbl_DetailContent.frame.origin.y + lbl_DetailContent.frame.size.height + height + 10) < self.view.frame.size.height) {
                    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height - 125);
                }
                else{
                    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, lbl_DetailContent.frame.origin.y + lbl_DetailContent.frame.size.height + height + 10);
                }
                
                newsLikes.text = [newsInfo objectForKey:@"likecount"];
                newsComment.text = [newsInfo objectForKey:@"commentcount"];
                likeCount = [[newsInfo objectForKey:@"likecount"] intValue];
                
                lineImg.frame = CGRectMake(10, contentTable.frame.origin.y + contentTable.frame.size.height + 5, self.view.frame.size.width - 20, 1);
                
                if ([[newsInfo objectForKey:@"likedflag"] isEqualToString:@"0"]) {
                    [likeBtn setImage:[UIImage imageNamed:@"likeIcon.png"] forState:UIControlStateNormal];
                    isLike = FALSE;
                }
                else{
                    [likeBtn setImage:[UIImage imageNamed:@"unlikeIcon.png"] forState:UIControlStateNormal];
                    isLike = TRUE;
                }
                
                NSDictionary *parameters = @{@"newsid":_strNewsId,
                                             @"userid":@"0",
                                             @"lastid":@"0"
                                             };
                
                [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
                [[GlobalPool sharedInstance].OAuth2Manager POST:LC_NEWS_COMMENTS parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    //                NSLog(@"%@",responseObject);
                    
                    commentArray = [NSMutableArray arrayWithArray:[responseObject objectForKey:@"comments"]];
                    
                    CGFloat commentTableHeight = 0.0;
                    for (int i = 0; i < commentArray.count; i++) {
                        NSString *strComment = [[commentArray objectAtIndex:i] objectForKey:@"content"];
                        
                        CGSize constrainedSize = CGSizeMake(self.view.frame.size.width - PADDING_WIDTH, 9999);
                        NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                                              [UIFont systemFontOfSize:14.0], NSFontAttributeName,
                                                              nil];
                        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:strComment attributes:attributesDictionary];
                        CGRect requiredCommentHeight = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
                        
                        NSMutableArray *replyArray = [[NSMutableArray alloc] initWithArray:[[commentArray objectAtIndex:i] objectForKey:@"replylist"]];
                        int height = 0;
                        for (int i = 0; i < replyArray.count; i++) {
                            NSString *content_str = nil;
                            NSString *replyName = nil;
                            NSString *replyNickname = nil;
                            NSString *reply_str = nil;
                            
                            reply_str = [[replyArray objectAtIndex:i] objectForKey:@"content"];
                            if ([[replyArray objectAtIndex:i] objectForKey:@"rnickname"] == [NSNull null]) {
                                replyNickname = [[replyArray objectAtIndex:i] objectForKey:@"nickname"];
                                content_str = [NSString stringWithFormat:@"%@: %@", replyNickname, reply_str];
                            }
                            else{
                                replyNickname = [[replyArray objectAtIndex:i] objectForKey:@"rnickname"];
                                replyName = [[replyArray objectAtIndex:i] objectForKey:@"nickname"];
                                content_str = [NSString stringWithFormat:@"%@回复%@: %@", replyNickname, replyName, reply_str];
                            }
                            
                            CGSize constrainedSize = CGSizeMake(self.view.frame.size.width - PADDING_WIDTH, 9999);
                            NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                  [UIFont systemFontOfSize:14.0], NSFontAttributeName,
                                                                  nil];
                            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:content_str attributes:attributesDictionary];
                            CGRect requiredHeight = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
                            
                            height = height + requiredHeight.size.height + PADDING_HEIGHT1;
                        }
                        
                        if ((25 + requiredCommentHeight.size.height + 5 + height + PADDING_HEIGHT2) < 80) {
                            commentTableHeight = commentTableHeight + 80;
                        }
                        else{
                            commentTableHeight = commentTableHeight + 25 + requiredCommentHeight.size.height + 5 + height + PADDING_HEIGHT2;
                        }
                        
                    }
                    
                    commentTable.frame = CGRectMake(0, lineImg.frame.origin.y + lineImg.frame.size.height, self.view.frame.size.width, commentTableHeight + 10);
                    
                    if ((lineImg.frame.origin.y + lineImg.frame.size.height + 10 + commentTableHeight) < self.view.frame.size.height) {
                        scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height - 125);
                    }
                    else{
                        scrollView.contentSize = CGSizeMake(self.view.frame.size.width, lineImg.frame.origin.y + lineImg.frame.size.height + commentTableHeight + 10);
                    }
                    
                    [contentTable reloadData];
                    [commentTable reloadData];
                    
                }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [SVProgressHUD showErrorWithStatus:@"Connection failed"];
                }];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"Connection failed"];
        }];
    }
    else{
        NSString *userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"];
        NSDictionary *parameters = @{@"userid":userid,
                                     @"newsid":_strNewsId,
                                     };
        
        [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
        [[GlobalPool sharedInstance].OAuth2Manager POST:LC_NEWS_DETAIL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //        NSLog(@"%@",responseObject);
            
            newsInfo = [responseObject objectForKey:@"newsinfo"];
            shareURL = [responseObject objectForKey:@"shareurl"];
            adsArray = [responseObject objectForKey:@"adinfo"];
            
            if (adsArray.count == 0) {
                bannerView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 60);
                shareView.frame = CGRectMake(0, self.view.frame.size.height - 60, self.view.frame.size.width, 60);
                scrollView.frame = CGRectMake(0, 65, self.view.frame.size.width, self.view.frame.size.height - 125);
            }
            else{
                NSString *bannerUrl = [[adsArray firstObject] objectForKey:@"imageurl"];
                [bannerImg setImageWithURL:[NSURL URLWithString:bannerUrl]];
                adsDetailUrl = [[adsArray firstObject] objectForKey:@"url"];
                adsDetailTitle = [[adsArray firstObject] objectForKey:@"title"];
            }
            
            int height = 0;
            if (newsInfo.count == 0) {
                contentTable.frame = CGRectMake(0, lbl_DetailContent.frame.origin.y + lbl_DetailContent.frame.size.height, self.view.frame.size.width, height + 10);
                
                if ((lbl_DetailContent.frame.origin.y + lbl_DetailContent.frame.size.height + height + 10) < self.view.frame.size.height) {
                    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height - 125);
                }
                else{
                    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, lbl_DetailContent.frame.origin.y + lbl_DetailContent.frame.size.height + height + 10);
                }
                
                newsLikes.text = @"0";
                newsComment.text = @"0";
                likeCount = 0;
                
                lineImg.frame = CGRectMake(10, contentTable.frame.origin.y + contentTable.frame.size.height + 5, self.view.frame.size.width - 20, 1);
                [likeBtn setImage:[UIImage imageNamed:@"likeIcon.png"] forState:UIControlStateNormal];
                isLike = FALSE;
                
                NSString *userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"];
                NSDictionary *parameters = @{@"newsid":_strNewsId,
                                             @"userid":userid,
                                             @"lastid":@"0"
                                             };
                
                [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
                [[GlobalPool sharedInstance].OAuth2Manager POST:LC_NEWS_COMMENTS parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    //                NSLog(@"%@",responseObject);
                    
                    commentArray = [NSMutableArray arrayWithArray:[responseObject objectForKey:@"comments"]];
                    
                    CGFloat commentTableHeight = 0.0;
                    for (int i = 0; i < commentArray.count; i++) {
                        NSString *strComment = [[commentArray objectAtIndex:i] objectForKey:@"content"];
                        
                        CGSize constrainedSize = CGSizeMake(self.view.frame.size.width - PADDING_WIDTH, 9999);
                        NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                                              [UIFont systemFontOfSize:14.0], NSFontAttributeName,
                                                              nil];
                        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:strComment attributes:attributesDictionary];
                        CGRect requiredCommentHeight = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
                        
                        NSMutableArray *replyArray = [[NSMutableArray alloc] initWithArray:[[commentArray objectAtIndex:i] objectForKey:@"replylist"]];
                        int height = 0;
                        for (int i = 0; i < replyArray.count; i++) {
                            NSString *content_str = nil;
                            NSString *replyName = nil;
                            NSString *replyNickname = nil;
                            NSString *reply_str = nil;
                            
                            reply_str = [[replyArray objectAtIndex:i] objectForKey:@"content"];
                            if ([[replyArray objectAtIndex:i] objectForKey:@"rnickname"] == [NSNull null]) {
                                replyNickname = [[replyArray objectAtIndex:i] objectForKey:@"nickname"];
                                content_str = [NSString stringWithFormat:@"%@: %@", replyNickname, reply_str];
                            }
                            else{
                                replyNickname = [[replyArray objectAtIndex:i] objectForKey:@"rnickname"];
                                replyName = [[replyArray objectAtIndex:i] objectForKey:@"nickname"];
                                content_str = [NSString stringWithFormat:@"%@回复%@: %@", replyNickname, replyName, reply_str];
                            }
                            
                            CGSize constrainedSize = CGSizeMake(self.view.frame.size.width - PADDING_WIDTH, 9999);
                            NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                  [UIFont systemFontOfSize:14.0], NSFontAttributeName,
                                                                  nil];
                            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:content_str attributes:attributesDictionary];
                            CGRect requiredHeight = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
                            
                            height = height + requiredHeight.size.height + PADDING_HEIGHT1;
                        }
                        
                        if ((25 + requiredCommentHeight.size.height + 5 + height + PADDING_HEIGHT2) < 80) {
                            commentTableHeight = commentTableHeight + 80;
                        }
                        else{
                            commentTableHeight = commentTableHeight + 25 + requiredCommentHeight.size.height + 5 + height + PADDING_HEIGHT2;
                        }
                        
                    }
                    
                    commentTable.frame = CGRectMake(0, lineImg.frame.origin.y + lineImg.frame.size.height, self.view.frame.size.width, commentTableHeight + 10);
                    
                    if ((lineImg.frame.origin.y + lineImg.frame.size.height + 10 + commentTableHeight) < self.view.frame.size.height) {
                        scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height - 125);
                    }
                    else{
                        scrollView.contentSize = CGSizeMake(self.view.frame.size.width, lineImg.frame.origin.y + lineImg.frame.size.height + commentTableHeight + 10);
                    }
                    
                    [contentTable reloadData];
                    [commentTable reloadData];
                    
                }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [SVProgressHUD showErrorWithStatus:@"Connection failed"];
                }];
            }
            else{
                contentArray = [NSMutableArray arrayWithArray:[newsInfo objectForKey:@"contentlist"]];
                
                for (int i = 0; i < contentArray.count; i++) {
                    if ([[[contentArray objectAtIndex:i] objectForKey:@"type"] isEqualToString:@"IMAGE"]) {
                        height = height + self.view.frame.size.width/16*9;
                    }
                    else{
                        CGSize constrainedSize = CGSizeMake(self.view.frame.size.width - 20, 9999);
                        NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                                              [UIFont systemFontOfSize:17.0], NSFontAttributeName,
                                                              nil];
                        NSString *contentStr = [[contentArray objectAtIndex:i] objectForKey:@"content"];
                        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:contentStr attributes:attributesDictionary];
                        CGRect requiredHeight = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
                        
                        height = height + requiredHeight.size.height;
                    }
                }
                
                contentTable.frame = CGRectMake(0, lbl_DetailContent.frame.origin.y + lbl_DetailContent.frame.size.height, self.view.frame.size.width, height + 10);
                
                if ((lbl_DetailContent.frame.origin.y + lbl_DetailContent.frame.size.height + height + 10) < self.view.frame.size.height) {
                    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height - 125);
                }
                else{
                    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, lbl_DetailContent.frame.origin.y + lbl_DetailContent.frame.size.height + height + 10);
                }
                
                newsLikes.text = [newsInfo objectForKey:@"likecount"];
                newsComment.text = [newsInfo objectForKey:@"commentcount"];
                likeCount = [[newsInfo objectForKey:@"likecount"] intValue];
                
                lineImg.frame = CGRectMake(10, contentTable.frame.origin.y + contentTable.frame.size.height + 5, self.view.frame.size.width - 20, 1);
                
                if ([[newsInfo objectForKey:@"likedflag"] isEqualToString:@"0"]) {
                    [likeBtn setImage:[UIImage imageNamed:@"likeIcon.png"] forState:UIControlStateNormal];
                    isLike = FALSE;
                }
                else{
                    [likeBtn setImage:[UIImage imageNamed:@"unlikeIcon.png"] forState:UIControlStateNormal];
                    isLike = TRUE;
                }
                
                NSString *userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"];
                NSDictionary *parameters = @{@"newsid":_strNewsId,
                                             @"userid":userid,
                                             @"lastid":@"0"
                                             };
                
                [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
                [[GlobalPool sharedInstance].OAuth2Manager POST:LC_NEWS_COMMENTS parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    //                NSLog(@"%@",responseObject);
                    
                    commentArray = [NSMutableArray arrayWithArray:[responseObject objectForKey:@"comments"]];
                    
                    CGFloat commentTableHeight = 0.0;
                    for (int i = 0; i < commentArray.count; i++) {
                        NSString *strComment = [[commentArray objectAtIndex:i] objectForKey:@"content"];
                        
                        CGSize constrainedSize = CGSizeMake(self.view.frame.size.width - PADDING_WIDTH, 9999);
                        NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                                              [UIFont systemFontOfSize:14.0], NSFontAttributeName,
                                                              nil];
                        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:strComment attributes:attributesDictionary];
                        CGRect requiredCommentHeight = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
                        
                        NSMutableArray *replyArray = [[NSMutableArray alloc] initWithArray:[[commentArray objectAtIndex:i] objectForKey:@"replylist"]];
                        int height = 0;
                        for (int i = 0; i < replyArray.count; i++) {
                            NSString *content_str = nil;
                            NSString *replyName = nil;
                            NSString *replyNickname = nil;
                            NSString *reply_str = nil;
                            
                            reply_str = [[replyArray objectAtIndex:i] objectForKey:@"content"];
                            if ([[replyArray objectAtIndex:i] objectForKey:@"rnickname"] == [NSNull null]) {
                                replyNickname = [[replyArray objectAtIndex:i] objectForKey:@"nickname"];
                                content_str = [NSString stringWithFormat:@"%@: %@", replyNickname, reply_str];
                            }
                            else{
                                replyNickname = [[replyArray objectAtIndex:i] objectForKey:@"rnickname"];
                                replyName = [[replyArray objectAtIndex:i] objectForKey:@"nickname"];
                                content_str = [NSString stringWithFormat:@"%@回复%@: %@", replyNickname, replyName, reply_str];
                            }
                            
                            CGSize constrainedSize = CGSizeMake(self.view.frame.size.width - PADDING_WIDTH, 9999);
                            NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                  [UIFont systemFontOfSize:14.0], NSFontAttributeName,
                                                                  nil];
                            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:content_str attributes:attributesDictionary];
                            CGRect requiredHeight = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
                            
                            height = height + requiredHeight.size.height + PADDING_HEIGHT1;
                        }
                        
                        if ((25 + requiredCommentHeight.size.height + 5 + height + PADDING_HEIGHT2) < 80) {
                            commentTableHeight = commentTableHeight + 80;
                        }
                        else{
                            commentTableHeight = commentTableHeight + 25 + requiredCommentHeight.size.height + 5 + height + PADDING_HEIGHT2;
                        }
                        
                    }
                    
                    commentTable.frame = CGRectMake(0, lineImg.frame.origin.y + lineImg.frame.size.height, self.view.frame.size.width, commentTableHeight + 10);
                    
                    if ((lineImg.frame.origin.y + lineImg.frame.size.height + 10 + commentTableHeight) < self.view.frame.size.height) {
                        scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height - 125);
                    }
                    else{
                        scrollView.contentSize = CGSizeMake(self.view.frame.size.width, lineImg.frame.origin.y + lineImg.frame.size.height + commentTableHeight + 10);
                    }
                    
                    [contentTable reloadData];
                    [commentTable reloadData];
                    
                }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [SVProgressHUD showErrorWithStatus:@"Connection failed"];
                }];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"Connection failed"];
        }];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [sendWord resignFirstResponder];
    [sendText resignFirstResponder];
    [sendReply resignFirstResponder];
    
    isReply = NO;
    isComment = NO;
    isLeft = NO;
    
    replyWordView.hidden = YES;
    commentView.hidden = YES;
    leftWordView.hidden = YES;
    
    return YES;
}

- (void)sendReplyBtnClicked{
    [sendReply resignFirstResponder];
    
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
        isReply = NO;
        
        NSString *userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"];
        NSString *sessionkey = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionkey"];
        NSString *replyCommentid = [[NSUserDefaults standardUserDefaults] objectForKey:@"replyCommentId"];
        NSString *ruserid = [[NSUserDefaults standardUserDefaults] objectForKey:@"rUserID"];
        NSString *lastReplyId = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastReplyId"];
        
        if ([userid isEqualToString:ruserid]) {
            NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
            if ([applang isEqualToString:@"ko"]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"주의" message:@"당신이 남긴 코멘트 입니다." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
            if ([applang isEqualToString:@"cn"]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注意" message:@"不能回复自己的评论" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                [alert show];
            }
        }
        else{
            NSDictionary *parameters = @{@"userid":userid,
                                         @"ruserid":ruserid,
                                         @"commentid":replyCommentid,
                                         @"content":sendReply.text,
                                         @"sessionkey":sessionkey,
                                         @"lastid":lastReplyId
                                         };
            [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
            [[GlobalPool sharedInstance].OAuth2Manager POST:LC_NEWS_LEAVE_REPLY parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                //            NSLog(@"%@",responseObject);
                
                NSString *status = [responseObject objectForKey:@"status"];
                
                if ([status intValue] == 200) {
                    [self getComments];
                }
                else if ([status intValue] == 1001) {
                    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setObject:@"NO" forKey:@"isLoginState"];
                    [defaults synchronize];
                    [[AppDelegate sharedAppDelegate] runMain];
                }
                else{
                    
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [SVProgressHUD showErrorWithStatus:@"Connection failed"];
            }];
        }
    }
    
    sendReply.text = @"";
}

- (void)sendWordBtnClicked{
    [sendWord resignFirstResponder];
    
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
        isLeft = NO;
        
        NSString *userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"];
        NSString *sessionkey = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionkey"];
        
        if (replyArrayForReply.count == 0) {
            NSDictionary *parameters = @{@"userid":userid,
                                         @"commentid":commentID,
                                         @"content":sendWord.text,
                                         @"sessionkey":sessionkey,
                                         @"lastid":@"0"
                                         };
            [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
            [[GlobalPool sharedInstance].OAuth2Manager POST:LC_NEWS_LEAVE_REPLY parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                //            NSLog(@"%@",responseObject);
                
                NSString *status = [responseObject objectForKey:@"status"];
                
                if ([status intValue] == 200) {
                    [self getComments];
                }
                else if ([status intValue] == 1001) {
                    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setObject:@"NO" forKey:@"isLoginState"];
                    [defaults synchronize];
                    [[AppDelegate sharedAppDelegate] runMain];
                }
                else{
                    
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [SVProgressHUD showErrorWithStatus:@"Connection failed"];
            }];
            
            sendWord.text = @"";
        }
        else{
            NSString *lastReplyId = [[replyArrayForReply objectAtIndex:replyArrayForReply.count - 1] objectForKey:@"replyid"];
            NSDictionary *parameters = @{@"userid":userid,
                                         @"commentid":commentID,
                                         @"content":sendWord.text,
                                         @"sessionkey":sessionkey,
                                         @"lastid":lastReplyId
                                         };
            [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
            [[GlobalPool sharedInstance].OAuth2Manager POST:LC_NEWS_LEAVE_REPLY parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                //            NSLog(@"%@",responseObject);
                
                NSString *status = [responseObject objectForKey:@"status"];
                
                if ([status intValue] == 200) {
                    [self getComments];
                }
                else if ([status intValue] == 1001) {
                    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setObject:@"NO" forKey:@"isLoginState"];
                    [defaults synchronize];
                    [[AppDelegate sharedAppDelegate] runMain];
                }
                else{
                    
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [SVProgressHUD showErrorWithStatus:@"Connection failed"];
            }];
            
            sendWord.text = @"";
        }
    }
}

- (void)sendBtnClicked{
    [sendText resignFirstResponder];
    
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
        isComment = NO;
        
        NSString *userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"];
        NSString *sessionkey = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionkey"];
        
        if (commentArray.count == 0) {
            NSDictionary *parameters = @{@"newsid":_strNewsId,
                                         @"userid":userid,
                                         @"content":sendText.text,
                                         @"sessionkey":sessionkey,
                                         @"lastid":@"0"
                                         };
            [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
            [[GlobalPool sharedInstance].OAuth2Manager POST:LC_NEWS_LEAVE_COMMENT parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                //            NSLog(@"%@",responseObject);
                
                NSString *status = [responseObject objectForKey:@"status"];
                
                if ([status intValue] == 200) {
                    [self getComments];
                }
                else if ([status intValue] == 1001) {
                    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setObject:@"NO" forKey:@"isLoginState"];
                    [defaults synchronize];
                    [[AppDelegate sharedAppDelegate] runMain];
                }
                else{
                    
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [SVProgressHUD showErrorWithStatus:@"Connection failed"];
            }];
            
            sendText.text = @"";
        }
        else{
            NSString *lastCommentId = [[commentArray objectAtIndex:commentArray.count - 1] objectForKey:@"commentid"];
            NSDictionary *parameters = @{@"newsid":_strNewsId,
                                         @"userid":userid,
                                         @"content":sendText.text,
                                         @"sessionkey":sessionkey,
                                         @"lastid":lastCommentId
                                         };
            [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
            [[GlobalPool sharedInstance].OAuth2Manager POST:LC_NEWS_LEAVE_COMMENT parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                //            NSLog(@"%@",responseObject);
                
                NSString *status = [responseObject objectForKey:@"status"];
                
                if ([status intValue] == 200) {
                    [self getComments];
                }
                else if ([status intValue] == 1001) {
                    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setObject:@"NO" forKey:@"isLoginState"];
                    [defaults synchronize];
                    [[AppDelegate sharedAppDelegate] runMain];
                }
                else{
                    
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [SVProgressHUD showErrorWithStatus:@"Connection failed"];
            }];
            
            sendText.text = @"";
        }
    }
}

- (void)likeBtnClicked{
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
        if (isLike == TRUE) {
            likeCount = likeCount - 1;
            newsLikes.text = [NSString stringWithFormat:@"%d", likeCount];
            [likeBtn setImage:[UIImage imageNamed:@"likeIcon.png"] forState:UIControlStateNormal];
            
            NSString *userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"];
            NSString *sessionkey = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionkey"];
            
            NSDictionary *parameters = @{@"userid":userid,
                                         @"newsid":_strNewsId,
                                         @"sessionkey":sessionkey
                                         };
            [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
            [[GlobalPool sharedInstance].OAuth2Manager POST:LC_NEWS_UNLIKE parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                //            NSLog(@"%@",responseObject);
                
                NSString *status = [responseObject objectForKey:@"status"];
                
                if ([status intValue] == 200) {
                    [ProgressHUD showSuccess:@"Unliked!"];
                    isLike = FALSE;
                }
                else if ([status intValue] == 1001) {
                    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setObject:@"NO" forKey:@"isLoginState"];
                    [defaults synchronize];
                    [[AppDelegate sharedAppDelegate] runMain];
                }
                else{
                    
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [SVProgressHUD showErrorWithStatus:@"Connection failed"];
            }];
        }
        else{
            likeCount = likeCount + 1;
            newsLikes.text = [NSString stringWithFormat:@"%d", likeCount];
            [likeBtn setImage:[UIImage imageNamed:@"unlikeIcon.png"] forState:UIControlStateNormal];
            
            NSString *userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"];
            NSString *sessionkey = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionkey"];
            
            NSDictionary *parameters = @{@"userid":userid,
                                         @"newsid":_strNewsId,
                                         @"sessionkey":sessionkey
                                         };
            [[GlobalPool sharedInstance].OAuth2Manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[GlobalPool sharedInstance].credential];
            [[GlobalPool sharedInstance].OAuth2Manager POST:LC_NEWS_LIKE parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                //            NSLog(@"%@",responseObject);
                
                NSString *status = [responseObject objectForKey:@"status"];
                
                if ([status intValue] == 200) {
                    [ProgressHUD showSuccess:@"Liked!"];
                    isLike = TRUE;
                }
                else if ([status intValue] == 1001) {
                    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setObject:@"NO" forKey:@"isLoginState"];
                    [defaults synchronize];
                    [[AppDelegate sharedAppDelegate] runMain];
                }
                else{
                    
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [SVProgressHUD showErrorWithStatus:@"Connection failed"];
            }];
        }
    }
    
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
    if (_strNewsContent.length > 128) {
        NSRange needleRange = NSMakeRange(0, 128);
        _strNewsContent = [_strNewsContent substringWithRange:needleRange];
        _strNewsContent = [NSString stringWithFormat:@"%@...", _strNewsContent];
    }
    
    UIGraphicsBeginImageContext(CGSizeMake(300,200));
    CGContextRef  context = UIGraphicsGetCurrentContext();
    [detailimage.image drawInRect: CGRectMake(0, 0, 300, 200)];
    UIImage *shareImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if (imageIndex == 0)
    {
        NSLog(@"shareByWeibo");
        
        NSString *news = [NSString stringWithFormat:@"%@ %@", _strNewsTitle, shareURL];
        
        NSDictionary *shareDict = [NSDictionary
                                   dictionaryWithObjectsAndKeys:
                                   _strNewsTitle, LDSDKShareContentTitleKey,
                                   _strNewsContent, LDSDKShareContentDescriptionKey,
                                   shareURL, LDSDKShareContentWapUrlKey,
                                   shareImg, LDSDKShareContentImageKey,
                                   news, LDSDKShareContentTextKey,
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
                                   _strNewsTitle, LDSDKShareContentTitleKey,
                                   _strNewsContent, LDSDKShareContentDescriptionKey,
                                   shareURL, LDSDKShareContentWapUrlKey,
                                   shareImg, LDSDKShareContentImageKey,
                                   @"NEWS", LDSDKShareContentTextKey,
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
                                   _strNewsTitle, LDSDKShareContentTitleKey,
                                   _strNewsContent, LDSDKShareContentDescriptionKey,
                                   shareURL, LDSDKShareContentWapUrlKey,
                                   shareImg,LDSDKShareContentImageKey,
                                   @"NEWS", LDSDKShareContentTextKey,
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
                                   _strNewsTitle, LDSDKShareContentTitleKey,
                                   _strNewsContent, LDSDKShareContentDescriptionKey,
                                   shareURL, LDSDKShareContentWapUrlKey,
                                   shareImg,LDSDKShareContentImageKey,
                                   @"NEWS", LDSDKShareContentTextKey,
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
        isComment = YES;
        isLeft = NO;
        isReply = NO;
        
        replyWordView.hidden = YES;
        commentView.hidden = NO;
        leftWordView.hidden = YES;
        
        [sendText becomeFirstResponder];
    }
    
}

#pragma mark - tableViewDelegate
// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == contentTable) {
        return contentArray.count;
    }
    return commentArray.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == contentTable) {
        static NSString *CellIdentifier = @"ContentCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.backgroundColor=[UIColor clearColor];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.accessoryType=UITableViewCellAccessoryNone;
        }
        else
        {
            UIView *subview;
            while ((subview= [[[cell contentView]subviews]lastObject])!=nil)
                [subview removeFromSuperview];
        }
        
        if ([[[contentArray objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"IMAGE"]) {
            UIImageView *image =[UIImageView new];
            image.frame=CGRectMake(10, 2, self.view.frame.size.width - 20, (self.view.frame.size.width - 20)/16*9 - 4);
            image.clipsToBounds = YES;
            image.userInteractionEnabled=YES;
            image.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:image];
            
            NSString *path = [[contentArray objectAtIndex:indexPath.row] objectForKey:@"content"];
            [image setImageWithURL:[NSURL URLWithString:path]];
        }
        else{
            UILabel *lbl_Content = [[UILabel alloc]init];
            [lbl_Content setFrame:CGRectMake(10, 5, self.view.frame.size.width - 20, 60)];
            [lbl_Content setTextAlignment:NSTextAlignmentLeft];
            [lbl_Content setTextColor:[UIColor colorWithRed:65.0/255.0 green:111.0/255.0 blue:155.0/255.0 alpha:1.0]];
            [lbl_Content setBackgroundColor:[UIColor clearColor]];
            [lbl_Content setFont:[UIFont systemFontOfSize:17.0]];
            lbl_Content.numberOfLines = 100;
            [cell.contentView addSubview:lbl_Content];
            
            lbl_Content.text = [[contentArray objectAtIndex:indexPath.row] objectForKey:@"content"];
            
            CGSize constrainedSize = CGSizeMake(lbl_Content.frame.size.width, 9999);
            NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                                  [UIFont systemFontOfSize:17.0], NSFontAttributeName,
                                                  nil];
            NSString *contentStr = [[contentArray objectAtIndex:indexPath.row] objectForKey:@"content"];
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:contentStr attributes:attributesDictionary];
            CGRect requiredHeight = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
            CGRect newFrame = lbl_Content.frame;
            newFrame.size.height = requiredHeight.size.height;
            lbl_Content.frame = newFrame;
        }
        
        return cell;
    }
    
    static NSString *CellIdentifier = @"CommentCell";
    
    CommentTableViewCell *cell = (CommentTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[CommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.lbl_NickName.text = [[commentArray objectAtIndex:indexPath.row] objectForKey:@"nickname"];
    NSString *path = [[commentArray objectAtIndex:indexPath.row] objectForKey:@"photourl"];
    cell.lbl_Content.text = [[commentArray objectAtIndex:indexPath.row] objectForKey:@"content"];
    
    [cell.image setImageWithURL:[NSURL URLWithString:path]];
    
    NSString *replyCommentID = [[commentArray objectAtIndex:indexPath.row] objectForKey:@"commentid"];
    
    [cell refreshTableView:[[NSMutableArray alloc] initWithArray:[[commentArray objectAtIndex:indexPath.row] objectForKey:@"replylist"]] commentid:replyCommentID];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //Height of the rows
    if (tableView == contentTable) {
        if ([[[contentArray objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"IMAGE"]) {
            return self.view.frame.size.width/16*9;
        }
        
        CGSize constrainedSize = CGSizeMake(self.view.frame.size.width - 20, 9999);
        NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                              [UIFont systemFontOfSize:17.0], NSFontAttributeName,
                                              nil];
        NSString *contentStr = [[contentArray objectAtIndex:indexPath.row] objectForKey:@"content"];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:contentStr attributes:attributesDictionary];
        CGRect requiredHeight = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        
        return requiredHeight.size.height;
    }
    
    int height = 0;
    NSMutableArray *replyArray = [[NSMutableArray alloc] initWithArray:[[commentArray objectAtIndex:indexPath.row] objectForKey:@"replylist"]];
    
    if (replyArray.count == 0) {
        return 80;
    }
    else{
        NSString *strComment = [[commentArray objectAtIndex:indexPath.row] objectForKey:@"content"];
        
        CGSize constrainedSize = CGSizeMake(self.view.frame.size.width - PADDING_WIDTH, 9999);
        NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                              [UIFont systemFontOfSize:14.0], NSFontAttributeName,
                                              nil];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:strComment attributes:attributesDictionary];
        CGRect requiredCommentHeight = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        
        for (int i = 0; i < replyArray.count; i++) {
            NSString *content_str = nil;
            NSString *replyName = nil;
            NSString *replyNickname = nil;
            NSString *reply_str = nil;
            
            reply_str = [[replyArray objectAtIndex:i] objectForKey:@"content"];
            if ([[replyArray objectAtIndex:i] objectForKey:@"rnickname"] == [NSNull null]) {
                replyNickname = [[replyArray objectAtIndex:i] objectForKey:@"nickname"];
                content_str = [NSString stringWithFormat:@"%@: %@", replyNickname, reply_str];
            }
            else{
                replyNickname = [[replyArray objectAtIndex:i] objectForKey:@"rnickname"];
                replyName = [[replyArray objectAtIndex:i] objectForKey:@"nickname"];
                content_str = [NSString stringWithFormat:@"%@回复%@: %@", replyNickname, replyName, reply_str];
            }
            
            CGSize constrainedSize = CGSizeMake(self.view.frame.size.width - PADDING_WIDTH, 9999);
            NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                                  [UIFont systemFontOfSize:14.0], NSFontAttributeName,
                                                  nil];
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:content_str attributes:attributesDictionary];
            CGRect requiredHeight = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
            
            height = height + requiredHeight.size.height + PADDING_HEIGHT1;
        }
        
        if ((25 + requiredCommentHeight.size.height + 5 + height + PADDING_HEIGHT2) < 80) {
            return 80;
        }
        
        return 25 + requiredCommentHeight.size.height + 5 + height + PADDING_HEIGHT2;
    }
    
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView == contentTable) {
        [sendText resignFirstResponder];
        [sendWord resignFirstResponder];
        [sendReply resignFirstResponder];
    }
    
    if (tableView == commentTable) {
        commentID = [[commentArray objectAtIndex:indexPath.row] objectForKey:@"commentid"];
        
        isLeft = YES;
        isComment = NO;
        isReply = NO;
        
        replyWordView.hidden = YES;
        commentView.hidden = YES;
        leftWordView.hidden = NO;
        
        sendWord.placeholder = [NSString stringWithFormat:@"回复%@", [[commentArray objectAtIndex:indexPath.row] objectForKey:@"nickname"]];
        [sendWord becomeFirstResponder];
    }
}

- (void)backBtnClicked{
    [sendText resignFirstResponder];
    [sendWord resignFirstResponder];
    [sendReply resignFirstResponder];
    
    [self.navigationController popViewControllerAnimated:YES];
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
