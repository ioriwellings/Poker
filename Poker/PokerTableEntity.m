//
//  HouseEntity.m
//  Poker
//
//  Created by Iori on 8/8/16.
//  Copyright © 2016 Hointe. All rights reserved.
//

#import "PokerTableEntity.h"

@implementation NextAction


@end

@implementation NextActionPlayer

-(instancetype)init
{
    if(self = [super init])
    {
        _nextPlayerIndex = -1;
    }
    return self;
}

-(void)loadNextActionFromDictOfArray:(NSArray<NSDictionary *> *)arrayDict
{
    self.nextActions = [NSMutableArray arrayWithCapacity:10];
    [arrayDict enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
    {
        NextAction *action = [NextAction new];
        action.status = [[obj objectForKey:@"type"] integerValue];
        action.value = [[obj objectForKey:@"value"] integerValue];
        [self.nextActions addObject:action];
    }];
}

@end

@implementation PokerTableEntity

static PokerTableEntity *_instance;

+(instancetype)sharedInstance
{
    if(_instance == nil)
        _instance = [PokerTableEntity new];
    return _instance;
}

-(instancetype)init
{
    self = [super init];
    if(self)
    {
        [self reset];
    }
    return self;
}

-(void)reset
{
    _tableStatus = PokerTableStatusEnumNone;
    _seats = [NSMutableArray arrayWithCapacity:10];
    _mainPots = [MainPotEntity new];
    _sidePots = [NSMutableArray arrayWithCapacity:10];
    _nextActionPlayer = [NextActionPlayer new];
    _communityCards = [NSMutableArray arrayWithCapacity:10];
}



-(void)updateUI
{
    if(self.tableStatus == PokerTableStatusEnumNone)
    {
        if([self.updateUIDelegate respondsToSelector:@selector(clearCommCard)])
        {
            [self.updateUIDelegate clearCommCard];
        }
    }
    else if(self.tableStatus == PokerTableStatusEnumFlop)
    {
        if([self.updateUIDelegate respondsToSelector:@selector(flopCard)])
        {
            [self.updateUIDelegate flopCard];
        }
    }
    else if (self.tableStatus == PokerTableStatusEnumTurn)
    {
        if([self.updateUIDelegate respondsToSelector:@selector(turnCard)])
        {
            [self.updateUIDelegate turnCard];
        }
    }
    else if (self.tableStatus == PokerTableStatusEnumRiver)
    {
        if([self.updateUIDelegate respondsToSelector:@selector(riverCard)])
        {
            [self.updateUIDelegate riverCard];
        }
    }
    [self.seats enumerateObjectsUsingBlock:^(SeatEntity * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
    {
        if(obj.player)
            [obj updateSeatUI];
        else
        {
            [obj clearSeat];
        }
    }];
}
@end
