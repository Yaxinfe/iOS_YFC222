//
//  FillViewController.m
//  YFC
//
//  Created by iOS on 06/08/15.
//  Copyright (c) 2015 ming. All rights reserved.
//

#import "FillViewController.h"
#import "GitaViewController.h"
#import "PayMethodViewController.h"
#import "AppLanguage.h"

@interface FillViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UIScrollView *scrollView;
    
    UICollectionView *_collectionView;
    NSMutableArray *imageArray;
}
@end

@implementation FillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    imageArray = [NSMutableArray arrayWithObjects:@"10Img.png", @"30Img.png", @"50Img.png", @"100Img.png", @"200Img.png", @"500Img.png", @"1000Img.png", @"2000Img.png", @"10000Img.png", nil];
    
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    backImageView.image = [UIImage imageNamed:@"shopBack.png"];
    [self.view addSubview:backImageView];
    
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 100, 30, 200, 24)];
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
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    scrollView.alwaysBounceHorizontal = NO;
    scrollView.alwaysBounceVertical = YES;
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    _collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 70, self.view.frame.size.width, 360) collectionViewLayout:layout];
    [_collectionView setDataSource:self];
    [_collectionView setDelegate:self];
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [_collectionView setBackgroundColor:[UIColor clearColor]];
    _collectionView.scrollEnabled = NO;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 3;
    [scrollView addSubview:_collectionView];
    
    UIButton *gita_btn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 160, _collectionView.frame.origin.y + _collectionView.frame.size.height + 10, 160, 40)];
    [gita_btn setBackgroundImage:[UIImage imageNamed:@"gitapayBtn.png"] forState:UIControlStateNormal];
    [gita_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [gita_btn addTarget:self action:@selector(gitaBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [gita_btn setTintColor:[UIColor lightGrayColor]];
    gita_btn.alpha = 1.0;
    gita_btn.transform = CGAffineTransformMakeTranslation(10, 0);
    [scrollView addSubview:gita_btn];
    
    [self.view addSubview:scrollView];
    
    NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
    if ([applang isEqualToString:@"ko"]) {
        titleLbl.text = QUNGJEN_TITLE[0];
        [gita_btn setTitle:QUNGJEN_GITA_BUTTON[0] forState:UIControlStateNormal];
    }
    if ([applang isEqualToString:@"cn"]) {
        titleLbl.text = QUNGJEN_TITLE[1];
        [gita_btn setTitle:QUNGJEN_GITA_BUTTON[1] forState:UIControlStateNormal];
    }
    
    UIButton *back_btn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.origin.x , self.view.frame.origin.y + 25, 27, 30)];
    [back_btn setImage:[UIImage imageNamed:@"backBtn.png"] forState:UIControlStateNormal];
    [back_btn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [back_btn setTintColor:[UIColor lightGrayColor]];
    back_btn.alpha = 1.0;
    back_btn.transform = CGAffineTransformMakeTranslation(10, 0);
    [self.view addSubview:back_btn];
}

#pragma mark - UICollectionView data source

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 9;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize retval;
    retval =  CGSizeMake(self.view.frame.size.width/3, 120);
    return retval;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    if (cell==nil)
    {
        cell.backgroundColor=[UIColor clearColor];
        
    }
    else
    {
        for (UIView *view in cell.contentView.subviews)
            [view removeFromSuperview];
    }
    
    UIImageView *back = [[UIImageView alloc] init];
    back.backgroundColor = [UIColor clearColor];
    back.frame = CGRectMake(10, 5, cell.frame.size.width - 20, 80);
    [cell.contentView addSubview:back];
    
    if (indexPath.row == 0) {
        UILabel *ballLbl = [[UILabel alloc] init];
        NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
        if ([applang isEqualToString:@"ko"]) {
            ballLbl.text = @"십원";
        }
        if ([applang isEqualToString:@"cn"]) {
            ballLbl.text = @"10元";
        }
        ballLbl.textColor = [UIColor whiteColor];
        ballLbl.backgroundColor = [UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0];
        ballLbl.frame = CGRectMake(20, 90, cell.frame.size.width - 40, 25);
        ballLbl.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:ballLbl];
    }
    if (indexPath.row == 1) {
        UILabel *ballLbl = [[UILabel alloc] init];
        NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
        if ([applang isEqualToString:@"ko"]) {
            ballLbl.text = @"삼십원";
        }
        if ([applang isEqualToString:@"cn"]) {
            ballLbl.text = @"30元";
        }
        
        ballLbl.textColor = [UIColor whiteColor];
        ballLbl.backgroundColor = [UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0];
        ballLbl.frame = CGRectMake(20, 90, cell.frame.size.width - 40, 25);
        ballLbl.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:ballLbl];
    }
    if (indexPath.row == 2) {
        UILabel *ballLbl = [[UILabel alloc] init];
        NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
        if ([applang isEqualToString:@"ko"]) {
            ballLbl.text = @"오십원";
        }
        if ([applang isEqualToString:@"cn"]) {
            ballLbl.text = @"50元";
        }
        
        ballLbl.textColor = [UIColor whiteColor];
        ballLbl.backgroundColor = [UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0];
        ballLbl.frame = CGRectMake(20, 90, cell.frame.size.width - 40, 25);
        ballLbl.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:ballLbl];
    }
    if (indexPath.row == 3) {
        UILabel *ballLbl = [[UILabel alloc] init];
        NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
        if ([applang isEqualToString:@"ko"]) {
            ballLbl.text = @"백원";
        }
        if ([applang isEqualToString:@"cn"]) {
            ballLbl.text = @"100元";
        }
        
        ballLbl.textColor = [UIColor whiteColor];
        ballLbl.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:148.0/255.0 blue:2.0/255.0 alpha:1.0];
        ballLbl.frame = CGRectMake(20, 90, cell.frame.size.width - 40, 25);
        ballLbl.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:ballLbl];
    }
    if (indexPath.row == 4) {
        UILabel *ballLbl = [[UILabel alloc] init];
        NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
        if ([applang isEqualToString:@"ko"]) {
            ballLbl.text = @"이백원";
        }
        if ([applang isEqualToString:@"cn"]) {
            ballLbl.text = @"200元";
        }
        
        ballLbl.textColor = [UIColor whiteColor];
        ballLbl.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:148.0/255.0 blue:2.0/255.0 alpha:1.0];
        ballLbl.frame = CGRectMake(20, 90, cell.frame.size.width - 40, 25);
        ballLbl.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:ballLbl];
    }
    if (indexPath.row == 5) {
        UILabel *ballLbl = [[UILabel alloc] init];
        NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
        if ([applang isEqualToString:@"ko"]) {
            ballLbl.text = @"오백원";
        }
        if ([applang isEqualToString:@"cn"]) {
            ballLbl.text = @"500元";
        }
        
        ballLbl.textColor = [UIColor whiteColor];
        ballLbl.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:148.0/255.0 blue:2.0/255.0 alpha:1.0];
        ballLbl.frame = CGRectMake(20, 90, cell.frame.size.width - 40, 25);
        ballLbl.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:ballLbl];
    }
    if (indexPath.row == 6) {
        UILabel *ballLbl = [[UILabel alloc] init];
        NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
        if ([applang isEqualToString:@"ko"]) {
            ballLbl.text = @"천원";
        }
        if ([applang isEqualToString:@"cn"]) {
            ballLbl.text = @"1000元";
        }
        
        ballLbl.textColor = [UIColor whiteColor];
        ballLbl.backgroundColor = [UIColor redColor];
        ballLbl.frame = CGRectMake(20, 90, cell.frame.size.width - 40, 25);
        ballLbl.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:ballLbl];
    }
    if (indexPath.row == 7) {
        UILabel *ballLbl = [[UILabel alloc] init];
        NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
        if ([applang isEqualToString:@"ko"]) {
            ballLbl.text = @"이천원";
        }
        if ([applang isEqualToString:@"cn"]) {
            ballLbl.text = @"2000元";
        }
        
        ballLbl.textColor = [UIColor whiteColor];
        ballLbl.backgroundColor = [UIColor redColor];
        ballLbl.frame = CGRectMake(20, 90, cell.frame.size.width - 40, 25);
        ballLbl.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:ballLbl];
    }
    if (indexPath.row == 8) {
        UILabel *ballLbl = [[UILabel alloc] init];
        NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
        if ([applang isEqualToString:@"ko"]) {
            ballLbl.text = @"만원";
        }
        if ([applang isEqualToString:@"cn"]) {
            ballLbl.text = @"10000元";
        }
        
        ballLbl.textColor = [UIColor whiteColor];
        ballLbl.backgroundColor = [UIColor redColor];
        ballLbl.frame = CGRectMake(20, 90, cell.frame.size.width - 40, 25);
        ballLbl.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:ballLbl];
    }
    
    back.contentMode = UIViewContentModeScaleAspectFit;
    back.image = [UIImage imageNamed:[imageArray objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PayMethodViewController *pay_view = [[PayMethodViewController alloc] init];
    if (indexPath.row == 0) {
        pay_view.ballCount = 10;
    }
    if (indexPath.row == 1) {
        pay_view.ballCount = 30;
    }
    if (indexPath.row == 2) {
        pay_view.ballCount = 50;
    }
    if (indexPath.row == 3) {
        pay_view.ballCount = 100;
    }
    if (indexPath.row == 4) {
        pay_view.ballCount = 200;
    }
    if (indexPath.row == 5) {
        pay_view.ballCount = 500;
    }
    if (indexPath.row == 6) {
        pay_view.ballCount = 1000;
    }
    if (indexPath.row == 7) {
        pay_view.ballCount = 2000;
    }
    if (indexPath.row == 8) {
        pay_view.ballCount = 10000;
    }
    
    [self.navigationController pushViewController:pay_view animated:YES];
}

- (void)backBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)gitaBtnClicked{
    GitaViewController *gita_view = [[GitaViewController alloc] init];
    [self.navigationController pushViewController:gita_view animated:YES];
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
