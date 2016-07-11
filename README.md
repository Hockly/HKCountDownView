# HKCountDownView
## ☆☆☆ “iOS 商城秒杀倒计时控件” ☆☆☆

### 使用步骤（just so  easy）
     HKCountDownView *countView  = [HKCountDownView loadCountDownViewWithTimeStyle:HKTimeStyleTypeSplitted];
     countView.frame = CGRectMake(100, 100, 112, 19);
     countView.timerStopComplete = ^{
        NSLog(@"倒计时结束了");
    };
    [self.view addSubview:countView];
    
 ---------------------------------------------------------------------------------------------------------------
