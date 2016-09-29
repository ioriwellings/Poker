//
//  ResumptionOfMethod.h
//  Poker
//
//  Created by admin on 16/9/29.
//  Copyright © 2016年 Hointe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PokerTableViewControler.h"

@interface ResumptionOfMethod  : PokerTableViewControler
{
    double nowCountNum;//当前播放到第几个事件
    double timeNum;//当前时间
    double clickCountNum;//点击次数
    NSTimer *timer;
    bool btnFlag;//控制button的隐藏显示
}
@property (weak, nonatomic) Pomelo *OnePomelo;
@property (weak, nonatomic) IBOutlet UILabel *roomLb;
@property (weak, nonatomic) IBOutlet UILabel *timeLb;

@property (weak, nonatomic) IBOutlet UIButton *playBtn;

@property (copy,nonatomic) NSArray *arrData;
- (void)initData:(NSArray* )arrData_;
-(void)playFunction;
-(void)closeTimer;
-(void)fastForward;
-(void)fastRewind:(int)count;
-(void)stop;
-(void)play;

-(void)initTableLayout;//初始化座位
-(PlayerEntity*)getPlayerFromDictionary:(NSDictionary*)dict;
-(void)player2Seat;
-(void)updateTableInfoUI;
-(void)onNewPlayerEnter:(NSDictionary*)dict;
-(void)onFlop:(NSDictionary*)dict;
-(void)onTurn:(NSDictionary*)dict;
-(void)onRiver:(NSDictionary*)dict;
-(void)showStartButton;
-(void)onSitDown:(NSDictionary*)dict;
-(void)onGameStart:(NSDictionary*)dict;
-(void)onCall:(NSDictionary*)callback;
-(void)onCheck:(NSDictionary*)callback;
-(void)onAllIn:(NSDictionary*)callback;
-(void)onRaise:(NSDictionary*)callback;
-(void)onFold:(NSDictionary*)callback;
-(void)onShowdown:(NSDictionary*)callback;
-(void)onPlayerKick:(NSDictionary*)dict;

- (IBAction)playBtn:(id)sender;
- (IBAction)stopBtn:(id)sender;

-(void)reconnectToHost;
@end
