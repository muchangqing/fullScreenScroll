//
//  CZScrollView.h
//  fullScreenScroll
//
//  Created by qcm on 17/2/9.
//  Copyright © 2017年 muchangqing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CZScrollView;
typedef void(^DidScrollBlock)(NSInteger index);

typedef NS_ENUM(NSInteger, CZScrollViewDirection)
{
        CZScrollViewDirectionHorizontal,
        CZScrollViewDirectionVertical
};

@interface CZScrollView : UIView

@property (strong, nonatomic) NSArray<UIView *> *views;

/**
 default pageCount = 2
 */
@property (assign, nonatomic) NSInteger pageCount;

/**
 default pageIndex = 0
 */
@property (assign, nonatomic) NSInteger pageIndex;

/**
 defaule scrollViewDirection = CZScrollViewDirectionHorizontal
 */
@property (assign, nonatomic) CZScrollViewDirection scrollViewDirection;

@property (assign, nonatomic, readonly) CGPoint contentOffset;

@property (assign, nonatomic, readonly) CGSize contentSize;

@property(assign, nonatomic) BOOL bounces;

@property(nonatomic,getter=isPagingEnabled) BOOL pagingEnabled;

@property(nonatomic,getter=isScrollEnabled) BOOL scrollEnabled;

@property(assign, nonatomic)BOOL showsHorizontalScrollIndicator;

@property(assign, nonatomic)BOOL showsVerticalScrollIndicator;

- (void)setDidScrollCallBack:(DidScrollBlock)block;

- (void)scrollPageIndexToVisible:(NSInteger)index; //animated: YES
- (void)scrollPageIndexToVisible:(NSInteger)index animated:(BOOL)animated;

@end
