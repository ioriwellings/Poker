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
    PokerSuitEnumSpades,
    PokerSuitEnumHearts,
    PokerSuitEnumDiamonds,
    PokerSuitEnumClubs
};

typedef NS_ENUM(NSUInteger, PokerPatternEnum)
{
    PokerPatternEnumRoyalFlush,
    PokerPatternEnumStraightFlush,
    PokerPatternEnumFourKind,
    PokerPatternEnumFullHouse,//葫芦
    PokerPatternEnumFlush,//同花
    PokerPatternEnumStraight,//顺子
    PokerPatternEnumThreeKind,
    PokerPatternEnumTwoPair,
    PokerPatternEnumOnePair,
    PokerPatternEnumHighCard
};

@interface PokerEntity : NSObject

@property (nonatomic, readonly) NSString *stringValue;
@property (nonatomic, assign) NSInteger numberValue;
@property (nonatomic, assign) PokerSuitEnum pokerSuit;
@property (nonatomic, assign) BOOL isKicker;

@end
