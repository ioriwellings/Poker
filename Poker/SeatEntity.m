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

@implementation SeatEntity

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
    self.seatView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:.4];
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
}

-(void)displayActionButtons
{
    __block BOOL hasCheckActon, hasCallAction, hasRaiseAction, hasAllIn;
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
    self.seatView.txtRaise.text = nil;
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
        self.seatView.txtRaise.text = [[NSNumber numberWithInteger: raiseValue] stringValue];
        self.seatView.labAllIn.text = [[NSNumber numberWithInteger:allInValue] stringValue];
    }
    if(hasAllIn)
    {
        self.seatView.btnAllIn.enabled = YES;
        self.seatView.labAllIn.text = [[NSNumber numberWithInteger:allInValue] stringValue];
    }
}

@end
