//
//  PokerEntity.h
//  Poker
//
//  Created by Iori on 8/8/16.
//  Copyright © 2016 Hointe. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, PokerSuitEnum)
{
    PokerSuitEnumDiamonds,
    PokerSuitEnumClubs,
    PokerSuitEnumHearts,
    PokerSuitEnumSpades
};

typedef NS_ENUM(NSUInteger, PokerPatternEnum)
{
    PokerPatternEnumHighCard,
    PokerPatternEnumOnePair,
    PokerPatternEnumTwoPair,
    PokerPatternEnumThreeKind,
    PokerPatternEnumStraight,//顺子
    PokerPatternEnumFlush,//同花
    PokerPatternEnumFullHouse,//葫芦
    PokerPatternEnumFourKind,
    PokerPatternEnumStraightFlush,
    PokerPatternEnumRoyalFlush,
};

@interface PokerEntity : NSObject

@property (nonatomic, readonly) NSString *stringValue;
@property (nonatomic, assign) NSInteger numberValue;
@property (nonatomic, assign) PokerSuitEnum pokerSuit;
@property (nonatomic, assign) BOOL isKicker;

@end
