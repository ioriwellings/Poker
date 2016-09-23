//
//  NSString+AudioFile.m
//  Poker
//
//  Created by Iori on 9/21/16.
//  Copyright © 2016 Hointe. All rights reserved.
//

#import "NSString+AudioFile.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@implementation NSString (AudioFile)

void soundCompleteCallback(SystemSoundID soundID,void * clientData)
{
    //NSLog(@"播放完成...");
    AudioServicesDisposeSystemSoundID(soundID);
}

-(void)playSoundEffect
{
    NSString *fileName = [self lastPathComponent];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    SystemSoundID sd = 0;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)(fileURL), &sd);
    AudioServicesAddSystemSoundCompletion(sd, NULL, NULL, soundCompleteCallback, NULL);
    AudioServicesPlaySystemSound(sd);
}

-(void)playVibrate
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

static AVAudioPlayer *__player;

-(void)playerMusic
{
    NSURL *fileURL = nil;
    if([self.lowercaseString hasPrefix:@"http"])
    {
        fileURL = [NSURL URLWithString:self];
    }
    else
    {
        fileURL = [NSURL fileURLWithPath:self];
    }
    [self playMusicWithURL:fileURL];
}

-(void)playBundleMusic
{
    NSString *fileName = [self lastPathComponent];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    [self playMusicWithURL:fileURL];
}

-(void)playMusicWithURL:(NSURL*)url
{
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    player.delegate = (id<AVAudioPlayerDelegate>)self;
    [player prepareToPlay];
    __player = player;
    
    AVAudioSession *audioSession=[AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    //        [audioSession setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionAllowBluetooth error:nil];
    [audioSession setActive:YES error:nil];
    //添加通知，拔出耳机后暂停播放
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(routeChange:) name:AVAudioSessionRouteChangeNotification object:nil];
    
    [player play];
}

-(void)routeChange:(NSNotification *)notification
{
    NSDictionary *dic=notification.userInfo;
    int changeReason= [dic[AVAudioSessionRouteChangeReasonKey] intValue];
    //等于AVAudioSessionRouteChangeReasonOldDeviceUnavailable表示旧输出不可用
    if (changeReason==AVAudioSessionRouteChangeReasonOldDeviceUnavailable)
    {
        AVAudioSessionRouteDescription *routeDescription=dic[AVAudioSessionRouteChangePreviousRouteKey];
        AVAudioSessionPortDescription *portDescription= [routeDescription.outputs firstObject];
        //原设备为耳机则暂停
        if ([portDescription.portType isEqualToString:@"Headphones"])
        {
            //[self pause];
        }
    }
}

#pragma mark - 播放器代理方法
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    //NSLog(@"音乐播放完成...");
    //根据实际情况播放完成可以将会话关闭，其他音频应用继续播放
    [[AVAudioSession sharedInstance]setActive:NO error:nil];
}

//-(void)dealloc
//{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVAudioSessionRouteChangeNotification object:nil];
//}

@end
