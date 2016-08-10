//
//  HouseEntity.h
//  Poker
//
//  Created by Iori on 8/8/16.
//  Copyright © 2016 Hointe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SidePotEntity.h"
#import "MainPotEntity.h"
#import "SeatEntity.h"

@interface PokerTableEntity : NSObject

@property (nonatomic, strong, readonly) NSMutableArray<SeatEntity*> *seats;
@property (nonatomic, strong) MainPotEntity *mainPots;
@property (nonatomic, strong) NSMutableArray<SidePotEntity*> *sidePots;
@property (nonatomic, strong) NSMutableArray<PokerEntity*> *communityCards;
@property (nonatomic, strong) NSArray<NSArray<PlayerEntity*>*> *winers;

@property (nonatomic, strong) NSDecimalNumber *minBring;
@property (nonatomic, strong) NSDecimalNumber *maxBring;

@property (nonatomic, assign) NSInteger sb;
@property (nonatomic, assign) NSInteger bb;

@property (nonatomic, assign) NSInteger cap;
@property (nonatomic, assign) NSInteger limit;

-(void)updateUI;
@end
