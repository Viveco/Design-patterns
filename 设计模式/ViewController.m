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

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableVIew;

@property (strong, nonatomic) NSArray *dataSource;

@property (strong, nonatomic) NSArray *classStringVC;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    NSLog(@"一共有21中设计模式，逐步写出感想和心得");
    NSLog(@"测试") ;
    
    _dataSource = @[@"设计模式",@"SKU 刷选",@"UIImageView的帧动画",@"一些东西，什么通知，数据持久化等"];
    _classStringVC = @[[CSViewController new],[SKUViewController new],[AnimationVC new],[SomethingViewController new]];
    
    [self.tableVIew registerClass:[UITableViewCell class] forCellReuseIdentifier:@"TabelViewCell"];
    [self.tableVIew setEditing:YES animated:YES];  // 编辑模式
    self.tableVIew.allowsMultipleSelectionDuringEditing = YES;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}
- (UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TabelViewCell"];
    cell.textLabel.text = _dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    [self.navigationController pushViewController:self.classStringVC[indexPath.row] animated:YES];
    
}

// 左滑删除
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
