//
//  XucgAdView.h
//  XucgAdView
//
//  Created by xucg on 5/18/16.
//  Copyright © 2016 xucg. All rights reserved.
//  Welcome visiting https://github.com/gukemanbu/XucgAdView

#import <UIKit/UIKit.h>

@protocol XucgAdViewDelegate <NSObject>

@optional
-(void) showAdDetail:(NSUInteger)adId;

@end

@interface XucgAdView : UIView <UIScrollViewDelegate>

@property (nonatomic, assign) CGFloat                 interval;      // 播放时间间隔
@property (nonatomic, strong) NSArray                 *adArray;      // 广告数组
@property (nonatomic, assign) id<XucgAdViewDelegate> delegate;

-(void) startTimer;

@end
