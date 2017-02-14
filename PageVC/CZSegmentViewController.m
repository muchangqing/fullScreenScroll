//
//  CZSegmentViewController.m
//  fullScreenScroll
//
//  Created by qcm on 17/2/10.
//  Copyright © 2017年 muchangqing. All rights reserved.
//

#import "CZSegmentViewController.h"
#import "HMSegmentedControl.h"

#define KTOP_HEIGHT 50.0

@interface CZSegmentViewController ()<UIPageViewControllerDelegate, UIPageViewControllerDataSource, UIScrollViewDelegate>

/** pageView */
@property (strong, nonatomic) UIPageViewController *pageViewController;
/** 顶部分类 */
@property (strong, nonatomic) UIScrollView * scrollView;
/** 页面指示器 */
@property (strong, nonatomic) HMSegmentedControl *segmentControl;
/** 顶部分类背景 */
@property (strong, nonatomic) UIView *topSortBackgroundView;
@end

@implementation CZSegmentViewController
{
        //是否用户点击
        BOOL _isDragging;
}

#pragma mark - life cycle
- (void)loadView
{
        [super loadView];
        
        [self addChildViewController:self.pageViewController];
        [self.pageViewController didMoveToParentViewController:self];
        [self.view addSubview:self.pageViewController.view];
        [self.view addSubview:self.segmentControl];
        
        UIView *pageView = self.pageViewController.view;
        UIView *topBack = self.segmentControl;
        
        NSDictionary *views = NSDictionaryOfVariableBindings(topBack,pageView);
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[pageView]-0-|" options:0 metrics:nil views:views]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[topBack]-0-|" options:0 metrics:nil views:views]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-64-[topBack(==50)]-0-[pageView]-0-|" options:0 metrics:nil views:views]];
}

- (void)viewDidLoad
{
        [super viewDidLoad];
        self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)didReceiveMemoryWarning
{
        [super didReceiveMemoryWarning];
}

#pragma mark - Setter
- (void)setTitles:(NSArray<NSString *> *)titles
{
        _titles = titles;
        self.segmentControl.sectionTitles = titles;
}

- (void)setCurrentIndex:(NSUInteger)currentIndex
{
        NSUInteger pageIndex = [self.viewControllers indexOfObject:[self displayedController]];
        if (pageIndex != currentIndex)
        {
                UIViewController *viewController = [self viewControllerAtIndex:currentIndex];
                UIPageViewControllerNavigationDirection direction = currentIndex > _currentIndex ? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse;
                [self.pageViewController setViewControllers:@[viewController] direction:direction animated:YES completion:nil];
        }
        _currentIndex = currentIndex;
}

#pragma mark - Getter
/** 视图控制器显示的控制器 */
- (UIViewController *)displayedController
{
        return self.pageViewController.viewControllers.firstObject;
}

/** 根据索引，得到相应的VC */
- (UIViewController *)viewControllerAtIndex:(NSUInteger)index
{
        if (self.viewControllers == nil || self.viewControllers.count == 0)
        {
                return nil;
        }
        else if (index >= self.viewControllers.count)
        {
                return nil;
        }
        return [self.viewControllers objectAtIndex:index];
}

#pragma mark - UIPageViewControllerDelegate
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed
{
        if (completed)
        {
                NSUInteger index = [_viewControllers indexOfObject:[self displayedController]];
                [self setCurrentIndex:index];
        }
}

#pragma mark - UIPageViewControllerDataSource
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
        //当前显示索引
        NSUInteger index = [self.viewControllers indexOfObject:viewController];
        if (index == 0 || index == NSNotFound)
        {
                return nil;
        }
        -- index;
        return [self viewControllerAtIndex:index];
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
        NSUInteger index = [self.viewControllers indexOfObject:viewController];
        if (index == NSNotFound)
        {
                return nil;
        }
        
        if (++index >= self.viewControllers.count)
        {
                return nil;
        }
        return [self viewControllerAtIndex:index];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
        if (scrollView == nil || !_isDragging)
        {
                return;
        }
        
        /** 单位宽度 */
        CGFloat width = scrollView.frame.size.width;
        /**
         * 横向偏移
         * 向左滑动 正
         * 向右滑动 负
         */
        CGFloat offSetX = scrollView.contentOffset.x - width;
        NSUInteger index = (NSUInteger)((offSetX / width + self.currentIndex)+ 0.5);
        [self.segmentControl setSelectedSegmentIndex:index animated:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
        _isDragging = YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
        _isDragging = NO;
}

#pragma mark - lazyMethod
- (UIPageViewController *)pageViewController
{
        if (!_pageViewController)
        {
                _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:@{UIPageViewControllerOptionInterPageSpacingKey : @0}];
                _pageViewController.delegate = self;
                _pageViewController.dataSource = self;
                [self scrollView];
        }
        return _pageViewController;
}

- (UIScrollView *)scrollView
{
        if (!_scrollView)
        {
                [self.pageViewController.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                   
                        if ([obj isKindOfClass:[UIScrollView class]])
                        {
                                _scrollView = (UIScrollView *)obj;
                                _scrollView.delegate = self;
                                *stop = YES;
                        }
                }];
        }
        return _scrollView;
}

- (HMSegmentedControl *)segmentControl
{
        if (!_segmentControl)
        {
                _segmentControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, KTOP_HEIGHT)];
                _segmentControl.translatesAutoresizingMaskIntoConstraints = NO;
                _segmentControl.shouldAnimateUserSelection = YES;
                _segmentControl.selectionIndicatorEdgeInsets    = UIEdgeInsetsMake(0, 0, -4, 0);
                _segmentControl.selectionStyle                  = HMSegmentedControlSelectionStyleTextWidthStripe;
                _segmentControl.type                            = HMSegmentedControlTypeText;
                _segmentControl.selectionIndicatorLocation      = HMSegmentedControlSelectionIndicatorLocationDown;
                _segmentControl.segmentWidthStyle               = HMSegmentedControlSegmentWidthStyleFixed;
                _segmentControl.selectionIndicatorHeight        = 3.0;
                _segmentControl.backgroundColor                 = [UIColor whiteColor];
                _segmentControl.selectedSegmentIndex            = 0;
                __weak typeof(self) weakSelf = self;
                [_segmentControl setIndexChangeBlock:^(NSInteger index) {
                        __strong typeof(self) strongSelf = weakSelf;
                        [strongSelf setCurrentIndex:index];
                }];
        }
        return _segmentControl;
}

- (UIView *)topSortBackgroundView
{
        if (!_topSortBackgroundView)
        {
                _topSortBackgroundView = [[UIView alloc] init];
                _topSortBackgroundView.translatesAutoresizingMaskIntoConstraints = NO;
                _topSortBackgroundView.backgroundColor = [UIColor whiteColor];
        }
        return _topSortBackgroundView;
}

@end
