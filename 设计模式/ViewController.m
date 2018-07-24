//
//  ViewController.m
//  设计模式
//
//  Created by 罗罗明祥 on 2017/12/5.
//  Copyright © 2017年 罗罗明祥. All rights reserved.
//

#import "ViewController.h"
#import "SKUViewController.h"
#import "CSViewController.h"
#import "AnimationVC.h"
#import "SomethingViewController.h"
#import "LifeCycleViewController.h"
#import "NGRViewController.h"
#import "NetViewController.h"
#import "RunLTViewController.h"
#import "NSURLSessionDataTaskViewController.h"
#import "EncryptionViewController.h"
#import "MapViewController.h"
#import "NotificationPushViewController.h"
#import "SensorViewController.h"
#import "DataStorageViewController.h"
#import "RunLoopViewController.h"
#import "UIScrollView+MJRefresh.h"


@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableVIew;

@property (strong, nonatomic) NSArray *dataSource;

@property (strong, nonatomic) NSArray *classStringVC;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"测试分支情况");
    NSLog(@"commit测试");
    NSLog(@"设置gitCommit");
    NSLog(@"再次测试gitCommit");
    NSLog(@"测试change log")
    
    _dataSource = @[@"设计模式",@"SKU 刷选",@"View的动画",@"一些东西，什么通知，数据持久化等",@"生命周期等",@"NSTimer-GCD等",@"RunLoop-RunTime",@"网络请求等",@"加密问题",@"地图",@"推送",@"传感器等",@"数据存储",@"runloop 使用场景"];
    
//    NSLog(@"%@",idstring);
    
    //首先获取之前已经下载的文件属性

    _classStringVC = @[[CSViewController new],
                       [SKUViewController new],
                       [AnimationVC new],
                       [SomethingViewController new],
                       [LifeCycleViewController new],
                       [NGRViewController new],
                       [RunLTViewController new],
                       [[NetViewController alloc] initWithNibName:@"NetViewController" bundle:[NSBundle mainBundle]],
                       [[EncryptionViewController alloc] initWithNibName:@"EncryptionViewController" bundle:[NSBundle mainBundle]],
                       [[MapViewController alloc] initWithNibName:@"MapViewController" bundle:[NSBundle mainBundle]],
                       [[NotificationPushViewController alloc]initWithNibName:@"NotificationPushViewController" bundle:[NSBundle mainBundle]],
                       [[SensorViewController alloc]initWithNibName:@"SensorViewController" bundle:[NSBundle mainBundle]],
                       [[DataStorageViewController alloc]initWithNibName:@"DataStorageViewController" bundle:[NSBundle mainBundle]],
                       [[RunLoopViewController alloc]initWithNibName:@"RunLoopViewController" bundle:[NSBundle mainBundle]]];
    
    [self.tableVIew registerClass:[UITableViewCell class] forCellReuseIdentifier:@"TabelViewCell"];

    
//    self.tableVIew.alwaysBounceVertical = YES; // 是否有横向纵向 反弹效果
//    self.tableVIew.alwaysBounceHorizontal = YES;
    
//    [self.tableVIew setEditing:YES animated:YES];  // 编辑模式
//    self.tableVIew.allowsMultipleSelectionDuringEditing = YES;// 同意选择多行
//    // 删除就那么几行，起码不用重新刷新啊
//    [self.tablieView deleteRowsAtIndexPaths:[NSArray new] withRowAnimation:UITableViewRowAnimationMiddle];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}
- (UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TabelViewCell"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIViewController * view =self.classStringVC[indexPath.row];
    view.title = _dataSource[indexPath.row];
    [self.navigationController pushViewController:view animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.textLabel.text = _dataSource[indexPath.row];
    cell.textLabel.textColor = [UIColor redColor];
    cell.textLabel.backgroundColor = [UIColor whiteColor];
}

// 删除的一些方法
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"编辑模式");
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewRowAction * action0 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"关注" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {

    }];

    UITableViewRowAction * action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {

    }];

    return @[action0,action1];
}

@end
