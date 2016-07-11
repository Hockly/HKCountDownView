//
//  HKCountDownView.m
//  HKCountDownView
//
//  Created by Mac on 16/7/4.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "HKCountDownView.h"
#import "UIImage+HKExtension.h"

static const CGFloat kTimeLabelSpan = 2;
static const CGFloat kDotLabelSpan = 2;

@interface HKCountDownView()
{
    dispatch_source_t _timer;
}

@property (weak, nonatomic) UILabel *hourFowardLabel;
@property (weak, nonatomic) UILabel *hourLastLabel;

@property (weak, nonatomic) UILabel *minuteFowardLabel;
@property (weak, nonatomic) UILabel *minuteLastLabel;

@property (weak, nonatomic) UILabel *secondFowardLabel;
@property (weak, nonatomic) UILabel *secondLastLabel;

@property (weak, nonatomic) UILabel *firstDot;
@property (weak, nonatomic) UILabel *secondDot;

@end

@implementation HKCountDownView
+ (instancetype)loadCountDownViewWithTimeStyle:(HKTimeStyleType)timeStyle
{
    HKCountDownView *countDownView = [[self alloc] init];
    countDownView->_timeStyle = timeStyle;
    return countDownView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]){
        [self setupMainView];
    }
    return self;
}

- (void)awakeFromNib
{
    [self setupMainView];
}

- (void)initialization
{
    _timeStyle = HKTimeStyleTypeSplitted;
}

- (void)setupMainView
{
    UILabel *hourFowardLabel = [[UILabel alloc] init];
    hourFowardLabel.textAlignment = NSTextAlignmentCenter;
    hourFowardLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:hourFowardLabel];
    self.hourFowardLabel = hourFowardLabel;
    
    UILabel *hourLastLabel = [[UILabel alloc] init];
    hourLastLabel.textAlignment = NSTextAlignmentCenter;
    hourLastLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:hourLastLabel];
    self.hourLastLabel = hourLastLabel;
    
    UILabel *firstDot = [[UILabel alloc] init];
    firstDot.textAlignment = NSTextAlignmentCenter;
    firstDot.translatesAutoresizingMaskIntoConstraints = NO;
    [firstDot setText:@":"];
    firstDot.textColor = [UIColor blackColor];
    [self addSubview:firstDot];
    self.firstDot = firstDot;
    
    UILabel *minuteFowardLabel = [[UILabel alloc] init];
    minuteFowardLabel.textAlignment = NSTextAlignmentCenter;
    minuteFowardLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:minuteFowardLabel];
    self.minuteFowardLabel = minuteFowardLabel;

    UILabel *minuteLastLabel = [[UILabel alloc] init];
    minuteLastLabel.textAlignment = NSTextAlignmentCenter;
    minuteLastLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:minuteLastLabel];
    self.minuteLastLabel = minuteLastLabel;

    UILabel *secondDot = [[UILabel alloc] init];
    secondDot.textAlignment = NSTextAlignmentCenter;
    secondDot.translatesAutoresizingMaskIntoConstraints = NO;
    [secondDot setText:@":"];
    secondDot.textColor = [UIColor blackColor];
    [self addSubview:secondDot];
    self.secondDot = secondDot;

    UILabel *secondFowardLabel = [[UILabel alloc] init];
    secondFowardLabel.textAlignment = NSTextAlignmentCenter;
    secondFowardLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:secondFowardLabel];
    self.secondFowardLabel = secondFowardLabel;
    
    UILabel *secondLastLabel = [[UILabel alloc] init];
    secondLastLabel.textAlignment = NSTextAlignmentCenter;
    secondLastLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:secondLastLabel];
    self.secondLastLabel = secondLastLabel;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    NSString *Hvfl = @"";
    NSDictionary *views = @{};
    if (self.timeStyle == HKTimeStyleTypeSplitted) {
         Hvfl = @"H:|-margin-[hourFowardLabel(==secondLastLabel)]-margin-[hourLastLabel(==secondLastLabel)]-padding-[firstDot(4)]-padding-[minuteFowardLabel(==secondLastLabel)]-margin-[minuteLastLabel(==secondLastLabel)]-padding-[secondDot(4)]-padding-[secondFowardLabel(==secondLastLabel)]-margin-[secondLastLabel]-margin-|";
        views = @{@"hourFowardLabel" : self.hourFowardLabel,
                                @"hourLastLabel" : self.hourLastLabel,
                                @"firstDot" : self.firstDot,
                                @"minuteFowardLabel" : self.minuteFowardLabel,
                                @"minuteLastLabel" : self.minuteLastLabel,
                                @"secondDot" : self.secondDot,
                                @"secondFowardLabel" : self.secondFowardLabel,
                                @"secondLastLabel" : self.secondLastLabel
                                };
    }else if (self.timeStyle == HKTimeStyleTypeCompact){
        Hvfl = @"H:|-margin-[hourFowardLabel(==secondFowardLabel)]-padding-[firstDot(4)]-padding-[minuteFowardLabel(==secondFowardLabel)]-padding-[secondDot(4)]-padding-[secondFowardLabel]-margin-|";
        views = @{@"hourFowardLabel" : self.hourFowardLabel,
                  @"firstDot" : self.firstDot,
                  @"minuteFowardLabel" : self.minuteFowardLabel,
                  @"secondDot" : self.secondDot,
                  @"secondFowardLabel" : self.secondFowardLabel
                  };
    }

    NSDictionary *metrics = @{ @"margin":@(kTimeLabelSpan),@"padding":@(kDotLabelSpan)};
    NSLayoutFormatOptions ops = NSLayoutFormatAlignAllTop|NSLayoutFormatAlignAllBottom;
    NSArray *Hconstraints = [NSLayoutConstraint constraintsWithVisualFormat:Hvfl options:ops metrics:metrics views:views];
    NSString *Vvfl = @"V:|-margin-[hourFowardLabel]-margin-|";
    NSArray *Vconstraints = [NSLayoutConstraint constraintsWithVisualFormat:Vvfl options:ops metrics:metrics views:views];
    [self addConstraints:Hconstraints];
    [self addConstraints:Vconstraints];
}

/**
 *  根据指定时间间隔开始倒计时
 */
- (void)fireWithTimeIntervar:(NSTimeInterval)timerInterval
{
    if (_timer == nil) {
        __block int timeout = timerInterval; //倒计时时间
        
        if (timeout != 0) {
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
            dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC, 0); //每秒执行
            dispatch_source_set_event_handler(_timer, ^{
                if(timeout <= 0){ //倒计时结束，关闭
                    dispatch_source_cancel(_timer);
                    _timer = nil;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (self.timeStyle == HKTimeStyleTypeSplitted) {
                            self.hourFowardLabel.text = @"0";
                            self.hourFowardLabel.text = @"0";
                            self.minuteFowardLabel.text = @"0";
                            self.minuteLastLabel.text = @"0";
                            self.secondFowardLabel.text = @"0";
                            self.secondLastLabel.text = @"0";
                        }else if (self.timeStyle == HKTimeStyleTypeCompact){
                            self.hourFowardLabel.text = @"00";
                            self.minuteFowardLabel.text = @"00";
                            self.secondFowardLabel.text = @"00";
                        }
                    });
                    // 结束的回调代理
                    if([self.delegate respondsToSelector:@selector(countDownViewDidStopComplete:)]){
                        [self.delegate countDownViewDidStopComplete:self];
                    }
                    
                    // 结束的回调block
                    !_timerStopComplete ? :_timerStopComplete();
                }else{
                    NSInteger hours = (NSInteger)((timeout)/3600);
                    NSInteger minute = (NSInteger)(timeout-hours*3600)/60;
                    NSInteger second = timeout-hours*3600-minute*60;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [self setTimeSplittedWithHours:hours minute:minute second:second];
                    });
                    timeout--;
                }
            });
            dispatch_resume(_timer);
        }
    }
}

- (void)setTimeSplittedWithHours:(NSInteger)hours minute:(NSInteger)minute second:(NSInteger)second
{
    if (self.timeStyle == HKTimeStyleTypeSplitted) {
        if (hours < 10) {
            self.hourFowardLabel.text = @"0";
            self.hourLastLabel.text = [NSString stringWithFormat:@"%zd",hours];
        }else {
            NSString *hourStr = [NSString stringWithFormat:@"%zd",hours];
            self.hourFowardLabel.text = [hourStr substringToIndex:1];
            self.hourLastLabel.text = [hourStr substringWithRange:NSMakeRange(1,1)];
        }
        if (minute < 10) {
            self.minuteFowardLabel.text = @"0";
            self.minuteLastLabel.text = [NSString stringWithFormat:@"%zd",minute];
        }else{
            NSString *minuteStr = [NSString stringWithFormat:@"%zd",minute];
            self.minuteFowardLabel.text = [minuteStr substringToIndex:1];
            self.minuteLastLabel.text = [minuteStr substringWithRange:NSMakeRange(1,1)];
        }
        if (second < 10) {
            self.secondFowardLabel.text = @"0";
            self.secondLastLabel.text = [NSString stringWithFormat:@"%zd",second];
        }else {
            NSString *secondStr = [NSString stringWithFormat:@"%zd",second];
            self.secondFowardLabel.text = [secondStr substringToIndex:1];
            self.secondLastLabel.text = [secondStr substringWithRange:NSMakeRange(1,1)];
        }

    }else if (self.timeStyle == HKTimeStyleTypeCompact){
        if (hours < 10) {
            self.hourFowardLabel.text = [NSString stringWithFormat:@"0%zd",hours];
        }else {
           self.hourFowardLabel.text = [NSString stringWithFormat:@"%zd",hours];
        }
        if (minute < 10) {
            self.minuteFowardLabel.text = [NSString stringWithFormat:@"0%zd",minute];
        }else{
            self.minuteFowardLabel.text = [NSString stringWithFormat:@"%zd",minute];
        }
        if (second < 10) {
            self.secondFowardLabel.text = [NSString stringWithFormat:@"0%zd",second];
        }else {
            self.secondFowardLabel.text =[NSString stringWithFormat:@"%zd",second];
        }
    }
}

#pragma mark -设置时间的方法
- (void)countDownViewWithEndString:(NSString *)endStr
{
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *endDate = [formatter dateFromString:endStr];
    NSTimeInterval timeInterval = [endDate timeIntervalSinceDate:now];
    
    [self fireWithTimeIntervar:timeInterval];
}

- (void)countDownViewWithEndData:(NSDate *)endDate
{
    NSDate *now = [NSDate date];
    NSTimeInterval timeInterval = [endDate timeIntervalSinceDate:now];
    
    [self fireWithTimeIntervar:timeInterval];
}

#pragma mark -set方法
- (void)setTimeRadius:(CGFloat)timeRadius
{
    _timeRadius = timeRadius;
    self.hourFowardLabel.layer.cornerRadius = timeRadius;
    self.hourFowardLabel.clipsToBounds = YES;
    self.hourLastLabel.layer.cornerRadius = timeRadius;
    self.hourLastLabel.clipsToBounds = YES;
    self.minuteFowardLabel.layer.cornerRadius = timeRadius;
    self.minuteFowardLabel.clipsToBounds = YES;
    self.minuteLastLabel.layer.cornerRadius = timeRadius;
    self.minuteLastLabel.clipsToBounds = YES;
    self.secondFowardLabel.layer.cornerRadius = timeRadius;
    self.secondFowardLabel.clipsToBounds = YES;
    self.secondLastLabel.layer.cornerRadius = timeRadius;
    self.secondLastLabel.clipsToBounds = YES;
}

- (void)setTimeBackGroundColor:(UIColor *)timeBackGroundColor
{
    _timeBackGroundColor = timeBackGroundColor;
    [self.hourFowardLabel setBackgroundColor:timeBackGroundColor];
    [self.hourLastLabel setBackgroundColor:timeBackGroundColor];
    [self.minuteFowardLabel setBackgroundColor:timeBackGroundColor];
    [self.minuteLastLabel setBackgroundColor:timeBackGroundColor];
    [self.secondFowardLabel setBackgroundColor:timeBackGroundColor];
    [self.secondLastLabel setBackgroundColor:timeBackGroundColor];
}

- (void)setTimeBackGroundImage:(UIImage *)timeBackGroundImage
{
    _timeBackGroundImage = timeBackGroundImage;
    UIImage *downscaleImage = nil;
    if (self.timeStyle == HKTimeStyleTypeSplitted) {
         downscaleImage = [timeBackGroundImage imageByScalingToSize:CGSizeMake((self.frame.size.width - 5 * kDotLabelSpan - 4 * kDotLabelSpan - 8) / 6, self.frame.size.height - 4.0)];
    }else if(self.timeStyle == HKTimeStyleTypeCompact){
        downscaleImage = [timeBackGroundImage imageByScalingToSize:CGSizeMake((self.frame.size.width - (2 * kDotLabelSpan) - (4 * kDotLabelSpan) - 8) / 3, self.frame.size.height - 4.0)];
    }
    self.hourFowardLabel.backgroundColor = [UIColor colorWithPatternImage: downscaleImage];
    self.hourLastLabel.backgroundColor = [UIColor colorWithPatternImage: downscaleImage];
    self.minuteFowardLabel.backgroundColor = [UIColor colorWithPatternImage: downscaleImage];
    self.minuteLastLabel.backgroundColor = [UIColor colorWithPatternImage: downscaleImage];
    self.secondFowardLabel.backgroundColor = [UIColor colorWithPatternImage: downscaleImage];
    self.secondLastLabel.backgroundColor = [UIColor colorWithPatternImage: downscaleImage];
}

- (void)setTimeFont:(UIFont *)timeFont
{
    _timeFont = timeFont;
    self.hourFowardLabel.font = timeFont;
    self.hourLastLabel.font = timeFont;
    self.minuteFowardLabel.font = timeFont;
    self.minuteLastLabel.font = timeFont;
    self.secondFowardLabel.font = timeFont;
    self.secondLastLabel.font = timeFont;
}

- (void)setTimeFontColor:(UIColor *)timeFontColor
{
    _timeFontColor = timeFontColor;
    self.hourFowardLabel.textColor = timeFontColor;
    self.hourLastLabel.textColor = timeFontColor;
    self.minuteFowardLabel.textColor = timeFontColor;
    self.minuteLastLabel.textColor = timeFontColor;
    self.secondFowardLabel.textColor = timeFontColor;
    self.secondLastLabel.textColor = timeFontColor;
}

- (void)setDotColor:(UIColor *)dotColor
{
    _dotColor = dotColor;
    self.firstDot.textColor = dotColor;
    self.secondDot.textColor = dotColor;
}
@end
