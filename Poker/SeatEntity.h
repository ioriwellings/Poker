//
//  SeatEntity.h
//  Poker
//
//  Created by Iori on 8/8/16.
//  Copyright © 2016 Hointe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlayerEntity.h"

@class UISeat;
@class PokerTableEntity;

@interface SeatEntity : NSObject

@property (nonatomic, assign) NSInteger iIndex;
@property (nonatomic, strong) PlayerEntity *player;
@property (nonatomic, strong) UISeat *seatView;
@property (nonatomic, strong) PokerTableEntity *pokerTable;
@property (nonatomic, assign) BOOL isDirty;

-(void)updateSeatUI;
-(void)clearSeat;

@end
