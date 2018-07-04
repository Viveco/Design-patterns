//
//  SomethingViewController.m
//  设计模式
//
//  Created by viveco on 2018/3/5.
//  Copyright © 2018年 罗罗明祥. All rights reserved.
//

#import "SomethingViewController.h"
#import <objc/runtime.h>

static UIButton * Button(UIColor * color, NSString * title)
{
    UIButton * uibu = [UIButton buttonWithType:UIButtonTypeCustom];
    uibu.backgroundColor = color;
    [uibu setTitle:title forState:UIControlStateNormal];
    return uibu;
}

static inline int sum (int a ,int b){
    return  a + b;
}

@interface SomethingViewController ()

@property (strong, nonatomic) BlockModel *model;

@end

@implementation SomethingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setValue:[UIColor whiteColor] forKey:@"backgroundColor"];
    self.navigationItem.title = @"something";
    
//    [self somethingSystem];
//    [self somethingNote];
//    [self somethingAlert];
//    [self somethingTime];
//    [self somethingTouch];
//    [self somethingQuartz2D];
    [self somethingCALayer];
//    [self somethingBlock];
    
    Button([UIColor redColor], @"按钮");
    NSLog(@"%d",sum(10, 10));
 
}
#pragma mark  关于进制
- (void)somethingSystem{
    NSLog(@"%d",[self function:999]);
}
- (int)function:(int)number{
    
    int count = 0;
    
    while (number) {
        count ++;
        number = number&(number-1);
    }
    return count;
}
#pragma mark  关于通知方面
- (void)somethingNote{

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handle:) name:@"xc" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"xc" object:@[@"xinyu"] userInfo:@{@"德玛":@"西亚"}];
    
    NSNotification * notification = [NSNotification notificationWithName:@"dema" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter]postNotification:notification];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboard:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)handle:(NSNotification * )note{
    NSLog(@"%@",note.object);
    
}

- (void)keyboard:(NSNotification * )note{
     CGRect frame = [note.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    
    // 可以定义位置然后 layoutIfNeeded
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark -- 关于alert

- (void)somethingAlert{
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"信息" message:@"somethingAlert" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * action0 = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"%s",__FUNCTION__);
    }];
    UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"%s",__FUNCTION__);
    }];
    
    [alert addAction:action0];
    [alert addAction:action1];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark -- 时间问题
- (void)somethingTime{
    
    NSDate * date = [[NSDate alloc] init];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSLog(@"%@",[formatter stringFromDate:date]);
}

#pragma mark -- touche

- (void)somethingTouch{
    TouchTestView * view = [[TouchTestView alloc] initWithFrame:CGRectMake(100, 100, 50, 50)];
    [self.view addSubview:view];
}

#pragma mark -- Quartz2d
- (void)somethingQuartz2D{
    
    Quartz2DView * quartyzView = [[Quartz2DView alloc] initWithFrame:CGRectMake(0,100, 375, 667)];
    [self.view addSubview:quartyzView];
}

#pragma mark -- Calayer
- (void)somethingCALayer{
    
    CAlayerView * calayerView = [[CAlayerView alloc] initWithFrame:CGRectMake(100, 64, 275, 567)];
    [self.view addSubview:calayerView];
    
    [self setupTab4](1, 3);
}

- (int(^)(int, int))setupTab4
{
    int(^block)(int, int) = ^(int a, int b){
        int c = a + b;
        NSLog(@"%d", c);
        return c;
    };
    return block;
}

#pragma mark --  测试block
- (void)somethingBlock{
    
    
    void (^block)(SomethingViewController * vc) = ^(SomethingViewController * vc){
        NSLog(@"%@",vc.title);
    };
    
    block(self);
    
    
    
    
    
    
    
    
    
    
    [BlockModel testBlockWithSelf:^(id responder) {
        NSLog(@"%@",responder);
    }];
    
    [BlockModel testPropertyWith:^(id responder) {
        NSLog(@"%@",responder);
    }];
    
    WEAK_SELF
    self.model = [[BlockModel alloc] init];
    __block BOOL falg = YES;
    self.model.MyBlock = ^UIView * (id responder) {
        wself.view.backgroundColor = [UIColor grayColor];
        falg = NO;
        NSLog(@"%@",responder);
        return nil;
    };
    
    self.model.MyBlock(@10);

}
@end


//对于block 来说如果没有对象进行持有的情况下，（类似不是 self.model来调用），那么block 内部是可以使用self，这样self并没有对这个对象进行持有。+ 号方法调用也是没有进行持有，所以可以进行调用，之后或许会出现 +号方法循环调用在理解说明，直接释放block= nil 就可以。
@implementation BlockModel

+ (void)testPropertyWith:(Block)block{
    block(@"属性测试");
}

+ (void)testBlockWithSelf:(void (^)(id))block{
    block(@"直接参数测试");
}
@end



@implementation BAD

- (instancetype)init{
    if (self = [super init]) {
        NSLog(@"%@",NSStringFromClass([self class]));
        NSLog(@"%@",NSStringFromClass([super class]));
    }return self;
}

@end
