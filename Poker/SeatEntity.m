//
//  SeatEntity.m
//  Poker
//
//  Created by Iori on 8/8/16.
//  Copyright © 2016 Hointe. All rights reserved.
//

#import "SeatEntity.h"
#import "PokerTableEntity.h"
#import "CardHelper.h"
#import "UISeat.h"
#import "UserInfo.h"
#import "UIImageView+ProgressMask.h"
#import "NSString+AudioFile.h"
#import "NSString+Addition.h"

@interface SeatEntity ()
{
    NSTimer *updateWaittingTimer;
    CGFloat progress;
}
@end

@implementation SeatEntity

-(void)playOnTurn
{
    [@"dongdong.wav" playSoundEffect];
}

-(void)clearSeat
{
    [self.seatView clear];
}

-(void)updateSeatUI
{
    if(self.pokerTable.nextActionPlayer &&
       self.pokerTable.nextActionPlayer.nextPlayerIndex == self.player.iSeatIndex)//显示玩家活动状态
    {
        //if(self.player.actionStatus != PokerActionStatusEnumNone)
        {
            [self displayWaittingView];
        }
        if([[UserInfo sharedUser].userID isEqualToString:self.player.playerID])
        {
            [self performSelector:@selector(playOnTurn) withObject:nil afterDelay:.6];
            [self displayActionButtons];
        }
    }
    else
    {
        [self dissWaittingView];
    }
    
    [self.seatView updateStatusByPlayer:self.player];
}

-(void)displayWaittingView
{
//    self.seatView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:.4];
    self.seatView.waittingView.hidden = NO;
    [self updateWaittingView];
    //updateWaittingTimer = [NSTimer scheduledTimerWithTimeInterval:.2 target:self selector:@selector(updateWaittingView) userInfo:nil repeats:YES];
}

-(void)updateWaittingView
{
    [self.seatView.waittingView setHidden:NO];
    [self.seatView.waittingView animationCircleProgress];
    /*progress +=0.02;
    [self.seatView.waittingView updateImageWithProgress:progress];
    
    if(progress>=1)
    {
        progress = 0;
        [updateWaittingTimer invalidate];
        [self.seatView.waittingView setHidden:YES];
        //[self.seatView.waittingView updateImageWithProgress:0];
        [self.seatView.waittingView removeCircleProgressAnimation];
    }
     */
}

-(void)dissWaittingView
{
    if([[UserInfo sharedUser].userID isEqualToString:self.player.playerID])
    {
        self.seatView.btnFold.enabled = NO;
        self.seatView.btnRaise.enabled = NO;
        self.seatView.btnCall.enabled = NO;
        self.seatView.btnCheck.enabled = NO;
        self.seatView.btnAllIn.enabled = NO;
    }
    self.seatView.backgroundColor = [UIColor clearColor];
    self.seatView.waittingView.hidden = YES;
    [self.seatView.waittingView removeCircleProgressAnimation];
//    if(updateWaittingTimer.isValid)
//    {
//        [updateWaittingTimer invalidate];
//        [self.seatView.waittingView updateImageWithProgress:0];
//        progress = 0;
//    }
}

-(void)displayActionButtons
{
    __block BOOL hasCheckActon = NO, hasCallAction = NO, hasRaiseAction = NO, hasAllIn = NO;
    __block NSInteger callValue= 0, raiseValue =0, allInValue = 0;
    [self.pokerTable.nextActionPlayer.nextActions enumerateObjectsUsingBlock:^(NextAction * _Nonnull obj,
                                                                               NSUInteger idx,
                                                                               BOOL * _Nonnull stop)
    {
        if(obj.status == PokerActionStatusEnumCheck)
        {
            hasCheckActon = YES;
        }
        else if (obj.status == PokerActionStatusEnumCall)
        {
            hasCallAction = YES;
            callValue = obj.value;
        }
        else if (obj.status == PokerActionStatusEnumRaise)
        {
            hasRaiseAction = YES;
            raiseValue = obj.value;
        }
        else if (obj.status == PokerActionStatusEnumAllIn)
        {
            hasAllIn = YES;
            allInValue = obj.value;
        }
    }];
    self.seatView.btnFold.enabled = YES;
    self.seatView.btnRaise.enabled = NO;
    self.seatView.btnCall.enabled = NO;
    self.seatView.btnCheck.enabled = NO;
    self.seatView.btnAllIn.enabled = NO;
    self.seatView.labRaise.text = nil;
    self.seatView.labAllIn.text = nil;

    //only call, fold.
    //check ,raise, (option)allin, fold
    //call, raise, (option)allin, fold
    //call, allin, fold;
    if(hasCheckActon)
    {
        self.seatView.btnCheck.enabled = YES;
    }
    if(hasCallAction)
    {
        self.seatView.btnCall.enabled = YES;
    }
    if (hasRaiseAction)
    {
        self.seatView.btnRaise.enabled = YES;
        self.seatView.labRaise.text = [NSString getFormatedNumberByInteger:raiseValue];
        self.seatView.slider.minimumValue = raiseValue;
        self.seatView.slider.value = raiseValue;
        self.seatView.slider.maximumValue = self.player.bringInMoney;
        self.seatView.labAllIn.text = [[NSNumber numberWithInteger:allInValue] stringValue];
    }
    if(hasAllIn)
    {
        self.seatView.btnAllIn.enabled = YES;
        self.seatView.labAllIn.text = [[NSNumber numberWithInteger:allInValue] stringValue];
    }
}

@end
