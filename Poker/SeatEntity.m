//
//  SeatEntity.m
//  Poker
//
//  Created by Iori on 8/8/16.
//  Copyright © 2016 Hointe. All rights reserved.
//

#import "SeatEntity.h"

@implementation SeatEntity

-(void)updateSeatUI
{
    self.seatView.labName.text = self.player.name;
    self.seatView.labBringIn.text = [[NSNumber numberWithInteger:self.player.bringInMoney] stringValue];
    if(self.player.bet != 0)
    {
        self.seatView.labBet.text = [[NSNumber numberWithInteger:self.player.bet] stringValue];
    }
    else
    {
        self.seatView.labBet.text = @"";
    }
    if(self.player.actionStatus == PokerActionStatusEnumCheck)
    {
        self.seatView.labStatus.text = @"看牌";
    }
    else if (self.player.actionStatus == PokerActionStatusEnumCall)
    {
        self.seatView.labStatus.text = @"跟注";
    }
    else if (self.player.actionStatus == PokerActionStatusEnumRaise)
    {
        self.seatView.labStatus.text = @"加注";
    }
    else if (self.player.actionStatus == PokerActionStatusEnumAllIn)
    {
        self.seatView.labStatus.text = @"全下";
    }
    else if(self.player.actionStatus == PokerActionStatusEnumWaitingNext)
    {
        self.seatView.labStatus.text = @"等待下一轮";
        self.seatView.labBet.text = @"";
    }
    else if (self.player.actionStatus == PokerActionStatusEnumSB)
    {
        self.seatView.labStatus.text = @"小盲";
        self.seatView.labBet.text = [[NSNumber numberWithInteger:self.player.bet] stringValue];
    }
    else if (self.player.actionStatus == PokerActionStatusEnumBB)
    {
        self.seatView.labStatus.text = @"大盲";
        self.seatView.labBet.text = [[NSNumber numberWithInteger:self.player.bet] stringValue];
    }
    else if (self.player.actionStatus == PokerActionStatusEnumNone)
    {
        self.seatView.labStatus.text = @"";
        if(self.player.isBigBlind)
        {
            self.seatView.labStatus.text = @"大盲注";
            if(self.player.bet >0 )
                self.seatView.labBet.text = [[NSNumber numberWithInteger:self.player.bet] stringValue];
        }
        if(self.player.isSmallBlind)
        {
            self.seatView.labStatus.text = @"小盲注";
            if(self.player.bet > 0)
                self.seatView.labBet.text = [[NSNumber numberWithInteger:self.player.bet] stringValue];
        }

        if(self.player.isWiner)
        {
            NSString *strResult;
            if(self.player.hands.pattern == PokerPatternEnumRoyalFlush)
            {
                strResult = @"皇家同花顺";
            }
            //else if ()
            if(strResult == nil)
            {
                self.seatView.labStatus.text = @"赢";
            }
            else
            {
                self.seatView.labStatus.text = [NSString stringWithFormat:@"%@%@",
                                                strResult,
                                                @" 赢"];
            }
        }
    }
}

@end
