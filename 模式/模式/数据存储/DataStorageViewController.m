//
//  DataStorageViewController.m
//  设计模式
//
//  Created by viveco on 2018/4/17.
//  Copyright © 2018年 罗罗明祥. All rights reserved.
//

#import "DataStorageViewController.h"
#import "FmdbTool.h"

@interface DataStorageViewController ()
@property (strong, nonatomic) IBOutlet UITextField *nameText;
@property (strong, nonatomic) IBOutlet UITextField *ageText;
@property (strong, nonatomic) IBOutlet UITextField *sexText;
@property (strong, nonatomic) IBOutlet UITextField *gradeText;

@property (strong, nonatomic) FmdbTool *fmdbModel;

@property (copy, nonatomic) NSString *docpath;

struct Mydatal {
    int year;
    int month;
    int day;
};


@end

@implementation DataStorageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    struct Mydatal dl = {2016,1,13};
    NSLog(@"%d",dl.year);
    
}

- (IBAction)encode:(UIButton *)sender {
    [self encodeValue];
}
- (IBAction)fmdbLook:(UIButton *)sender {
    
    NSArray * documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    _docpath = [documentPaths firstObject];
    _fmdbModel = [[FmdbTool alloc] init];
    [_fmdbModel createDatabaseWithPath:[documentPaths firstObject] WithDatabaseName:@"student"];
    
    NSDictionary * dic = @{@"tableName":@"_student",
                           @"id":@"interger",
                           @"name":@"text",
                           @"age":@"integer",
                           @"sex":@"text",
                           @"grade":@"integer"};
    [_fmdbModel creatDataTableWithNSDictionary:dic];
}
- (IBAction)fmdbAdd:(id)sender {
}
- (IBAction)FmdbUpdate:(id)sender {
}
- (IBAction)fmdbDelete:(id)sender {
}

#pragma mark -- 数据归档问题
- (void)encodeValue{
    
    // 字典转模型
    ValueForKey * value = [[ValueForKey alloc] init];
    NSDictionary * dic = @{@"name":@"Tom"};
    [value setValuesForKeysWithDictionary:dic];
    NSLog(@"%@",value.name);
    
    // 归档问题
    
    NSString *path = NSHomeDirectory();
    NSLog(@"沙盒%@",path);
    
    
    NSArray * LibraryPaths =  NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask,YES);
    NSString *LibraryPath = [LibraryPaths firstObject];
    NSLog(@"%@",LibraryPath);
    
    LibraryPath = [LibraryPath stringByAppendingPathComponent:@"valueModel.archiver"];
    ValueForKey * model = [[ValueForKey alloc] init];
    model.name = @"Tom";
    model.age = 12;
    model.grade = @"1";
    model.sex = @"man";
    model.dataArray = @[@"测试归档",@"不能归档"];
    
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:model];// 归档到nadata
    NSLog(@"%@",data);
    
    [NSKeyedArchiver archiveRootObject:model toFile:LibraryPath]; // 归档到documentPath 路径
    ValueForKey *person = [NSKeyedUnarchiver unarchiveObjectWithFile:LibraryPath];
    NSLog(@"%@",person.dataArray);
    
    [self twoObjectSaveArchiverWithPath:[LibraryPaths firstObject]];
    
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

@end


@implementation ValueForKey

- (void)encodeWithCoder:(NSCoder *)aCoder{
    //    encodeRuntime(ValueForKey) // 宏封装
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
    //    initCoderRuntime(ValueForKey)// 宏封装
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
