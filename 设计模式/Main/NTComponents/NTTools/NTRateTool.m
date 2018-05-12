//
//  NTRateTool.m
//  NTProject
//
//  Created by 肖文 on 2017/10/10.
//  Copyright © 2017年 NineTonTech. All rights reserved.
//

#import "NTRateTool.h"
#import "NTCatergory.h"
#import <StoreKit/StoreKit.h>

static NSString *kRateToolRateCountKey = @"com.nineton.ratetool.ratecount";
static NSString *kRateToolLastVersionKey = @"com.nineton.ratetool.lastversion";

@implementation NTRateTool

+ (void)nt_checkRateStatusWithAppID:(NSString *)AppID gapCount:(NSUInteger)gapCount delay:(NSTimeInterval)delay needRateConfig:(void (^)(void (^)(void (^)(BOOL))))config{
    NSString *lastVersion = [NT_USER_DEFAULTS objectForKey:kRateToolLastVersionKey];
    NSInteger count = [[NT_USER_DEFAULTS objectForKey:kRateToolRateCountKey] integerValue];
    if (!lastVersion || (![lastVersion isEqualToString:NT_APPLICATION.appVersion])) {
        [NT_USER_DEFAULTS setObject:@0 forKey:kRateToolRateCountKey];
        [NT_USER_DEFAULTS setObject:NT_APPLICATION.appVersion forKey:kRateToolLastVersionKey];
        count = 0;
    }
    if (count > (NSInteger)gapCount) {
        count = 0;
    }
    if (count == -1) {
        return;
    }
    BOOL needShow = count == 0;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (!needShow) {
            [NT_USER_DEFAULTS setObject:@(count + 1) forKey:kRateToolRateCountKey];
            return;
        }else{
            [NT_USER_DEFAULTS setObject:@(1) forKey:kRateToolRateCountKey];
        }
        void(^goToRateConfig)(void(^ratedConfig)(BOOL isRated)) = ^(void(^rateConfig)(BOOL isRated)) {
            NSDate *date = [NSDate date];
            NTRateTool *observerTarget = [NTRateTool new];
            NT_WEAKIFY(observerTarget);
            [self nt_setAssociateValue:observerTarget withKey:"com.nineton.tjonlinetool.observertarget"];
            [observerTarget nt_addNotificationForName:UIApplicationWillEnterForegroundNotification block:^(NSNotification * _Nonnull notification) {
                NT_STRONGIFY(observerTarget);
                if ([[NSDate date] timeIntervalSinceDate:date] >= 20) {
                    [NT_USER_DEFAULTS setObject:@"-1" forKey:kRateToolRateCountKey];
                    NT_BLOCK(rateConfig, YES);
                }else{
                    NT_BLOCK(rateConfig, NO);
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self nt_tryInnerRate];
                    });
                }
                [observerTarget nt_removeAllNotification];
                [self nt_removeAssociateWithKey:"com.nineton.tjonlinetool.observertarget"];
            }];
            [NT_APPLICATION openURL:[NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@?action=write-review", AppID]]];
        };
        NT_BLOCK(config, goToRateConfig);
    });
}

+ (void)nt_tryInnerRate{
    if (@available(iOS 10.3, *)) {
        [SKStoreReviewController requestReview];
    }
}

@end
