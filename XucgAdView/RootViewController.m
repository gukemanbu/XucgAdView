//
//  RootViewController.m
//  XucgAdView
//
//  Created by xucg on 5/18/16.
//  Copyright © 2016 xucg. All rights reserved.
//

#import "RootViewController.h"
#import "XucgAdView.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    XucgAdView *adView = [[XucgAdView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 240.f)];
    adView.adArray = @[@"image1", @"image2", @"image3", @"image4", @"image5"];
    [self.view addSubview:adView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
