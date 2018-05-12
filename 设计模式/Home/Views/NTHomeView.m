//
//  NTHomeView.m
//  NTWeather
//
//  Created by 肖文 on 2017/9/20.
//  Copyright © 2017年 NinetonTech. All rights reserved.
//

#import "NTHomeView.h"

#import "NTHomeViewModel.h"

#import "NTHomeTestModel.h"

#import "NTCatergory.h"
#import "UIView+NTAddForMasonry.h"

@interface NTHomeView ()
@property (nonatomic, readonly) NTHomeViewModel *viewModel;
@property(nonatomic, strong) UIButton *testButton;
@end

@implementation NTHomeView
@dynamic viewModel;

#pragma mark - InitailizeUI Methods
- (void)nt_initailizeUI{
    self.backgroundColor = NT_WATERMELON_COLOR;
    _testButton = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"NineTon" forState:UIControlStateNormal];
        btn.titleLabel.font = NTFontMedium(15);
        btn.backgroundColor = NT_SKY_BLUE_COLOR;
        btn;
    });
    [self addSubview:_testButton];
    [_testButton nt_makeCenterEqualConstraintsToView:self];
}

#pragma mark - Add User Events
- (void)nt_addUserEvents{
    NT_WEAKIFY(self);
    [_testButton nt_addConfig:^(__kindof UIControl * _Nonnull control) {
        NT_STRONGIFY(self);
        NT_BLOCK(self.centerButtonConfig)
    } forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - UpdateUI Methods

#pragma mark - Private Methods

#pragma mark - Public Methods
@end


