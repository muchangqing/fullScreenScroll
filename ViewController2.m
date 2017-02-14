//
//  ViewController2.m
//  fullScreenScroll
//
//  Created by qcm on 17/2/14.
//  Copyright © 2017年 muchangqing. All rights reserved.
//

#import "ViewController2.h"
#import "CZScrollView.h"
#import "HMSegmentedControl.h"
#import "UIView+Utils.h"

@interface ViewController2 ()

@property (weak, nonatomic) CZScrollView *scrollView;
@property (weak, nonatomic) HMSegmentedControl *segmentedControl;

@end

@implementation ViewController2

- (void)viewDidLoad
{
        [super viewDidLoad];
        self.automaticallyAdjustsScrollViewInsets = NO;
        [self initializeTopView];
        [self initializeScrollView];
}

- (void)didReceiveMemoryWarning
{
        [super didReceiveMemoryWarning];
}

- (void)initializeScrollView
{
        //初始化数据
        NSArray *colors = @[[UIColor redColor],
                            [UIColor blueColor],
                            [UIColor yellowColor],
                            [UIColor cyanColor],
                            [UIColor purpleColor]];
        
        NSMutableArray *views = [NSMutableArray arrayWithCapacity:colors.count];
        
        for (UIColor *color in colors)
        {
                UIViewController *vc = [[UIViewController alloc] init];
                vc.view.backgroundColor = color;
                vc.view.userInteractionEnabled = NO;
                [self addChildViewController:vc];
                [views addObject:vc.view];
        }
        
        CGRect rect = CGRectMake(0, 0, self.view.cz_width, self.view.cz_height);
        CZScrollView *scrollView = [[CZScrollView alloc] initWithFrame:rect];
        [self.view addSubview:scrollView];
        self.scrollView = scrollView;
        
        //属性
        scrollView.scrollViewDirection = CZScrollViewDirectionHorizontal;
        scrollView.pageIndex = 2;
        scrollView.bounces = YES;
        scrollView.pagingEnabled = YES;
        scrollView.scrollEnabled = YES;
        scrollView.showsVerticalScrollIndicator = YES;
        scrollView.showsHorizontalScrollIndicator = YES;
        scrollView.views = views;
        
        //滚动回调
        __weak typeof(scrollView) weakScrollView = scrollView;
        [scrollView setDidScrollCallBack:^(NSInteger index) {
                
                NSLog(@"contentOffset : %@", NSStringFromCGPoint(weakScrollView.contentOffset));
                NSLog(@"contentSize : %@", NSStringFromCGSize(weakScrollView.contentSize));
                NSLog(@"index : %ld", (long)index);
                [self.segmentedControl setSelectedSegmentIndex:index animated:NO];
        }];
}

- (void)initializeTopView
{
        CGFloat segmentHeight = 30.0;
        CGFloat borderWidth   = 1.0;
        CGFloat topViewWidth  = 200;
        HMSegmentedControl *segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"VC1", @"VC2", @"VC3", @"VC4", @"VC5"]];
        segmentedControl.shouldAnimateUserSelection     = NO;
        segmentedControl.frame                          = CGRectMake(0, 0, topViewWidth, segmentHeight);
        segmentedControl.backgroundColor                = [UIColor whiteColor];
        segmentedControl.layer.borderWidth              = borderWidth;
        segmentedControl.layer.borderColor              = [UIColor cyanColor].CGColor;
        segmentedControl.layer.cornerRadius             = segmentedControl.cz_height * 0.5;
        segmentedControl.layer.masksToBounds            = YES;
        segmentedControl.clipsToBounds                  = YES;
        segmentedControl.selectionIndicatorLocation     = HMSegmentedControlSelectionIndicatorLocationNone;
        segmentedControl.selectionIndicatorColor        = [UIColor redColor];
        segmentedControl.selectionIndicatorBoxOpacity   = 1.0;
        segmentedControl.selectionStyle                 = HMSegmentedControlSelectionStyleBox;
        segmentedControl.selectedSegmentIndex           = 0;
        segmentedControl.segmentEdgeInset               = UIEdgeInsetsZero;
        
        __weak typeof(self) weakSelf = self;
        [segmentedControl setIndexChangeBlock:^(NSInteger index) {
                [weakSelf.scrollView scrollPageIndexToVisible:index];
        }];
        
        self.navigationItem.titleView = segmentedControl;
        self.segmentedControl = segmentedControl;
}

@end
