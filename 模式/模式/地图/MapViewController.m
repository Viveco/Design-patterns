//
//  MapViewController.m
//  设计模式
//
//  Created by viveco on 2018/4/9.
//  Copyright © 2018年 罗罗明祥. All rights reserved.
//

#import "MapViewController.h"
#import "BaiduMapViewController.h"
#import "CustomMapViewController.h"
#import "GaoDeMapViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view setValue:[UIColor whiteColor] forKey:@"backgroundColor"];
}
- (IBAction)baiduMap:(UIButton *)sender {
}
- (IBAction)gaodeMap:(UIButton *)sender {
}
- (IBAction)customMap:(UIButton *)sender {
    CustomMapViewController * vc = [[CustomMapViewController alloc] init];
    vc.title = @"自定义地图";
    [self.navigationController pushViewController:vc animated:YES];
}


@end
