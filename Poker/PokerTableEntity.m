//
//  HouseEntity.m
//  Poker
//
//  Created by Iori on 8/8/16.
//  Copyright © 2016 Hointe. All rights reserved.
//

#import "PokerTableEntity.h"

@implementation PokerTableEntity

-(instancetype)init
{
    self = [super init];
    if(self)
    {
        _seats = [NSMutableArray arrayWithCapacity:10];
    }
    return self;
}

-(void)updateUI
{
    [self.seats enumerateObjectsUsingBlock:^(SeatEntity * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj updateSeatUI];
    }];
}
@end
