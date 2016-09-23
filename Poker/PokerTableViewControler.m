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

@interface PokerTableViewControler ()
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
    pomelo = [[Pomelo alloc] initWithDelegate:ws];
    [pomelo connectToHost:@"192.168.0.101" onPort:13014 withCallback:^(Pomelo *p)
     {
         NSDictionary *params = [NSDictionary dictionaryWithObject:[UserInfo sharedUser].userID forKey:@"uid"];
         [p requestWithRoute:@"gate.gateHandler.queryEntry"
                   andParams:params
                 andCallback:^(NSDictionary *result)
          {
              p.isDisconnectByUser = YES;
              [p disconnectWithCallback:^(Pomelo *p)
               {
                   [MessageBox removeLoading:nil];
                   [ws entryWithData:result];
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
    [MessageBox removeLoading:nil];
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
    __weak typeof(self) ws = self;
    NSDictionary *dict = (NSDictionary*)message;
    if([[dict objectForKey:@"code"] integerValue] == 500)
    {
        [ws reconnectToHost];
    }
}
- (void)entryWithData:(NSDictionary *)data
{
    __weak typeof(self) ws = self;
    NSString *host = strServerIP = [data objectForKey:@"host"];
    NSInteger port = iServerPort = [[data objectForKey:@"port"] intValue];
    NSString *name = [UserInfo sharedUser].userID;
    NSString *channel = [UserInfo sharedUser].roomName;
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
              [ws initTableLayout];
              //观战者
              NSArray *userList = [[result objectForKey:@"dataInfo"] objectForKey:@"observerPlayerList"];
              NSLog(@"%@",userList);
              //房间信息
              NSDictionary *room = [IoriJsonHelper getDictForKey:@"room" fromDict:result];
              RoomEntity *roomInfo = [RoomEntity new];
              roomInfo.roomBaseBigBlind = [IoriJsonHelper getIntegerForKey:@"roomBaseBigBlind" fromDict:room];
              roomInfo.roomBaseSmallBlind = [IoriJsonHelper getIntegerForKey:@"roomBaseSmallBlind" fromDict:room];
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
              [ws player2Seat];
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
     }];
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

-(void)hiddenChips
{
    [self.betPots enumerateObjectsUsingBlock:^(UIView*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
    {
        obj.hidden = YES;;
    }];
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
    [self hiddenChips];
    [self loadChipsInfo:dict];
    [self loadFlopCardFromDict:(NSDictionary*)dict];
    pokerTable.mainPots.mainPot = [self getMainPotFromDictionary:dict];
    [self setNextActionPlayerFromDict:dict];
    [self updateTableInfoUI];
}

-(void)onTurn:(NSDictionary*)dict
{
    [self loadChipsInfo:dict];
    [self loadTurnCardFromDict:(NSDictionary *)dict];
    pokerTable.mainPots.mainPot = [self getMainPotFromDictionary:dict];
    [self setNextActionPlayerFromDict:dict];
    [self updateTableInfoUI];
}

-(void)onRiver:(NSDictionary*)dict
{
    [self loadChipsInfo:dict];
    [self loadRiverCardFromDict:(NSDictionary *)dict];
    pokerTable.mainPots.mainPot = [self getMainPotFromDictionary:dict];
    [self setNextActionPlayerFromDict:dict];
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
    if(pokerTable.tableStatus == PokerTableStatusEnumNone && arrayPlayer.count == 1)
    {
        self.maskContainer.hidden = NO;
    }
    [self player2Seat];
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
    [self updateTableInfoUI];
}

-(void)onCheck:(NSDictionary*)callback
{
    [self mergeActionPlayer:(NSDictionary*)callback];
    [self setNextActionPlayerFromDict:(NSDictionary*)callback];
    pokerTable.tableStatus = PokerTableStatusEnumBet;
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
    [self updateTableInfoUI];
}

-(void)onFold:(NSDictionary*)callback
{
    [self playSoundFold];
    PlayerEntity* foldPlayer = [self mergeActionPlayer:(NSDictionary*)callback];
    [self setNextActionPlayerFromDict:(NSDictionary*)callback];
    pokerTable.foldPlayer = foldPlayer;
    pokerTable.tableStatus = PokerTableStatusEnumBet;
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
                  [obj2.handCard.arrayPoker removeAllObjects];
                  NSArray<NSDictionary*> *arrayCards = [IoriJsonHelper getArrayForKey:@"cardlist" fromDict:obj];
                  [arrayCards enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj3, NSUInteger idx3, BOOL * _Nonnull stop3)
                  {
                      PokerEntity *poker = [PokerEntity new];
                      poker.numberValue = [IoriJsonHelper getIntegerForKey:@"value" fromDict:obj3];
                      poker.pokerSuit = [IoriJsonHelper getIntegerForKey:@"color" fromDict:obj3];
                      [obj2.handCard.arrayPoker addObject:poker];
                  }];
                  obj2.handCard.pattern = (PokerPatternEnum)[IoriJsonHelper getIntegerForKey:@"cardType" fromDict:obj];
                  *stop2 = YES;
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
                if([playerID isEqualToString:playerEntity.playerID])
                {
                    sidePot.bet = [[dictPlayer objectForKey:@"value"] integerValue];
                    [sidePot.players addObject:playerEntity];
                    playerEntity.actionStatus = PokerActionStatusEnumNone;
                    playerEntity.isWiner = YES;
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
                    *stop3 = YES;
                };;
            }];
        }];
    }];
    [self player2Seat];
    [self countBet];
    [self updateTableInfoUI];
}

-(void)onPlayerKick:(NSDictionary*)dict
{
    [self setNextActionPlayerFromDict:dict];
    PlayerEntity *kicter = [self getPlayerFromDictionary:[IoriJsonHelper getDictForKey:@"playerList" fromDict:dict]];
    [arrayPlayer enumerateObjectsUsingBlock:^(PlayerEntity * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
    {
        if(kicter.playerID == obj.playerID)
        {
            [arrayPlayer removeObject:obj];
            *stop = YES;
        }
    }];
    if(pokerTable.tableStatus == PokerTableStatusEnumNone && arrayPlayer.count == 1)
    {
        self.maskContainer.hidden = NO;
    }
    [self player2Seat];
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

//-(void)flyChipAnimation
//{
//    UIView *seatView = self.btnSits[0];
//    CGPoint point = CGPointMake(seatView.frame.origin.x,
//                                seatView.frame.origin.y);
//    point = [self.iconChips[0] convertPoint:point toView:self.iconChips[0]];
//    CGPoint newPoint4 = CGPointMake([self.iconChips[0] frame].origin.x,
//                                    [self.iconChips[0] frame].origin.y);
//    CGPoint newpoint5;
//    if(point.x < newPoint4.x)
//    {
//        newpoint5.x = newPoint4.x - point.x;
//    }
//    else
//    {
//        newpoint5.x = newPoint4.x + point.x;
//    }
//    if(point.y < newPoint4.y)
//    {
//        newpoint5.y = newPoint4.y - point.y;
//    }
//    else
//    {
//        newpoint5.y = newPoint4.y + point.y;
//    }
//   // newpoint5 = [self.iconChips[0] convertPoint:newpoint5 fromView:self.view];
//    [self.iconChips[0] setPoint:newpoint5 duration:2 finished:^{
//    }];
//    
//}

-(void)initTableLayout//初始化座位
{
    __weak typeof(self) ws = self;
    arrayAudience = [NSMutableArray arrayWithCapacity:10];
    arrayPlayer = [NSMutableArray arrayWithCapacity:10];
    PokerTableEntity *table = [PokerTableEntity sharedInstance];
    [table reset];
    table.updateUIDelegate = self;
    pokerTable = table;
    self.btnAllIn.enabled = NO;
    self.btnFold.enabled = NO;
    self.btnRaise.enabled = NO;
    self.btnCheck.enabled = NO;
    self.btnCall.enabled = NO;
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
        obj.btnAllIn = self.btnAllIn;
        obj.btnCall = self.btnCall;
        obj.btnCheck = self.btnCheck;
        obj.btnFold = self.btnFold;
        obj.btnRaise = self.btnRaise;
        obj.labRaise = self.labRaise;
        obj.slider = self.slider;
        obj.labAllIn = self.labAllIn;
        obj.waittingView = self.waittingImageViews[idx];
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
    self.labBlindBet.text = [NSString stringWithFormat:@"盲注:%ld/%ld", pokerTable.bb, pokerTable.sb];
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
    [pokerTable.seats enumerateObjectsUsingBlock:^(SeatEntity * _Nonnull seat, NSUInteger idx, BOOL * _Nonnull stop)
    {
        UISeat *view = seat.seatView;
        view.labBet.text = @"";
        view.betContainer.hidden = YES;
        if(seat.player.bet != 0)
        {
            //pokerTable.mainPots.mainPot += seat.player.bet;
        }
        seat.player.bet = 0;
    }];
    [pokerTable.sidePots enumerateObjectsUsingBlock:^(SidePotEntity * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
    {
        UIView *betPot01 = self.betPots[idx];
        betPot01.hidden = NO;
        UILabel *labBet = betPot01.subviews[0];
        labBet.text = [NSString getFormatedNumberByInteger:obj.bet];
    }];
}


#pragma mark - viewcontroller life cycle -

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.slider.transform = CGAffineTransformMakeRotation(-M_PI_2);
    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.sliderBG.mas_height).offset(-20);
        make.height.mas_equalTo(12);
    }];
    
    //设置未滑动位置背景图片
    [self.slider setMinimumTrackImage:[UIImage imageNamed:@"iori_slider_1"] forState:UIControlStateNormal];
    //设置已滑动位置背景图
    [self.slider setMaximumTrackImage:[UIImage imageNamed:@"iori_slider_bg"] forState:UIControlStateNormal];
    //设置滑块图标图片
//    [self.slider setThumbImage:[UIImage imageNamed:@"main_slider_btn.png"] forState:UIControlStateNormal];
    //设置点击滑块状态图标
//    [self.slider setThumbImage:[UIImage imageNamed:@"main_slider_btn.png"] forState:UIControlStateHighlighted];
    
    [self initTableLayout];
    
    [self reconnectToHost];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)dealloc
{
    [pomelo disconnect];
    pomelo = nil;
    NSLog(@"%@:%s",self,__func__);
}

#pragma mark - button action

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
}

static BOOL isRaiseClicked;
- (IBAction)btnRaise_click:(UIButton *)sender
{
    if(isRaiseClicked == NO)
    {
        isRaiseClicked = YES;
        [sender setImage:[UIImage imageNamed:@"btn_a_3_1.png"] forState:UIControlStateNormal];
        self.sliderContainer.hidden = NO;
    }
    else
    {
        NSNumberFormatter *formatter = [NSNumberFormatter new];
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
        NSNumber *number = [formatter numberFromString:self.labRaise.text];
        [pomelo requestWithRoute:@"game.gameHandler.raise" andParams:@{@"chip":[number stringValue] } andCallback:^(id callback) {
            ;
        }];
        isRaiseClicked = NO;
        [sender setImage:[UIImage imageNamed:@"btn_a_2_0.png"] forState:UIControlStateNormal];
        self.sliderContainer.hidden = YES;
    }
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

- (IBAction)slider_valueChanged:(UISlider *)sender
{
    self.labRaise.text = [NSString getFormatedNumberByInteger:sender.value];
}

- (IBAction)btnStart_click:(UIButton *)sender
{
    self.maskContainer.hidden = YES;
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
