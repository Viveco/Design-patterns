//
//  FmdbTool.m
//  设计模式
//
//  Created by viveco on 2018/4/17.
//  Copyright © 2018年 罗罗明祥. All rights reserved.
//

#import "FmdbTool.h"

@interface FmdbTool()

@property (strong, nonatomic) FMDatabase *fmdb;

@end

@implementation FmdbTool



- (void)createDatabaseWithPath:(NSString *)path WithDatabaseName:(NSString * )databaseName{
    
    NSString *fileName = [path stringByAppendingPathComponent:[databaseName stringByAppendingString:@".sqlist"]];
    _fmdb = [FMDatabase databaseWithPath:fileName];
    if ([_fmdb open]) {
        NSLog(@"打开数据库成功");
    } else {
        NSLog(@"打开数据库失败");
    }
}

- (BOOL)creatDataTableWithNSDictionary:(NSDictionary *)tableDic{
    BOOL result = [_fmdb executeUpdate:@"CREATE TABLE IF NOT EXISTS ''()"];
    return result;
}
@end
