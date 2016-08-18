//
//  ViewController.m
//  Poker
//
//  Created by Iori on 8/5/16.
//  Copyright © 2016 Hointe. All rights reserved.
//

#import "ViewController.h"

@implementation PokerAction

//-(void)playActionBehaviour
//{
//    
//}
//
//-(void)performActiveBehaviour
//{
//    if(self.actionType == PokerActionEnumCall)
//    {
//        
//    }
//    else if(self.actionType == PokerActionEnumCheck)
//    {
//        
//    }
//    else if(self.actionType == PokerActionEnumFold)
//    {
//        
//    }
//    else if (self.actionType == PokerActionEnumBigBlind)
//    {
//        [self sendCommandAction:PokerActionEnumBigBlind];
//    }
//}

@end

@interface ViewController ()
{
    PokerTableEntity *pokerTable;
    NSMutableArray<PlayerEntity*> *arrayPlayer;
    NSInteger round;
}
@end

@implementation ViewController

#pragma mark -pomelo-
-(void)reconnectToHost
{
    pomelo = [[Pomelo alloc] initWithDelegate:self];
    [pomelo connectToHost:@"192.168.0.105" onPort:3014 withCallback:^(Pomelo *p)
     {
         NSDictionary *params = [NSDictionary dictionaryWithObject:@"iori" forKey:@"uid"];
         [pomelo requestWithRoute:@"gate.gateHandler.queryEntry" andParams:params andCallback:^(NSDictionary *result)
          {
              [pomelo disconnectWithCallback:^(Pomelo *p)
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
}
- (void)Pomelo:(Pomelo *)pomelo didReceiveMessage:(NSArray *)message
{
    NSLog(@"-%s, message:%@", __func__, message);
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
    NSString *name = @"iori";
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
            NSArray *userList = [[result objectForKey:@"dataInfo"] objectForKey:@"observerPlayerList"];
            //
            [p onRoute:@"onNewPlayerEnter" withCallback:^(NSDictionary *data){
                NSLog(@"onRoute:onNewPlayerEnter------");
            }];
            [p onRoute:@"onHandCard" withCallback:^(id callback) {
                ;
            }];
            [p onRoute:@"onSitDown" withCallback:^(id callback) {
                ;
            }];
            [p onRoute:@"onEnterRomm" withCallback:^(id callback) {
                ;
            }];
        }];
    }];
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

#pragma mark - viewcontroller life-

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    

//    [helper makePokerByNum:array[14].numberValue pokerSuit:PokerSuitEnumDiamonds containerView:self.card04];
//    [helper makePokerByNum:array[13].numberValue pokerSuit:PokerSuitEnumHearts containerView:self.card05];
    
    [self initTableLayout];
    
    [self performSelector:@selector(getTableInfoFromService) withObject:nil afterDelay:5];
    
    [self reconnectToHost];
}

-(void)initTableLayout//初始化座位
{
    
    arrayPlayer = [NSMutableArray arrayWithCapacity:10];
    PokerTableEntity *table = [PokerTableEntity sharedInstance];
    pokerTable = table;
    table.bb = 20;
    table.sb= 10;
    
    UISeat *seatView01 = (UISeat*)self.seat02;  //顶部坐位
    seatView01.labName = self.labPlayer02;
    seatView01.labBet = self.labBetPlayer02;
    seatView01.labBringIn = self.labBring02;
    seatView01.labStatus = self.labStatusPlayer02;
    SeatEntity *seat =[SeatEntity new];
    seat.iIndex = 1;
    seat.seatView = seatView01;
    [pokerTable.seats addObject:seat];
    
    seatView01 = (UISeat*)self.seat01; //底部坐位
    seatView01.labName = self.labPlayerName;
    seatView01.labBet = self.labBetPlayer01;
    seatView01.labBringIn = self.labBring01;
    seatView01.labStatus = self.labStatusPlayer01;
    seat = [SeatEntity new];
    seat.iIndex = 0;
    seat.seatView = seatView01;
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
    [pokerTable.seats enumerateObjectsUsingBlock:^(SeatEntity * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj updateSeatUI];
    }];
    if([pokerTable.mainPots.mainPot compare:@(0)] != NSOrderedSame)
    {
        self.labPotBet.text = [pokerTable.mainPots.mainPot stringValue];
    }
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
    [helper makePoker:array[2] containerView:self.card01];
    [helper makePoker:array[40] containerView:self.card02];
    [helper makePoker:array[42] containerView:self.card03];
    
    [self countBet];
}

-(void)turnCard
{
    CardHelper *helper = [CardHelper sharedInstance];
    NSArray<PokerEntity*> *array = [helper getShuffle];
    [helper makePoker:array[13] containerView:self.card04];
    
    [self countBet];
}

-(void)riverCard
{
    CardHelper *helper = [CardHelper sharedInstance];
    NSArray<PokerEntity*> *array = [helper getShuffle];
    [helper makePoker:array[14] containerView:self.card05];
    
    [self countBet];
}

-(void)countBet
{
    [pokerTable.seats enumerateObjectsUsingBlock:^(SeatEntity * _Nonnull seat, NSUInteger idx, BOOL * _Nonnull stop) {
        UISeat *view = seat.seatView;
        view.labBet.text = @"";
        NSDecimalNumber *playerBet = [NSDecimalNumber decimalNumberWithString:[[NSNumber numberWithInteger:seat.player.bet] stringValue]];
        if([playerBet integerValue] != 0)
            pokerTable.mainPots.mainPot = [pokerTable.mainPots.mainPot decimalNumberByAdding:playerBet];
        self.labPotBet.text = [pokerTable.mainPots.mainPot stringValue];
        seat.player.bet = 0;
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnSitDown_click:(UIButton *)sender
{
    PlayerEntity *player = [PlayerEntity new];
    player.iSeatIndex =0;
    player.bringInMoney = 10000;
    player.bet = 20;
    player.name = @"Iori";
    player.actionStatus = PokerActionStatusEnumNone;
    player.isBigBlind = YES;
    PokerAction *action = [PokerAction new];
    action.player = player;
    action.actionType = PokerActionEnumSitDown;
    round++;
    [self commandReceiveCenter:action];
    [pomelo requestWithRoute:@"game.gameHandler.SitDown" andParams:@{@"index":@(1)} andCallback:^(id callback) {
        ;
    }];
}

- (IBAction)btnStandUp_click:(UIButton *)sender
{
}

- (IBAction)btnCall_click:(UIButton *)sender
{
    PokerAction *action = [PokerAction new];
    action.player = arrayPlayer[1];
    action.actionType = PokerActionEnumCheck;
    round++;
    [self commandReceiveCenter:action];
}

- (IBAction)btnRaise_click:(UIButton *)sender
{
}

- (IBAction)btnAllin_click:(UIButton *)sender
{
}

- (IBAction)btnFold_click:(UIButton *)sender
{
}
@end
