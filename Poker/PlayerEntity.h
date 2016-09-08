//
//  PlayerEntity.h
//  Poker
//
//  Created by Iori on 8/8/16.
//  Copyright © 2016 Hointe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PokerHandsEntity.h"

typedef NS_ENUM(NSUInteger, PokerActionEnum) {
    PokerActionEnumCheck = 1,
    PokerActionEnumCall,
    PokerActionEnumFold,
    PokerActionEnumAllin,
    PokerActionEnumSitDown,
    PokerActionEnumStandUp
};

typedef NS_ENUM(NSUInteger, PokerActionStatusEnum)
{
    PokerActionStatusEnumNone,
    PokerActionStatusEnumCheck,
    PokerActionStatusEnumCall,//2
    PokerActionStatusEnumRaise,
    PokerActionStatusEnumAllIn,//4
    PokerActionStatusEnumFold,
    PokerActionStatusEnumWaitingBet,
    PokerActionStatusEnumWaitingNext,
    PokerActionStatusEnumBB,
    PokerActionStatusEnumSB
};

@interface PlayerEntity : NSObject

@property (nonatomic, copy) NSString *playerID;
@property (nonatomic, assign) NSInteger ownMoney;
@property (nonatomic, assign) NSInteger bringInMoney;
@property (nonatomic, assign) NSInteger bet;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger iSeatIndex;
@property (nonatomic, assign) NSInteger iLevel;
@property (nonatomic, assign) BOOL isButton;
@property (nonatomic, assign) BOOL isSmallBlind;
@property (nonatomic, assign) BOOL isBigBlind;
@property (nonatomic, assign) BOOL isWiner;
@property (nonatomic, copy) NSString *imageHead;
@property (nonatomic, strong, readonly) PokerHandsEntity *handCard;
@property (nonatomic, assign) PokerActionStatusEnum actionStatus;

@end
