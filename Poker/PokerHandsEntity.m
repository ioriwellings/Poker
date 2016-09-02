//
//  PokerHandsEntity.m
//  Poker
//
//  Created by Iori on 8/8/16.
//  Copyright © 2016 Hointe. All rights reserved.
//

#import "PokerHandsEntity.h"

@implementation PokerHandsEntity

-(instancetype)init
{
    self = [super init];
    if(self)
    {
        _arrayPoker = [NSMutableArray arrayWithCapacity:10];
    }
    return self;
}

-(NSString*)patternStringValue
{
    if(self.pattern == PokerPatternEnumHighCard)
    {
        return @"高牌";
    }
    else if(self.pattern == PokerPatternEnumOnePair)
    {
        return @"一对";
    }
    else if(self.pattern == PokerPatternEnumTwoPair)
    {
        return @"两对";
    }
    else if(self.pattern == PokerPatternEnumThreeKind)
    {
        return @"三条";
    }
    else if(self.pattern == PokerPatternEnumStraight)
    {
        return @"顺子";
    }
    else if(self.pattern == PokerPatternEnumFlush)
    {
        return @"同花";
    }
    else if(self.pattern == PokerPatternEnumFullHouse)
    {
        return @"葫芦";
    }
    else if(self.pattern == PokerPatternEnumFourKind)
    {
        return @"四条";
    }
    else if(self.pattern == PokerPatternEnumStraightFlush)
    {
        return @"同花顺";
    }
    else if(self.pattern == PokerPatternEnumRoyalFlush)
    {
        return @"皇家同花顺";
    }
    return nil;
}
@end
