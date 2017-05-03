//
//  GitaViewController.m
//  YFC
//
//  Created by iOS on 06/08/15.
//  Copyright (c) 2015 ming. All rights reserved.
//
#import "publicHeaders.h"

#import "GitaViewController.h"
#import "PayMethodViewController.h"

@interface GitaViewController ()<UITextFieldDelegate>
{
    UITextField *priceText;
    UILabel *price2Lbl;
}
@end

@implementation GitaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    backImageView.image = [UIImage imageNamed:@"shopBack.png"];
    [self.view addSubview:backImageView];
    
    UIButton *back_btn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.origin.x , self.view.frame.origin.y + 25, 27, 30)];
    [back_btn setImage:[UIImage imageNamed:@"backBtn.png"] forState:UIControlStateNormal];
    [back_btn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [back_btn setTintColor:[UIColor lightGrayColor]];
    back_btn.alpha = 1.0;
    back_btn.transform = CGAffineTransformMakeTranslation(10, 0);
    [self.view addSubview:back_btn];
    
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
    
    UIImageView *lineImg = [[UIImageView alloc] initWithFrame:CGRectMake(40, 120, self.view.frame.size.width - 80, (self.view.frame.size.width - 80)/6)];
    lineImg.backgroundColor = [UIColor clearColor];
    lineImg.layer.cornerRadius = 5;
    lineImg.layer.borderColor = [UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0].CGColor;
    lineImg.layer.borderWidth = 1;
    lineImg.layer.masksToBounds = YES;
    [self.view addSubview:lineImg];
    
    priceText = [[UITextField alloc] initWithFrame:CGRectMake(lineImg.frame.origin.x + 10, lineImg.frame.origin.y + 3, lineImg.frame.size.width - 20, lineImg.frame.size.width/6 - 6)];
    priceText.delegate = self;
    priceText.backgroundColor = [UIColor clearColor];
    priceText.textColor = [UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0];
    priceText.font = [UIFont systemFontOfSize:18];
    priceText.keyboardType = UIKeyboardTypeDecimalPad;
    [priceText setValue:[UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0] forKeyPath:@"_placeholderLabel.textColor"];
    [self.view addSubview:priceText];
    
    UILabel *price1Lbl = [[UILabel alloc] initWithFrame:CGRectMake(priceText.frame.origin.x, lineImg.frame.origin.y + lineImg.frame.size.height + 15, self.view.frame.size.width - priceText.frame.origin.x * 2, 30)];
    price1Lbl.font = [UIFont systemFontOfSize:20.0];
    price1Lbl.textAlignment = NSTextAlignmentCenter;
    price1Lbl.textColor = [UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0];
    [self.view addSubview:price1Lbl];
    
    price2Lbl = [[UILabel alloc] initWithFrame:CGRectMake(priceText.frame.origin.x, price1Lbl.frame.origin.y + price1Lbl.frame.size.height + 8, price1Lbl.frame.size.width, 30)];
    price2Lbl.font = [UIFont systemFontOfSize:20.0];
    price2Lbl.textAlignment = NSTextAlignmentCenter;
    price2Lbl.textColor = [UIColor colorWithRed:35.0/255.0 green:85.0/255.0 blue:140.0/255.0 alpha:1.0];
    [self.view addSubview:price2Lbl];
    
    UIButton *pay_btn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 120, price2Lbl.frame.origin.y + price2Lbl.frame.size.height + 20, 240, 40)];
    [pay_btn setBackgroundImage:[UIImage imageNamed:@"ballPayBtn.png"] forState:UIControlStateNormal];
    [pay_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [pay_btn addTarget:self action:@selector(payBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [pay_btn setTintColor:[UIColor lightGrayColor]];
    pay_btn.alpha = 1.0;
    pay_btn.transform = CGAffineTransformMakeTranslation(10, 0);
    [self.view addSubview:pay_btn];
    
    NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
    if ([applang isEqualToString:@"ko"]) {
        titleLbl.text = PAY_TITLE[0];
        priceText.placeholder = PAY_TEXT_PLACE[0];
        price1Lbl.text = PAY_LABEL1[0];
        price2Lbl.text = [NSString stringWithFormat:@"%@%@", PAY_LABEL2[0], @"0원"];
        [pay_btn setTitle:PAY_BUTTON[0] forState:UIControlStateNormal];
    }
    if ([applang isEqualToString:@"cn"]) {
        titleLbl.text = PAY_TITLE[1];
        priceText.placeholder = PAY_TEXT_PLACE[1];
        price1Lbl.text = PAY_LABEL1[1];
        price2Lbl.text = [NSString stringWithFormat:@"%@%@", PAY_LABEL2[1], @"0元"];
        [pay_btn setTitle:PAY_BUTTON[1] forState:UIControlStateNormal];
    }
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    [self.view addGestureRecognizer:tapGesture];
}

- (void)viewTapped:(UIGestureRecognizer *)gesture {
    [priceText resignFirstResponder];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
    if ([applang isEqualToString:@"ko"]) {
        price2Lbl.text = [NSString stringWithFormat:@"%@%@%@", PAY_LABEL2[0], priceText.text, @"원"];
    }
    if ([applang isEqualToString:@"cn"]) {
        price2Lbl.text = [NSString stringWithFormat:@"%@%@%@", PAY_LABEL2[1], priceText.text, @"元"];
    }
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
    if ([applang isEqualToString:@"ko"]) {
        price2Lbl.text = [NSString stringWithFormat:@"%@%@%@", PAY_LABEL2[0], priceText.text, @"원"];
    }
    if ([applang isEqualToString:@"cn"]) {
        price2Lbl.text = [NSString stringWithFormat:@"%@%@%@", PAY_LABEL2[1], priceText.text, @"元"];
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSLog(@"%@", string);
    NSString *applang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];
    if ([applang isEqualToString:@"ko"]) {
        price2Lbl.text = [NSString stringWithFormat:@"%@%@%@%@", PAY_LABEL2[0], priceText.text, string, @"원"];
    }
    if ([applang isEqualToString:@"cn"]) {
        price2Lbl.text = [NSString stringWithFormat:@"%@%@%@%@", PAY_LABEL2[1], priceText.text, string, @"元"];
    }
    
    return YES;
}

- (void)payBtnClicked{
    [priceText resignFirstResponder];
    PayMethodViewController *pay_view = [[PayMethodViewController alloc] init];
    pay_view.ballCount = [priceText.text intValue];
    [self.navigationController pushViewController:pay_view animated:YES];
}

- (void)backBtnClicked{
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
