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


@interface NetViewController ()<NSXMLParserDelegate,NSURLSessionDownloadDelegate,NSURLSessionDataDelegate,NSURLSessionDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *downImageView;

@property (strong, nonatomic) Reachability *reachability;

@property (copy, nonatomic) NSString *filePaths;

@property (strong, nonatomic) NSURLSession *session;

@property (strong, nonatomic) NSData *resumeData;

@property (strong, nonatomic) NSURLSessionDownloadTask *task;

@property (strong, nonatomic) NSURLSessionDataTask *dataTask;

/** 文件的总长度 */
@property (assign, nonatomic) NSInteger totalLength;
/** 已经下载的文件长度 */
@property (assign, nonatomic) NSInteger curLength;
/** 输出流 */
@property (strong, nonatomic) NSOutputStream *outStream;


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
    
    NSURLSessionConfiguration * config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.timeoutIntervalForRequest = 10;
    config.allowsCellularAccess = NO;
    NSString *userPasswordString = [NSString stringWithFormat:@"%@:%@", @"LXM", @"123"];
    NSData * userPasswordData = [userPasswordString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64EncodedCredential = [userPasswordData base64EncodedStringWithOptions:0];
    NSString *authString = [NSString stringWithFormat:@"Basic: %@", base64EncodedCredential];
    config.HTTPAdditionalHeaders = @{@"Accept":@"application/json",
                                     @"Language":@"en",
                                     @"Authorization" : authString,
                                      @"User-Agent": @"iPhone AppleWebKi"
                                     };
    
    self.session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    NSString * urlString = @"http://www.deskcar.com/desktop/fengjing/20125700336/18.jpg";
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL * url  = [NSURL URLWithString:urlString];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30];
    
    self.task = [self.session downloadTaskWithRequest:request];
    
    NSString *rangeStr = [NSString stringWithFormat:@"bytes=%zd-", self.curLength]; // 拿到之前下载的多少
    [request setValue:rangeStr forHTTPHeaderField:@"Range"];
    self.dataTask = [self.session dataTaskWithRequest:request];
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
#pragma mark -- NSURLSessionDownloadTask
- (IBAction)starDown:(UIButton *)sender {
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

#pragma mark -- NSURLSessionDownLoadDelegate
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
    if (self.outStream != nil) {
        [self.outStream close];
        self.outStream = nil;
    }
}














#pragma mark -- NSURLSessionDataTask
- (IBAction)starUp:(id)sender {
    [_dataTask resume];
}
- (IBAction)pauseUp:(id)sender {
    [_dataTask suspend];
}

- (IBAction)recoverUp:(id)sender {
    [_dataTask resume];
}






#pragma mark-- NSURLSessionDataDelegate
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    
    // 允许接受数据，如果没有写这句，则后面代理的方法不会被执行

    completionHandler(NSURLSessionResponseAllow);
    self.totalLength = response.expectedContentLength;
    NSString * filePahts = [self cacheDir:response.suggestedFilename];
    self.filePaths = filePahts;
    self.outStream = [[NSOutputStream alloc] initToFileAtPath:self.filePaths append:YES];
    [self.outStream open];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data{
    
    self.curLength += data.length;
    [self.outStream write:data.bytes maxLength:data.length];
    NSLog(@"%f",1.0* self.curLength/self.totalLength);
   
}
// 当请求是 https 的时候 会自动调用这个地方
- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler{
    NSLog(@"调用外层");
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
         NSLog(@"调用了里面这一层是服务器信任的证书");
        NSURLCredential *card = [[NSURLCredential alloc]initWithTrust:challenge.protectionSpace.serverTrust];
        completionHandler(NSURLSessionAuthChallengeUseCredential , card);
    }
}






#pragma mark --- 输入一个字符串,则在沙盒中生成路径
// 传入字符串,直接在沙盒Cache中生成路径
- (NSString *)cacheDir:(NSString *)paths
{
    NSString *cache = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    
    return [cache stringByAppendingPathComponent:[paths lastPathComponent]];
}


- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.session invalidateAndCancel];
    
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

