//
//  ViewController.m
//  HKCountDownViewExample
//
//  Created by Mac on 16/7/11.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "ViewController.h"
#import "HKCountDownView.h"

@interface ViewController ()
@property (weak, nonatomic) HKCountDownView *countView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UILabel *lable1 = [[UILabel alloc] initWithFrame:CGRectMake(100, 80, 112, 19)];
    lable1.text = @"自定义:";
    [self.view addSubview:lable1];
    HKCountDownView *countView  = [HKCountDownView loadCountDownViewWithTimeStyle:HKTimeStyleTypeSplitted];
    countView.frame = CGRectMake(100, 100, 112, 19);
    countView.dotColor = [UIColor redColor];
    countView.timeBackGroundColor = [UIColor redColor];
    countView.timeRadius = 3;
    
    NSDate *endDate = [NSDate dateWithTimeIntervalSinceNow:3900];
    [countView countDownViewWithEndData:endDate];
    
    countView.timerStopComplete = ^{
        NSLog(@"倒计时结束了");
    };
    [self.view addSubview:countView];
    _countView = countView;
    
    
    UILabel *lable2 = [[UILabel alloc] initWithFrame:CGRectMake(100, 180, 150, 20)];
    lable2.text = @"京东:";
    [self.view addSubview:lable2];
    HKCountDownView *countView2  = [HKCountDownView loadCountDownViewWithTimeStyle:HKTimeStyleTypeCompact];
    countView2.frame = CGRectMake(100, 200, 100, 20);
    countView2.timeBackGroundImage = [UIImage imageNamed:@"bg_login_textfield_hl"];
    NSDate *endDate2 = [NSDate dateWithTimeIntervalSinceNow:40000];
    [countView2 countDownViewWithEndData:endDate2];
    
    countView2.timerStopComplete = ^{
        NSLog(@"倒计时结束了");
    };
    [self.view addSubview:countView2];
    
    UILabel *lable3 = [[UILabel alloc] initWithFrame:CGRectMake(100, 270, 150, 20)];
    lable3.text = @"淘宝:";
    [self.view addSubview:lable3];
    
    HKCountDownView *countView3  = [HKCountDownView loadCountDownViewWithTimeStyle:HKTimeStyleTypeCompact];
    countView3.frame = CGRectMake(100, 300, 100, 30);
    countView3.timeBackGroundColor = [UIColor blackColor];
    countView3.timeRadius = 5;
    countView3.timeFontColor = [UIColor whiteColor];
    NSDate *endDate3 = [NSDate dateWithTimeIntervalSinceNow:900];
    [countView3 countDownViewWithEndData:endDate3];
    
    countView3.timerStopComplete = ^{
        NSLog(@"倒计时结束了");
    };
    [self.view addSubview:countView3];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
