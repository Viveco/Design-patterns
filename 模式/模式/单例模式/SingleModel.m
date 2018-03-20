//
//  SingleModel.m
//  设计模式
//
//  Created by viveco on 2018/3/16.
//  Copyright © 2018年 罗罗明祥. All rights reserved.
//

#import "SingleModel.h"

static SingleModel * model;

@implementation SingleModel

+ (SingleModel * )shareSingleModel{

    static dispatch_once_t oncetoken;
    dispatch_once(&oncetoken, ^{
        model = [[SingleModel alloc] init];
    });
    return model;
}

// 适用于alloc ，不论调用多少次alloc 都不重新分配内存
+(instancetype)allocWithZone:(struct _NSZone *)zone{
    if(!model){
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            model = [super allocWithZone:zone];
        });
    }
    return model;
}
// 防止copy
+(id)copyWithZone:(struct _NSZone *)zone{
    if (!model) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
           model = [super copyWithZone:zone];
        });
    }return model;
}

+(id)mutableCopyWithZone:(struct _NSZone * )zone{
    if (!model) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            model = [super mutableCopyWithZone:zone];
        });
    }return model;
}
@end
