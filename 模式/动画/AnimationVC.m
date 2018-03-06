//
//  AnimationVC.m
//  设计模式
//
//  Created by viveco on 2018/2/28.
//  Copyright © 2018年 罗罗明祥. All rights reserved.
//

#import "AnimationVC.h"


@interface AnimationVC ()<UIScrollViewDelegate>

@property (strong, nonatomic) UIImageView *animationImageView;
@property (strong, nonatomic) UIButton *button;
@property (copy, nonatomic, getter=IDString) NSString *idString;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) NSTimer *timer;

@property (strong, nonatomic) UITableView *tablieView;


@end

@implementation AnimationVC



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
    
    self.button = [UIButton buttonWithType:UIButtonTypeContactAdd];
    self.button.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0 );
    self.button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);

    self.animationImageView.animationImages = @[];
    self.animationImageView.animationDuration = 10;
    self.animationImageView.animationRepeatCount = 2;
    [self.animationImageView startAnimating];
    [self.animationImageView isAnimating];
    
    

    NSLog(@"%@",self.idString);
    
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(begingScro) userInfo:@"001" repeats:YES];
    
//    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
    
    self.scrollView.alwaysBounceVertical = YES;
    self.scrollView.alwaysBounceHorizontal = YES;
    
    
    
    DicModel * model = [[DicModel alloc] init];
    [model setValuesForKeysWithDictionary:[NSDictionary new]]; // dic 转model
    
    // 删除就那么几行，起码不用重新刷新啊
    [self.tablieView deleteRowsAtIndexPaths:[NSArray new] withRowAnimation:UITableViewRowAnimationMiddle];
    
}

//视图将要出现
- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"%s", __FUNCTION__);
    [super viewWillAppear:animated];
    [self.view addSubview:self.button];
}

// view 即将布局其 Subviews
- (void)viewWillLayoutSubviews {
    NSLog(@"%s", __FUNCTION__);
    [super viewWillLayoutSubviews];
    self.button.frame = CGRectMake(100, 100, 100, 100);
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



#pragma mark -- ScrollView 的delegate

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view{
    
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    
}

@end




@implementation DicModel


@end

