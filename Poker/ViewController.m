//
//  ViewController.m
//  Poker
//
//  Created by Iori on 8/5/16.
//  Copyright © 2016 Hointe. All rights reserved.
//

#import "ViewController.h"
#import "IoriJsonHelper.h"
#import "UserInfo.h"

@implementation PokerAction
@end

@interface ViewController ()
{
    PokerTableEntity *pokerTable;
    NSMutableArray<PlayerEntity*> *arrayPlayer;
    NSMutableArray<PlayerEntity*> *arrayAudience;
    NSInteger round;
}
@end

@implementation ViewController

#pragma mark -pomelo-
-(void)reconnectToHost
{
    pomelo = [[Pomelo alloc] initWithDelegate:self];
    [pomelo connectToHost:@"192.168.0.101" onPort:3014 withCallback:^(Pomelo *p)
     {
         NSDictionary *params = [NSDictionary dictionaryWithObject:[UserInfo sharedUser].userID forKey:@"uid"];
         [pomelo requestWithRoute:@"gate.gateHandler.queryEntry" andParams:params andCallback:^(NSDictionary *result)
          {
              p.isDisconnectByUser = YES;
              [p disconnectWithCallback:^(Pomelo *p)
               {
                   [self entryWithData:result];
               }];
              
          }];
     }];
}

- (void)PomeloDidConnect:(Pomelo *)pomelo
{
    NSLog(@"-%s", __func__);
}
- (void)PomeloDidDisconnect:(Pomelo *)_pomelo withError:(NSError *)error;
{
    //NSLog(@"-%s, error:%@", __func__, error);
    if([[error.userInfo objectForKey:@"isDisconnectByUser"] boolValue] == NO)
    {
        [self reconnectToHost];
    }
    else
    {
        _pomelo.isDisconnectByUser = NO;
    }
}
- (void)Pomelo:(Pomelo *)pomelo didReceiveMessage:(NSArray *)message
{
    //NSLog(@"-%s, message:%@", __func__, message);
    NSDictionary *dict = (NSDictionary*)message;
    if([[dict objectForKey:@"code"] integerValue] == 500)
    {
        [self reconnectToHost];
    }
}
- (void)entryWithData:(NSDictionary *)data
{
    NSString *host = strServerIP = [data objectForKey:@"host"];
    NSInteger port = iServerPort = [[data objectForKey:@"port"] intValue];
    NSString *name = [UserInfo sharedUser].userID;
    NSString *channel = @"";
    [pomelo connectToHost:host
                   onPort:port
             withCallback:^(Pomelo *p)
    {
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                name, @"username",
                                channel, @"rid",
                                nil];
        [p requestWithRoute:@"connector.entryHandler.enter"
                  andParams:params
                andCallback:^(NSDictionary *result)
        {
            __weak typeof(self) weakself = self;
            //观战者
            NSArray *userList = [[result objectForKey:@"dataInfo"] objectForKey:@"observerPlayerList"];
            //房间信息
            NSDictionary *room = [[[result objectForKey:@"body"] objectForKey:@"dataInfo"] objectForKey:@"room"];
            RoomEntity *roomInfo = [RoomEntity new];
            roomInfo.roomBaseBigBlind = [[room objectForKey:@"roomBaseBigBlind"] integerValue];
            roomInfo.roomBaseSmallBlind = [[room objectForKey:@"roomBaseSmallBlind"] integerValue];
            pokerTable.sb = roomInfo.roomBaseSmallBlind;
            pokerTable.bb = roomInfo.roomBaseBigBlind;
            pokerTable.roomInfo = roomInfo;
            //在坐玩家
            NSArray *arrayPlayerList = [[[result objectForKey:@"dataInfo"] objectForKey:@"game"] objectForKey:@"playerList"];
            [arrayPlayerList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if([obj isKindOfClass:[NSNull class]] == NO)
                {
                    NSDictionary *dictPlayer = obj;
                    PlayerEntity *player = [self getPlayerFromDictionary:dictPlayer];
                    [arrayPlayer addObject:player];
                }
            }];
            [self player2Seat];
            [self updateTableInfoUI];
            
            [p onRoute:@"onNewPlayerEnter" withCallback:^(NSDictionary *data)
            {
                [self onNewPlayerEnter:data];
            }];
            [p onRoute:@"onFlop" withCallback:^(id callback)
            {
                [self onFlop:(NSDictionary *)callback];
            }];
            [p onRoute:@"onTurn" withCallback:^(id callback)
            {
                [self onTurn:(NSDictionary *)callback];
            }];
            [p onRoute:@"onRiver" withCallback:^(id callback)
            {
                [self onRiver:(NSDictionary *)callback];
            }];
            [p onRoute:@"onSitDown" withCallback:^(id callback)
            {
                [self onSitDown:(NSDictionary *)callback];
            }];
            [p onRoute:@"onEnterRomm" withCallback:^(id callback)
            {
                ;
            }];
            [p onRoute:@"onGameStart" withCallback:^(id callback)
            {
                [self onGameStart:(NSDictionary *)callback];
            }];
            [p onRoute:@"onCall" withCallback:^(id callback)
            {
                [self onCall:(NSDictionary *)callback];
            }];
            [p onRoute:@"onCheck" withCallback:^(id callback)
            {
                [self onCheck:(NSDictionary *)callback];
            }];
            [p onRoute:@"onAllIn" withCallback:^(id callback)
            {
                [self onAllIn:(NSDictionary *)callback];
            }];
            [p onRoute:@"onRaise" withCallback:^(id callback)
            {
                [self onRaise:(NSDictionary *)callback];
            }];
            [p onRoute:@"onFold" withCallback:^(id callback)
            {
                [self onFold:(NSDictionary *)callback];
            }];
            [p onRoute:@"onShowdown" withCallback:^(id callback)
            {
                [self onShowdown:(NSDictionary *)callback];
            }];
        }];
    }];
}

-(void)setNextActionPlayerFromDict:(NSDictionary*)dict
{
    pokerTable.nextActionPlayer.nextPlayerIndex = [IoriJsonHelper getIntegerForKey:@"tokenPlayerIndex" fromDict:dict];
    [pokerTable.nextActionPlayer
     loadNextActionFromDictOfArray:(NSArray*)[IoriJsonHelper
                                              getObjectForKey:@"tokenPlayerAction"
                                              fromDict:dict]];
}

-(void)commandReceiveCenter:(PokerAction *)action  //receiveAction and response from server.
{
    if(action.actionType == PokerActionEnumSitDown)
    {
        [arrayPlayer addObject:action.player];
    }
    else if (action.actionType == PokerActionEnumCall)
    {
        action.player.actionStatus = PokerActionStatusEnumCall;
        action.player.bet = action.player.bet;
    }
    else if (action.actionType == PokerActionEnumCheck)
    {
        action.player.actionStatus = PokerActionEnumCheck;
        action.player.bet = action.player.bet;
    }
    
    //response server;
    
    [self player2Seat];
    if(round == 0)
    {
        PlayerEntity *player = pokerTable.seats[0].player;
        player.actionStatus = PokerActionStatusEnumWaitingNext;
    }
    else if (round == 1)
    {
        PlayerEntity *player = pokerTable.seats[0].player;
        player.actionStatus = PokerActionStatusEnumSB;
        player.bet = pokerTable.sb;
        [self markerActionSeat:pokerTable.seats[0]];
        
        player = pokerTable.seats[1].player;
        player.actionStatus = PokerActionStatusEnumBB;
        player.bet = pokerTable.bb;
        
        CardHelper *helper = [CardHelper sharedInstance];
        NSArray<PokerEntity*> *array = [helper getShuffle];
        [helper makePoker:array[0] containerView:self.card1];
        [helper makePoker:array[1] containerView:self.card0];
    }
    else if (round == 2)
    {
        PlayerEntity *player = pokerTable.seats[0].player;
        player.actionStatus = PokerActionStatusEnumCall;
        player.bet = pokerTable.bb;
        
        [self markerActionSeat:pokerTable.seats[1]];
    }
    else if (round == 3)
    {
        PlayerEntity *player = pokerTable.seats[1].player;
        player.actionStatus = PokerActionStatusEnumCheck;
        //player.bet = 0;
        
        [self flopCard];
        
        [self markerActionSeat:pokerTable.seats[1]];
    }
    else if (round == 4)
    {
        //play01 checked;
        [self markerActionSeat:pokerTable.seats[0]];
    }
    else if (round == 5)
    {
        //player02 checked
        //turn
        PlayerEntity *player = pokerTable.seats[0].player;
        player.actionStatus = PokerActionStatusEnumCheck;
        player.bet = 0;
        [self markerActionSeat:pokerTable.seats[1]];
        [self turnCard];
    }
    else if (round == 6)
    {
        PlayerEntity *player = pokerTable.seats[1].player;
        player.actionStatus = PokerActionStatusEnumCheck;
        player.bet = 0;
        [self markerActionSeat:pokerTable.seats[0]];
    }
    else if(round == 7)
    {
        PlayerEntity *player = pokerTable.seats[0].player;
        player.actionStatus = PokerActionStatusEnumNone;
        player.bet = 0;
        player.isWiner = YES;
        
        player = pokerTable.seats[1].player;
        player.actionStatus = PokerActionStatusEnumNone;
        player.bet = 0;
        player.isWiner = NO;
        
        [self markerNormalSeat:pokerTable.seats[0]];
        [self riverCard];
        //river
    }
    
    [self updateTableInfoUI];
}

#pragma mark - commPokerMethods

-(void)onNewPlayerEnter:(NSDictionary*)dict
{
    NSLog(@"onRoute:onNewPlayerEnter------");
    NSDictionary *dictP = [IoriJsonHelper getDictForKey:@"observerPlayerList" fromDict:dict];
    PlayerEntity *player = [self getPlayerFromDictionary:dictP];
    [arrayAudience addObject:player];
}

-(void)onFlop:(NSDictionary*)dict
{
    [self loadFlopCardFromDict:(NSDictionary*)dict];
    [self updateTableInfoUI];
}

-(void)onTurn:(NSDictionary*)dict
{
    [self loadTurnCardFromDict:(NSDictionary *)dict];
    [self updateTableInfoUI];
}

-(void)onRiver:(NSDictionary*)dict
{
    [self loadRiverCardFromDict:(NSDictionary *)dict];
    [self updateTableInfoUI];
}

-(void)onSitDown:(NSDictionary*)dict
{
    NSDictionary *player = [IoriJsonHelper getDictForKey:@"observerPlayerList" fromDict:dict];
    NSString *playerID = [player objectForKey:@"playerID"];
    __block NSInteger iFoundIndex = -1;
    [arrayAudience enumerateObjectsUsingBlock:^(PlayerEntity * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
    {
        if([obj.playerID isEqualToString:playerID])
        {
            iFoundIndex = idx;
            *stop = YES;
        }
    }];
    if(iFoundIndex != -1)
    {
        [arrayAudience removeObjectAtIndex:iFoundIndex];
    }
    PlayerEntity *playerObj = [self getPlayerFromDictionary:[IoriJsonHelper getDictForKey:@"playerList" fromDict:dict]];
//    playerObj.iSeatIndex =
    [arrayPlayer addObject:playerObj];
    [self player2Seat];
    [self updateTableInfoUI];
}

-(void)onGameStart:(NSDictionary*)dict
{
    NSDictionary *dictBody = [IoriJsonHelper getDictForKey:@"body" fromDict:dict];
    NSDictionary *dictGame = [[dictBody objectForKey:@"Data"] objectForKey:@"game"];
    NSArray<NSDictionary*> *arrayPlayerList = [dictGame objectForKey:@"playerList"];
    NSArray<NSDictionary*> *arrayCardList = [[dictGame objectForKey:@"playerCardList"] objectForKey:@"card"];
    [arrayPlayer removeAllObjects];
    pokerTable.tableStatus = (PokerTableStatusEnum)[[dictGame objectForKey:@"gameState"] integerValue];
    pokerTable.sb = [IoriJsonHelper getIntegerForKey:@"smallBlind" fromDict:dictGame];
    pokerTable.bb = [IoriJsonHelper getIntegerForKey:@"bigBlind" fromDict:dictGame];
    pokerTable.mainPots.mainPot = 0;
    [arrayPlayerList enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull playerObj2, NSUInteger idx2, BOOL * _Nonnull stop2)
     {
         if([playerObj2 isKindOfClass:[NSNull class]] ==NO)
         {
             PlayerEntity *player = [self getPlayerFromDictionary:playerObj2];
             [arrayPlayer addObject:player];
             if(player.isSmallBlind)
                 player.bet = pokerTable.sb;
             if(player.isBigBlind)
                 player.bet = pokerTable.bb;
             if([player.playerID isEqualToString:[UserInfo sharedUser].userID])
             {
                 PokerEntity *poker = [PokerEntity new];
                 poker.pokerSuit = (PokerSuitEnum)[[arrayCardList[0] objectForKey:@"color"] integerValue];
                 poker.numberValue = [[arrayCardList[0] objectForKey:@"value"] integerValue];
                 [player.handCard.arrayPoker addObject:poker];
                 poker = [PokerEntity new];
                 poker.pokerSuit = (PokerSuitEnum)[[arrayCardList[1] objectForKey:@"color"] integerValue];
                 poker.numberValue = [[arrayCardList[1] objectForKey:@"value"] integerValue];
                 [player.handCard.arrayPoker addObject:poker];
                 //player.handCard.patternStringValue = [[dictGame objectForKey:@"playerCardList"] objectForKey:@"cardType"];
             }
             else
             {
                 
             }
         }
     }];
    NSDictionary *dictNextPlayer = [[dictBody objectForKey:@"Data"] objectForKey:@"tokenPlayer"];
    [self setNextActionPlayerFromDict:dictNextPlayer];
    [self player2Seat];
    [self updateTableInfoUI];
}

-(void)onCall:(NSDictionary*)callback
{
    [self mergePlayer:(NSDictionary*)callback];
    [self setNextActionPlayerFromDict:(NSDictionary*)callback];
    [self updateTableInfoUI];
}

-(void)onCheck:(NSDictionary*)callback
{
    [self mergePlayer:(NSDictionary*)callback];
    [self setNextActionPlayerFromDict:(NSDictionary*)callback];
    [self updateTableInfoUI];
}

-(void)onAllIn:(NSDictionary*)callback
{
    [self mergePlayer:(NSDictionary*)callback];
    [self setNextActionPlayerFromDict:(NSDictionary*)callback];
    [self updateTableInfoUI];
}

-(void)onRaise:(NSDictionary*)callback
{
    [self mergePlayer:(NSDictionary*)callback];
    [self setNextActionPlayerFromDict:(NSDictionary*)callback];
    [self updateTableInfoUI];
}

-(void)onFold:(NSDictionary*)callback
{
    [self mergePlayer:(NSDictionary*)callback];
    [self setNextActionPlayerFromDict:(NSDictionary*)callback];
    PlayerEntity *foldPlayer = [self getPlayerFromDictionary:[IoriJsonHelper getDictForKey:@"playerList" fromDict:(NSDictionary*)callback]];
    pokerTable.foldPlayer = foldPlayer;
    [arrayPlayer enumerateObjectsUsingBlock:^(PlayerEntity * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         if ([obj.playerID isEqualToString:foldPlayer.playerID])
         {
             //[weakself mergePlayer:obj newPlayer:foldPlayer]
             [arrayPlayer replaceObjectAtIndex:idx withObject:foldPlayer];
         };
     }];
    //[self player2Seat];
    [self updateTableInfoUI];
}

-(void)onShowdown:(NSDictionary*)callback
{
    [pokerTable.mainPots.players removeAllObjects];
    [pokerTable.nextActionPlayer.nextActions removeAllObjects];
    pokerTable.nextActionPlayer.nextPlayerIndex = -1;
    NSArray<NSDictionary*> *arrayWiners = [IoriJsonHelper getArrayForKey:@"MainPools" fromDict:(NSDictionary*)callback];
    [arrayWiners enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         //WINER PLAYERID;
         NSString *playerID = [IoriJsonHelper getStringForKey:@"playerID" fromDict:obj];
         [arrayPlayer enumerateObjectsUsingBlock:^(PlayerEntity * _Nonnull obj2, NSUInteger idx2, BOOL * _Nonnull stop2)
          {
              if([playerID isEqualToString:obj2.playerID])
              {
                  [pokerTable.mainPots.players addObject:obj2];
                  obj2.actionStatus = PokerActionStatusEnumNone;
                  obj2.isWiner = YES;
                  obj2.handCard.pattern = (PokerPatternEnum)[IoriJsonHelper getIntegerForKey:@"cardtype" fromDict:obj];
                  //obj2.handCard.patternStringValue = [[dictGame objectForKey:@"playerCardList"] objectForKey:@"cardType"];
                  *stop2 = YES;
              }
          }];
     }];
    NSArray<NSDictionary*> *arraySidePools = [IoriJsonHelper getArrayForKey:@"BPools" fromDict:(NSDictionary*)callback];
    //
    [self player2Seat];
    [self countBet];
    [self updateTableInfoUI];
}

-(PlayerEntity*)mergePlayer:(NSDictionary*)dict
{
    __block PlayerEntity *result = nil;
    PlayerEntity *actionPlayer = [self getPlayerFromDictionary:[IoriJsonHelper getDictForKey:@"playerList"
                                                                                    fromDict:dict]];
    [arrayPlayer enumerateObjectsUsingBlock:^(PlayerEntity * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
    {
       if([obj.playerID isEqualToString:actionPlayer.playerID])
       {
           [self mergePlayer:obj newPlayer:actionPlayer];
           result = obj;
            *stop = YES;
       }
    }];
    return result;
}

-(PlayerEntity*)mergePlayer:(PlayerEntity*)oldPlayer newPlayer:(PlayerEntity*)newPlayer
{
    if(newPlayer.bet == 0)
    {
        oldPlayer.bet = 0;
    }
    else
    {
        oldPlayer.bet = newPlayer.bet;
    }
    oldPlayer.isSmallBlind = newPlayer.isSmallBlind;
    oldPlayer.isBigBlind = newPlayer.isBigBlind;
    oldPlayer.isButton = newPlayer.isButton;
    oldPlayer.actionStatus = newPlayer.actionStatus;
    oldPlayer.bringInMoney = newPlayer.bringInMoney;
    oldPlayer.ownMoney = newPlayer.ownMoney;
    return oldPlayer;
}

-(PlayerEntity*)getPlayerFromDictionary:(NSDictionary*)dict
{
    PlayerEntity *playerObj = [PlayerEntity new];
    playerObj.iSeatIndex = [[dict objectForKey:@"playerIndex"] integerValue];
    playerObj.playerID = [dict objectForKey:@"playerID"];
    playerObj.name = [dict objectForKey:@"playerName"];
    playerObj.imageHead = [dict objectForKey:@"playerHead"];
    playerObj.ownMoney = [[dict objectForKey:@"playerMoney"] integerValue];
    playerObj.bringInMoney = [[dict objectForKey:@"playerhasJetton"] integerValue];
    playerObj.actionStatus = [[dict objectForKey:@"playerState"] integerValue];
    playerObj.isButton = [[dict objectForKey:@"isDealer"] boolValue];
    playerObj.isSmallBlind = [[dict objectForKey:@"isSB"] boolValue];
    playerObj.isBigBlind = [[dict objectForKey:@"isBB"] boolValue];
    playerObj.bet = [[dict objectForKey:@"chipInTurn"] integerValue];
    return playerObj;
}

-(void)initTableLayout//初始化座位
{
    arrayAudience = [NSMutableArray arrayWithCapacity:10];
    arrayPlayer = [NSMutableArray arrayWithCapacity:10];
    PokerTableEntity *table = [PokerTableEntity sharedInstance];
    table.updateUIDelegate = self;
    pokerTable = table;
    table.bb = 20;
    table.sb= 10;
    
    UISeat *seatView01 = (UISeat*)self.seat02;  //顶部坐位
    seatView01.labName = self.labPlayer02;
    seatView01.labBet = self.labBetPlayer02;
    seatView01.labBringIn = self.labBring02;
    seatView01.labStatus = self.labStatusPlayer02;
    //    seatView01
    SeatEntity *seat =[SeatEntity new];
    seat.iIndex = 1;
    seat.seatView = seatView01;
    seat.pokerTable = pokerTable;
    [pokerTable.seats addObject:seat];
    
    seatView01 = (UISeat*)self.seat01; //底部坐位
    seatView01.labName = self.labPlayerName;
    seatView01.labBet = self.labBetPlayer01;
    seatView01.labBringIn = self.labBring01;
    seatView01.labStatus = self.labStatusPlayer01;
    seatView01.poker00 = self.card0;
    seatView01.poker01 = self.card1;
    seat = [SeatEntity new];
    seat.iIndex = 0;
    seat.seatView = seatView01;
    seat.pokerTable = pokerTable;
    [pokerTable.seats addObject:seat];
}

-(void)getTableInfoFromService //假设第一次请求数据库服务，这时有一个玩家来了。
{
    //if(round == 0)
    {
        PlayerEntity *player02 = [PlayerEntity new];
        player02.iSeatIndex =1;
        player02.bringInMoney = 400;
        player02.name = @"Player02";
        
        PokerAction *action = [PokerAction new];
        action.player = player02;
        action.actionType = PokerActionEnumSitDown;
        [self commandReceiveCenter:action];
        //round +=1;
    }
    //    else if (round == 1)
    //    {
    //        PlayerEntity *player02 = pokerTable.seats[0].player;
    //        player02.actionStatus = PokerActionStatusEnumCall;
    //        player02.bet = 20;
    //        [PokerAction sharedInstance].player = player02;
    //        [PokerAction sharedInstance].action = PokerActionEnumCall;
    //        [[PokerAction sharedInstance] playActionBehaviour];
    //        [self player2Seat];
    //        [self updateTableInfoUI];
    //        //round +=1;
    //    }
    //    else if (round == 2)
    //    {
    //
    //    }
}

-(void)updateTableInfoUI
{
    [pokerTable updateUI];
    if(pokerTable.mainPots.mainPot > 0)
    {
        self.labPotBet.text = [NSString stringWithFormat:@"%ld", pokerTable.mainPots.mainPot];
    }
}

-(void)player2Seat
{
    [arrayPlayer enumerateObjectsUsingBlock:^(PlayerEntity * _Nonnull player, NSUInteger idx, BOOL * _Nonnull stop) {
        [pokerTable.seats enumerateObjectsUsingBlock:^(SeatEntity * _Nonnull seat, NSUInteger idx, BOOL * _Nonnull stop) {
            if(player.iSeatIndex == seat.iIndex)
            {
                seat.player = player;
                *stop = YES;
            }
        }];
    }];
}

-(void)markerActionSeat:(SeatEntity *)seat
{
    if(lastActionSeat)
    {
        [self markerNormalSeat:lastActionSeat];
    }
    lastActionSeat = seat;
    seat.seatView.backgroundColor = [UIColor greenColor];
}

-(void)markerNormalSeat:(SeatEntity *)seat
{
    seat.seatView.backgroundColor =  [UIColor redColor];
}

-(void)flopCard
{
    CardHelper *helper = [CardHelper sharedInstance];
    NSArray<PokerEntity*> *array = [helper getShuffle];
//    [helper makePoker:array[2] containerView:self.card01];
//    [helper makePoker:array[40] containerView:self.card02];
//    [helper makePoker:array[42] containerView:self.card03];
    
    [self countBet];

    [array enumerateObjectsUsingBlock:^(PokerEntity * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         NSInteger iFound = 0;
         if(obj.numberValue == pokerTable.communityCards[0].numberValue
            && obj.pokerSuit ==  pokerTable.communityCards[0].pokerSuit)
         {
             [helper makePoker:array[idx] containerView:self.card01];
             iFound ++;
         }
         else if(obj.numberValue == pokerTable.communityCards[1].numberValue
            && obj.pokerSuit ==  pokerTable.communityCards[1].pokerSuit)
         {
             [helper makePoker:array[idx] containerView:self.card02];
             iFound ++;
         }
         else if(obj.numberValue == pokerTable.communityCards[2].numberValue
            && obj.pokerSuit ==  pokerTable.communityCards[2].pokerSuit)
         {
             [helper makePoker:array[idx] containerView:self.card03];
             iFound ++;
         }
         if(iFound > 2)
         {
             *stop = YES;
         }
     }];

}

-(void)turnCard
{
    CardHelper *helper = [CardHelper sharedInstance];
    NSArray<PokerEntity*> *array = [helper getShuffle];
//    [helper makePoker:array[13] containerView:self.card04];
    
    [self countBet];
    
    [array enumerateObjectsUsingBlock:^(PokerEntity * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         NSInteger iFound = 0;
         if(obj.numberValue == pokerTable.communityCards[3].numberValue
            && obj.pokerSuit ==  pokerTable.communityCards[3].pokerSuit)
         {
             [helper makePoker:array[idx] containerView:self.card04];
             iFound ++;
         }
         if(iFound > 0)
         {
             *stop = YES;
         }
     }];
}

-(void)riverCard
{
    CardHelper *helper = [CardHelper sharedInstance];
    NSArray<PokerEntity*> *array = [helper getShuffle];
//    [helper makePoker:array[14] containerView:self.card05];
    
    [self countBet];
    
    [array enumerateObjectsUsingBlock:^(PokerEntity * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         NSInteger iFound = 0;
         if(obj.numberValue == pokerTable.communityCards[4].numberValue
            && obj.pokerSuit ==  pokerTable.communityCards[4].pokerSuit)
         {
             [helper makePoker:array[idx] containerView:self.card05];
             iFound ++;
         }
         if(iFound > 0)
         {
             *stop = YES;
         }
     }];
}

-(void)loadFlopCardFromDict:(NSDictionary*)dict
{
    NSArray<NSDictionary*> *arrayCardList = [IoriJsonHelper getArrayForKey:@"publicCardList" fromDict:dict];
    [arrayCardList enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
    {
        PokerEntity *poker = [PokerEntity new];
        poker.pokerSuit = (PokerSuitEnum)[[obj objectForKey:@"color"] integerValue];
        poker.numberValue = [[obj objectForKey:@"value"] integerValue];
        [pokerTable.communityCards addObject:poker];
    }];
    pokerTable.tableStatus = PokerTableStatusEnumFlop;
}

-(void)loadTurnCardFromDict:(NSDictionary*)dict
{
    NSArray<NSDictionary*> *arrayCardList = [IoriJsonHelper getArrayForKey:@"publicCardList" fromDict:dict];
    PokerEntity *poker = [PokerEntity new];
    poker.pokerSuit = (PokerSuitEnum)[[arrayCardList[0] objectForKey:@"color"] integerValue];
    poker.numberValue = [[arrayCardList[0] objectForKey:@"value"] integerValue];
    [pokerTable.communityCards addObject:poker];
    pokerTable.tableStatus = PokerTableStatusEnumTurn;
}

-(void)loadRiverCardFromDict:(NSDictionary*)dict
{
    NSArray<NSDictionary*> *arrayCardList = [IoriJsonHelper getArrayForKey:@"publicCardList" fromDict:dict];
    PokerEntity *poker = [PokerEntity new];
    poker.pokerSuit = (PokerSuitEnum)[[arrayCardList[0] objectForKey:@"color"] integerValue];
    poker.numberValue = [[arrayCardList[0] objectForKey:@"value"] integerValue];
    [pokerTable.communityCards addObject:poker];
    pokerTable.tableStatus = PokerTableStatusEnumRiver;
}


-(void)countBet
{
    [pokerTable.seats enumerateObjectsUsingBlock:^(SeatEntity * _Nonnull seat, NSUInteger idx, BOOL * _Nonnull stop) {
        UISeat *view = seat.seatView;
        view.labBet.text = @"";
        if(seat.player.bet != 0)
        {
            pokerTable.mainPots.mainPot += seat.player.bet;
        }
        seat.player.bet = 0;
    }];
    //self.labPotBet.text = [NSString stringWithFormat:@"%ld", pokerTable.mainPots.mainPot];
}

#pragma mark - viewcontroller life-

- (void)viewDidLoad
{
    [super viewDidLoad];
    [UserInfo sharedUser].userID = @"iori";
    // Do any additional setup after loading the view, typically from a nib.
    
    [self initTableLayout];
    
    //[self performSelector:@selector(getTableInfoFromService) withObject:nil afterDelay:5];
    
    [self reconnectToHost];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction

- (IBAction)btnSitDown_click:(UIButton *)sender
{
//    PlayerEntity *player = [PlayerEntity new];
//    player.iSeatIndex =0;
//    player.bringInMoney = 10000;
//    player.bet = 20;
//    player.name = @"Iori";
//    player.actionStatus = PokerActionStatusEnumNone;
//    player.isBigBlind = YES;
//    PokerAction *action = [PokerAction new];
//    action.player = player;
//    action.actionType = PokerActionEnumSitDown;
//    round++;
//    [self commandReceiveCenter:action];
    [pomelo requestWithRoute:@"game.gameHandler.sitDown" andParams:@{@"index":@(0)} andCallback:^(id callback) {
        ;
    }];
}

- (IBAction)btnStandUp_click:(UIButton *)sender
{
}

- (IBAction)btnCheck_click:(UIButton *)sender
{
    [pomelo requestWithRoute:@"game.gameHandler.check" andParams:@{} andCallback:^(id callback) {
        ;
    }];
}

- (IBAction)btnCall_click:(UIButton *)sender
{
    [pomelo requestWithRoute:@"game.gameHandler.call" andParams:@{} andCallback:^(id callback) {
        ;
    }];
//    PokerAction *action = [PokerAction new];
//    action.player = arrayPlayer[1];
//    action.actionType = PokerActionEnumCheck;
//    round++;
//    [self commandReceiveCenter:action];
}

- (IBAction)btnRaise_click:(UIButton *)sender
{
    [pomelo requestWithRoute:@"game.gameHandler.raise" andParams:@{@"chip":@(1)} andCallback:^(id callback) {
        ;
    }];
}

- (IBAction)btnAllin_click:(UIButton *)sender
{
    [pomelo requestWithRoute:@"game.gameHandler.allIn" andParams:@{} andCallback:^(id callback) {
        ;
    }];
}

- (IBAction)btnFold_click:(UIButton *)sender
{
    [pomelo requestWithRoute:@"game.gameHandler.fold" andParams:@{} andCallback:^(id callback) {
        ;
    }];
}

- (IBAction)btnPlayer02_click:(UIButton *)sender
{
    PlayerEntity *player = arrayPlayer[0];
    player.bet = 20;
    //    player.actionStatus = PokerActionStatusEnumCall;
    PokerAction *action = [PokerAction new];
    action.player = player;
    action.actionType = PokerActionEnumCall;
    round++;
    [self commandReceiveCenter:action];
}

- (IBAction)btnStart_click:(UIButton *)sender
{
    [pomelo requestWithRoute:@"game.gameHandler.gameStart" andParams:@{} andCallback:^(id callback) {
        
    }];
}

- (IBAction)btnCheck2_click:(UIButton *)sender
{
    [pomelo requestWithRoute:@"game.gameHandler.playerAction"
                   andParams:@{@"playerID":@"112211",
                              @"actionType":@(PokerActionEnumCheck)} andCallback:^(id callback)
    {
        ;
    }];
}

@end
