//
//  CZSegmentViewController.h
//  fullScreenScroll
//
//  Created by qcm on 17/2/10.
//  Copyright © 2017年 muchangqing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CZSegmentViewController : UIViewController

/**
 子控制器
 */
@property (strong, nonatomic) NSArray<UIViewController *> *viewControllers;

/**
 当前索引
 */
@property (assign, nonatomic) NSUInteger currentIndex;

/**
 顶部分类
 */
@property (strong, nonatomic) NSArray<NSString *> *titles;


@end
