//
//  NTRateTool.h
//  NTProject
//
//  Created by 肖文 on 2017/10/10.
//  Copyright © 2017年 NineTonTech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface NTRateTool : NSObject
/**
 检测是否需要好评，如需好评则通过config回调同时传递好评点击逻辑goToRateConfig，

 @param AppID 应用ID，在itunesconnect创建应用后即可获取
 @param gapCount 回调后如果没去好评，会在间隔gapCount次启动后再次回调
 @param delay 延迟多少回调config
 @param config 回调检测好评的结果，并传递点击好评逻辑的block
 举例：
 //发起好评检测
 [NTRateTool nt_checkRateStatusWithAppID:@"455611831" gapCount:3 delay:2 needRateConfig:^(void (^goToRateConfig)(void (^ratedConfig)(BOOL isRated))) {
     //如果需要好评，会在2秒后回调此处，此处应该弹出你的好评视图
     [NTTestRateView xw_showRateViewWithRateButtonClickedConfig:^{
         //点击了去好评的按钮
         //构建好评完成的逻辑
         void(^ratedConfig)(BOOL isRated) = ^(BOOL isRated) {
             //根据好评结果做你需要的事情
             NT_LOG(@"%@", isRated ? @"好评成功" : @"好评失败");
         };
         //调用goToRateConfig，进行好评
         NT_BLOCK(goToRateConfig, ratedConfig);
     }];
 }];
 */
+ (void)nt_checkRateStatusWithAppID:(NSString *)AppID
                           gapCount:(NSUInteger)gapCount
                              delay:(NSTimeInterval)delay
                     needRateConfig:(void(^)(void(^goToRateConfig)(void(^ratedConfig)(BOOL isRated))))config;

/**
 尝试iOS10.3之后提供了内置好评弹窗，内部已做版本判断，不用另行判断
 注意：1、即使调用了该API，也不保证能唤起好评弹窗，弹窗是否弹出由苹果自己决定，我们也无法收到回调；
      2、在上一个接口中，如果好评失败，也会尝试调用该接口；
      3、如果需要更频繁的好评，可以在每次程序启动后一段时间，就调该接口。
 */
+ (void)nt_tryInnerRate;
@end
NS_ASSUME_NONNULL_END
