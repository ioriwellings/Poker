//
//  PokerTableViewControler.m
//  Poker
//
//  Created by Iori on 9/2/16.
//  Copyright © 2016 Hointe. All rights reserved.
//

#import "PokerTableViewControler.h"
#import "IQKeyboardManager.h"
#import "UIView+DCAnimationKit.h"
#import "MessageBox.h"
#import "NSString+AudioFile.h"
#import "Masonry.h"
#import "Config.h"
#import "GloubVariables.h"

@interface PokerTableViewControler ()
{
}
@property (nonatomic, assign) BOOL hasFlopCard;
@property (nonatomic, assign) BOOL hasTurnCard;
@end

@implementation PokerTableViewControler

#pragma mark -play sound effect-

-(void)playSoundFaPai
{
    [@"fapai.wav" playSoundEffect];
}

-(void)playSoundFlop
{
    [@"fapai3.wav" playSoundEffect];
}

-(void)playSoundFold
{
    [@"foldpai.wav" playSoundEffect];
}

-(void)playDingDing
{
    [@"half_time.wav" playSoundEffect];
}

-(void)playDongDong
{
    [@"dongdong.wav" playSoundEffect];
}

-(void)playSoundChip
{
    [@"chip.wav" playSoundEffect];
}

-(void)playSoundBetCount
{
    [@"chipfly.wav" playSoundEffect];
}

-(void)playSoundOnTurn
{
    [@"on_turn.wav" playSoundEffect];
}

#pragma mark -pomelo method-

-(void)reconnectToHost
{
    __weak typeof(self) ws = self;
    [MessageBox displayLoadingInView:ws.view];
    if(self.OnePomelo != nil)
    {
        pomelo = self.OnePomelo;
    }
    else
    {
        pomelo = [[Pomelo alloc] initWithDelegate:ws];
    }
//    [pomelo connectToHost:PK_SERVER_IP onPort:PK_SERVER_PORT withCallback:^(Pomelo *p)
//     {
//         NSDictionary *params = [NSDictionary dictionaryWithObject:[UserInfo sharedUser].userID forKey:@"uid"];
//    Pomelo *p = self.OnePomelo;
//         [p requestWithRoute:@"gate.gateHandler.queryEntry"
//                   andParams:params
//                 andCallback:^(NSDictionary *result)
//          {
//              p.isDisconnectByUser = YES;
//              [p disconnectWithCallback:^(Pomelo *p)
//               {
//                   [MessageBox removeLoading:nil];
                   [ws entryWithData:nil];
//               }];
//              
//          }];
//     }];
}

- (void)PomeloDidConnect:(Pomelo *)pomelo
{
    NSLog(@"-%s", __func__);
}
- (void)PomeloDidDisconnect:(Pomelo *)_pomelo withError:(NSError *)error;
{
    //NSLog(@"-%s, error:%@", __func__, error);
    [MessageBox removeLoading:nil];
    if([[error.userInfo objectForKey:@"isDisconnectByUser"] boolValue] == NO)
    {
        //[self reconnectToHost];
    }
    else
    {
        _pomelo.isDisconnectByUser = NO;
    }
}
- (void)Pomelo:(Pomelo *)pomelo didReceiveMessage:(NSArray *)message
{
    //NSLog(@"-%s, message:%@", __func__, message);
    __weak typeof(self) ws = self;
    NSDictionary *dict = (NSDictionary*)message;
    if([[dict objectForKey:@"code"] integerValue] == 500)
    {
        //[ws reconnectToHost];
    }
}
- (void)entryWithData:(NSDictionary *)data
{
    __weak typeof(self) ws = self;
//    NSString *host = strServerIP = [data objectForKey:@"host"];
//    NSInteger port = iServerPort = [[data objectForKey:@"port"] intValue];
//    NSString *name = [UserInfo sharedUser].userID;
//    NSString *channel = [UserInfo sharedUser].roomName;
//    [pomelo connectToHost:host
//                   onPort:port
//             withCallback:^(Pomelo *p)
//     {
         NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [UserInfo sharedUser].userID, @"username",
                                 [UserInfo sharedUser].roomName, @"rid",
                                 nil];
    Pomelo *p = self.OnePomelo;
         [self.OnePomelo requestWithRoute:@"connector.entryHandler.enter"
                   andParams:params
                 andCallback:^(NSDictionary *result)
          {
              [ws initTableLayout];
              //观战者
              NSArray *userList = [[result objectForKey:@"dataInfo"] objectForKey:@"observerPlayerList"];
              NSLog(@"%@",userList);
              //房间信息
              NSDictionary *room = [IoriJsonHelper getDictForKey:@"room" fromDict:result];
              RoomEntity *roomInfo = [RoomEntity new];
              roomInfo.roomID = [room objectForKey:@"roomID"];
              roomInfo.roomName = [room objectForKey:@"roomName"];
              roomInfo.roomBaseBigBlind = [IoriJsonHelper getIntegerForKey:@"roomBaseBigBlind" fromDict:room];
              roomInfo.roomBaseSmallBlind = [IoriJsonHelper getIntegerForKey:@"roomBaseSmallBlind" fromDict:room];
              pokerTable.sb = roomInfo.roomBaseSmallBlind;
              pokerTable.bb = roomInfo.roomBaseBigBlind;
              pokerTable.roomInfo = roomInfo;
              ws.labRoom.text = [NSString stringWithFormat:@"Room:%@", roomInfo.roomID];
              
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
              [ws player2Seat];
              [self markDirtySeatWithPlayerArray:arrayPlayer];
              [ws updateTableInfoUI];
              [MessageBox removeLoading:nil];
              
              [p onRoute:@"onNewPlayerEnter" withCallback:^(NSDictionary *data)
               {
                   [ws onNewPlayerEnter:data];
               }];
              [p onRoute:@"onFlop" withCallback:^(id callback)
               {
                   [ws onFlop:(NSDictionary *)callback];
               }];
              [p onRoute:@"onTurn" withCallback:^(id callback)
               {
                   [ws onTurn:(NSDictionary *)callback];
               }];
              [p onRoute:@"onRiver" withCallback:^(id callback)
               {
                   [ws onRiver:(NSDictionary *)callback];
               }];
              [p onRoute:@"onSitDown" withCallback:^(id callback)
               {
                   [ws onSitDown:(NSDictionary *)callback];
               }];
              [p onRoute:@"onEnterRomm" withCallback:^(id callback)
               {
                   ;
               }];
              [p onRoute:@"onGameStart" withCallback:^(id callback)
               {
                   [ws onGameStart:(NSDictionary *)callback];
               }];
              [p onRoute:@"onCall" withCallback:^(id callback)
               {
                   [ws onCall:(NSDictionary *)callback];
               }];
              [p onRoute:@"onCheck" withCallback:^(id callback)
               {
                   [ws onCheck:(NSDictionary *)callback];
               }];
              [p onRoute:@"onAllIn" withCallback:^(id callback)
               {
                   [ws onAllIn:(NSDictionary *)callback];
               }];
              [p onRoute:@"onRaise" withCallback:^(id callback)
               {
                   [ws onRaise:(NSDictionary *)callback];
               }];
              [p onRoute:@"onFold" withCallback:^(id callback)
               {
                   [ws onFold:(NSDictionary *)callback];
               }];
              [p onRoute:@"onShowdown" withCallback:^(id callback)
               {
                   [ws onShowdown:(NSDictionary *)callback];
               }];
              [p onRoute:@"onPlayerKick" withCallback:^(id callback)
              {
                  [ws onPlayerKick:(NSDictionary *)callback];;
              }];
          }];
//     }];
}

-(void)setNextActionPlayerFromDict:(NSDictionary*)dict
{
    NSString *strValue = [IoriJsonHelper getStringForKey:@"tokenPlayerIndex" fromDict:dict];
    if(strValue == nil)
    {
        pokerTable.nextActionPlayer.nextPlayerIndex = -1;
    }
    else
        pokerTable.nextActionPlayer.nextPlayerIndex = [strValue integerValue];
    [pokerTable.nextActionPlayer
     loadNextActionFromDictOfArray:(NSArray*)[IoriJsonHelper
                                              getObjectForKey:@"tokenPlayerAction"
                                              fromDict:dict]];
}

-(void)loadChipsInfo:(NSDictionary*)dict
{
    __weak typeof(self) ws = self;
    NSArray<NSDictionary*> *arrayChips = [IoriJsonHelper getArrayForKey:@"chips" fromDict:dict];
    [arrayChips enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
    {
        UIView *potView = ws.betPots[idx];
        UILabel* labBet = potView.subviews[0];
        NSNumberFormatter *formater = [NSNumberFormatter alloc];
        formater.numberStyle = NSNumberFormatterDecimalStyle;
        NSInteger iBet = [[obj objectForKey:@"value"] integerValue];
        labBet.text = [formater stringFromNumber:[NSNumber numberWithInteger:iBet]];
        potView.hidden = NO;
    }];
}

//隐藏边池
-(void)hiddenChips
{
    [self.betPots enumerateObjectsUsingBlock:^(UIView*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
    {
        obj.hidden = YES;;
    }];
}

-(void)markDirtySeatWithPlayer:(PlayerEntity*)player
{
    [pokerTable.seats enumerateObjectsUsingBlock:^(SeatEntity * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(obj.player.iSeatIndex == player.iSeatIndex)
        {
            obj.isDirty = YES;
            *stop = YES;
        }
    }];
}

-(void)markDirtySeatWithPlayerArray:(NSArray<PlayerEntity*>*)players
{
    [players enumerateObjectsUsingBlock:^(PlayerEntity * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self markDirtySeatWithPlayer:obj];
    }];
}

-(void)clearAllSeatDirty
{
    [pokerTable.seats enumerateObjectsUsingBlock:^(SeatEntity * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.isDirty = NO;
    }];
}

#pragma mark - commPokerMethods

-(void)onNewPlayerEnter:(NSDictionary*)dict
{
    NSLog(@"onRoute:onNewPlayerEnter------");
    NSDictionary *dictP = [IoriJsonHelper getDictForKey:@"observerPlayerList" fromDict:dict];
    if([dictP isKindOfClass:[NSNull class]])
    {
        return;
    }
    PlayerEntity *player = [self getPlayerFromDictionary:dictP];
    [arrayAudience addObject:player];
}

-(void)onFlop:(NSDictionary*)dict
{
    [self loadChipsInfo:dict];
    [self loadFlopCardFromDict:(NSDictionary*)dict];
    pokerTable.mainPots.mainPot = [self getMainPotFromDictionary:dict];
    [self setNextActionPlayerFromDict:dict];
    [self markDirtySeatWithPlayerArray:arrayPlayer];
    [self updateTableInfoUI];
}

-(void)onTurn:(NSDictionary*)dict
{
    [self loadChipsInfo:dict];
    [self loadTurnCardFromDict:(NSDictionary *)dict];
    pokerTable.mainPots.mainPot = [self getMainPotFromDictionary:dict];
    [self setNextActionPlayerFromDict:dict];
    [self markDirtySeatWithPlayerArray:arrayPlayer];
    [self updateTableInfoUI];
}

-(void)onRiver:(NSDictionary*)dict
{
    [self loadChipsInfo:dict];
    [self loadRiverCardFromDict:(NSDictionary *)dict];
    pokerTable.mainPots.mainPot = [self getMainPotFromDictionary:dict];
    [self setNextActionPlayerFromDict:dict];
    [self markDirtySeatWithPlayerArray:arrayPlayer];
    [self updateTableInfoUI];
}


-(void)showStartButton
{
    if(pokerTable.tableStatus == PokerTableStatusEnumNone)
    {
        self.maskContainer.hidden = NO;
    }
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
    
    __block PlayerEntity *playerSelf = nil;
    [arrayPlayer enumerateObjectsUsingBlock:^(PlayerEntity * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         if([obj.playerID isEqualToString:[UserInfo sharedUser].userID])
         {
             playerSelf = obj;
             *stop = YES;
         }
     }];
    if(playerSelf !=nil &&
       playerSelf.iSeatIndex == [IoriJsonHelper getIntegerForKey:@"gameStartMaster" fromDict:dict])
    {
        [self showStartButton];
    }
    [self player2Seat];
    [self markDirtySeatWithPlayer:playerObj];
    [self updateTableInfoUI];
}

-(void)onGameStart:(NSDictionary*)dict
{
    NSDictionary *dictBody = [IoriJsonHelper getDictForKey:@"body" fromDict:dict];
    NSDictionary *dictGame = [[dictBody objectForKey:@"Data"] objectForKey:@"game"];
    NSArray<NSDictionary*> *arrayPlayerList = [dictGame objectForKey:@"playerList"];
    NSArray<NSDictionary*> *arrayCardList = [[dictGame objectForKey:@"playerCardList"] objectForKey:@"card"];
    
    [self clearCommCard];
    [arrayPlayer removeAllObjects];
    pokerTable.tableStatus = PokerTableStatusEnumBet;
    pokerTable.hasUpdatedHandCard = NO;
    pokerTable.mainPots.mainPot = pokerTable.sb + pokerTable.bb;
    pokerTable.allPots = pokerTable.mainPots.mainPot;
    pokerTable.mainPots.mainPot = 0;
    [pokerTable.mainPots.players removeAllObjects];
    [pokerTable.sidePots removeAllObjects];
    [self clearBetPots];
    [self.handCardContainer enumerateObjectsUsingBlock:^(UIView*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
    {
        obj.subviews[0].alpha = 0;
        obj.subviews[1].alpha = 0;
    }];
    
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
                 player.handCard.pattern = (PokerPatternEnum)[IoriJsonHelper getIntegerForKey:@"cardType" fromDict:dictGame];
                 self.labCardType.text = player.handCard.patternStringValue;
             }
             else
             {
                 
             }
         }
     }];
    NSDictionary *dictNextPlayer = [IoriJsonHelper getDictForKey:@"tokenPlayer" fromDict:dictBody];
    [self setNextActionPlayerFromDict:dictNextPlayer];
    [self player2Seat];
    [self markDirtySeatWithPlayerArray:arrayPlayer];
    [self updateTableInfoUI];
}

-(void)onCall:(NSDictionary*)callback
{
    [self playSoundChip];
    PlayerEntity *player = [self mergeActionPlayer:(NSDictionary*)callback];
    player.isDirty = YES;
    [self setNextActionPlayerFromDict:(NSDictionary*)callback];
    pokerTable.tableStatus = PokerTableStatusEnumBet;
    pokerTable.allPots = [self getAllPotFromDictionary:callback];
    [self markDirtySeatWithPlayer:player];
    [self updateTableInfoUI];
}

-(void)onCheck:(NSDictionary*)callback
{
    PlayerEntity *player = [self mergeActionPlayer:(NSDictionary*)callback];
    [self setNextActionPlayerFromDict:(NSDictionary*)callback];
    pokerTable.tableStatus = PokerTableStatusEnumBet;
    [self markDirtySeatWithPlayer:player];
    [self updateTableInfoUI];
}

-(void)onAllIn:(NSDictionary*)callback
{
    [self playSoundChip];
    PlayerEntity *player = [self mergeActionPlayer:(NSDictionary*)callback];
    player.isDirty = YES;
    [self setNextActionPlayerFromDict:(NSDictionary*)callback];
    pokerTable.tableStatus = PokerTableStatusEnumBet;
    pokerTable.allPots = [self getAllPotFromDictionary:callback];
    [self markDirtySeatWithPlayer:player];
    [self updateTableInfoUI];
}

-(void)onRaise:(NSDictionary*)callback
{
    [self playSoundChip];
    PlayerEntity *player = [self mergeActionPlayer:(NSDictionary*)callback];
    player.isDirty = YES;
    [self setNextActionPlayerFromDict:(NSDictionary*)callback];
    pokerTable.tableStatus = PokerTableStatusEnumBet;
    pokerTable.allPots = [self getAllPotFromDictionary:callback];
    [self markDirtySeatWithPlayer:player];
    [self updateTableInfoUI];
}

-(void)onFold:(NSDictionary*)callback
{
    [self playSoundFold];
    PlayerEntity* foldPlayer = [self mergeActionPlayer:(NSDictionary*)callback];
    [self setNextActionPlayerFromDict:(NSDictionary*)callback];
    pokerTable.foldPlayer = foldPlayer;
    pokerTable.tableStatus = PokerTableStatusEnumBet;
    [self markDirtySeatWithPlayer:foldPlayer];
    [self updateTableInfoUI];
}

-(void)onShowdown:(NSDictionary*)callback
{
    pokerTable.mainPots.mainPot = 0;
    [pokerTable.nextActionPlayer.nextActions removeAllObjects];
    pokerTable.nextActionPlayer.nextPlayerIndex = -1;
    NSArray *arrayOpenCardPlayer = [IoriJsonHelper getArrayForKey:@"playerList" fromDict:callback];
    NSArray *arrayOpenCardList = [IoriJsonHelper getArrayForKey:@"playerCardList" fromDict:callback];
    NSArray<NSDictionary*> *arrayWiners = [IoriJsonHelper getArrayForKey:@"MainPools" fromDict:(NSDictionary*)callback];
    [arrayWiners enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         //WINER PLAYERID;
         NSString *playerID = [IoriJsonHelper getStringForKey:@"playerID" fromDict:obj];
         [arrayPlayer enumerateObjectsUsingBlock:^(PlayerEntity * _Nonnull obj2, NSUInteger idx2, BOOL * _Nonnull stop2)
          {
              obj2.actionStatus = PokerActionStatusEnumNone;
              if([playerID isEqualToString:obj2.playerID])
              {
                  [pokerTable.mainPots.players addObject:obj2];
                  obj2.isWiner = YES;
                  obj2.winBet = [[obj objectForKey:@"value"] integerValue];
                  [obj2.handCard.arrayPoker removeAllObjects];//不能删手牌
                  NSArray<NSDictionary*> *arrayCards = [IoriJsonHelper getArrayForKey:@"cardlist" fromDict:obj];
                  [arrayCards enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj3, NSUInteger idx3, BOOL * _Nonnull stop3)
                  {
                      PokerEntity *poker = [PokerEntity new];
                      poker.numberValue = [IoriJsonHelper getIntegerForKey:@"value" fromDict:obj3];
                      poker.pokerSuit = [IoriJsonHelper getIntegerForKey:@"color" fromDict:obj3];
                      [obj2.handCard.arrayPoker addObject:poker];
                  }];
                  obj2.handCard.pattern = (PokerPatternEnum)[IoriJsonHelper getIntegerForKey:@"cardType" fromDict:obj];
                  //*stop2 = YES;
              }
          }];
     }];
    NSArray<NSArray<NSDictionary*>*> *arraySidePools = [IoriJsonHelper getArrayForKey:@"BPools" fromDict:(NSDictionary*)callback];
    [arraySidePools enumerateObjectsUsingBlock:^(NSArray * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
    {
        NSArray<NSDictionary*> *arrayWinPlayes = obj;
        SidePotEntity *sidePot = [SidePotEntity new];
        [pokerTable.sidePots addObject:sidePot];
        [arrayWinPlayes enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull dictPlayer, NSUInteger idx2, BOOL * _Nonnull stop2)
        {
            NSString *playerID = [IoriJsonHelper getStringForKey:@"playerID" fromDict:dictPlayer];
            [arrayPlayer enumerateObjectsUsingBlock:^(PlayerEntity * _Nonnull playerEntity, NSUInteger idx3, BOOL * _Nonnull stop3)
            {
                playerEntity.actionStatus = PokerActionStatusEnumNone;
                if([playerID isEqualToString:playerEntity.playerID])
                {
                    sidePot.bet = [[dictPlayer objectForKey:@"value"] integerValue];
                    [sidePot.players addObject:playerEntity];
                    //playerEntity.actionStatus = PokerActionStatusEnumNone;
                    playerEntity.isWiner = YES;
                    playerEntity.winBet = 0;
                    playerEntity.handCard.pattern = (PokerPatternEnum)[IoriJsonHelper getIntegerForKey:@"cardType" fromDict:dictPlayer];
                    [playerEntity.handCard.arrayPoker removeAllObjects];
                    NSArray<NSDictionary*> *arrayCards = [IoriJsonHelper getArrayForKey:@"cardlist" fromDict:dictPlayer];
                    [arrayCards enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj4, NSUInteger idx4, BOOL * _Nonnull stop4)
                     {
                         PokerEntity *poker = [PokerEntity new];
                         poker.numberValue = [IoriJsonHelper getIntegerForKey:@"value" fromDict:obj4];
                         poker.pokerSuit = [IoriJsonHelper getIntegerForKey:@"color" fromDict:obj4];
                         [playerEntity.handCard.arrayPoker addObject:poker];
                     }];
                    //*stop3 = YES;
                };;
            }];
        }];
    }];
    [self player2Seat];
    [self countBet];
    [self markDirtySeatWithPlayerArray:arrayPlayer];
    [self updateTableInfoUI];
    [pokerTable.mainPots.players removeAllObjects];
}

-(void)onPlayerKick:(NSDictionary*)dict
{
    [self setNextActionPlayerFromDict:dict];
    PlayerEntity *kicter = [self getPlayerFromDictionary:[IoriJsonHelper getDictForKey:@"playerList" fromDict:dict]];
    __block __weak PlayerEntity *playerSelf = nil;
    __block PlayerEntity *willDeletePlayer = nil;
    [arrayPlayer enumerateObjectsUsingBlock:^(PlayerEntity * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
    {
        if([kicter.playerID isEqualToString: obj.playerID])
        {
            willDeletePlayer = obj;
            //*stop = YES;
        }
        if([obj.playerID isEqualToString: [UserInfo sharedUser].userID])
        {
            playerSelf = obj;
        }
    }];
    if(willDeletePlayer)
        [arrayPlayer removeObject:willDeletePlayer];
    if(playerSelf != nil &&
       playerSelf.iSeatIndex == [IoriJsonHelper getIntegerForKey:@"gameStartMaster" fromDict:dict])
    {
        [self showStartButton];
    }
    [self player2Seat];
    [self markDirtySeatWithPlayer:kicter];
    [self updateTableInfoUI];
}

-(PlayerEntity*)mergeActionPlayer:(NSDictionary*)dict
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

-(NSInteger)getMainPotFromDictionary:(NSDictionary*)dict
{
    NSDictionary *mainPools = [IoriJsonHelper getDictForKey:@"mainPools" fromDict:dict];
    return [IoriJsonHelper getIntegerForKey:@"value" fromDict:mainPools];
}

-(NSInteger)getAllPotFromDictionary:(NSDictionary*)dict
{
    return [IoriJsonHelper getIntegerForKey:@"winPools" fromDict:dict];
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
    __weak typeof(self) ws = self;
    arrayAudience = [NSMutableArray arrayWithCapacity:10];
    arrayPlayer = [NSMutableArray arrayWithCapacity:10];
    PokerTableEntity *table = [PokerTableEntity sharedInstance];
    [table reset];
    table.updateUIDelegate = self;
    pokerTable = table;
    self.actionContainer.hidden = YES;
    [self clearCommCard];
    [self.seatView enumerateObjectsUsingBlock:^(UISeat   * _Nonnull obj,
                                                NSUInteger idx,
                                                BOOL * _Nonnull stop)
    {
        obj.betContainer = self.betViews[idx];
        obj.labBet = self.labBet[idx];
        obj.iconChip = self.iconChips[idx];
        obj.labBringIn = self.labBringBet[idx];
        obj.labName = self.labUserName[idx];
        obj.labStatus = self.labStatus[idx];
        obj.iconDelear = self.iconDelear[idx];
        obj.hiddenCards = self.hiddenCardContainer[idx];
        obj.pokerContainer = self.handCardContainer[idx];
        obj.iconWinner = self.iconWinner[idx];
        obj.poker00 = obj.pokerContainer.subviews[0];
        obj.poker01 = obj.pokerContainer.subviews[1];
        obj.waittingView = self.waittingImageViews[idx];
        obj.refMainBetView = self.MainBetView;
        obj.refSidePotsContainerViews = self.betPots;
        [obj clear];
        UIButton *btnSit = self.btnSits[idx];
        btnSit.tag = idx;
        [btnSit addTarget:ws action:@selector(btnSit_click:) forControlEvents:UIControlEventTouchUpInside];
        
        SeatEntity *seat = [SeatEntity new];
        seat.iIndex = idx;
        seat.seatView = obj;
        seat.pokerTable = pokerTable;
        [pokerTable.seats addObject:seat];
        
    }];
    [self clearBetPots];
}

-(void)clearBetPots
{
    self.MainBetView.hidden = YES;
    [self.betPots enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         UIView *betView = obj;
         betView.hidden = YES;
     }];
}

-(void)updateTableInfoUI
{
    [pokerTable updateUI];
    if(pokerTable.allPots > 0)
    {
        NSNumberFormatter *formater = [NSNumberFormatter new];
        formater.numberStyle = NSNumberFormatterDecimalStyle;
        self.labMainBot.text = [formater stringFromNumber:[NSNumber numberWithInteger:pokerTable.allPots]];
    }
    else
    {
        self.labMainBot.text = nil;
    }
    
    __weak UILabel *labBet = self.MainBetView.subviews[0];
    __weak typeof(self) ws = self;
    if(pokerTable.mainPots.mainPot >0 )
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((IoriAnimationDuration+IoriAnimationDelayInterval) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            ws.MainBetView.hidden = NO;
            labBet.text = [NSString getFormatedNumberByInteger:pokerTable.mainPots.mainPot];
        });
    }
    else
    {
        if(pokerTable.mainPots.players.count >0)
        {
            __block NSInteger iBet = 0;
            [pokerTable.mainPots.players enumerateObjectsUsingBlock:^(PlayerEntity * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                iBet += obj.winBet;
            }];

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((IoriAnimationDelayInterval+IoriAnimationDuration) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                labBet.text = [NSString getFormatedNumberByInteger:iBet];
                ws.MainBetView.hidden = NO;;
            });

            [pokerTable.mainPots.players enumerateObjectsUsingBlock:^(PlayerEntity * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
            {
                //PlayerEntity *obj = pokerTable.mainPots.players[0];
                NSInteger iSeatIndex = obj.iSeatIndex;
                UIView *temp = [UIView duplicateBetContainer:ws.MainBetView];
                [temp.subviews[0] setHidden:YES];
                [temp.subviews[1] setHidden:YES];
                [ws.view addSubview:temp];
                [temp.subviews[0] setText:[NSString getFormatedNumberByInteger:obj.winBet]];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((2*IoriAnimationDelayInterval+IoriAnimationDuration) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    labBet.text = nil;
                    ws.MainBetView.hidden = YES;
                    
                    [temp.subviews[1] setHidden:NO];
                    [temp.subviews[0] setHidden:YES];

                });
                [UIView animateWithDuration:IoriAnimationDuration delay:2.4*IoriAnimationDelayInterval options:UIViewAnimationOptionCurveEaseOut animations:^{
                    temp.frame = [ws.seatView[iSeatIndex] frame];
                } completion:^(BOOL finished)
                {
                    if(finished)
                    {
                        [temp removeFromSuperview];
                    }
                }];
            }
            ];
        }
        else
        {
            ws.MainBetView.hidden = YES;
        }
    }
    self.labBlindBet.text = [NSString stringWithFormat:@"Blind:%ld/%ld", pokerTable.sb, pokerTable.bb];
    [self clearAllSeatDirty];
}

-(void)player2Seat
{
    [pokerTable.seats enumerateObjectsUsingBlock:^(SeatEntity * _Nonnull seat, NSUInteger idx, BOOL * _Nonnull stop)
     {
         seat.player = nil;
         [arrayPlayer enumerateObjectsUsingBlock:^(PlayerEntity * _Nonnull player, NSUInteger idx2, BOOL * _Nonnull stop2)
         {
             if(player.iSeatIndex == seat.iIndex)
             {
                 seat.player = player;
                 *stop2 = YES;
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

-(void)clearCommCard
{
    [self.commCards enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView *view = obj;
        if([view isKindOfClass:[UIImageView class]])
        {
            ((UIImageView*)view).image = nil;
            view.alpha = 0;
            view.backgroundColor = [UIColor clearColor];
        }
        view.backgroundColor = [UIColor clearColor];
        [view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull subView, NSUInteger idx, BOOL * _Nonnull stop)
        {
            [subView removeFromSuperview];
        }];
    }];
    [self.handCardContainer enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
    {
        UIView *view = (UIView*)obj;
        UIImageView *imageView = (UIImageView*)view.subviews[0];
        imageView.image = nil;
        imageView = (UIImageView*)view.subviews[1];
        imageView.image = nil;
    }];
    [pokerTable.communityCards removeAllObjects];
}

-(void)flopCard
{
    if(pokerTable.communityCards.count<3)return;
    CardHelper *helper = [CardHelper sharedInstance];
    NSArray<PokerEntity*> *array = [helper getShuffle];
    
    [self countBet];
    
    __block NSInteger iFound = 0;
    [array enumerateObjectsUsingBlock:^(PokerEntity * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         if(obj.numberValue == pokerTable.communityCards[0].numberValue
            && obj.pokerSuit ==  pokerTable.communityCards[0].pokerSuit)
         {
             [helper makePoker:obj containerView:self.commCards[0]];
             
             iFound ++;
         }
         else if(obj.numberValue == pokerTable.communityCards[1].numberValue
                 && obj.pokerSuit ==  pokerTable.communityCards[1].pokerSuit)
         {
             [helper makePoker:obj containerView:self.commCards[1]];
             
             iFound ++;
         }
         else if(obj.numberValue == pokerTable.communityCards[2].numberValue
                 && obj.pokerSuit ==  pokerTable.communityCards[2].pokerSuit)
         {
             [helper makePoker:obj containerView:self.commCards[2]];
             
             iFound ++;
         }
         if(iFound > 2)
         {
             *stop = YES;
         }
     }];
    [self.commCards[0] flip:nil delay:0];
    [self.commCards[1] flip:nil delay:0.2];
    [self.commCards[2] flip:^{
        self.hasFlopCard = YES;
    } delay:0.3];
    [self playSoundFlop];
}

-(void)turnCard
{
    if(pokerTable.communityCards.count<4)return;
    CardHelper *helper = [CardHelper sharedInstance];
    NSArray<PokerEntity*> *array = [helper getShuffle];
    //    [helper makePoker:array[13] containerView:self.card04];
    
    [self countBet];
    
    __block NSInteger iFound = 0;
    [array enumerateObjectsUsingBlock:^(PokerEntity * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         if(obj.numberValue == pokerTable.communityCards[3].numberValue
            && obj.pokerSuit ==  pokerTable.communityCards[3].pokerSuit)
         {
             [helper makePoker:array[idx] containerView:self.commCards[3]];
             iFound ++;
         }
         if(iFound > 0)
         {
             *stop = YES;
         }
     }];
    if(self.hasFlopCard == NO)
    {
        [self.commCards[3] flip:nil delay:0.4];
    }
    else
    {
        [self.commCards[3] flip:^{self.hasFlopCard = NO;self.hasTurnCard = YES;} delay:0];
    }
    [self playSoundFaPai];
}

-(void)riverCard
{
    if(pokerTable.communityCards.count<5)return;
    CardHelper *helper = [CardHelper sharedInstance];
    NSArray<PokerEntity*> *array = [helper getShuffle];
    
    [self countBet];
    
    __block NSInteger iFound = 0;
    [array enumerateObjectsUsingBlock:^(PokerEntity * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         if(obj.numberValue == pokerTable.communityCards[4].numberValue
            && obj.pokerSuit ==  pokerTable.communityCards[4].pokerSuit)
         {
             [helper makePoker:array[idx] containerView:self.commCards[4]];
             iFound ++;
         }
         if(iFound > 0)
         {
             *stop = YES;
         }
     }];
    if(self.hasTurnCard == NO)
    {
        [self.commCards[4] flip:nil delay:.5];
    }
    else
    {
        [self.commCards[4] flip:^{self.hasTurnCard = NO;} delay:.1];
    }
    [self playSoundFaPai];
}

-(void)showMyCardType:(NSDictionary*)dict
{
    PlayerEntity *player = [PlayerEntity new];
    player.handCard.pattern = (PokerPatternEnum)[IoriJsonHelper getIntegerForKey:@"cardType" fromDict:dict];
    self.labCardType.text = player.handCard.patternStringValue;
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
    [self showMyCardType:dict];
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
    [self showMyCardType:dict];
}

-(void)loadRiverCardFromDict:(NSDictionary*)dict
{
    NSArray<NSDictionary*> *arrayCardList = [IoriJsonHelper getArrayForKey:@"publicCardList" fromDict:dict];
    PokerEntity *poker = [PokerEntity new];
    poker.pokerSuit = (PokerSuitEnum)[[arrayCardList[0] objectForKey:@"color"] integerValue];
    poker.numberValue = [[arrayCardList[0] objectForKey:@"value"] integerValue];
    [pokerTable.communityCards addObject:poker];
    pokerTable.tableStatus = PokerTableStatusEnumRiver;
    [self showMyCardType:dict];
}


-(void)countBet
{
    __weak typeof(self) ws = self;
    [pokerTable.seats enumerateObjectsUsingBlock:^(SeatEntity * _Nonnull seat, NSUInteger idx, BOOL * _Nonnull stop)
     {
//         UISeat *view = seat.seatView;
//         view.labBet.text = @"";
//         view.betContainer.hidden = YES;;
         seat.player.bet = 0;
     }];
    [pokerTable.sidePots enumerateObjectsUsingBlock:^(SidePotEntity * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         UIView *betPot01 = ws.betPots[idx];
         betPot01.hidden = NO;
         UILabel *labBet = betPot01.subviews[0];
         labBet.text = [NSString getFormatedNumberByInteger:obj.bet];
     }];
}

-(void)closeActionPanel
{
    __weak typeof(self) ws = self;
    self.actionContainer.hidden = YES;
    self.numberPadView.hidden = YES;
    self.actionContainerBottomConstraint.constant = 0;
    [UIView animateWithDuration:IoriAnimationDuration animations:^{
        [ws.view layoutIfNeeded];
    }];
}

#pragma mark - viewcontroller life cycle -
static long iCallValue,iRaiseMinValue,iRaiseMaxValue, chipsInHand;

-(void)handleActionNotificationWithPlayer:(NSNotification*)notif
{
    __weak typeof(self) ws = self;
    [ws.view layoutIfNeeded];
    if([notif.name isEqualToString:ClosePlayerActionNotification])
    {
        self.numberPadView.hidden = YES;
        self.actionContainer.hidden = YES;
        self.actionContainerBottomConstraint.constant = -self.actionContainer.frame.size.height;
        [UIView animateWithDuration:IoriAnimationDuration animations:^{
            [ws.view layoutIfNeeded];
        }];
        return;
    }
    self.actionContainer.hidden = NO;
    self.actionContainerBottomConstraint.constant = 0;
    [UIView animateWithDuration:IoriAnimationDuration animations:^{
        [ws.view layoutIfNeeded];
    }];
    
    SeatEntity *seat = notif.object;
    chipsInHand = seat.player.bringInMoney;
    __block BOOL hasCheckActon = NO, hasCallAction = NO, hasRaiseAction = NO, hasAllIn = NO;
    __block NSInteger callValue= 0, raiseValue =0, allInValue = 0;
    [pokerTable.nextActionPlayer.nextActions enumerateObjectsUsingBlock:^(NextAction * _Nonnull obj,
                                                                               NSUInteger idx,
                                                                               BOOL * _Nonnull stop)
    {
        if(obj.status == PokerActionStatusEnumCheck)
        {
            hasCheckActon = YES;
        }
        else if (obj.status == PokerActionStatusEnumCall)
        {
            hasCallAction = YES;
            callValue = obj.value;
            iCallValue = callValue;
        }
        else if (obj.status == PokerActionStatusEnumRaise)
        {
            hasRaiseAction = YES;
            raiseValue = obj.value;
            iRaiseMinValue = raiseValue;
        }
        else if (obj.status == PokerActionStatusEnumAllIn)
        {
            hasAllIn = YES;
            allInValue = seat.player.bringInMoney;
            iRaiseMaxValue = allInValue;
        }
    }];
    self.btnFold.enabled = YES;
    self.btnRaise.enabled = NO;
    self.slider.enabled = NO;
    self.btnMin.enabled = NO;
    self.btnMax.enabled = NO;
    self.btnSetMin.enabled = NO;
    self.btnSetHalf.enabled = NO;
    self.btnSetPot.enabled = NO;
    self.btnSetMax.enabled = NO;
    self.btnCall.enabled = NO;
    self.btnCall.hidden = YES;
    self.btnCheck.enabled = NO;
    self.btnCheck.hidden = YES;
    self.txtRaise.text = nil;
    [self.btnRaise setTitle:@"" forState:UIControlStateNormal];

    //only call, fold.
    //check ,raise, (option)allin, fold
    //call, raise, (option)allin, fold
    //call, allin, fold;
    if(hasCheckActon)
    {
        self.btnCheck.enabled = YES;
        self.btnCheck.hidden = NO;
    }
    if(hasCallAction)
    {
        self.btnCall.enabled = YES;
        self.btnCall.hidden = NO;
    }
    if (hasRaiseAction)
    {
        self.btnRaise.enabled = YES;
        self.txtRaise.enabled = YES;
        self.txtRaise.text = [[NSNumber numberWithInteger: raiseValue] stringValue];
        [self.btnRaise setTitle:[NSString getFormatedNumberByInteger:raiseValue] forState:UIControlStateNormal];
        self.slider.minimumValue = raiseValue;
        self.slider.value = raiseValue;
        self.slider.maximumValue = seat.player.bringInMoney;
        self.slider.enabled = YES;
        self.btnMin.enabled = YES;
        self.btnMax.enabled = YES;
        self.btnSetMax.enabled = YES;
        self.btnSetMin.enabled = YES;
        self.btnSetHalf.enabled = YES;
        self.btnSetPot.enabled = YES;
        
        if(pokerTable.allPots/2 < iRaiseMinValue)
        {
            self.btnSetHalf.enabled = NO;
        }
        if(pokerTable.allPots < iRaiseMinValue)
        {
            self.btnSetPot.enabled = NO;
        }
        if(seat.player.bringInMoney < iRaiseMinValue)
        {
            self.btnSetMax.enabled = NO;
        }
    }
    if(hasCheckActon == NO && hasCallAction == NO && hasRaiseAction == NO && hasAllIn == YES)
    {
        self.btnRaise.enabled = YES;
        self.txtRaise.enabled = NO;
        [self.btnRaise setTitle:[NSString getFormatedNumberByInteger:seat.player.bringInMoney] forState:UIControlStateNormal];
    }
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    //设置未滑动位置背景图片
    [self.slider setMinimumTrackImage:[UIImage imageNamed:@"slider_1_new"] forState:UIControlStateNormal];
    //设置已滑动位置背景图
    [self.slider setMaximumTrackImage:[UIImage imageNamed:@"slider_bg_new"] forState:UIControlStateNormal];
    //设置滑块图标图片
    [self.slider setThumbImage:[UIImage imageNamed:@"btn_raise_1"] forState:UIControlStateNormal];
    //设置点击滑块状态图标
//    [self.slider setThumbImage:[UIImage imageNamed:@"main_slider_btn.png"] forState:UIControlStateHighlighted];
    
    [self initTableLayout];
    
    [self reconnectToHost];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleActionNotificationWithPlayer:) name:ShowPlayerActionNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleActionNotificationWithPlayer:) name:ClosePlayerActionNotification object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(BOOL)shouldAutorotate
{
    return NO;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self quitRoom];
//    [pomelo disconnect];
//    pomelo = nil;
    NSLog(@"%@:%s",self,__func__);
}

#pragma mark - button action

-(void)quitRoom
{
    [pomelo requestWithRoute:@"connector.entryHandler.exit" andParams:@{} andCallback:^(id callback) {
        ;
    }];
}

- (IBAction)btnSit_click:(UIButton *)sender
{
    [pomelo requestWithRoute:@"game.gameHandler.sitDown" andParams:@{@"index":@(sender.tag)} andCallback:^(id callback) {
        ;
    }];
}

- (IBAction)btnMenu_click:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)btnMore_click:(UIButton *)sender
{
//    [pomelo requestWithRoute:@"connector.entryHandler.gameReplay"
//                   andParams:@{@"gameReplayType":@(1), @"playerID":@"cy103"}
//            andCallback:^(NSDictionary *result)
//     {
//         NSLog(@"result:%@",result);
//     }];
}

- (IBAction)btnCheck_click:(UIButton *)sender
{
    [self closeActionPanel];
    [pomelo requestWithRoute:@"game.gameHandler.check" andParams:@{} andCallback:^(id callback) {
        ;
    }];
}

- (IBAction)btnCall_click:(UIButton *)sender
{
    [self closeActionPanel];
    [pomelo requestWithRoute:@"game.gameHandler.call" andParams:@{} andCallback:^(id callback) {
        ;
    }];
}

- (IBAction)btnRaise_click:(UIButton *)sender
{
    [self onBtnAssign:nil];
    NSInteger iBet = [self.txtRaise.text integerValue];
//    if(iBet < iRaiseMinValue)
//    {
//        [pomelo requestWithRoute:@"game.gameHandler.raise" andParams:@{@"chip":@(iRaiseMinValue)} andCallback:^(id callback) {
//            ;
//        }];
//    }
    //else
    if(iBet >= chipsInHand)
    {
        [self btnAllin_click:nil];
    }
    else
    {
        [pomelo requestWithRoute:@"game.gameHandler.raise" andParams:@{@"chip":@(iBet) } andCallback:^(id callback) {
            ;
        }];
    }
    [self closeActionPanel];
}

- (IBAction)btnAllin_click:(UIButton *)sender
{
    [self closeActionPanel];
    [pomelo requestWithRoute:@"game.gameHandler.allIn" andParams:@{} andCallback:^(id callback) {
        ;
    }];
}

- (IBAction)btnFold_click:(UIButton *)sender
{
    [self closeActionPanel];
    [pomelo requestWithRoute:@"game.gameHandler.fold" andParams:@{} andCallback:^(id callback) {
        ;
    }];
}

- (IBAction)slider_valueChanged:(UISlider *)sender
{
    self.txtRaise.text = [[NSNumber numberWithInteger:sender.value] stringValue];
    [self.btnRaise setTitle:[NSString getFormatedNumberByInteger:sender.value] forState:UIControlStateNormal];
}

- (IBAction)btnStart_click:(UIButton *)sender
{
    self.maskContainer.hidden = YES;
    [pomelo requestWithRoute:@"game.gameHandler.gameStart" andParams:@{} andCallback:^(id callback) {
        
    }];
}

-(IBAction)btnPutCard:(UIButton*)sender
{
    [pomelo requestWithRoute:@"game.gameHandler.openCard" andParams:@{} andCallback:^(id callback) {
        
    }];
}

-(IBAction)btnDownCard:(UIButton*)sender
{
    [pomelo requestWithRoute:@"game.gameHandler.downCard" andParams:@{} andCallback:^(id callback) {
        
    }];
}

- (IBAction)btnMin_click:(UIButton *)sender
{
    self.slider.value -=1;
    if(self.slider.value < iRaiseMinValue)
    {
        self.slider.value = iRaiseMinValue;
    }
    self.txtRaise.text = [[NSNumber numberWithInteger:self.slider.value] stringValue];
    [self.btnRaise setTitle:[NSString getFormatedNumberByInteger:self.slider.value] forState:UIControlStateNormal];
}

- (IBAction)btnMax:(UIButton *)sender
{
    self.slider.value +=1;
    if(self.slider.value > iRaiseMaxValue)
    {
        self.slider.value = iRaiseMaxValue;
    }
    self.txtRaise.text = [[NSNumber numberWithInteger:self.slider.value] stringValue];
    [self.btnRaise setTitle:[NSString getFormatedNumberByInteger:self.slider.value] forState:UIControlStateNormal];
}

- (IBAction)btnSetMin_click:(UIButton *)sender
{
    self.txtRaise.text = [[NSNumber numberWithInteger:iRaiseMinValue] stringValue];
    [self.btnRaise setTitle:[NSString getFormatedNumberByInteger:iRaiseMinValue] forState:UIControlStateNormal];
}

- (IBAction)btnSetHalf_click:(UIButton *)sender
{
    self.txtRaise.text = [[NSNumber numberWithInteger:pokerTable.allPots/2] stringValue];
    [self.btnRaise setTitle:[NSString getFormatedNumberByInteger:pokerTable.allPots/2] forState:UIControlStateNormal];
}

- (IBAction)btnSetPot_click:(UIButton *)sender
{
    self.txtRaise.text = [[NSNumber numberWithInteger:pokerTable.allPots] stringValue];
    [self.btnRaise setTitle:[NSString getFormatedNumberByInteger:pokerTable.allPots] forState:UIControlStateNormal];
}

- (IBAction)btnSetMax_click:(UIButton *)sender
{
    self.txtRaise.text = [[NSNumber numberWithInteger:iRaiseMaxValue] stringValue];
    [self.btnRaise setTitle:[NSString getFormatedNumberByInteger:iRaiseMaxValue] forState:UIControlStateNormal];
}

- (IBAction)btnNumberPad_click:(UIButton *)sender
{
    self.numberPadView.hidden = NO;
}

#pragma mark -number pad-

- (IBAction)onBtnDel:(id)sender
{
    NSString *str = [self.txtRaise text];
    int idx = (int)[str length]-1;
    NSString *numStr;
    if(idx<=0){
        numStr = @"";
    }else{
        numStr = [str substringToIndex:idx];
    }
    self.txtRaise.text =  [self filterNumStr: numStr];
    [self.btnRaise setTitle:[NSString getFormatedNumberByInteger:[self.txtRaise.text integerValue]] forState:UIControlStateNormal];
}

- (IBAction)onBtnClear:(id)sender
{
    self.txtRaise.text = [NSString stringWithFormat:@"%ld",iRaiseMinValue]; //filterNumStr(numStr: numStr)
    [self.btnRaise setTitle:[NSString getFormatedNumberByInteger:[self.txtRaise.text integerValue]] forState:UIControlStateNormal];
}

- (IBAction)onBtnAssign:(id)sender
{
    UIView *view = [sender superview];
    view.hidden = YES;
    //[self closeActionPanel];
    //assignValue = [self.text doubleValue];
    NSInteger assignValue = [self.txtRaise.text integerValue];
    assignValue = MAX(iRaiseMinValue, assignValue);
    assignValue = MIN(assignValue, chipsInHand);
    self.txtRaise.text = [NSString stringWithFormat:@"%ld",assignValue ];
    [self.btnRaise setTitle:[NSString getFormatedNumberByInteger:[self.txtRaise.text integerValue]] forState:UIControlStateNormal];
}
- (IBAction)onBtnNumber:(id)sender
{
    NSString *nextNum;
    UIButton * btn = (UIButton *)sender;
    if( btn.tag == 0 )
    {
        nextNum = @"0";
    }
    else if(btn.tag == 1)
    {
        nextNum = @"1";
    }
    else if(btn.tag== 2)
    {
        nextNum = @"2";
    }
    else if(btn.tag== 3)
    {
        nextNum = @"3";
    }
    else if(btn.tag== 4)
    {
        nextNum = @"4";
    }
    else if(btn.tag== 5)
    {
        nextNum = @"5";
    }
    else if(btn.tag== 6)
    {
        nextNum = @"6";
    }
    else if(btn.tag== 7)
    {
        nextNum = @"7";
    }
    else if(btn.tag== 8)
    {
        nextNum = @"8";
    }
    else if(btn.tag== 9)
    {
        nextNum = @"9";
    }
    else if(btn.tag== 10)
    {
        nextNum = @"00";
    }
    else if(btn.tag== 11)
    {
        nextNum = @".";
    }
    
    NSString *str = [self.txtRaise.text stringByAppendingString: nextNum];
    self.txtRaise.text = [self filterNumStr: str];
    [self.btnRaise setTitle:[NSString getFormatedNumberByInteger:[self.txtRaise.text integerValue]] forState:UIControlStateNormal];
}

- (NSString*)filterNumStr:(NSString*)numStr
{
    NSString* str;
    if ([numStr isEqualToString:@""]) {
        str = @"";
        return str;
    }
    NSString* substr = [numStr substringFromIndex:numStr.length-1];
    
    if (pokerTable.sb - floor(pokerTable.sb)<0.001)
    {  // 不允许输入浮点数
        if([substr isEqualToString:@"."])
        {
            str = substr;
        }
        else
        {
            str = numStr;
        }
    }else{   // 可以输入浮点数
        if([substr isEqualToString:@"."])
        {
            NSString* temp = [numStr substringToIndex:numStr.length-1];
            NSRange range;
            range = [temp rangeOfString:@"."];
            if (range.location == NSNotFound)
            {
                str = numStr;
            }
            else
            {
                str = temp;
                
                //                if (temp.length - range.location >= 2){
                //                    str = temp substring;
                //                }else{
                //                    str = temp;
                //                }
                //                //输入保留两位小数
                //                if () {
                //
                //
                //                }
            }
        }else{
            
            str = numStr;
        }
        
        
    }
    
    return str;
}

- (IBAction)txtRaise_beginEdit:(UITextField *)sender
{
    [sender resignFirstResponder];
    self.numberPadView.hidden = NO;
}
@end
