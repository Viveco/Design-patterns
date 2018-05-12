//
//  NotificationPushViewController.m
//  设计模式
//
//  Created by viveco on 2018/4/13.
//  Copyright © 2018年 罗罗明祥. All rights reserved.
//

#import "NotificationPushViewController.h"
#import <Social/Social.h>


@interface NotificationPushViewController ()

@end

static  NSString * locaIdentifer = @"LocalRequest";

@implementation NotificationPushViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view setValue:[UIColor lightGrayColor] forKey:@"backgroundColor"];
}

- (IBAction)locaNotification:(UIButton *)sender {
    
    //创建通知内容
    UNMutableNotificationContent * content = [[UNMutableNotificationContent alloc] init];
    content.title = @"通知";
    content.subtitle = @"需要更新系统";
    content.body = @"来自viveco";
    NSString *path = [[NSBundle mainBundle] pathForResource:@"15" ofType:@"png"];
    // 2.设置通知附件内容
    NSError *error = nil;
    UNNotificationAttachment *att = [UNNotificationAttachment attachmentWithIdentifier:@"att1" URL:[NSURL fileURLWithPath:path] options:nil error:&error];
    if (error) {
        NSLog(@"attachment error %@", error);
    }
    content.attachments = @[att];

    UNNotificationSound *sound = [UNNotificationSound defaultSound];
    content.sound = sound;

    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:5 repeats:NO];
    UNNotificationRequest * request = [UNNotificationRequest requestWithIdentifier:locaIdentifer content:content trigger:trigger];
    //5.把通知加到UNUserNotificationCenter, 到指定触发点会被触发
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        NSLog(@"本地推送 :( 报错 %@",error);
    }];
}
- (IBAction)RemoteNotification:(UIButton *)sender {
}
- (IBAction)jiGuang:(UIButton *)sender {
}
- (IBAction)systemShare:(id)sender {
    
    NSString *textToShare = @"哈罗大家好，这是分享测试的内容哦，如已看请忽略！如有任何疑问可联系1008611查你话费吧！";
    UIImage *imageToShare = [UIImage imageNamed:@"1.png"];
    NSURL *urlToShare = [NSURL URLWithString:@"http://blog.csdn.net/Boyqicheng"];
    // 分享的图片不能为空
    NSArray *activityItems = @[textToShare, imageToShare, urlToShare];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    // 排除（UIActivityTypeAirDrop）AirDrop 共享、(UIActivityTypePostToFacebook)Facebook
    activityVC.excludedActivityTypes = @[UIActivityTypePostToFacebook, UIActivityTypeAirDrop];
    [self presentViewController:activityVC animated:YES completion:nil];
    // 通过block接收结果处理
    UIActivityViewControllerCompletionWithItemsHandler completionHandler = ^(UIActivityType __nullable activityType, BOOL completed, NSArray * __nullable returnedItems, NSError * __nullable activityError){
        if (completed) {
            NSLog (@"恭喜你，分享成功！");
        }else{
             NSLog (@"很遗憾，分享失败！");
        }
    };
    activityVC.completionWithItemsHandler = completionHandler;
}
- (IBAction)slcomposeShare:(id)sender {
    
    NSString *socialType = @"com.tencent.mqq.ShareExtension";
    
    SLComposeViewController *composeVc  = [SLComposeViewController composeViewControllerForServiceType:socialType];
    if (!composeVc) {
        NSLog(@"您尚未安装软件");
        return;
    }
    if (![SLComposeViewController isAvailableForServiceType:socialType]) {
        NSLog(@"软件未配置登录信息");
        return;
    }
    
    // 2.1.添加分享的文字
    [composeVc setInitialText:@"梦想还是要有的,万一实现了呢"];
    
    // 2.2.添加分享的图片
    [composeVc addImage:[UIImage imageNamed:@"1.png"]];
    
    // 3.弹出控制器进行分享
    [self presentViewController:composeVc animated:YES completion:nil];
    
    // 4.设置监听发送结果
    composeVc.completionHandler = ^(SLComposeViewControllerResult reulst) {
        if (reulst == SLComposeViewControllerResultDone) {
            NSLog(@"用户发送成功");
        } else {
            NSLog(@"用户发送失败");
        }
    };
}

- (IBAction)UMengShare:(id)sender {
}



@end
