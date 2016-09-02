//
//  PokerHandsEntity.h
//  Poker
//
//  Created by Iori on 8/8/16.
//  Copyright © 2016 Hointe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PokerEntity.h"

@interface PokerHandsEntity : NSObject

@property (nonatomic, strong, readonly) NSMutableArray<PokerEntity*> *arrayPoker;
@property (nonatomic, assign) PokerPatternEnum pattern;
@property (nonatomic, readonly) NSString* patternStringValue;
@end
