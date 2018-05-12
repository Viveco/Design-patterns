//
//  FmdbTool.h
//  设计模式
//
//  Created by viveco on 2018/4/17.
//  Copyright © 2018年 罗罗明祥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FmdbTool : NSObject

- (void)createDatabaseWithPath:(NSString * )path WithDatabaseName:(NSString * )databaseName;


- (BOOL)creatDataTableWithNSDictionary:(NSDictionary *)tableDic;

@end
