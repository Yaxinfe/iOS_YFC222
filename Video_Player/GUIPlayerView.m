//
//  GUIPlayerView.m
//  GUIPlayerView
//
//  Created by Guilherme Araújo on 08/12/14.
//  Copyright (c) 2014 Guilherme Araújo. All rights reserved.
//

#import "GUIPlayerView.h"
#import "GUISlider.h"

#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

#import "UIView+UpdateAutoLayoutConstraints.h"

@interface GUIPlayerView () <AVAssetResourceLoaderDelegate, NSURLConnectionDataDelegate, UITextFieldDelegate>
{
    UIView       *commentView;
    UITextField  *chatSendText;
    
    UILabel      *lblFlow1;
    UILabel      *lblFlow2;
    UILabel      *lblFlow3;
    
    BOOL status[3];
    BOOL isFullBtnClicked;
}

@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic) AVPlayerLayer *playerLayer;
@property (strong, nonatomic) AVPlayerItem *currentItem;

@property (strong, nonatomic) UIView *controllersView;
@property (strong, nonatomic) UILabel *airPlayLabel;

@property (strong, nonatomic) UIButton *playButton;
@property (strong, nonatomic) UIButton *fullscreenButton;
@property (strong, nonatomic) MPVolumeView *volumeView;
@property (strong, nonatomic) GUISlider *progressIndicator;
@property (strong, nonatomic) UILabel *currentTimeLabel;
@property (strong, nonatomic) UILabel *remainingTimeLabel;
@property (strong, nonatomic) UILabel *liveLabel;

@property (strong, nonatomic) UIView *spacerView;

@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) NSTimer *progressTimer;
@property (strong, nonatomic) NSTimer *controllersTimer;
@property (assign, nonatomic) BOOL seeking;
@property (assign, nonatomic) BOOL fullscreen;
@property (assign, nonatomic) CGRect defaultFrame;
@property (assign, nonatomic) CGRect commentVFrame;
@property (assign, nonatomic) CGRect fullScreenFrame;

@property (nonatomic, strong) UIButton *chatBtn;
@property (nonatomic, strong) UISwitch *hiddenSwitch;
@property (nonatomic, strong) UIButton *sendBtn;

@end

@implementation GUIPlayerView

@synthesize player, playerLayer, currentItem;
@synthesize controllersView, airPlayLabel;
@synthesize playButton, fullscreenButton, volumeView, progressIndicator, currentTimeLabel, remainingTimeLabel, liveLabel, spacerView, chatBtn, hiddenSwitch, sendBtn;
@synthesize activityIndicator, progressTimer, controllersTimer, seeking, fullscreen, defaultFrame, commentVFrame;

@synthesize videoURL, controllersTimeoutPeriod, delegate;

#pragma mark - View Life Cycle

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  defaultFrame = frame;
  [self setup];
  return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  [self setup];
  return self;
}

- (void)changeLabelDelegate{
    NSString *scrollChats = [[NSUserDefaults standardUserDefaults] objectForKey:@"scrollChats"];
    
    int emptyPosition = [self checkEmpty];
    
    if (emptyPosition == 0) {
        [UIView animateWithDuration:15.0 animations:^{
            status[0] = YES;
            lblFlow1.text = scrollChats;
            lblFlow1.frame = CGRectMake(-commentVFrame.size.width, 5, commentVFrame.size.width, 20);
        }completion:^(BOOL finished){
            lblFlow1.text = @"";
            status[0] = NO;
            lblFlow1.frame = CGRectMake(commentVFrame.size.width, 5, commentVFrame.size.width, 20);
        }];
    }
    if (emptyPosition == 1) {
        [UIView animateWithDuration:15.0 animations:^{
            lblFlow2.text = scrollChats;
            status[1] = YES;
            lblFlow2.frame = CGRectMake(-commentVFrame.size.width, 5, commentVFrame.size.width, 20);
        }completion:^(BOOL finished){
            lblFlow2.text = @"";
            status[1] = NO;
            lblFlow2.frame = CGRectMake(commentVFrame.size.width, 5, commentVFrame.size.width, 20);
        }];
    }
    if (emptyPosition == 2) {
        [UIView animateWithDuration:15.0 animations:^{
            lblFlow3.text = scrollChats;
            status[2] = YES;
            lblFlow3.frame = CGRectMake(-commentVFrame.size.width, 5, commentVFrame.size.width, 20);
        }completion:^(BOOL finished){
            lblFlow3.text = @"";
            status[2] = NO;
            lblFlow3.frame = CGRectMake(commentVFrame.size.width, 5, commentVFrame.size.width, 20);
        }];
    }
}

- (int)checkEmpty{
    for (int i = 0; i < 3; i++) {
        if (status[i] == NO) {
            return i;
        }
    }
    return 0;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [chatSendText resignFirstResponder];
    return YES;
}

- (void)setup {
    status[0] = NO;
    status[1] = NO;
    status[2] = NO;
    
  // Set up notification observers
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerDidFinishPlaying:)
                                               name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerFailedToPlayToEnd:)
                                               name:AVPlayerItemFailedToPlayToEndTimeNotification object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerStalled:)
                                               name:AVPlayerItemPlaybackStalledNotification object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(airPlayAvailabilityChanged:)
                                               name:MPVolumeViewWirelessRoutesAvailableDidChangeNotification object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(airPlayActivityChanged:)
                                               name:MPVolumeViewWirelessRouteActiveDidChangeNotification object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLabelDelegate) name:@"changeChatContents" object:nil];
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detectOrientation:) name:@"UIDeviceOrientationDidChangeNotification" object:nil];
    
    
  [self setBackgroundColor:[UIColor blackColor]];
  
  NSArray *horizontalConstraints;
  NSArray *verticalConstraints;
  
  
  /** Container View **************************************************************************************************/
  controllersView = [UIView new];
  [controllersView setTranslatesAutoresizingMaskIntoConstraints:NO];
  [controllersView setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:0.45f]];
  
  [self addSubview:controllersView];
  
  horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[CV]|"
                                                                  options:0
                                                                  metrics:nil
                                                                    views:@{@"CV" : controllersView}];
  
  verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[CV(40)]|"
                                                                options:0
                                                                metrics:nil
                                                                  views:@{@"CV" : controllersView}];
  [self addConstraints:horizontalConstraints];
  [self addConstraints:verticalConstraints];
  
  
  /** AirPlay View ****************************************************************************************************/
  
  airPlayLabel = [UILabel new];
  [airPlayLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
  [airPlayLabel setText:@"AirPlay is enabled"];
  [airPlayLabel setTextColor:[UIColor lightGrayColor]];
  [airPlayLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:13.0f]];
  [airPlayLabel setTextAlignment:NSTextAlignmentCenter];
  [airPlayLabel setNumberOfLines:0];
  [airPlayLabel setHidden:YES];
  
  [self addSubview:airPlayLabel];
  
  horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[AP]|"
                                                                  options:0
                                                                  metrics:nil
                                                                    views:@{@"AP" : airPlayLabel}];
  
  verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[AP]-40-|"
                                                                options:0
                                                                metrics:nil
                                                                  views:@{@"AP" : airPlayLabel}];
  [self addConstraints:horizontalConstraints];
  [self addConstraints:verticalConstraints];
  
  /** UI Controllers **************************************************************************************************/
  playButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [playButton setTranslatesAutoresizingMaskIntoConstraints:NO];
  [playButton setImage:[UIImage imageNamed:@"gui_play"] forState:UIControlStateNormal];
  [playButton setImage:[UIImage imageNamed:@"gui_pause"] forState:UIControlStateSelected];
    
  volumeView = [MPVolumeView new];
  [volumeView setTranslatesAutoresizingMaskIntoConstraints:NO];
  [volumeView setShowsRouteButton:YES];
  [volumeView setShowsVolumeSlider:YES];
  [volumeView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
  
  fullscreenButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [fullscreenButton setTranslatesAutoresizingMaskIntoConstraints:NO];
  [fullscreenButton setImage:[UIImage imageNamed:@"gui_expand"] forState:UIControlStateNormal];
  [fullscreenButton setImage:[UIImage imageNamed:@"gui_shrink"] forState:UIControlStateSelected];
  
  currentTimeLabel = [UILabel new];
  [currentTimeLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
  [currentTimeLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:13.0f]];
  [currentTimeLabel setTextAlignment:NSTextAlignmentCenter];
  [currentTimeLabel setTextColor:[UIColor whiteColor]];
  
  remainingTimeLabel = [UILabel new];
  [remainingTimeLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
  [remainingTimeLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:13.0f]];
  [remainingTimeLabel setTextAlignment:NSTextAlignmentCenter];
  [remainingTimeLabel setTextColor:[UIColor whiteColor]];
  
  progressIndicator = [GUISlider new];
  [progressIndicator setTranslatesAutoresizingMaskIntoConstraints:NO];
  [progressIndicator setContinuous:YES];
  
  liveLabel = [UILabel new];
  [liveLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
  [liveLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:13.0f]];
  [liveLabel setTextAlignment:NSTextAlignmentCenter];
  [liveLabel setTextColor:[UIColor whiteColor]];
//  [liveLabel setText:@"생방송"];
  [liveLabel setHidden:YES];
  
  spacerView = [UIView new];
  [spacerView setTranslatesAutoresizingMaskIntoConstraints:NO];
  
      chatBtn = [UIButton new];
    [chatBtn setTranslatesAutoresizingMaskIntoConstraints:NO];
      [chatBtn setImage:[UIImage imageNamed:@"chatBtn.png"] forState:UIControlStateNormal];
      [chatBtn addTarget:self action:@selector(chatBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    hiddenSwitch = [UISwitch new];
    [hiddenSwitch setTranslatesAutoresizingMaskIntoConstraints:NO];
    [hiddenSwitch addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
    [hiddenSwitch setOnTintColor:[UIColor redColor]];
    hiddenSwitch.transform = CGAffineTransformMakeScale(0.75, 0.75);
    
  [controllersView addSubview:playButton];
  [controllersView addSubview:fullscreenButton];
  [controllersView addSubview:volumeView];
  [controllersView addSubview:currentTimeLabel];
  [controllersView addSubview:progressIndicator];
  [controllersView addSubview:remainingTimeLabel];
  [controllersView addSubview:liveLabel];
  [controllersView addSubview:spacerView];
    [controllersView addSubview:chatBtn];
    [controllersView addSubview:hiddenSwitch];
    
    progressIndicator.hidden = YES;
    currentTimeLabel.hidden = YES;
    remainingTimeLabel.hidden = YES;
    chatBtn.hidden = YES;
    hiddenSwitch.hidden = YES;
    
  horizontalConstraints = [NSLayoutConstraint
                           constraintsWithVisualFormat:@"H:|[P(40)][S(10)][C]-5-[I]-5-[R(30)][H(50)][F(40)]|"
                           options:0
                           metrics:nil
                           views:@{@"P" : playButton,
                                   @"S" : spacerView,
                                   @"C" : currentTimeLabel,
                                   @"I" : progressIndicator,
                                   @"R" : chatBtn,
                                   @"H" : hiddenSwitch,
                                   @"F" : fullscreenButton}];
  
  [controllersView addConstraints:horizontalConstraints];
  
  [volumeView hideByWidth:YES];
  [spacerView hideByWidth:YES];
  
  horizontalConstraints = [NSLayoutConstraint
                           constraintsWithVisualFormat:@"H:|-5-[L]-5-|"
                           options:0
                           metrics:nil
                           views:@{@"L" : liveLabel}];
  
  [controllersView addConstraints:horizontalConstraints];
  
  for (UIView *view in [controllersView subviews]) {
    verticalConstraints = [NSLayoutConstraint
                           constraintsWithVisualFormat:@"V:|-0-[V(40)]"
                           options:NSLayoutFormatAlignAllCenterY
                           metrics:nil
                           views:@{@"V" : view}];
    [controllersView addConstraints:verticalConstraints];
  }
  
  
  /** Loading Indicator ***********************************************************************************************/
  activityIndicator = [UIActivityIndicatorView new];
  [activityIndicator stopAnimating];
  
  CGRect frame = self.frame;
  frame.origin = CGPointZero;
    
  [activityIndicator setFrame:frame];
  
  [self addSubview:activityIndicator];
  
  
  /** Actions Setup ***************************************************************************************************/
  
  [playButton addTarget:self action:@selector(togglePlay:) forControlEvents:UIControlEventTouchUpInside];
  [fullscreenButton addTarget:self action:@selector(toggleFullscreen:) forControlEvents:UIControlEventTouchUpInside];
  
  [progressIndicator addTarget:self action:@selector(seek:) forControlEvents:UIControlEventValueChanged];
  [progressIndicator addTarget:self action:@selector(pauseRefreshing) forControlEvents:UIControlEventTouchDown];
  [progressIndicator addTarget:self action:@selector(resumeRefreshing) forControlEvents:UIControlEventTouchUpInside|
   UIControlEventTouchUpOutside];
  
  [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showControllers)]];
  [self showControllers];
  
  controllersTimeoutPeriod = 3;
}

#pragma mark - UI Customization

- (void)setTintColor:(UIColor *)tintColor {
  [super setTintColor:tintColor];
  
  [progressIndicator setTintColor:tintColor];
}

- (void)setBufferTintColor:(UIColor *)tintColor {
  [progressIndicator setSecondaryTintColor:tintColor];
}

- (void)setLiveStreamText:(NSString *)text {
  [liveLabel setText:text];
}

- (void)setAirPlayText:(NSString *)text {
  [airPlayLabel setText:text];
}

#pragma mark - Actions

- (void)togglePlay:(UIButton *)button {
  if ([button isSelected]) {
    [button setSelected:NO];
    [player pause];
    
    if ([delegate respondsToSelector:@selector(playerDidPause)]) {
      [delegate playerDidPause];
    }
  } else {
    [button setSelected:YES];
    [self play];
    
    if ([delegate respondsToSelector:@selector(playerDidResume)]) {
      [delegate playerDidResume];
    }
  }
  
  [self showControllers];
}

-(void)setPortraitScreen{
    if ([delegate respondsToSelector:@selector(playerWillLeaveFullscreen)]) {
        [delegate playerWillLeaveFullscreen];
    }
    
    [UIView animateWithDuration:0.2f animations:^{
        [self setTransform:CGAffineTransformMakeRotation(0)];
        [self setFrame:defaultFrame];
        
        CGRect frame = defaultFrame;
        frame.origin = CGPointZero;
        [playerLayer setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height)];
        [activityIndicator setFrame:frame];
        
        lblFlow1.hidden = YES;
        lblFlow2.hidden = YES;
        lblFlow3.hidden = YES;
        
        commentView.hidden = YES;
        
        lblFlow1.frame = CGRectMake(frame.size.width, 5, frame.size.width, 20);
        lblFlow2.frame = CGRectMake(frame.size.width, 30, frame.size.width, 20);
        lblFlow3.frame = CGRectMake(frame.size.width, 55, frame.size.width, 20);
        
    } completion:^(BOOL finished) {
        fullscreen = NO;
        
        if ([delegate respondsToSelector:@selector(playerDidLeaveFullscreen)]) {
            [delegate playerDidLeaveFullscreen];
        }
    }];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideNaviDelegate" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    chatBtn.hidden = YES;
    hiddenSwitch.hidden = YES;
    
    [fullscreenButton setSelected:NO];
}

-(void)setLandscapeScreen{
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerkeyboardDidShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerkeyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    CGFloat width = [[UIScreen mainScreen] bounds].size.width;
    CGFloat height = [[UIScreen mainScreen] bounds].size.height;
    CGRect frame;
    
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        CGFloat aux = width;
        width = height;
        height = aux;
        frame = CGRectMake((height - width) / 2, (width - height) / 2, width, height);
    }
    else {
        frame = CGRectMake(0, 0, width, height);
    }
    
    if ([delegate respondsToSelector:@selector(playerWillEnterFullscreen)]) {
        [delegate playerWillEnterFullscreen];
    }
    
    [UIView animateWithDuration:0.2f animations:^{
        [self setFrame:frame];
        [playerLayer setFrame:CGRectMake(0, 0, width, height)];
        
        [activityIndicator setFrame:CGRectMake(0, 0, width, height)];
        if (UIInterfaceOrientationIsPortrait(orientation)) {
            [self setTransform:CGAffineTransformMakeRotation(M_PI_2)];
            [activityIndicator setTransform:CGAffineTransformMakeRotation(M_PI_2)];
        }
        
    } completion:^(BOOL finished) {
        fullscreen = YES;
        
        lblFlow1.hidden = NO;
        lblFlow2.hidden = NO;
        lblFlow3.hidden = NO;
        
        chatBtn.hidden = NO;
        hiddenSwitch.hidden = NO;
        
        lblFlow1.frame = CGRectMake(frame.size.width, 5, frame.size.width, 20);
        lblFlow2.frame = CGRectMake(frame.size.width, 30, frame.size.width, 20);
        lblFlow3.frame = CGRectMake(frame.size.width, 55, frame.size.width, 20);
        
        commentVFrame = frame;
        commentView.frame = CGRectMake(0, frame.size.height, frame.size.width, 50);
        commentView.hidden = NO;
        sendBtn.frame = CGRectMake(frame.size.width - 100, 5, 80, 40);
        
        if ([delegate respondsToSelector:@selector(playerDidEnterFullscreen)]) {
            [delegate playerDidEnterFullscreen];
        }
    }];
    
    [fullscreenButton setSelected:YES];
}

-(void)detectOrientation:(NSNotification *)notification
{
    UIInterfaceOrientation newOrientation =  [UIApplication sharedApplication].statusBarOrientation;
    if ((newOrientation == UIInterfaceOrientationLandscapeLeft || newOrientation == UIInterfaceOrientationLandscapeRight))
    {
        NSLog(@"Landscape-----");
        [self setLandscapeScreen];
        [chatSendText resignFirstResponder];
    }
    else if (newOrientation == UIInterfaceOrientationPortrait || newOrientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        NSLog(@"Portrait------");
        [self setPortraitScreen];
        [chatSendText resignFirstResponder];
    }
    [self showControllers];
}

- (void)toggleFullscreen:(UIButton *)button {
      if (fullscreen) {
          NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
          [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
          [self setPortraitScreen];
      }
      else {
          NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
          [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
          [self setLandscapeScreen];
      }
      
      [self showControllers];
}

-(void)playerkeyboardDidShow:(NSNotification *)notification {
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:0.2 animations:^{
        commentView.frame = CGRectMake(0, commentVFrame.size.height - keyboardSize.height - 50, commentVFrame.size.width, 50);
    }completion:^(BOOL finished){
        
    }];
}

-(void)playerkeyboardWillHide:(NSNotification *)notification {
    [UIView animateWithDuration:0.2 animations:^{
        commentView.frame = CGRectMake(0, commentVFrame.size.height, commentVFrame.size.width, 50);
    }completion:^(BOOL finished){
        
    }];
}

- (void)changeSwitch:(id)sender{
    if([sender isOn]){
        NSLog(@"Switch is ON");

        lblFlow1.hidden = YES;
        lblFlow2.hidden = YES;
        lblFlow3.hidden = YES;
    }
    else{
        NSLog(@"Switch is OFF");

        lblFlow1.hidden = NO;
        lblFlow2.hidden = NO;
        lblFlow3.hidden = NO;
    }
}

- (void)sendBtnClicked{
    [chatSendText resignFirstResponder];
    [[NSUserDefaults standardUserDefaults] setObject:chatSendText.text forKey:@"sendMessage"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"sendMessageNoty" object:nil];
    chatSendText.text = @"";
}

- (void)chatBtnClicked{
    [chatSendText becomeFirstResponder];
}

- (void)seek:(UISlider *)slider {
  int timescale = currentItem.asset.duration.timescale;
  float time = slider.value * (currentItem.asset.duration.value / timescale);
  [player seekToTime:CMTimeMakeWithSeconds(time, timescale)];
  
  [self showControllers];
}

- (void)pauseRefreshing {
  seeking = YES;
}

- (void)resumeRefreshing {
  seeking = NO;
}

- (NSTimeInterval)availableDuration {
  NSTimeInterval result = 0;
  NSArray *loadedTimeRanges = player.currentItem.loadedTimeRanges;
  
  if ([loadedTimeRanges count] > 0) {
    CMTimeRange timeRange = [[loadedTimeRanges objectAtIndex:0] CMTimeRangeValue];
    Float64 startSeconds = CMTimeGetSeconds(timeRange.start);
    Float64 durationSeconds = CMTimeGetSeconds(timeRange.duration);
    result = startSeconds + durationSeconds;
  }
  
  return result;
}

- (void)refreshProgressIndicator {
  CGFloat duration = CMTimeGetSeconds(currentItem.asset.duration);
  
  if (duration == 0 || isnan(duration)) {
    // Video is a live stream
    [currentTimeLabel setText:nil];
    [remainingTimeLabel setText:nil];
    [progressIndicator setHidden:YES];
    [liveLabel setHidden:NO];
  }
  
  else {
    CGFloat current = seeking ?
    progressIndicator.value * duration :         // If seeking, reflects the position of the slider
    CMTimeGetSeconds(player.currentTime); // Otherwise, use the actual video position
    
    [progressIndicator setValue:(current / duration)];
    [progressIndicator setSecondaryValue:([self availableDuration] / duration)];
    
    // Set time labels
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:(duration >= 3600 ? @"hh:mm:ss": @"mm:ss")];
    
    NSDate *currentTime = [NSDate dateWithTimeIntervalSince1970:current];
    NSDate *remainingTime = [NSDate dateWithTimeIntervalSince1970:(duration - current)];
    
    [currentTimeLabel setText:[formatter stringFromDate:currentTime]];
    [remainingTimeLabel setText:[NSString stringWithFormat:@"-%@", [formatter stringFromDate:remainingTime]]];
    
    [progressIndicator setHidden:NO];
    [liveLabel setHidden:YES];
  }
}

- (void)showControllers {
  [UIView animateWithDuration:0.2f animations:^{
    [controllersView setAlpha:1.0f];
  } completion:^(BOOL finished) {
    [controllersTimer invalidate];
    
    if (controllersTimeoutPeriod > 0) {
      controllersTimer = [NSTimer scheduledTimerWithTimeInterval:controllersTimeoutPeriod
                                                          target:self
                                                        selector:@selector(hideControllers)
                                                        userInfo:nil
                                                         repeats:NO];
    }
  }];
}

- (void)hideControllers {
  [UIView animateWithDuration:0.5f animations:^{
    [controllersView setAlpha:0.0f];
  }];
}

#pragma mark - Public Methods

- (void)prepareAndPlayAutomatically:(BOOL)playAutomatically {
  if (player) {
    [self stop];
  }
  
  player = [[AVPlayer alloc] initWithPlayerItem:nil];
  
  AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
  NSArray *keys = [NSArray arrayWithObject:@"playable"];
  
  [asset loadValuesAsynchronouslyForKeys:keys completionHandler:^{
    currentItem = [AVPlayerItem playerItemWithAsset:asset];
    [player replaceCurrentItemWithPlayerItem:currentItem];
    
    if (playAutomatically) {
      dispatch_sync(dispatch_get_main_queue(), ^{
        [self play];
      });
    }
  }];
  
  [player setAllowsExternalPlayback:YES];
  playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
  [self.layer addSublayer:playerLayer];
  
  defaultFrame = self.frame;
  
  CGRect frame = self.frame;
  frame.origin = CGPointZero;
  [playerLayer setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height)];

    
    lblFlow1 = [[UILabel alloc] init];
    [lblFlow1 setFrame:CGRectMake(frame.size.width, 5, frame.size.width, 20)];
    [lblFlow1 setTextAlignment:NSTextAlignmentLeft];
    [lblFlow1 setTextColor:[UIColor whiteColor]];
    [lblFlow1 setBackgroundColor:[UIColor clearColor]];
    lblFlow1.hidden = YES;
    [self addSubview:lblFlow1];
    
    lblFlow2 = [[UILabel alloc] init];
    [lblFlow2 setFrame:CGRectMake(frame.size.width, 30, frame.size.width, 20)];
    [lblFlow2 setTextAlignment:NSTextAlignmentLeft];
    [lblFlow2 setTextColor:[UIColor whiteColor]];
    [lblFlow2 setBackgroundColor:[UIColor clearColor]];
    lblFlow2.hidden = YES;
    [self addSubview:lblFlow2];
    
    lblFlow3 = [[UILabel alloc] init];
    [lblFlow3 setFrame:CGRectMake(frame.size.width, 55, frame.size.width, 20)];
    [lblFlow3 setTextAlignment:NSTextAlignmentLeft];
    [lblFlow3 setTextColor:[UIColor whiteColor]];
    [lblFlow3 setBackgroundColor:[UIColor clearColor]];
    lblFlow3.hidden = YES;
    [self addSubview:lblFlow3];
    
    commentView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height, frame.size.width, 50)];
    commentView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *lineImg1 = [[UIImageView alloc] initWithFrame:CGRectMake(20, 5, 400, 40)];
    lineImg1.backgroundColor = [UIColor clearColor];
    lineImg1.layer.cornerRadius = 5;
    lineImg1.layer.borderColor = [UIColor lightGrayColor].CGColor;
    lineImg1.layer.borderWidth = 1;
    lineImg1.layer.masksToBounds = YES;
    [commentView addSubview:lineImg1];
    
    chatSendText = [[UITextField alloc] initWithFrame:CGRectMake(25, 8, 350, 34)];
    chatSendText.backgroundColor = [UIColor whiteColor];
    chatSendText.font = [UIFont systemFontOfSize:15.0];
    chatSendText.placeholder = @"Chat";
    chatSendText.keyboardType = UIKeyboardTypeDefault;
    chatSendText.delegate = self;
    [chatSendText setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [commentView addSubview:chatSendText];
    
    sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width - 100, 5, 80, 40)];
    [sendBtn setTitle:@"전 송" forState:UIControlStateNormal];
    sendBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [sendBtn setTitleColor:[UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(sendBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [sendBtn setTintColor:[UIColor lightGrayColor]];
    sendBtn.alpha = 1.0;
    sendBtn.transform = CGAffineTransformMakeTranslation(10, 0);
    [commentView addSubview:sendBtn];
    
    commentView.layer.cornerRadius = 5;
    commentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    commentView.layer.borderWidth = 1;
    commentView.layer.masksToBounds = YES;
    
    [self addSubview:commentView];
    commentView.hidden = YES;
    
  [self bringSubviewToFront:controllersView];
  
  [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
  
  [player addObserver:self forKeyPath:@"rate" options:0 context:nil];
//  [currentItem addObserver:self forKeyPath:@"status" options:0 context:nil];
  
  [player seekToTime:kCMTimeZero];
  [player setRate:0.0f];
  [playButton setSelected:NO];
  
  if (playAutomatically) {
    [activityIndicator startAnimating];
  }
}

- (void)clean {
    [progressTimer invalidate];
    progressTimer = nil;
    [controllersTimer invalidate];
    controllersTimer = nil;
    
  [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemFailedToPlayToEndTimeNotification object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemPlaybackStalledNotification object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:MPVolumeViewWirelessRoutesAvailableDidChangeNotification object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:MPVolumeViewWirelessRouteActiveDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIDeviceOrientationDidChangeNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changeChatContents" object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
//    [currentItem removeObserver:self forKeyPath:@"status"];
    
  [player setAllowsExternalPlayback:NO];
  [self stop];
  [player removeObserver:self forKeyPath:@"rate"];
  [self setPlayer:nil];
  [self setPlayerLayer:nil];
  [self removeFromSuperview];
}

- (void)play {
  [player play];
  
  [playButton setSelected:YES];
  
  progressTimer = [NSTimer scheduledTimerWithTimeInterval:0.1f
                                                   target:self
                                                 selector:@selector(refreshProgressIndicator)
                                                 userInfo:nil
                                                  repeats:YES];
}

- (void)pause {
  [player pause];
  [playButton setSelected:NO];
  
  if ([delegate respondsToSelector:@selector(playerDidPause)]) {
    [delegate playerDidPause];
  }
}

- (void)stop {
  if (player) {
    [player pause];
    [player seekToTime:kCMTimeZero];
    
    [playButton setSelected:NO];
  }
}

- (BOOL)isPlaying {
  return [player rate] > 0.0f;
}

#pragma mark - AV Player Notifications and Observers

- (void)playerDidFinishPlaying:(NSNotification *)notification {
  [self stop];
  
  if (fullscreen) {
    [self toggleFullscreen:fullscreenButton];
  }
  
  if ([delegate respondsToSelector:@selector(playerDidEndPlaying)]) {
    [delegate playerDidEndPlaying];
  }
}

- (void)playerFailedToPlayToEnd:(NSNotification *)notification {
  [self stop];
  
  if ([delegate respondsToSelector:@selector(playerFailedToPlayToEnd)]) {
    [delegate playerFailedToPlayToEnd];
  }
}

- (void)playerStalled:(NSNotification *)notification {
  [self togglePlay:playButton];
  
  if ([delegate respondsToSelector:@selector(playerStalled)]) {
    [delegate playerStalled];
  }
}


- (void)airPlayAvailabilityChanged:(NSNotification *)notification {
  [UIView animateWithDuration:0.4f
                   animations:^{
                     if ([volumeView areWirelessRoutesAvailable]) {
                       [volumeView hideByWidth:NO];
                     } else if (! [volumeView isWirelessRouteActive]) {
                       [volumeView hideByWidth:YES];
                     }
                     [self layoutIfNeeded];
                   }];
}


- (void)airPlayActivityChanged:(NSNotification *)notification {
  [UIView animateWithDuration:0.4f
                   animations:^{
                     if ([volumeView isWirelessRouteActive]) {
                       if (fullscreen)
                         [self toggleFullscreen:fullscreenButton];
                       
                       [playButton hideByWidth:YES];
                       [fullscreenButton hideByWidth:YES];
                       [spacerView hideByWidth:NO];
                       
                       [airPlayLabel setHidden:NO];
                       
                       controllersTimeoutPeriod = 0;
                       [self showControllers];
                     } else {
                       [playButton hideByWidth:NO];
                       [fullscreenButton hideByWidth:NO];
                       [spacerView hideByWidth:YES];
                       
                       [airPlayLabel setHidden:YES];
                       
                       controllersTimeoutPeriod = 3;
                       [self showControllers];
                     }
                     [self layoutIfNeeded];
                   }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
  if ([keyPath isEqualToString:@"status"]) {
    if (currentItem.status == AVPlayerItemStatusFailed) {
      if ([delegate respondsToSelector:@selector(playerFailedToPlayToEnd)]) {
        [delegate playerFailedToPlayToEnd];
      }
    }
  }
  
  if ([keyPath isEqualToString:@"rate"]) {
    CGFloat rate = [player rate];
    if (rate > 0) {
      [activityIndicator stopAnimating];
    }
  }
}

@end
