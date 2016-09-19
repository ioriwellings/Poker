//
//  SidePotPlayerEntity.h
//  Poker
//
//  Created by Iori on 8/8/16.
//  Copyright © 2016 Hointe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainPotEntity.h"

@interface SidePotEntity : MainPotEntity

@property (nonatomic, assign) NSInteger bet;
@property (nonatomic, assign) NSInteger iLevel;
@property (nonatomic, strong) NSMutableArray<SidePotEntity*> *sidePots;

@end
