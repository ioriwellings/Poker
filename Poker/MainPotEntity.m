//
//  MainPotEntity.m
//  Poker
//
//  Created by Iori on 8/8/16.
//  Copyright © 2016 Hointe. All rights reserved.
//

#import "MainPotEntity.h"

@implementation MainPotEntity

-(instancetype)init
{
    self = [super init];
    if(self)
    {
        _mainPot = 0;
        _players = [NSMutableArray arrayWithCapacity:10];
    }
    return self;
}

@end
