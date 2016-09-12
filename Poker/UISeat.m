//
//  UISeat.m
//  Poker
//
//  Created by Iori on 8/8/16.
//  Copyright © 2016 Hointe. All rights reserved.
//

#import "UISeat.h"
#import "UserInfo.h"
#import "PokerTableEntity.h"

#define UserBg 1001

@implementation UISeat

-(UIView*)userNameBg
{
    return [self viewWithTag:UserBg];
}

-(void)setStatusFromPlayer:(PlayerEntity*)player
{
    //self.backgroundColor = [UIColor clearColor];
    self.labName.text = player.name;
    if(player)
    {
        self.userNameBg.hidden = NO;
        self.labBringIn.hidden = NO;
    }
    NSNumberFormatter *formate = [NSNumberFormatter new];
    formate.numberStyle = NSNumberFormatterDecimalStyle;
    self.labBringIn.text = [formate stringFromNumber:[NSNumber numberWithInteger:player.bringInMoney]];
    self.iconDelear.hidden = player.isButton ? NO : YES;
    
    if (player.handCard.arrayPoker.count >0)
    {
        
        self.hiddenCards.hidden = YES;
        self.pokerContainer.hidden = NO;
    }
    else
    {
        if([[UserInfo sharedUser].userID isEqualToString:player.playerID])
        {
            self.hiddenCards.hidden = YES;
        }
        else
        {
            self.hiddenCards.hidden = NO;
        }
        self.pokerContainer.hidden = YES;
    }
    //
    
    if(player.bet != 0)
    {
        self.labBet.text = [formate stringFromNumber:[NSNumber numberWithInteger:player.bet]];
        self.betContainer.hidden = NO;
    }
    else
    {
        self.labBet.text = nil;
        self.betContainer.hidden = YES;
    }
    
    if(player.actionStatus == PokerActionStatusEnumFold)
    {
        self.backgroundColor = [UIColor darkGrayColor];
        self.labStatus.text = @"弃牌";
        [self foldCard];
    }
    else if(player.actionStatus == PokerActionStatusEnumCheck)
    {
        self.labStatus.text = @"看牌";
    }
    else if (player.actionStatus == PokerActionStatusEnumCall)
    {
        self.labStatus.text = @"跟注";
    }
    else if (player.actionStatus == PokerActionStatusEnumRaise)
    {
        self.labStatus.text = @"加注";
        if(player.bet>0)
        {
            self.betContainer.hidden = NO;
            self.labBet.text = [formate stringFromNumber:[NSNumber numberWithInteger:player.bet]];
        }
    }
    else if (player.actionStatus == PokerActionStatusEnumAllIn)
    {
        self.labStatus.text = @"全下";
    }
    else if(player.actionStatus == PokerActionStatusEnumWaitingNext)
    {
        self.labStatus.text = @"等待下一轮";
        self.labBet.text = @"";
    }
    else if (player.actionStatus == PokerActionStatusEnumSB)
    {
        self.labStatus.text = @"小盲";
        if(player.bet>0)
            self.labBet.text = [[NSNumber numberWithInteger:player.bet] stringValue];
    }
    else if (player.actionStatus == PokerActionStatusEnumBB)
    {
        self.labStatus.text = @"大盲";
        if(player.bet>0)
        {
            self.labBet.text = [[NSNumber numberWithInteger:player.bet] stringValue];
            self.betContainer.hidden = NO;
        }
    }
    else if (player.actionStatus == PokerActionStatusEnumNone)
    {
        self.labStatus.text = @"";
        if(player.isBigBlind)
        {
            self.labStatus.text = @"大盲注";
            if(player.bet >0 )
            {
                self.labBet.text = [[NSNumber numberWithInteger:player.bet] stringValue];
                self.betContainer.hidden = NO;
            }
        }
        if(player.isSmallBlind)
        {
            self.labStatus.text = @"小盲注";
            if(player.bet > 0)
            {
                self.labBet.text = [[NSNumber numberWithInteger:player.bet] stringValue];
                self.betContainer.hidden = NO;
            }
        }
        
        if(player.isWiner)
        {
            NSString *strResult;
            if(player.handCard.pattern == PokerPatternEnumRoyalFlush)
            {
                strResult = player.handCard.patternStringValue;
            }
            //else if ()
            if(strResult == nil)
            {
                self.labStatus.text = @"赢";
            }
            else
            {
                self.labStatus.text = [NSString stringWithFormat:@"%@%@",
                                       strResult,
                                       @" 赢"];
            }
        }
    }
}

-(void)clear
{
    self.betContainer.hidden = YES;
    self.userNameBg.hidden = YES;
    self.hiddenCards.hidden = YES;
    self.iconDelear.hidden = YES;
    self.labStatus.text = nil;
    self.labName.text = nil;
    self.labBringIn.text = nil;
    self.labBet.text = nil;
    self.pokerContainer.hidden = YES;
}

-(void)resetByPlayer:(PlayerEntity *)player
{
    self.pokerContainer.hidden = YES;
    self.hiddenCards.hidden = YES;
    self.betContainer.hidden = YES;
    [self setStatusFromPlayer:player];
}

-(void)updateStatusByPlayer:(PlayerEntity *)player
{
    if(player.actionStatus == PokerActionStatusEnumNone ||
       player.actionStatus == PokerActionStatusEnumWaitingNext)
    {
        [self resetByPlayer:player];
        self.labBringIn.hidden = NO;
    }
    else
    {
        [self setStatusFromPlayer:player];
    }
    if([PokerTableEntity sharedInstance].hasUpdatedHandCard == NO  &&
       [PokerTableEntity sharedInstance].tableStatus == PokerTableStatusEnumBet)
    {
        [self updateHandCards:player.handCard.arrayPoker];
        [PokerTableEntity sharedInstance].hasUpdatedHandCard = YES;
    }
}

-(void)updateHandCards:(NSArray<PokerEntity *> *)pokers
{
    if(pokers == nil || pokers.count == 0)
    {
        self.pokerContainer.hidden = YES;
    }
    else
    {
        self.pokerContainer.hidden = NO;
        if(pokers.count > 0)
        {
            CardHelper *helper = [CardHelper sharedInstance];
            NSArray<PokerEntity*> *array = [helper getShuffle];
            __block NSInteger iFound = 0;
            [array enumerateObjectsUsingBlock:^(PokerEntity * _Nonnull obj,
                                                NSUInteger idx,
                                                BOOL * _Nonnull stop)
             {
                 if(obj.numberValue == pokers[0].numberValue
                    && obj.pokerSuit ==  pokers[0].pokerSuit)
                 {
                     [helper makePoker:array[idx] containerView:self.poker00];
                     iFound ++;
                 }
                 if(obj.numberValue == pokers[1].numberValue
                    && obj.pokerSuit ==  pokers[1].pokerSuit)
                 {
                     [helper makePoker:array[idx] containerView:self.poker01];
                     iFound ++;
                 }
                 if(iFound > 1)
                 {
                     *stop = YES;
                 }
             }];
        }
    }
}

-(void)foldCard
{
    if(self.hiddenCards.hidden == NO)
    {
        self.hiddenCards.hidden = YES;
    }
    else if (self.pokerContainer.hidden == NO)
    {
        self.pokerContainer.hidden = YES;
    }
}

@end
