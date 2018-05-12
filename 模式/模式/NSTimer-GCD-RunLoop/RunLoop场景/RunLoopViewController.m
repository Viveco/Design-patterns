//
//  RunLoopViewController.m
//  设计模式
//
//  Created by viveco on 2018/4/25.
//  Copyright © 2018年 罗罗明祥. All rights reserved.
//

#import "RunLoopViewController.h"
#import "HLThread.h"

@interface RunLoopViewController ()
@property (strong, nonatomic) HLThread *subThread;

@end

@implementation RunLoopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self threadTest];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self performSelector:@selector(subThreadOpetion) onThread:self.subThread withObject:nil waitUntilDone:NO];
}

- (void)threadTest
{
    HLThread *subThread = [[HLThread alloc] initWithTarget:self selector:@selector(subThreadEntryPoint) object:nil];
    [subThread setName:@"HLThread"];
    [subThread start];
    self.subThread = subThread;
    
}

/**
 子线程启动后，启动runloop
 */
- (void)subThreadEntryPoint
{
    NSLog(@"ll============%@",[NSThread currentThread]);
    @autoreleasepool {
       NSRunLoop *  runLoop = [NSRunLoop currentRunLoop];
        
        CFRunLoopRef cfloop  = [runLoop getCFRunLoop];
        
        CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(CFAllocatorGetDefault(), kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
            switch (activity) {
                case kCFRunLoopEntry:
                    NSLog(@"进入");
                    break;
                case kCFRunLoopBeforeTimers:
                    NSLog(@"即将处理Timer事件");
                    break;
                case kCFRunLoopBeforeSources:
                    NSLog(@"即将处理Source事件");
                    break;
                case kCFRunLoopBeforeWaiting:
                    NSLog(@"即将休眠");
                    break;
                case kCFRunLoopAfterWaiting:
                    NSLog(@"被唤醒");
                    break;
                case kCFRunLoopExit:
                    NSLog(@"退出RunLoop");
                    break;
                default:
                    break;
            }
        });
        
        // 添加观察者到当前RunLoop中
        CFRunLoopAddObserver(cfloop, observer, kCFRunLoopDefaultMode);
        
        
        // 释放observer，最后添加完需要释放掉
        CFRelease(observer);
        
        
        //如果注释了下面这一行，子线程中的任务并不能正常执行
        [runLoop addPort:[NSMachPort port] forMode:NSRunLoopCommonModes];
        NSLog(@"启动RunLoop前--%@",runLoop.currentMode);
        [runLoop runMode:NSDefaultRunLoopMode  beforeDate:[NSDate dateWithTimeIntervalSinceNow:2]];
    }
}

/**
 子线程任务
 */
- (void)subThreadOpetion
{
    NSLog(@"启动RunLoop后--%@",[NSRunLoop currentRunLoop].currentMode);
    NSLog(@"%@----子线程任务开始",[NSThread currentThread]);
    [NSThread sleepForTimeInterval:3.0];
    NSLog(@"%@----子线程任务结束",[NSThread currentThread]);
}

- (IBAction)exitThread:(id)sender {
    
    
    [self performSelector:@selector(stop) onThread:self.subThread withObject:nil waitUntilDone:NO];
    self.subThread = nil;
    NSLog(@"%@",self.subThread);
}

- (void)stop{

    CFRunLoopStop(CFRunLoopGetCurrent());
}
@end
