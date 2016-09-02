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

@implementation SeatEntity

-(void)updateSeatUI
{
    if(self.player.handCard.arrayPoker.count > 0)//更新手牌显示
    {
        CardHelper *helper = [CardHelper sharedInstance];
        NSArray<PokerEntity*> *array = [helper getShuffle];
        [array enumerateObjectsUsingBlock:^(PokerEntity * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
        {
            NSInteger iFound = 0;
            if(obj.numberValue == self.player.handCard.arrayPoker[0].numberValue
               && obj.pokerSuit ==  self.player.handCard.arrayPoker[0].pokerSuit)
            {
                [helper makePoker:array[idx] containerView:self.seatView.poker00];
                iFound ++;
            }
            if(obj.numberValue == self.player.handCard.arrayPoker[1].numberValue
               && obj.pokerSuit ==  self.player.handCard.arrayPoker[1].pokerSuit)
            {
                [helper makePoker:array[idx] containerView:self.seatView.poker01];
                iFound ++;
            }
            if(iFound > 1)
            {
                *stop = YES;
            }
        }];
    }
    
    if(self.pokerTable.nextActionPlayer &&
       self.pokerTable.nextActionPlayer.nextPlayerIndex == self.player.iSeatIndex)//显示玩家活动状态
    {
        [self displayWaittingView];
        [self displayActionButtons];
    }
    else
    {
        [self dissWaittingView];
    }
    
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
    //
    if(self.player.actionStatus == PokerActionStatusEnumFold)
    {
        self.seatView.backgroundColor = [UIColor darkGrayColor];
    }
    else if(self.player.actionStatus == PokerActionStatusEnumCheck)
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
        if(self.player.bet>0)
            self.seatView.labBet.text = [[NSNumber numberWithInteger:self.player.bet] stringValue];
    }
    else if (self.player.actionStatus == PokerActionStatusEnumBB)
    {
        self.seatView.labStatus.text = @"大盲";
        if(self.player.bet>0)
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
            if(self.player.handCard.pattern == PokerPatternEnumRoyalFlush)
            {
                strResult = self.player.handCard.patternStringValue;
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

-(void)displayWaittingView
{
    self.seatView.backgroundColor = [UIColor blueColor];
}

-(void)dissWaittingView
{
    self.seatView.backgroundColor = [UIColor redColor];
}

-(void)displayActionButtons
{
    __block BOOL hasCheckActon, hasCallAction, hasRaiseAction, hasAllIn;
    __block NSInteger callValue, raiseValue, allInValue;
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
    
    if(hasCheckActon == NO && hasCallAction == YES && hasRaiseAction == NO && hasAllIn == NO)
    {
        //only call, fold.
    }
    else if(hasCheckActon == YES && hasCallAction == NO && hasRaiseAction == YES)
    {
        //check ,raise, (option)allin, fold
    }
    else if (hasCheckActon == NO && hasCallAction == YES && hasRaiseAction == YES)
    {
        //call, raise, (option)allin, fold
    }
    else if(hasCheckActon == NO && hasCallAction == YES && hasRaiseAction == NO && hasAllIn == YES)
    {
        //call, allin, fold;
    }
    else if (hasCheckActon == NO && hasCallAction == YES && hasRaiseAction == YES)
    {
        //call, raise, (option)allin, fold
    }
}

@end
