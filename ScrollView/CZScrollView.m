//
//  CZScrollView.m
//  fullScreenScroll
//
//  Created by qcm on 17/2/9.
//  Copyright © 2017年 muchangqing. All rights reserved.
//

#import "CZScrollView.h"
#import "UIView+Utils.h"

/* Sizes. */

struct CZIndex{
        NSInteger horIndex;
        NSInteger verIndex;
};
typedef struct CZIndex CZIndex;

CG_INLINE CZIndex CZIndexMake(NSInteger idx1, NSInteger idx2)
{
        CZIndex idx;
        idx.horIndex = idx1;
        idx.verIndex = idx2;
        return idx;
}


@interface CZScrollView ()<UIScrollViewDelegate>

@property (weak, nonatomic) UIScrollView *scrollView;
@property (copy, nonatomic) DidScrollBlock didScrollBlock;

/**
 是否用户滚动
 */
@property (assign, nonatomic) BOOL userScroll;

@end


@implementation CZScrollView

- (instancetype)init
{
        self = [super init];
        if (self)
        {
                [self initializeDefault];
        }
        return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
        if (self = [super initWithFrame:frame])
        {
                [self initializeDefault];
        }
        return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
        if (self = [super initWithCoder:aDecoder])
        {
                [self initializeDefault];
        }
        return self;
}

- (void)initializeDefault
{
        self.pageCount = 2;
        self.pageIndex = 0;
        self.scrollViewDirection = CZScrollViewDirectionHorizontal;
        self.bounces = NO;
        self.pagingEnabled = YES;
        self.scrollEnabled = YES;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        //scrollView
        [self initializeScrollView];
}

- (void)initializeScrollView
{
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        scrollView.delegate = self;
        scrollView.bounces = self.bounces;
        scrollView.pagingEnabled = self.pagingEnabled;
        scrollView.scrollEnabled = self.scrollEnabled;
        scrollView.showsHorizontalScrollIndicator = self.showsHorizontalScrollIndicator;
        scrollView.showsVerticalScrollIndicator = self.showsVerticalScrollIndicator;
        [self addSubview:scrollView];
        self.scrollView = scrollView;
}

- (void)setContentSize
{
        CZIndex cur = [self getSize:self.pageCount];
        self.scrollView.contentSize = CGSizeMake(self.cz_width * cur.horIndex, self.cz_height * cur.verIndex);
}

- (void)layoutSubviews
{
        [super layoutSubviews];
        
        //frame
        self.scrollView.frame = self.bounds;
        
        //contentSize
        [self setContentSize];
        
        //scrollRectToVisible
        [self scrollRectToVisible:NO];
}

#pragma mark - common
- (CZIndex)getSize:(NSInteger)count
{
        return self.scrollViewDirection == CZScrollViewDirectionVertical ? CZIndexMake(1, count) : CZIndexMake(count, 1);
}

- (CZIndex)getIndex:(NSInteger)count
{
        return self.scrollViewDirection == CZScrollViewDirectionVertical ? CZIndexMake(0, count) : CZIndexMake(count, 0);
}

- (CGFloat)contentLength
{
        return self.scrollViewDirection == CZScrollViewDirectionHorizontal ? self.scrollView.contentOffset.x : self.scrollView.contentOffset.y;
}

- (CGFloat)unitLength
{
        return self.scrollViewDirection == CZScrollViewDirectionHorizontal ? self.cz_width : self.cz_height;
}

- (NSInteger)getValidValue:(NSInteger)index
{
        return index >= self.pageCount ? self.pageCount - 1 : (index < 0 ? 0 : index);
}

- (void)scrollRectToVisible:(BOOL)animated
{
        self.userScroll = NO;
        self.pageIndex = [self getValidValue:self.pageIndex];
        CZIndex cur = [self getIndex:self.pageIndex];
        CGRect visibleRect = CGRectMake(self.cz_width * cur.horIndex, self.cz_height * cur.verIndex, self.cz_width, self.cz_height);
        [self.scrollView scrollRectToVisible:visibleRect animated:animated];
}

#pragma mark - setter

- (void)setViews:(NSArray<UIView *> *)views
{
        if (views.count == 0 || views == nil)
        {
                return;
        }
        self.pageCount = views.count;
        
        //变量在外面声明，不能在for循环内声明，消耗内存
        CGFloat x = 0;
        CGFloat y = 0;
        CGFloat w = self.cz_width;
        CGFloat h = self.cz_height;
        CGFloat unitLength = [self unitLength];
        
        for (int i=0; i<self.pageCount; i++)
        {
                if (self.scrollViewDirection == CZScrollViewDirectionHorizontal)
                {
                        x = unitLength * i;
                        y = 0;
                }
                else
                {
                        x = 0;
                        y = unitLength * i;
                }
                UIView *view = [views objectAtIndex:i];
                view.frame = CGRectMake(x, y, w, h);
                [self.scrollView addSubview:view];
        }
}

- (void)setPageCount:(NSInteger)pageCount
{
        _pageCount = pageCount;
        [self setNeedsLayout];
}

- (void)scrollPageIndexToVisible:(NSInteger)index
{
        [self scrollPageIndexToVisible:index animated:YES];
}

- (void)scrollPageIndexToVisible:(NSInteger)index animated:(BOOL)animated
{
        self.pageIndex = index;
        [self scrollRectToVisible:animated];
}

- (void)setScrollViewDirection:(CZScrollViewDirection)scrollViewDirection
{
        _scrollViewDirection = scrollViewDirection;
        [self setNeedsLayout];
}

- (void)setBounces:(BOOL)bounces
{
        _bounces = bounces;
        self.scrollView.bounces = bounces;
}

- (void)setPagingEnabled:(BOOL)pagingEnabled
{
        _pagingEnabled = pagingEnabled;
        self.scrollView.pagingEnabled = pagingEnabled;
}

- (void)setScrollEnabled:(BOOL)scrollEnabled
{
        _scrollEnabled = scrollEnabled;
        self.scrollView.scrollEnabled = scrollEnabled;
}

- (void)setShowsVerticalScrollIndicator:(BOOL)showsVerticalScrollIndicator
{
        _showsVerticalScrollIndicator = showsVerticalScrollIndicator;
        self.scrollView.showsVerticalScrollIndicator = showsVerticalScrollIndicator;
}

- (void)setShowsHorizontalScrollIndicator:(BOOL)showsHorizontalScrollIndicator
{
        _showsHorizontalScrollIndicator = showsHorizontalScrollIndicator;
        self.scrollView.showsHorizontalScrollIndicator = showsHorizontalScrollIndicator;
}

- (void)setDidScrollCallBack:(DidScrollBlock)block
{
        self.didScrollBlock = block;
}

#pragma mark - getter
- (CGPoint)contentOffset
{
        return self.scrollView.contentOffset;
}

- (CGSize)contentSize
{
        return self.scrollView.contentSize;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
        if (self.didScrollBlock && self.userScroll)
        {
                NSInteger index = (NSInteger)([self contentLength] / [self unitLength] + 0.5);
                self.pageIndex = index;
                self.didScrollBlock(index);
        }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
        self.userScroll = YES;
}
@end
