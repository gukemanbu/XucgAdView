//
//  XucgAdView.m
//  XucgAdView
//
//  Created by xucg on 5/18/16.
//  Copyright © 2016 xucg. All rights reserved.
//  Welcome visiting https://github.com/gukemanbu/XucgAdView

#import "XucgAdView.h"

#define kXucgWidth  self.frame.size.width
#define kXucgHeight self.frame.size.height

@interface XucgAdView ()

@property (nonatomic, strong) UIScrollView  *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSTimer       *timer;

@end

@implementation XucgAdView

-(instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _interval = 3.0f;
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kXucgWidth, kXucgHeight)];
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
        [self addSubview:_scrollView];
        
        // 底部小圆点
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, kXucgHeight - 30, kXucgWidth, 30)];
        _pageControl.numberOfPages = 1;
        _pageControl.hidesForSinglePage = YES;
        _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
        _pageControl.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        [self addSubview:_pageControl];
    }
    
    return self;
}

-(void) timerTick:(NSTimer*) timer {
    CGPoint newOffset = _scrollView.contentOffset;
    newOffset.x += kXucgWidth;
    [_scrollView setContentOffset:newOffset animated:YES];
}

-(void) startTimer {
    if (_timer) {
        [_timer invalidate];
    }
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:_interval target:self selector:@selector(timerTick:) userInfo:nil repeats:YES];
}

-(void) setInterval:(CGFloat)interval {
    _interval = interval;
    [self startTimer];
}

/*
 * 调整ScrollView的当前视图
 */
-(void) adjustScrollView {
    CGPoint newOffset = _scrollView.contentOffset;
    NSInteger index = floor(_scrollView.contentOffset.x / _scrollView.frame.size.width);
    
    // 当offset为0时
    if (index == 0) {
        newOffset.x = _pageControl.numberOfPages * kXucgWidth;
        [_scrollView setContentOffset:newOffset];
        _pageControl.currentPage = _pageControl.numberOfPages - 1;
        // 当offset为最后一页时
    } else if (index == _pageControl.numberOfPages + 1) {
        newOffset.x = kXucgWidth;
        [_scrollView setContentOffset:newOffset];
        _pageControl.currentPage = 0;
    } else {
        _pageControl.currentPage = index - 1;
    }
}

/*
 * 拖拽时先停止timer
 */
-(void) scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (_timer) {
        [_timer invalidate];
    }
}

/*
 * 手动滑动完毕时调用
 */
-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // 调整ScrollView的偏移到正确位置
    [self adjustScrollView];
    // 启动timer
    [self startTimer];
}

/*
 * 自动滑动完毕时调用
 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self adjustScrollView];
}

/**
 * 添加图片到ScrollView里
 */
-(void) addImage:(NSString*)imageName index:(NSInteger) i {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kXucgWidth, kXucgHeight)];
    imageView.image = [UIImage imageNamed:imageName];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(kXucgWidth * i, 0, kXucgWidth, kXucgHeight);
    [button addSubview:imageView];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:button];
}

/**
 * 设置图片数组
 */
-(void) setAdArray:(NSArray *)adArray {
    if (adArray.count < 1) {
        return;
    }
    _adArray = adArray;
    
    // 首先清空ScrollView
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    self.scrollView.contentSize = CGSizeMake(kXucgWidth * (adArray.count + 2), kXucgHeight);
    self.pageControl.numberOfPages = adArray.count;
    
    // 图片数组添加到ScrollView里
    [adArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self addImage:obj index:idx+1];
    }];
    
    // 将最后一张图片插入第一页
    [self addImage:adArray[adArray.count - 1] index:0];
    // 将第一张图片追加到最后一页
    [self addImage:adArray[0] index:adArray.count + 1];
    
    // 将ScrollView滑动到第一页
    CGPoint firstPage = self.scrollView.contentOffset;
    firstPage.x = kXucgWidth;
    [self.scrollView setContentOffset:firstPage];
    
    [self startTimer];
}

-(void) buttonAction:(UIButton*)button {
    if (self.delegate) {
        [self.delegate showAdDetail:button.tag];
    }
}

@end
