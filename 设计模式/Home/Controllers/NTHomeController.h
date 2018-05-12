//
//  NTHomeController.h
//  NTWeather
//
//  Created by 肖文 on 2017/9/20.
//  Copyright © 2017年 NinetonTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NTHomeController : UIViewController

@property(nonatomic, strong) UIButton *tableViewHeaderConfirmButton;
@property(nonatomic, copy) dispatch_block_t cellConfirmButtonConfig;


@end
