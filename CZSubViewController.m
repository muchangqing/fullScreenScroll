//
//  CZSubViewController.m
//  fullScreenScroll
//
//  Created by qcm on 17/2/13.
//  Copyright © 2017年 muchangqing. All rights reserved.
//

#import "CZSubViewController.h"

@interface CZSubViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation CZSubViewController

+ (instancetype)subViewController
{
        return [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
}

- (void)viewDidLoad {
        [super viewDidLoad];
        self.label.text = self.vcTitle;
}

- (void)didReceiveMemoryWarning {
        [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
