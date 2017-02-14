//
//  ViewController.m
//  fullScreenScroll
//
//  Created by qcm on 17/2/9.
//  Copyright © 2017年 ChengziVR. All rights reserved.
//

#import "ViewController.h"
#import "CZScrollView.h"
#import "UIView+Utils.h"
#import "HMSegmentedControl.h"
#import "SubSegmentViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
        [super viewDidLoad];
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.view.backgroundColor = [UIColor whiteColor];
        [self initializeTestView];
}

- (void)initializeTestView
{
        
        UIViewController *testVC = [[SubSegmentViewController alloc] init];
        [self addChildViewController:testVC];
        
        [self.view addSubview:testVC.view];
        testVC.view.frame = self.view.bounds;
}

- (void)didReceiveMemoryWarning
{
        [super didReceiveMemoryWarning];
}


@end
