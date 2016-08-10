//
//  PokerEntity.m
//  Poker
//
//  Created by Iori on 8/8/16.
//  Copyright © 2016 Hointe. All rights reserved.
//

#import "PokerEntity.h"

@implementation PokerEntity

-(instancetype)init
{
    self = [super init];
    if(self)
    {
        _numberValue = 1;
        _pokerSuit = PokerSuitEnumSpades;
    }
    return self;
}

-(NSString*)getStringValue
{
    if(self.numberValue == 1)
    {
        return @"A";
    }
    else if (self.numberValue == 11)
    {
        return @"J";
    }
    else if (self.numberValue == 12)
    {
        return @"Q";
    }
    else if (self.numberValue == 13)
    {
        return @"K";
    }
    else
    {
        return [[NSNumber numberWithInteger:self.numberValue] stringValue];
    }
}

@end
