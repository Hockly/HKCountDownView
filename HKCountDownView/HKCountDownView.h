//
//  HKCountDownView.h
//  HKCountDownView
//
//  Created by Mac on 16/7/4.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HKTimeStyleType) {
    HKTimeStyleTypeSplitted, //隔开
    HKTimeStyleTypeCompact,  //紧凑
};

@class HKCountDownView;

@protocol HKCountDownViewDelegate <NSObject>

- (void)countDownViewDidStopComplete:(HKCountDownView *)countDownView;

@end

@interface HKCountDownView : UIView
/** 结束的回调*/
@property (nonatomic, copy) void (^timerStopComplete)();
/** 圆角处理*/
@property (nonatomic, assign) CGFloat timeRadius;
/** 时间背景颜色*/
@property (nonatomic, strong) UIColor *timeBackGroundColor;
/** 时间背景图片*/
@property (nonatomic, strong) UIImage *timeBackGroundImage;
/** 字体 */
@property (nonatomic, strong) UIFont *timeFont;
/** 字体颜色 */
@property (nonatomic, strong) UIColor *timeFontColor;
/** : 的颜色 */
@property (nonatomic, strong) UIColor *dotColor;
/** 样式*/
@property (nonatomic, assign, readonly) IBInspectable HKTimeStyleType timeStyle;
/** 代理*/
@property (nonatomic, weak) id<HKCountDownViewDelegate> delegate;

/**
 *  推荐初始化方法
 *
 *  @param timeStyle 样式
 *
 *  @return HKCountDownView
 */
+ (instancetype)loadCountDownViewWithTimeStyle:(HKTimeStyleType)timeStyle;

/**
 *  根据结束时间字符串开始倒计时
 *
 *  @param endStr 倒计时结束的时间字符串 eq: yyyy-MM-dd HH:mm:ss
 */
- (void)countDownViewWithEndString:(NSString *)endStr;

/**
 *  根据结时间串开始倒计时
 *
 *  @param endDate NSDate对象
 */
- (void)countDownViewWithEndData:(NSDate *)endDate;
@end
