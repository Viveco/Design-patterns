//
//  adViewController.m
//  设计模式
//
//  Created by viveco on 2018/4/2.
//  Copyright © 2018年 罗罗明祥. All rights reserved.
//

#import "NSURLSessionDataTaskViewController.h"

#define totalLengthPath [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"totalLength.txt"]
#define downloadPath [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"download.png"]

@interface NSURLSessionDataTaskViewController ()<NSURLSessionDataDelegate>

@property (strong, nonatomic) NSURLSessionDataTask *dataTask;

@property (strong, nonatomic) NSURLSession *session;
/** 文件的总长度 */
@property (assign, nonatomic) NSInteger totalLength;
/** 已经下载的文件长度 */
@property (assign, nonatomic) NSInteger curLength;
/** 文件句柄 */
@property (strong, nonatomic) NSFileHandle *fileHandle;
/** 输出流 */
@property (strong, nonatomic) NSOutputStream *outStream;
/** 下载进度 */
@property (weak, nonatomic) IBOutlet UIProgressView *downProgress;
@end

@implementation NSURLSessionDataTaskViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //首先获取之前已经下载的文件属性
    NSDictionary *fileInfo = [[NSFileManager defaultManager] attributesOfItemAtPath:downloadPath error:nil];
    NSLog(@"fileInfo --- %@", fileInfo);
    //得到之前下载的文件数据大小
    self.curLength = [fileInfo fileSize];
    NSLog(@"之前已经下载的数据大小curLength --- %zd", self.curLength);
    
    //显示文件的进度信息
    NSData *dataSize = [NSData dataWithContentsOfFile:totalLengthPath];
    self.totalLength = [[[NSString alloc] initWithData:dataSize encoding:NSUTF8StringEncoding] integerValue];
}

//当控制器消失的时候
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    //使用 session 设置代理，会造成对 session 的强引用，需要进行解除
    //方式一：等请求任务结束之后释放代理对象
    [self.session finishTasksAndInvalidate];
    //方式二：立即释放
    //    [self.session invalidateAndCancel];
}

- (NSURLSession *)session {
    if (_session == nil) {
        //创建会话对象 设置代理
        _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    }
    return _session;
}

- (NSURLSessionDataTask *)dataTask {
    if (_dataTask == nil) {
        
        //确定请求路径
        NSURL *url = [NSURL URLWithString:@"http://sony.it168.com/data/attachment/forum/201410/20/2154195j037033ujs7cio0.jpg"];
        //创建可变的请求对象
        NSMutableURLRequest *requestM = [NSMutableURLRequest requestWithURL:url];

        NSString *rangeStr = [NSString stringWithFormat:@"bytes=%zd-", self.curLength];
        [requestM setValue:rangeStr forHTTPHeaderField:@"Range"];
        
        //创建发送请求
        _dataTask = [self.session dataTaskWithRequest:requestM];
    }
    return _dataTask;
}

#pragma mark - 下载控制
- (IBAction)startBtnClick:(id)sender {
    //开始下载

    [self.dataTask resume];
}

- (IBAction)suspendBtnClick:(id)sender {
    //暂停下载
    [self.dataTask suspend];
}

- (IBAction)resumeBtnClick:(id)sender {
    //恢复下载
    [self.dataTask resume];
}

- (IBAction)cancelBtnClick:(id)sender {
    //取消下载
    [self.dataTask cancel];
    //设置取消之后还可以恢复
    self.dataTask = nil;
}

#pragma mark - NSURLSessionDataDelegate
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    

    completionHandler(NSURLSessionResponseAllow);
    self.totalLength = response.expectedContentLength + self.curLength;
    [[[NSString stringWithFormat:@"%zd", self.totalLength] dataUsingEncoding:NSUTF8StringEncoding] writeToFile:totalLengthPath atomically:YES];
    self.outStream = [[NSOutputStream alloc] initToFileAtPath:downloadPath append:YES];
    [self.outStream open];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {

    [self.outStream write:data.bytes maxLength:data.length];
    self.curLength += data.length;
    NSLog(@"%f", 1.0 * self.curLength / self.totalLength);

}


- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{

    [self.outStream close];
    
    NSLog(@"%@", downloadPath);
}



@end
