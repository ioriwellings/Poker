//
//  PlayerEntity.m
//  Poker
//
//  Created by Iori on 8/8/16.
//  Copyright © 2016 Hointe. All rights reserved.
//

#import "PlayerEntity.h"

@implementation PlayerEntity

-(instancetype)init
{
    self = [super init];
    if(self)
    {
        _handCard = [PokerHandsEntity new];
    }
    return self;
}

@end
