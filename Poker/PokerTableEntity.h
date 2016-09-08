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
#import "RoomEntity.h"

@protocol PokerTableUpdateUIDelegate <NSObject>

-(void)clearCommCard;
-(void)flopCard;
-(void)turnCard;
-(void)riverCard;

@end

typedef NS_ENUM(NSUInteger, PokerTableStatusEnum) {
    PokerTableStatusEnumNone,
    PokerTableStatusEnumBet,
    PokerTableStatusEnumFlop,
    PokerTableStatusEnumTurn,
    PokerTableStatusEnumRiver
};

@interface NextAction : NSObject
@property (nonatomic, assign) PokerActionStatusEnum status;
@property (nonatomic, assign) NSInteger value;
@end

@interface NextActionPlayer : NSObject
@property (nonatomic, assign) NSInteger nextPlayerIndex;
@property (nonatomic, strong) NSMutableArray<NextAction*> *nextActions;
-(void)loadNextActionFromDictOfArray:(NSArray<NSDictionary*>*)arrayDict;
@end

@interface PokerTableEntity : NSObject

@property (nonatomic, strong) RoomEntity *roomInfo;
@property (nonatomic, strong, readonly) NSMutableArray<SeatEntity*> *seats;
@property (nonatomic, strong) MainPotEntity *mainPots;
@property (nonatomic, assign) PokerTableStatusEnum tableStatus;
@property (nonatomic, strong) NSMutableArray<SidePotEntity*> *sidePots;
@property (nonatomic, strong) NSMutableArray<PokerEntity*> *communityCards;
@property (nonatomic, weak) NSArray<NSArray<PlayerEntity*>*> *winers;
@property (nonatomic, strong) NextActionPlayer *nextActionPlayer;
@property (nonatomic, weak) PlayerEntity *foldPlayer;
@property (nonatomic, strong) NSDecimalNumber *minBring;
@property (nonatomic, strong) NSDecimalNumber *maxBring;

@property (nonatomic, assign) NSInteger sb;
@property (nonatomic, assign) NSInteger bb;

@property (nonatomic, assign) NSInteger cap;
@property (nonatomic, assign) NSInteger limit;

@property (nonatomic, weak) id<PokerTableUpdateUIDelegate> updateUIDelegate;

+(instancetype)sharedInstance;
-(void)updateUI;
@end
