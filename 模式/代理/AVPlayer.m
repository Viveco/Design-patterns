//
//  AVPlayerProtocol.m
//  设计模式
//
//  Created by 罗罗明祥 on 2017/12/5.
//  Copyright © 2017年 罗罗明祥. All rights reserved.
//

#import "AVPlayer.h"

@implementation AVPlayer


- (NSString * )a_play{
    
    return @"播放";
}
@end



// 遵循了 Protocol的代理 那么就会执行这个方法
//- (IBAction)btnAVPlayerEvent:(UIButton *)sender {
//    if (_player) {
//        _player = nil;
//    }
//    _player = [[AVPlayer alloc] init];
//}
//
//// 播放器播放视频
//- (IBAction)btnPlayerEvent:(UIButton *)sender {
//    _lbState.text = _player ? [_player a_play] : @"播放器为空";
//}
