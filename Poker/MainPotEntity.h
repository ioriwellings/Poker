//
//  MainPotEntity.h
//  Poker
//
//  Created by Iori on 8/8/16.
//  Copyright © 2016 Hointe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlayerEntity.h"

@interface MainPotEntity : NSObject

@property (nonatomic, assign) NSInteger mainPot;
@property (nonatomic, strong, readonly) NSMutableArray<PlayerEntity*> *players;

@end
