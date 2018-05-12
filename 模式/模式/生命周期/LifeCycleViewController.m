//
//  LifeCycleViewController.m
//  设计模式
//
//  Created by viveco on 2018/3/14.
//  Copyright © 2018年 罗罗明祥. All rights reserved.
//

#import "LifeCycleViewController.h"

@interface LifeCycleViewController ()<UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) LifeView *imgv;
@property (copy, nonatomic, getter=IDString) NSString *idString;

@end

@implementation LifeCycleViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    NSLog(@"%s", __FUNCTION__);
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
    }
    return self;
}

// 如果连接了串联图storyBoard 走这个方法
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    NSLog(@"%s", __FUNCTION__);
    if (self = [super initWithCoder:aDecoder]) {
        
    }
    return self;
}

// xib 加载 完成
- (void)awakeFromNib {
    [super awakeFromNib];
    NSLog(@"%s", __FUNCTION__);
}

// 加载视图(默认从nib)
- (void)loadView {
    NSLog(@"%s", __FUNCTION__);
    
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

//视图控制器中的视图加载完成，viewController自带的view加载完成
- (void)viewDidLoad {
    NSLog(@"%s", __FUNCTION__);
    [super viewDidLoad];
    
    self.idString = @"yes";
    NSLog(@"%@",self.IDString);
    
    
    UIScrollView * scrollView = [[UIScrollView alloc] init];
    scrollView.contentSize = CGSizeMake(500, 0);
    scrollView.backgroundColor = [UIColor yellowColor];
    scrollView.multipleTouchEnabled = YES;
    scrollView.maximumZoomScale = 2;
    scrollView.minimumZoomScale =0.5;
    scrollView.zoomScale = 3.0;
    scrollView.delegate = self;
    self.scrollView = scrollView;
    
    LifeView *imgv = [[LifeView alloc]initWithFrame:CGRectMake(20, 10, 50, 80)];
    imgv.backgroundColor = [UIColor grayColor];
    [self.scrollView addSubview:imgv];
    self.imgv = imgv;
}

//视图将要出现
- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"%s", __FUNCTION__);
    [super viewWillAppear:animated];
    [self.view addSubview:self.scrollView];
}

// view 即将布局其 Subviews
- (void)viewWillLayoutSubviews {
    NSLog(@"%s", __FUNCTION__);
    [super viewWillLayoutSubviews];
    self.scrollView.frame = CGRectMake(0, 90, 375, 100);
}

// view 已经布局其 Subviews
- (void)viewDidLayoutSubviews {
    NSLog(@"%s", __FUNCTION__);
    [super viewDidLayoutSubviews];
}

//视图已经出现
- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"%s", __FUNCTION__);
    [super viewDidAppear:animated];
}

//视图将要消失
- (void)viewWillDisappear:(BOOL)animated {
    NSLog(@"%s", __FUNCTION__);
    [super viewWillDisappear:animated];
}

//视图已经消失
- (void)viewDidDisappear:(BOOL)animated {
    NSLog(@"%s", __FUNCTION__);
    [super viewDidDisappear:animated];
}

//出现内存警告  //模拟内存警告:点击模拟器->hardware-> Simulate Memory Warning
- (void)didReceiveMemoryWarning {
    NSLog(@"%s", __FUNCTION__);
    [super didReceiveMemoryWarning];
}

// 视图被销毁
- (void)dealloc {
    NSLog(@"%s", __FUNCTION__);
}


- (void)back{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -- ScrollView 的delegate

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view{
    
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imgv;
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    self.imgv.center = self.scrollView.center;
}

@end




@interface LifeView ()
{
    NSInteger count;
}

@end

@implementation LifeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        NSLog(@"<-- 1 %s , count = %@-->", __func__, @(count++));
    }
    return self;
}


- (void)willMoveToSuperview:(nullable UIView *)newSuperview
{
    NSLog(@"<-- 2 %s , count = %@-->", __func__, @(count++));
}

- (void)didMoveToSuperview
{
    NSLog(@"<-- 3 %s , count = %@-->", __func__, @(count++));
}

- (void)willMoveToWindow:(nullable UIWindow *)newWindow
{
    NSLog(@"<-- 4/7 %s , count = %@-->", __func__, @(count++));
}

- (void)didMoveToWindow
{
    NSLog(@"<-- 5/8 %s , count = %@-->", __func__, @(count++));
}

- (void)layoutSubviews
{
    NSLog(@"<-- 6 %s , count = %@-->", __func__, @(count++));
}

- (void)removeFromSuperview
{
    NSLog(@"<-- 9 %s , count = %@-->", __func__, @(count++));
}

- (void)dealloc
{
    NSLog(@"<-- 10 %s , count = %@-->", __func__, @(count++));
}

@end
