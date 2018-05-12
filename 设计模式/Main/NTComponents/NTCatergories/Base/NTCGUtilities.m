//
//  NTCGUtilities.m
//  CatergoryDemo
//
//  Created by wazrx on 16/5/16.
//  Copyright © 2016年 wazrx. All rights reserved.
//

#import "NTCGUtilities.h"

CGFloat NTScreenScale() {
    static CGFloat scale;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        scale = [UIScreen mainScreen].scale;
    });
    return scale;
}


CGFloat NTScreenWidthRatio(){
    static CGFloat ratio;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ratio = [UIScreen mainScreen].bounds.size.width / 375.0f;
    });
    return ratio;
}

CGFloat NTScreenHeightRatio(){
    static CGFloat ratio;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ratio = [UIScreen mainScreen].bounds.size.height / 667.0f;
    });
    return ratio;
}

CGSize NTScreenSize() {
    static CGSize size;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        size = [UIScreen mainScreen].bounds.size;
        if (size.height < size.width) {
            CGFloat tmp = size.height;
            size.height = size.width;
            size.width = tmp;
        }
    });
    return size;
}

CGRect NTScreenBounds(){
    static CGRect bounds;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bounds = [UIScreen mainScreen].bounds;
    });
    return bounds;
}

CGPoint NTScreenCenter(){
    static CGPoint center;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        center = NTCenterOfFrame(NTScreenBounds());
    });
    return center;
}


