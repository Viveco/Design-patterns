//
//  NetViewController.m
//  设计模式
//
//  Created by viveco on 2018/3/28.
//  Copyright © 2018年 罗罗明祥. All rights reserved.
//

#import "NetViewController.h"
#import "NSObject+SimpleKVO.h"
#import "Reachability.h"


@interface NetViewController ()<NSXMLParserDelegate,NSURLSessionDownloadDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *downImageView;

@property (strong, nonatomic) Reachability *reachability;

@property (copy, nonatomic) NSString *filePaths;

@property (strong, nonatomic) NSURLSession *session;

@property (strong, nonatomic) NSData *resumeData;

@property (strong, nonatomic) NSURLSessionDownloadTask *task;


@end

@implementation NetViewController

@synthesize reachability = _reachability;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.testItem = [[ItemInfo alloc] init];
    [self.testItem addKVOForPath:@"desc" withBlock:^(id newValue) {
        NSLog(@"%@",newValue);
    }];
    
//    [self somethingRequest];
//    [self somethingJSON];
//    [self somethingXML];
//    [self somthingReachability];
    [self seomthingNSURLSession];
}

#pragma mark -- Request
- (void)somethingRequest{
    NSLog(@"NSURLConnection(是它发送NSURLRequest数据给服务器,并且收集来自服务器的响应数据)");
//    NSURL *url = [NSURL URLWithString:@"http://120.25.226.186:32812/weather?place=Beijing&place=Guangzhou"];
//    NSURLRequest * request = [NSURLRequest requestWithURL:url];
//    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
//        NSLog(@"%@",data);
//    }];
}

#pragma mark -- Json
- (void)somethingJSON{
    NSDictionary * dic =  [NSJSONSerialization JSONObjectWithData:[NSData data] options:kNilOptions error:nil];
    
    
    NSDictionary *dictM = @{
                            @"name":@"wendingding",
                            @"age":@100,
                            @"height":@1.72
                            };
    if ([NSJSONSerialization isValidJSONObject:dic]) {// 是否是可以转成 json的对象判断
         NSData * data = [NSJSONSerialization dataWithJSONObject:dictM options:NSJSONWritingPrettyPrinted error:nil];
        NSLog(@"%@",data);
    }
   
    
    NSString *test = @"{\"name\":\"wendingding\"}";
    id obj = [NSJSONSerialization JSONObjectWithData:[test dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];// 如果对象不是字典和数组则用这个NSJSONReadingAllowFragments。
    NSLog(@"%@ %@",obj, [obj class]);
}

#pragma mark -- XML
- (void)somethingXML{
    NSXMLParser * parser = [[NSXMLParser alloc] init];
    parser.delegate = self;
}

#pragma mark -- Reachability
- (void)somthingReachability{
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(appReachabilityChanged:) name:kReachabilityChangedNotification object:nil];

    // 检测默认路由是否可达
    self.reachability = [Reachability reachabilityForInternetConnection];
    [self.reachability startNotifier];
}
- (void)appReachabilityChanged:(NSNotification * )not{
    
    Reachability *reach = [not object];
    NetworkStatus status = [reach currentReachabilityStatus];
    if (reach == self.reachability) {
        if (status == NotReachable) {
            NSLog(@"routerReachability NotReachable");
        } else if (status == ReachableViaWiFi) {
            NSLog(@"routerReachability ReachableViaWiFi");
        } else if (status == ReachableViaWWAN) {
            NSLog(@"routerReachability ReachableViaWWAN");
        }
    }
}

#pragma mark -- 断点下载

- (void)seomthingNSURLSession{
    
    self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
}

- (IBAction)onceDown:(UIButton *)sender {
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSURL * urlString  = [NSURL URLWithString:@"http://www.deskcar.com/desktop/fengjing/20125700336/18.jpg"];
        NSData * data = [NSData dataWithContentsOfURL:urlString];
        if (data) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.downImageView.image = [UIImage imageWithData:data];
                self.downImageView.contentMode = UIViewContentModeScaleAspectFit;
            });
        }
    });
}

- (IBAction)starDown:(UIButton *)sender {
    
    NSURL * urlString  = [NSURL URLWithString:@"http://www.deskcar.com/desktop/fengjing/20125700336/20.jpg"];
    self.task = [self.session downloadTaskWithURL:urlString];
    [self.task resume];
}
- (IBAction)pauseDown:(UIButton *)sender {
    WEAK_SELF
    [self.task cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
        wself.resumeData = resumeData;
        wself.task = nil;
    }];
}
- (IBAction)recoverDown:(UIButton *)sender {
    self.task = [self.session downloadTaskWithResumeData:self.resumeData];
    [self.task resume];
    self.resumeData = nil;
}


- (IBAction)starUp:(id)sender {
}
- (IBAction)pauseUp:(id)sender {
}
- (IBAction)recoverUp:(id)sender {
}


- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    
    if (session == self.session) {
        NSLog(@"已经下载了%lf",(float)1.0*totalBytesWritten / totalBytesExpectedToWrite );
    }
  
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{
    NSURLResponse * response = downloadTask.response;
    NSString * filePahts = [self cacheDir:response.suggestedFilename];
    self.filePaths = filePahts;
    NSFileManager * fileManget = [NSFileManager defaultManager];
    [fileManget moveItemAtURL:location toURL:[NSURL fileURLWithPath:filePahts] error:nil];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    
    self.downImageView.image = [UIImage imageWithContentsOfFile:self.filePaths];
}



#pragma mark --- 输入一个字符串,则在沙盒中生成路径
// 传入字符串,直接在沙盒Cache中生成路径
- (NSString *)cacheDir:(NSString *)paths
{
    NSString *cache = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    
    return [cache stringByAppendingPathComponent:[paths lastPathComponent]];
}


- (void)dealloc{

    [self.reachability stopNotifier];
    [self.testItem removeAllKVOs];
    self.testItem = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end




@implementation ItemInfo



- (void)testSelector{

    BOOL b1 = [self respondsToSelector:@selector(selector)];
    bool b2 = [self.class instancesRespondToSelector:@selector(selector)];
    BOOL b3 = [self.class  respondsToSelector:@selector(selector)];
    BOOL b4 = [ItemInfo respondsToSelector:@selector(selector)];
    BOOL b5 = [ItemInfo instancesRespondToSelector:@selector(selector)];
    //respondsToSelector 自己能否响应这个方法  //instancesRespondToSelector 他的实例对象能否响应这个方法
    NSLog(@"%d %d %d %d %d", b1, b2, b3, b4, b5);
}

- (void)selector{
    NSLog(@"测试实例和类方法")
}
@end

