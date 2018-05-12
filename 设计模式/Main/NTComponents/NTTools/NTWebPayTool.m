//
//  XWWebPayTool.m
//  NewCenterWeather
//
//  Created by 肖文 on 2017/6/20.
//  Copyright © 2017年 肖文. All rights reserved.
//

#import "NTWebPayTool.h"
#import "NTCatergory.h"
#import <StoreKit/StoreKit.h>

static NTWebPayTool *_delegateTarget;
static NTWebPayTool *_applePayDelegateTarget;
@interface NTWebPayTool ()<UIWebViewDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver>
@property(nonatomic, copy) void(^completion)(BOOL successed);
@property(nonatomic, copy) void(^checkConfig)(void(^checkedConfig)(BOOL successeed));
@property(nonatomic, copy) void(^applePayCompletion)(BOOL successed, NSString *errorInfo);
@property(nonatomic, strong) UIWebView *payView;
@end

@implementation NTWebPayTool

- (void)dealloc{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

#pragma mark - Public Methods
+ (void)nt_payWithURL:(NSString *)url body:(NSString *)body userOpenURL:(BOOL)useOpenURL checkConfig:(void (^)(void (^)(BOOL)))checkConfig completion:(void (^)(BOOL))completion{
    NT_ROOT_WINDOW.userInteractionEnabled = NO;
    _delegateTarget = nil;
    _delegateTarget = [NTWebPayTool new];
    _delegateTarget.completion = completion;
    _delegateTarget.checkConfig = checkConfig;
    [NT_NOTIFICATION_CENTER removeObserver:_delegateTarget];
    [NT_NOTIFICATION_CENTER addObserver:_delegateTarget selector:@selector(_nt_enterBack) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [NT_NOTIFICATION_CENTER addObserver:_delegateTarget selector:@selector(_nt_enterFront) name:UIApplicationWillEnterForegroundNotification object:nil];
    if (useOpenURL) {
        [NT_APPLICATION openURL:[NSURL URLWithString:url]];
    }else{
        _delegateTarget.payView = [UIWebView new];
        _delegateTarget.payView.delegate = _delegateTarget;
        [_delegateTarget.payView loadRequest:({
            NSMutableURLRequest *requset = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
            if (body.length) {
                [requset setHTTPMethod: @"POST"];
                [requset setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
            }
            requset;
        })];
    }
}

+ (void)nt_payByApplePayWithProductionID:(NSString *)productionID completion:(void (^)(BOOL, NSString *))completion{
    if (!productionID.length) {
        NT_BLOCK(completion, NO, @"缺少商品ID");
        return;
    }
    NT_LOG(@"target = %@", _applePayDelegateTarget);
    _applePayDelegateTarget = nil;
    _applePayDelegateTarget = [NTWebPayTool new];
    _applePayDelegateTarget.applePayCompletion = completion;
    [[SKPaymentQueue defaultQueue] addTransactionObserver:_applePayDelegateTarget];
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithArray:@[productionID]]];
    request.delegate = _applePayDelegateTarget;
    [request start];
}

#pragma mark - Private Methods
- (void)_nt_handleCompletion:(BOOL)isSucceed{
    NT_ROOT_WINDOW.userInteractionEnabled = YES;
    NT_BLOCK(_completion, isSucceed);
    _delegateTarget = nil;
}

- (void)_nt_handleApplePayCompletion:(BOOL)isSucceed errorInfo:(NSString *)errorInfo{
    NT_BLOCK(_applePayCompletion, isSucceed, errorInfo);
    _applePayDelegateTarget = nil;
}

- (void)_nt_enterBack{
    [_payView stopLoading];
    _payView.delegate = nil;
    _payView = nil;
    [NT_NOTIFICATION_CENTER removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    NT_LOG(@"跳转微信");
}

- (void)_nt_enterFront{
    [NT_NOTIFICATION_CENTER removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    void(^checkedConfig)(BOOL successed) = ^(BOOL successed) {
        [self _nt_handleCompletion:successed];
    };
    NT_BLOCK(_checkConfig, checkedConfig);
    NT_LOG(@"回到应用");
}

#pragma mark - <UIWebViewDelegate>
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NT_LOG(@"finish = %@", webView.request.URL);
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self _nt_handleCompletion:NO];
}

#pragma mark - <SKProductsRequestDelegate>
- (void)productsRequest:(nonnull SKProductsRequest *)request didReceiveResponse:(nonnull SKProductsResponse *)response {
    NSArray *myProducts = response.products;
    SKProduct *product = [myProducts firstObject];
    if (!product) {
        [self _nt_handleApplePayCompletion:NO errorInfo:@"无法获取产品信息"];
        return;
    }
    if ([SKPaymentQueue canMakePayments]) {
        SKPayment *payment = [SKPayment paymentWithProduct:product];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    } else {
        [self _nt_handleApplePayCompletion:NO errorInfo:@"您禁止了应用内支付购买"];
    }
}

#pragma mark - <SKPaymentTransactionObserver>
- (void)paymentQueue:(nonnull SKPaymentQueue *)queue updatedTransactions:(nonnull NSArray<SKPaymentTransaction *> *)transactions {
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased:{
                [self _nt_handleApplePayCompletion:YES errorInfo:nil];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            }
            case SKPaymentTransactionStateFailed:{ // 加入服务队列时，事务被取消或者失败。
                if (transaction.error.code == SKErrorPaymentCancelled) {
                    [self _nt_handleApplePayCompletion:NO errorInfo:@"购买已取消"];
                } else {
                    [self _nt_handleApplePayCompletion:NO errorInfo:transaction.error.localizedDescription];
                }
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            }
            case SKPaymentTransactionStateRestored:
                break;
            default:
                break;
        }
    }
}

@end
