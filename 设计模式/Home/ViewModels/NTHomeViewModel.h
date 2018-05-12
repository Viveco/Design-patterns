//
//  NTHomeViewModel.h
//  NTWeather
//
//  Created by 肖文 on 2017/9/20.
//  Copyright © 2017年 NinetonTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NTHomeTestModel;
@interface NTHomeViewModel : NSObject
@property(nonatomic, readonly)NSArray<NTHomeTestModel *> *listData;

@end
