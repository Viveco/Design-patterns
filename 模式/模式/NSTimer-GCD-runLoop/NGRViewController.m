//
//  NGRViewController.m
//  设计模式
//
//  Created by viveco on 2018/3/20.
//  Copyright © 2018年 罗罗明祥. All rights reserved.
//

#import "NGRViewController.h"

@interface NGRViewController ()
{
    NSTimer * timer;
    CADisplayLink * displaylink;
    dispatch_source_t timerInG;
    NSInteger ticketCount;
    UIImageView * imageView;
}

@end

@implementation NGRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setValue:[UIColor lightGrayColor] forKey:@"backgroundColor"];
    imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(10, 100, 200, 200);
    [self.view addSubview:imageView];
    
//    [self somethingNSTimer];
//    [self somethingDisplayLink];
//    [self somethingGCD];
//    [self somethingNSThread];
    [self somethingOperation];
}

#pragma mark -- NSTimer
- (void)somethingNSTimer{
    
    timer = [NSTimer timerWithTimeInterval:10 target:self selector:@selector(changeImg) userInfo:nil repeats:YES];
    [timer fire];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
//    [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(changeImg) userInfo:nil repeats:YES];// 这个方法直接把nstimer 加到了 nsrunloop 中，不需要在addTimer

    // 根据 Invocation  创建 
//    NSInvocation * invo = [NSInvocation invocationWithMethodSignature:[[self class] instanceMethodSignatureForSelector:@selector(init)]];
//    [invo setTarget:self];
//    [invo setSelector:@selector(changeImg)];
//    [NSTimer scheduledTimerWithTimeInterval:2 invocation:invo repeats:YES];
    

}

#pragma mark -- DisplayLink
- (void)somethingDisplayLink{
    
    displaylink = [CADisplayLink displayLinkWithTarget:self selector:@selector(changeImg)];
    displaylink.preferredFramesPerSecond = 2;
    [displaylink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    displaylink.paused = YES;
    NSLog(@"%f",displaylink.timestamp);
    NSLog(@"%f",displaylink.duration);
}

#pragma mark -- GCD
- (void)somethingGCD{
    
    // 计时器
    timerInG = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(timerInG, dispatch_walltime(NULL, 0 * NSEC_PER_SEC), 2 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(timerInG, ^{
        [self changeImg];
    });
    dispatch_resume(timerInG); // 启动定时器
    
    
    // 是否并发 + 在哪个队列中 + 执行什么任务 so 基本如下的操作就可以写出GCD
    dispatch_async(dispatch_get_main_queue(), ^{
        
    });
    
    
    
    
    // 获取全局的并发队列,不需要创建并发队列,第一个参数为优先级。默认是0
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    // 创建一个串行队列
    dispatch_queue_t queue2 = dispatch_queue_create("cn.heima.queue", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(queue, ^{
        
    });
    
    dispatch_sync(queue2, ^{
        
    });
    
    
    // 延迟执行, 主线程延迟2s后调用
    [self performSelector:@selector(run) withObject:nil afterDelay:2.0];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 开始执行哈哈
    });
    
    [NSThread sleepForTimeInterval:2.0];
    
    
    // 一次性代码
    static  dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
    });
    
    //  队列组，在notify 的block中，他会等group队列组中所有任务完成才会进行调用
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //执行1个耗时的异步操作
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //执行1个耗时的异步操作
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        // 前面两个异步操作完成之后，回到主线程操作
    });
    
    
     //  设置队列的优先级，子队列，放到全局队列，设置优先级为LOW
    dispatch_queue_t concurrencyQueue = dispatch_queue_create("com.huangyibiao.concurrency_queue",
                                                              DISPATCH_QUEUE_CONCURRENT);
    dispatch_set_target_queue(concurrencyQueue,
                              dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0));
    
    dispatch_async(concurrencyQueue, ^{
        
    });
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 这里添加了一个全局并发队列，优先级为默认，比concurrencyQueue的优先级高，所以会先执行。
    });
    
    
    //    creat(@"name", type)
//    DISPATCH_QUEUE_SERIAL  串行队列
//    DISPATCH_QUEUE_CONCURRENT  并行队列
    
}


#pragma mark -- NSThread
- (void)somethingNSThread{
    
    NSThread * thread = [[NSThread alloc] initWithTarget:self selector:@selector(thread:) object:nil];
    [thread setName:@"thread01"];
    [thread start];
    NSLog(@"是否主线程：%d",[thread isMainThread]);
    NSLog(@"线程名字：%@",thread.name);
    NSLog(@"主线程：%@",[NSThread mainThread]);

    
    // 线程之间的通讯
//    [thread performSelectorOnMainThread:@selector(null) withObject:@"canshu" waitUntilDone:YES];
//    [thread performSelector:@selector(null) onThread:[NSThread mainThread] withObject:@"canshu" waitUntilDone:YES];
//    [thread performSelectorOnMainThread:@selector(null) withObject:@"canshu" waitUntilDone:YES];

    [self somethingLock];
    
}
- (void)thread:(NSThread * )thread{
    NSLog(@"调度优先级：%lf",[NSThread threadPriority]);
    NSLog(@"设置调度优先级为：%d",[NSThread setThreadPriority:0.1])
    [NSThread sleepForTimeInterval:2.0];
    [NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:2.0]];
    NSLog(@"当前线程：%@",[NSThread currentThread]);
    [NSThread exit];
    NSLog(@"当前线程：%@",[NSThread currentThread]);
}

- (void)somethingLock{

    ticketCount = 100;
    NSThread * thread01 = [[NSThread alloc] initWithTarget:self selector:@selector(saleTicket) object:nil];
    thread01.name = @"售票员01";
    
    NSThread * thread02 = [[NSThread alloc] initWithTarget:self selector:@selector(saleTicket) object:nil];
    thread02.name = @"售票员02";
    
    NSThread * thread03 = [[NSThread alloc] initWithTarget:self selector:@selector(saleTicket) object:nil];
    thread03.name = @"售票员03";
    
    [thread01 start];
    [thread02 start];
    [thread03 start];
}

- (void)saleTicket{
    while (1) {
        @synchronized (self){
            if (ticketCount > 0) {
                ticketCount -= 1;
                NSLog(@"%@卖了一张票，还剩下%zd张", [NSThread currentThread].name,ticketCount);
            }else{
                NSLog(@"完了");
                break;
            }
        }
    }
}

#pragma mark -- NSOperation
- (void)somethingOperation{
    // 当operation 对象调用了star之后，默认不会有新的线程出现，而是在当前线程中同步执行操作。（在主线程中同步操作）添加到NSOperationQueue 才会进行异步操作，并且自动调用star 方法
    
    
    //  将操作封装到Operation中,如果直接执行NSInvocationOperation中的操作, 那么默认会在主线程中执行
    NSInvocationOperation * op1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(addDependency) object:nil];
    op1.queuePriority = NSOperationQueuePriorityNormal;

    
    //NSBlockOperation, 只有一个操作的时候在主线程中执行，如果有多个操作，则除了第一个在主线程，其他的在子线程中异步执行,但是如果添加到 Queue 队列中就会全部开启新线程执行.
    NSBlockOperation * op2= [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"第一个操作吗 ？");
        NSLog(@"%s, %@", __func__,[NSThread currentThread]);
    }];
    [op2 addExecutionBlock:^{
        NSLog(@"第二个操作");
        NSLog(@"%s, %@", __func__,[NSThread currentThread]);
    }];
    [op2 addExecutionBlock:^{
        NSLog(@"第三个操作");
        NSLog(@"%s, %@", __func__,[NSThread currentThread]);
    }];
    
    
    // 自定义Operation
    JPOperation * op3 = [[JPOperation alloc] init];

    
//    NSOperationQueue * queue  = [NSOperationQueue mainQueue];// 主线程
    NSOperationQueue * queue = [[NSOperationQueue alloc] init];// 默认并发处理
    queue.maxConcurrentOperationCount = 1;// 串行队列
    [op3 addDependency:op2];// 操作op2 执行完才会执行op1
    [op2 addDependency:op1];

    [queue addOperation:op2];
    [queue addOperation:op1];
    [queue addOperation:op3];
    [queue addOperationWithBlock:^{
        NSLog(@"默认添加BlockOperation");
    }];
    
//    [op1 cancel];// 单个取消操作
//    [queue cancelAllOperations];// 全部一起取消操作
}

- (void)addDependency{
    
    NSLog(@"执行addDependency方法")
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    NSOperationQueue *queue2 = [[NSOperationQueue alloc] init];
    
    __block UIImage *image1 = nil;
    __block UIImage *image2 = nil;
    // 1.开启一个线程下载第一张图片
    NSOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        NSURL *url = [NSURL URLWithString:@"http://cdn.cocimg.com/assets/images/logo.png?v=201510272"];
        NSData *data = [NSData dataWithContentsOfURL:url];
        // 2.生成下载好的图片
        UIImage *image = [UIImage imageWithData:data];
        image1 = image;
    }];
    
    // 2.开启一个线程下载第二长图片
    NSOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        NSURL *url = [NSURL URLWithString:@"https://www.baidu.com/img/bd_logo1.png"];
        NSData *data = [NSData dataWithContentsOfURL:url];
        // 2.生成下载好的图片
        UIImage *image = [UIImage imageWithData:data];
        image2 = image;
        
    }];
    // 3.开启一个线程合成图片
    NSOperation *op3 = [NSBlockOperation blockOperationWithBlock:^{
        UIGraphicsBeginImageContext(CGSizeMake(200, 200));
        [image1 drawInRect:CGRectMake(0, 0, 100, 200)];
        [image2 drawInRect:CGRectMake(100, 0, 100, 200)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        // 4.回到主线程更新UI
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            NSLog(@"回到主线程更新UI");
            imageView.image = newImage;
        }];
    }];
    
    
    // 监听任务是否执行完毕
    op1.completionBlock = ^{
        NSLog(@"第一张图片下载完毕");
    };
    op2.completionBlock = ^{
        NSLog(@"第二张图片下载完毕");
    };
    
    // 添加依赖
    // 只要添加了依赖, 那么就会等依赖的任务执行完毕, 才会执行当前任务
    // 注意:
    // 1.添加依赖, 不能添加循环依赖
    // 2.NSOperation可以跨队列添加依赖
    [op3 addDependency:op1];
    [op3 addDependency:op2];
    
    // 将任务添加到队列中
    [queue addOperation:op1];
    [queue addOperation:op2];
    [queue2 addOperation:op3];
}










- (void)changeImg{
    if (timer.valid) {
        NSLog(@"%f",timer.timeInterval);
    }
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [timer invalidate];
    timer = nil;
}
- (void)dealloc{

    [displaylink invalidate];
}


#pragma mark -- Getter

@end



@implementation JPOperation
// 重写 main方法，然后进行封装操作
- (void)main{
    
    NSLog(@"执行的方法");
    NSLog(@"%s, %@", __func__,[NSThread currentThread]);
}

@end
