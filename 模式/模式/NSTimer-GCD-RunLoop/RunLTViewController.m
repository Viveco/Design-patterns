//
//  RunLTViewController.m
//  设计模式
//
//  Created by viveco on 2018/3/26.
//  Copyright © 2018年 罗罗明祥. All rights reserved.
//

#import "RunLTViewController.h"
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <net/if.h>
#import <objc/runtime.h>


@interface RunLTViewController ()

@end

@implementation RunLTViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setValue:[UIColor lightTextColor] forKey:@"backgroundColor"];
    
//    [self somethingFoundataionRunLoop];
//    [self somthingCFRunLoop];
    [self somethingRuntime];
}
- (void)somethingFoundataionRunLoop{
 
    NSLog(@"当前Runloop：%@\n主线程：%@",[NSRunLoop currentRunLoop],[NSRunLoop mainRunLoop]);
}
- (void)somthingCFRunLoop{
    NSLog(@"当前Runloop：%@\n主线程：%@",CFRunLoopGetCurrent(),CFRunLoopGetMain());
}

- (void)somethingRuntime{
    
    // 获取属性列表
    unsigned int outCount;
    objc_property_t *propertyList = class_copyPropertyList([RuntimeModel class], &outCount);
    for ( int i = 0; i < outCount; i ++) {
        const char *name = property_getName(propertyList[i]);
        NSLog(@"__%@",[NSString stringWithUTF8String:name]);
        objc_property_t property = propertyList[i];
        const char *a = property_getAttributes(property);
        NSLog(@"属性信息-%@",[NSString stringWithUTF8String:a]);
    }
    free(propertyList);
    
    // 获取方法列表
    Method * methodList = class_copyMethodList([RuntimeModel class], &outCount);
    for (unsigned int i = 0; i < outCount; i ++) {
        SEL name = method_getName(methodList[i]);
        NSString *strName = [NSString stringWithCString:sel_getName(name) encoding:NSUTF8StringEncoding];
        NSLog(@"方法-%@",strName);
    }
    free(methodList);
    
    // 获取协议列表
    __unsafe_unretained Protocol **protocolList  = class_copyProtocolList([RuntimeModel class],&outCount);
    for (unsigned int i = 0; i< outCount; i++) {
        Protocol *myProtocal = protocolList[i];
        const char *protocolName = protocol_getName(myProtocal);
        NSLog(@"protocol---->%@", [NSString stringWithUTF8String:protocolName]);
    }
    
     // 获取类的实例方法
    Class RunTimeClass = object_getClass([RuntimeModel class]);
    SEL oriSEL = @selector(isName);
    Method oriMethod = class_getInstanceMethod(RunTimeClass, oriSEL);
    
    // 获取类方法
    SEL kisel = @selector(NameAge);
    Method kinMethod = class_getClassMethod(RunTimeClass, kisel);
    
    
    // 添加
    RuntimeModel * model = [[RuntimeModel alloc] init];
    class_addMethod([model class], @selector(changeAge),  (IMP)guessAnswer, "v@:@");
    if ([model respondsToSelector:@selector(changeAge)]) {
        [model performSelector:@selector(changeAge) withObject:@"GRLAO"];
    }
    
    // 交换两个方法
    
    method_exchangeImplementations(class_getInstanceMethod([model class], @selector(isName)), class_getInstanceMethod([model class], @selector(isSex)));
    NSLog(@"交换方法，然后名字是：%@", [model isSex]);
    
    Method isNameThod = class_getInstanceMethod([model class], @selector(isName));
    class_replaceMethod([model class], @selector(isSex), method_getImplementation(isNameThod), method_getTypeEncoding(isNameThod));
    NSLog(@"替换方法，然后名字是：%@", [model isName]);
    
    // 关联对象
    NSString * class = @"一年级";
    objc_setAssociatedObject(model, @"grade", class, OBJC_ASSOCIATION_COPY_NONATOMIC);
    NSString * classNum = objc_getAssociatedObject(model, @"grade");
    NSLog(@"%@",classNum);
    
}


void guessAnswer(id self, SEL _cmd, NSString * name){
    NSLog(@"名字是%@",name);
}
@end



@implementation RuntimeModel

- (NSString * )isName{
    self.name = @"Tom";
    return @"Tom";
}

- (NSInteger)isAge{
    return 10;
}

- (NSString * )isSex{
    return @"man";
}

+ (void)NameAge{
    NSLog(@"名字和年纪")
}
@end


