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
        return NSLocalizedString(@"HighCard", nil);
    }
    else if(self.pattern == PokerPatternEnumOnePair)
    {
        return NSLocalizedString(@"OnePair", nil);
    }
    else if(self.pattern == PokerPatternEnumTwoPair)
    {
        return NSLocalizedString(@"TwoPair", nil);
    }
    else if(self.pattern == PokerPatternEnumThreeKind)
    {
        return NSLocalizedString(@"ThreeKind", nil);
    }
    else if(self.pattern == PokerPatternEnumStraight)
    {
        return NSLocalizedString(@"Straight", nil);
    }
    else if(self.pattern == PokerPatternEnumFlush)
    {
        return NSLocalizedString(@"Flush", nil);
    }
    else if(self.pattern == PokerPatternEnumFullHouse)
    {
        return NSLocalizedString(@"FullHouse", nil);
    }
    else if(self.pattern == PokerPatternEnumFourKind)
    {
        return NSLocalizedString(@"FourKind", nil);
    }
    else if(self.pattern == PokerPatternEnumStraightFlush)
    {
        return NSLocalizedString(@"StraightFlush", nil);
    }
    else if(self.pattern == PokerPatternEnumRoyalFlush)
    {
        return NSLocalizedString(@"RoyalFlush", nil);
    }
    return nil;
}
@end
