//
//  SomethingViewController.m
//  设计模式
//
//  Created by viveco on 2018/3/5.
//  Copyright © 2018年 罗罗明祥. All rights reserved.
//

#import "SomethingViewController.h"
#import <objc/runtime.h>

@interface SomethingViewController ()

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
//    [self somethingSave];
//    [self somethingTouch];
    [self somethingQuartz2D];
    
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

#pragma mark -- 数据归档问题
- (void)somethingSave{
    
    // 字典转模型
    ValueForKey * value = [[ValueForKey alloc] init];
    NSDictionary * dic = @{@"name":@"Tom"};
    [value setValuesForKeysWithDictionary:dic];
    NSLog(@"%@",value.name);

    // 归档问题
    
    NSString *path = NSHomeDirectory();
    NSLog(@"沙盒%@",path);

    NSArray * documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documentPath = [documentPaths firstObject];
    NSLog(@"%@",documentPath);
    
    NSArray * LibraryPaths =  NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask,YES);
    NSString *LibraryPath = [LibraryPaths objectAtIndex:0];
    NSLog(@"%@",LibraryPath);
    
    documentPath = [documentPath stringByAppendingPathComponent:@"valueModel.archiver"];
    ValueForKey * model = [[ValueForKey alloc] init];
    model.name = @"Tom";
    model.age = 12;
    model.grade = @"1";
    model.sex = @"man";

    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:model]; // 归档到nadata
    
    [NSKeyedArchiver archiveRootObject:model toFile:documentPath]; // 归档到documentPath 路径
    ValueForKey *person = [NSKeyedUnarchiver unarchiveObjectWithFile:documentPath];
    NSLog(@"%@",person.name);
    
    [self twoObjectSaveArchiverWithPath:[documentPaths firstObject]];
}
- (void)twoObjectSaveArchiverWithPath:(NSString * )path{
    
    path = [path stringByAppendingPathComponent:@"twoValueModel.archiver"];
    
    ValueForKey * model1 = [[ValueForKey alloc] init];
    model1.name = @"Bob";
    
    ValueForKey * model2 = [[ValueForKey alloc] init];
    model2.name = @"Jack";
    // 存
    NSMutableData * saveData =[[NSMutableData alloc] init];
    NSKeyedArchiver * archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:saveData];
    [archiver encodeObject:model1 forKey:@"model1"];
    [archiver encodeObject:model2 forKey:@"model2"];
    [archiver finishEncoding];
    [saveData writeToFile:path atomically:YES];
    
    // 取
    NSData *data = [NSData dataWithContentsOfFile:path];

    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    ValueForKey *person1 = [unarchiver decodeObjectForKey:@"model1"];
    ValueForKey *person2 = [unarchiver decodeObjectForKey:@"model2"]; // 新解析出来的对象和原来的指针不一样，因此可以实现mutableCopy
    [unarchiver finishDecoding];
    NSLog(@"%@,%@",person1.name,person2.name);
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

@end


@implementation ValueForKey


- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    unsigned int count = 0;
    Ivar * ivars = class_copyIvarList([ValueForKey class], &count);
    for (int i = 0; i < count; i ++) {
        
        Ivar ivar = ivars[i];
        
        const char * name = ivar_getName(ivar);
        NSString * key = [NSString stringWithUTF8String:name];
        id value = [self valueForKey:key];
        [aCoder encodeObject:value forKey:key];
    }
    free(ivars);
}

- (instancetype)initWithCoder:(NSCoder * )aDecoder{
    if (self = [super init]) {
        
        unsigned int count = 0;
        Ivar * ivars = class_copyIvarList([ValueForKey class], &count);
        for (int i = 0; i < count; i ++) {
            Ivar  ivar = ivars[i];
            const char * name = ivar_getName(ivar);
            NSString * key = [NSString stringWithUTF8String:name];
            id  value = [aDecoder decodeObjectForKey:key];
            [self setValue:value forKey:key];
        }
        free(ivars);
    }return self;
}

- (instancetype)init{
    if (self = [super init]) {
    }return self;
}

@end
