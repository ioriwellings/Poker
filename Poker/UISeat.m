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
#import "UIView+DCAnimationKit.h"
#import "NSString+Addition.h"

#define UserBg 1001

@interface UISeat ()
{
    PlayerEntity *currentPlayer;
    CGRect iconChipFrame;
    BOOL isBetHiddenAnimate;
}
@end

@implementation UISeat

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
        isBetHiddenAnimate = NO;
    }
    return self;;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        isBetHiddenAnimate=  NO;
    }
    return self;
}

-(instancetype)init
{
    if(self = [super init])
    {
        isBetHiddenAnimate = NO;
    }
    return self;
}

-(UIView*)userNameBg
{
    return [self viewWithTag:UserBg];
}

-(void)flyChipAnimation
{
    if(currentPlayer.isDirty == NO) return;
    __weak typeof(self) ws = self;
    if(CGRectIsEmpty(iconChipFrame))
    {
        iconChipFrame = [self.iconChip frame];
    }
    CGPoint newPoint = [self convertRect:self.waittingView.frame toView:self.betContainer].origin;
    newPoint.x += self.waittingView.frame.size.width/3.0;
    newPoint.y += self.waittingView.frame.size.height/3.0;
    self.iconChip.frame = CGRectMake(newPoint.x,
                                     newPoint.y,
                                     self.iconChip.frame.size.width,
                                     self.iconChip.frame.size.height);
    [ws.iconChip setPoint:iconChipFrame.origin duration:.3 finished:^{currentPlayer.isDirty = NO;}];
}

-(void)setStatusFromPlayer:(PlayerEntity*)player
{
    //self.backgroundColor = [UIColor clearColor];
    currentPlayer = player;
    self.labName.text = player.name;
    if(player)
    {
        self.userNameBg.hidden = NO;
        self.labBringIn.hidden = NO;
    }

    self.labBringIn.text = [NSString getFormatedNumberByInteger:player.bringInMoney];
    self.iconDelear.hidden = player.isButton ? NO : YES;
    self.iconWinner.hidden = YES;
    
    if (player.handCard.arrayPoker.count >0)
    {
        if(player.isNeedShowCards)
        {
            self.hiddenCards.hidden = YES;
            self.pokerContainer.hidden = NO;
            [self updateHandCards:player.handCard.arrayPoker];//亮牌
        }
        else if(player.actionStatus == PokerActionEnumFold && [[UserInfo sharedUser].userID isEqualToString:player.playerID])
        {
            self.hiddenCards.hidden = YES;
            self.pokerContainer.hidden = NO;
        }
    }
    else
    {
        if([[UserInfo sharedUser].userID isEqualToString:player.playerID])
        {
            self.hiddenCards.hidden = YES;
        }
        else
        {
            if(player.actionStatus != PokerActionStatusEnumWaitingNext)
            {
                self.hiddenCards.hidden = NO;
            }
        }
        self.pokerContainer.hidden = YES;
    }
    //
    __weak typeof(self) ws = self;
    if(player.bet == 0)
    {
        if(isBetHiddenAnimate == NO && ws.betContainer.hidden == NO)
        {
            isBetHiddenAnimate = YES;
            CGRect originFrame = ws.betContainer.frame;
            [UIView animateWithDuration:.65 delay:1.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
                ws.betContainer.alpha = 1;
                CGRect frame = [ws.refMainPotView.superview convertRect:ws.refMainPotView.frame toView:ws];
                ws.betContainer.frame = frame;
            } completion:^(BOOL finished)
            {
                if(finished)
                {
                    ws.betContainer.hidden = YES;
                    ws.betContainer.frame = originFrame;
                    ws.labBet.text = nil;
                    isBetHiddenAnimate = NO;
                }
            }];
        }
    }
    else
    {
        self.labBet.text = [NSString getFormatedNumberByInteger:player.bet];
    }
    
    if(player.actionStatus == PokerActionStatusEnumFold)
    {
        //self.backgroundColor = [UIColor darkGrayColor];
        self.labStatus.text = NSLocalizedString(@"FoldCard", nil);
        [self foldCard];
    }
    else if(player.actionStatus == PokerActionStatusEnumCheck)
    {
        self.labStatus.text = NSLocalizedString(@"CheckCard", nil);
    }
    else if (player.actionStatus == PokerActionStatusEnumCall)
    {
        self.labStatus.text = NSLocalizedString(@"Call", nil);
        if(player.bet >0 ) self.betContainer.hidden = NO;
        [self flyChipAnimation];
    }
    else if (player.actionStatus == PokerActionStatusEnumRaise)
    {
        self.labStatus.text = NSLocalizedString(@"Raise", nil);
        if(player.bet>0)
        {
            self.betContainer.hidden = NO;
            [self flyChipAnimation];
        }
    }
    else if (player.actionStatus == PokerActionStatusEnumAllIn)
    {
        self.labStatus.text = NSLocalizedString(@"AllIn", nil);;
        if(player.bet >0 ) self.betContainer.hidden = NO;
        [self flyChipAnimation];
    }
    else if(player.actionStatus == PokerActionStatusEnumWaitingBet)
    {
        self.labStatus.text = NSLocalizedString(@"Wait", nil);
        self.labBet.text = @"";
    }
    else if(player.actionStatus == PokerActionStatusEnumWaitingNext)
    {
        self.labStatus.text = NSLocalizedString(@"WaitNext", nil);;
        self.labBet.text = @"";
    }
    else if (player.actionStatus == PokerActionStatusEnumSB)
    {
        self.labStatus.text = NSLocalizedString(@"SB", nil);;
        if(player.bet>0)
        {
            self.labBet.text = [[NSNumber numberWithInteger:player.bet] stringValue];
            self.betContainer.hidden = NO;
        }
    }
    else if (player.actionStatus == PokerActionStatusEnumBB)
    {
        self.labStatus.text = NSLocalizedString(@"BB", nil);;
        if(player.bet>0)
        {
            self.betContainer.hidden = NO;
        }
    }
    else if (player.actionStatus == PokerActionStatusEnumNone)
    {
        self.labStatus.text = @"";
        if(player.isBigBlind)
        {
            self.labStatus.text = NSLocalizedString(@"BB", nil);
            if(player.bet >0 )
            {
                self.betContainer.hidden = NO;
            }
        }
        if(player.isSmallBlind)
        {
            self.labStatus.text = NSLocalizedString(@"SB", nil);
            if(player.bet > 0)
            {
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
                self.labStatus.text = NSLocalizedString(@"Win", nil);;
            }
            else
            {
                self.labStatus.text = [NSString stringWithFormat:@"%@%@",
                                       strResult,
                                       NSLocalizedString(@"Win", nil)];
            }
            self.iconWinner.hidden = NO;
        }
        else
        {
            self.iconWinner.hidden = YES;
        }
    }
}

-(void)clear
{
    self.iconWinner.hidden = YES;
    self.betContainer.hidden = YES;
    self.userNameBg.hidden = YES;
    self.hiddenCards.hidden = YES;
    self.iconDelear.hidden = YES;
    self.labStatus.text = nil;
    self.labName.text = nil;
    self.labBringIn.text = nil;
    self.labBet.text = nil;
    self.pokerContainer.hidden = YES;
    self.waittingView.hidden = YES;
    self.backgroundColor = [UIColor clearColor];
}

-(void)resetByPlayer:(PlayerEntity *)player
{
    self.pokerContainer.hidden = YES;
    self.hiddenCards.hidden = YES;
    self.betContainer.hidden = YES;
    self.iconWinner.hidden = YES;
    self.waittingView.hidden = YES;
    [self setStatusFromPlayer:player];
}

-(void)updateStatusByPlayer:(PlayerEntity *)player
{
    if((player.actionStatus == PokerActionStatusEnumNone ||
       player.actionStatus == PokerActionStatusEnumWaitingNext) && player.isWiner == NO)
    {
        [self resetByPlayer:player];
        self.labBringIn.hidden = NO;
    }
    else
    {
        [self setStatusFromPlayer:player];
    }
    if([PokerTableEntity sharedInstance].hasUpdatedHandCard == NO  &&
       [PokerTableEntity sharedInstance].tableStatus == PokerTableStatusEnumBet &&
       player.handCard.arrayPoker.count > 0)
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
            [self.poker00 flip:^{[self.poker01 flip:nil delay:0];} delay:0];
        }
    }
}

-(void)foldCard
{
    if(self.hiddenCards.hidden == NO)
    {
        if([currentPlayer.playerID isEqualToString:[UserInfo sharedUser].userID] == NO)
        {
            self.hiddenCards.hidden = YES;
        }
    }
    else if (self.pokerContainer.hidden == NO)
    {
        if([currentPlayer.playerID isEqualToString:[UserInfo sharedUser].userID] == NO)
        {
            self.pokerContainer.hidden = YES;
        }
    }
}

@end
