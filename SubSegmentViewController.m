//
//  CZViewController1.m
//  fullScreenScroll
//
//  Created by qcm on 17/2/13.
//  Copyright © 2017年 muchangqing. All rights reserved.
//

#import "SubSegmentViewController.h"
#import "CZSubViewController.h"

@interface SubSegmentViewController ()

@end

@implementation SubSegmentViewController

- (void)viewDidLoad
{
        [super viewDidLoad];
        NSArray *titles = @[@"VC1", @"VC2", @"VC3" ,@"VC4" ,@"VC5", @"VC6"];
        NSMutableArray *viewControllers = [NSMutableArray arrayWithCapacity:titles.count];
        for (NSString *title in titles)
        {
                CZSubViewController *vc = [CZSubViewController subViewController];
                vc.vcTitle = title;
                [viewControllers addObject:vc];
        }
        self.viewControllers  = viewControllers;
        self.currentIndex = 0;
        self.titles = titles;
}

- (void)didReceiveMemoryWarning
{
        [super didReceiveMemoryWarning];
}

@end
