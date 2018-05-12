//
//  UIView+NTAddForMasonry.h
//  TryLrc
//
//  Created by wazrx on 16/7/11.
//  Copyright © 2016年 wazrx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import "NTCGUtilities.h"

static inline id NTMaonryRatioBoxValue(const char *type, ...) {
    va_list v;
    va_start(v, type);
    id obj = nil;
    if (strcmp(type, @encode(id)) == 0) {
        id actual = va_arg(v, id);
        obj = actual;
    } else if (strcmp(type, @encode(CGPoint)) == 0) {
        CGPoint actual = (CGPoint)va_arg(v, CGPoint);
        actual = CGPointMake(NTWidthRatio(actual.x), NTWidthRatio(actual.y));
        obj = [NSValue value:&actual withObjCType:type];
    } else if (strcmp(type, @encode(CGSize)) == 0) {
        CGSize actual = (CGSize)va_arg(v, CGSize);
        actual = CGSizeMake(NTWidthRatio(actual.width), NTWidthRatio(actual.height));
        obj = [NSValue value:&actual withObjCType:type];
    } else if (strcmp(type, @encode(MASEdgeInsets)) == 0) {
        MASEdgeInsets actual = (MASEdgeInsets)va_arg(v, MASEdgeInsets);
        actual = UIEdgeInsetsMake(NTWidthRatio(actual.top), NTWidthRatio(actual.left), NTWidthRatio(actual.bottom), actual.right);
        obj = [NSValue value:&actual withObjCType:type];
    } else if (strcmp(type, @encode(double)) == 0) {
        double actual = (double)va_arg(v, double);
        obj = [NSNumber numberWithDouble:NTWidthRatio(actual)];
    } else if (strcmp(type, @encode(float)) == 0) {
        float actual = (float)va_arg(v, double);
        obj = [NSNumber numberWithFloat:NTWidthRatio(actual)];
    } else if (strcmp(type, @encode(int)) == 0) {
        CGFloat actual = NTWidthRatio((int)va_arg(v, int));
        obj = CGFLOAT_IS_DOUBLE ? [NSNumber numberWithDouble:actual] : [NSNumber numberWithFloat:actual];
    } else if (strcmp(type, @encode(long)) == 0) {
        CGFloat actual = (long)va_arg(v, long) * NT_WIDTH_RATIO;
        obj = CGFLOAT_IS_DOUBLE ? [NSNumber numberWithDouble:actual] : [NSNumber numberWithFloat:actual];
    } else if (strcmp(type, @encode(long long)) == 0) {
        CGFloat actual = (long long)va_arg(v, long long) * NT_WIDTH_RATIO;
        obj = CGFLOAT_IS_DOUBLE ? [NSNumber numberWithDouble:actual] : [NSNumber numberWithFloat:actual];
    } else if (strcmp(type, @encode(short)) == 0) {
        CGFloat actual = (short)va_arg(v, int) * NT_WIDTH_RATIO;
        obj = CGFLOAT_IS_DOUBLE ? [NSNumber numberWithDouble:actual] : [NSNumber numberWithFloat:actual];
    } else if (strcmp(type, @encode(char)) == 0) {
        char actual = (char)va_arg(v, int);
        obj = [NSNumber numberWithChar:actual];
    } else if (strcmp(type, @encode(bool)) == 0) {
        bool actual = (bool)va_arg(v, int);
        obj = [NSNumber numberWithBool:actual];
    } else if (strcmp(type, @encode(unsigned char)) == 0) {
        unsigned char actual = (unsigned char)va_arg(v, unsigned int);
        obj = [NSNumber numberWithUnsignedChar:actual];
    } else if (strcmp(type, @encode(unsigned int)) == 0) {
        CGFloat actual = (unsigned int)va_arg(v, unsigned int) * NT_WIDTH_RATIO;
        obj = CGFLOAT_IS_DOUBLE ? [NSNumber numberWithDouble:actual] : [NSNumber numberWithFloat:actual];
    } else if (strcmp(type, @encode(unsigned long)) == 0) {
        CGFloat actual = (unsigned long)va_arg(v, unsigned long) * NT_WIDTH_RATIO;
        obj = CGFLOAT_IS_DOUBLE ? [NSNumber numberWithDouble:actual] : [NSNumber numberWithFloat:actual];
    } else if (strcmp(type, @encode(unsigned long long)) == 0) {
        CGFloat actual = (unsigned long long)va_arg(v, unsigned long long) * NT_WIDTH_RATIO;
        obj = CGFLOAT_IS_DOUBLE ? [NSNumber numberWithDouble:actual] : [NSNumber numberWithFloat:actual];
    } else if (strcmp(type, @encode(unsigned short)) == 0) {
        CGFloat actual = (unsigned short)va_arg(v, unsigned int) * NT_WIDTH_RATIO;
        obj = CGFLOAT_IS_DOUBLE ? [NSNumber numberWithDouble:actual] : [NSNumber numberWithFloat:actual];
    }
    va_end(v);
    return obj;
}


@interface UIView (NTAddForMasonry)

- (NSArray *)nt_makeConstraints:(void(^)(MASConstraintMaker *make))block;

- (NSArray *)nt_updateConstraints:(void (^)(MASConstraintMaker *make))block;

- (NSArray *)nt_remakeConstraints:(void (^)(MASConstraintMaker *make))block;

- (NSArray *)nt_makeEdgeInsetsZeroConstraints;

- (NSArray *)nt_makeCenterEqualConstraintsToView:(UIView *)toView;

@end

@interface MASConstraint (NTAddForMasonry)

- (MASConstraint *(^)(CGFloat))nt_offset;

- (MASConstraint * (^)(id))nt_equalTo;

#define nt_left(_f_)  make.left.nt_offset(_f_)
#define nt_right(_f_)  make.right.nt_offset(_f_)
#define nt_top(_f_)  make.top.nt_offset(_f_)
#define nt_bottom(_f_)  make.bottom.nt_offset(_f_)
#define nt_edge(_f_)  make.edge.nt_equalTo(_f_)
#define nt_center(_f_)  make.center.nt_equalTo(_f_)
#define nt_size(_f_)  make.size.nt_equalTo(_f_)
#define nt_height(_f_)  make.height.nt_equalTo(_f_)
#define nt_width(_f_)  make.width.nt_equalTo(_f_)

#define nt_equalTo(...)                 equalTo(NTRatioBoxValue((__VA_ARGS__)))

#define NTRatioBoxValue(value) NTMaonryRatioBoxValue(@encode(__typeof__((value))), (value))

@end
