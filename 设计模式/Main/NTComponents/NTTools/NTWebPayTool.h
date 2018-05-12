//
//  XWWebPayTool.h
//  NewCenterWeather
//
//  Created by 肖文 on 2017/6/20.
//  Copyright © 2017年 肖文. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NTWebPayTool : NSObject
/**
 调起网页支付

 @param url 发起支付的链接
 @param body 发起支付的body，可选，部分平台需要
 @param useOpenURL 是否通过OpenURL的方式跳转到Safari进行支付逻辑，某些平台的某些支付，无法通过内置webView实现
 @param checkConfig 检测支付的block，用户回到应用后调用，此时应该调用服务器的接口检车支付是否成功，然后将是否成功的信息通过checkedConfig回调给工具类
 @param completion 支付完毕的block
    注意：发起支付后会禁用App的用户交互防止用户的多余操作引起其它问题，当支付完成completion调用后，会解除禁用。
 */
+ (void)nt_payWithURL:(NSString *)url
                 body:(nullable NSString *)body
          userOpenURL:(BOOL)useOpenURL
          checkConfig:(void(^)(void(^checkedConfig)(BOOL successeed)))checkConfig
           completion:(void(^)(BOOL isSucceed))completion;

/**
 调起审核用的ApplePay，注意该接口只适用于过审核，如果需要正式的applePay，还需要自行处理其他逻辑

 @param productionID 商品ID，在itunesconnect后台创建
 @param completion 支付结果回调的block
 */
+ (void)nt_payByApplePayWithProductionID:(NSString *)productionID completion:(void(^)(BOOL isSucceed, NSString *errorInfo))completion;

@end

NS_ASSUME_NONNULL_END
