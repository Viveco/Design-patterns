//
//  UIView+NTAddForMasonry.m
//  TryLrc
//
//  Created by wazrx on 16/7/11.
//  Copyright © 2016年 wazrx. All rights reserved.
//

#import "UIView+NTAddForMasonry.h"
#import "NTCGUtilities.h"

@implementation UIView (NTAddForMasonry)

- (NSArray *)nt_makeConstraints:(void(^)(MASConstraintMaker *make))block {
    return [self mas_makeConstraints:block];
}

- (NSArray *)nt_updateConstraints:(void (^)(MASConstraintMaker *make))block{
    return [self mas_updateConstraints:block];
}

- (NSArray *)nt_remakeConstraints:(void (^)(MASConstraintMaker *make))block{
    return [self mas_remakeConstraints:block];
}

- (NSArray *)nt_makeEdgeInsetsZeroConstraints {
    return [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.removeExisting = YES;
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

- (NSArray *)nt_makeCenterEqualConstraintsToView:(UIView *)toView {
	return [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(toView);
    }];
}
@end

@implementation MASConstraint (NTAddForMasonry)

- (MASConstraint *(^)(CGFloat))nt_offset{
    return ^id(CGFloat offset){
        self.offset = NTWidthRatio(offset);
        return self;
    };
}

- (MASConstraint * (^)(id))nt_equalTo {
    return [self mas_equalTo];
}


@end
