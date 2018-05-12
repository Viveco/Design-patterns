//
//  NTHomeController.m
//  NTWeather
//
//  Created by 肖文 on 2017/9/20.
//  Copyright © 2017年 NinetonTech. All rights reserved.
//

#import "NTHomeController.h"

#import "NTHomeView.h"

#import "NTHomeViewModel.h"

#import "NTCatergory.h"

@interface NTHomeController ()
@property (nonatomic, strong) NTHomeView *view;
@property (nonatomic, strong) NTHomeViewModel *viewModel;
@end

@implementation NTHomeController
@dynamic view;

#pragma mark - Life Cycle Methods
- (void)loadView{
    self.view = [NTHomeView nt_viewWithViewModel:self.viewModel];
    self.view.frame = NT_SCREEN_BOUNDS;
    
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self _nt_addObservers];
    [self _nt_handleViewEvents];
    [self _nt_handleOtherEvents];
}

#pragma mark - Lazyloading Methods
- (NTHomeViewModel *)viewModel{
    if (_viewModel) return _viewModel;
    _viewModel = [NTHomeViewModel new];
    return _viewModel;
}

#pragma mark - Privite Methods
- (void)_nt_addObservers{
    
}

- (void)_nt_handleViewEvents{
    self.view.centerButtonConfig = ^{
        NT_LOG(@"welcome to NineTon!");
    };
}


- (void)_nt_handleOtherEvents{
    
}

#pragma mark - Public Methods

@end
