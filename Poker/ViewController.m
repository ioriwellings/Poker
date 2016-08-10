//
//  ViewController.m
//  Poker
//
//  Created by Iori on 8/5/16.
//  Copyright © 2016 Hointe. All rights reserved.
//

#import "ViewController.h"

@implementation PokerAction

+(instancetype)sharedInstance
{
    static PokerAction *__instance = nil;
    if(__instance == nil)
    {
        __instance = [PokerAction new];
    }
    return __instance;
}


-(void)sendCommandAction:(PokerActionEnum)action
{
    if(action == PokerActionEnumBigBlind && round == 0)
    {
        [self.delegateVC player2Seat];
        [self.delegateVC updateTableInfoUI];
        round++;
    }
}

-(void)playActionBehaviour
{
    
}

-(void)performActiveBehaviour
{
    if(self.action == PokerActionEnumCall)
    {
        
    }
    else if(self.action == PokerActionEnumCheck)
    {
        
    }
    else if(self.action == PokerActionEnumFold)
    {
        
    }
    else if (self.action == PokerActionEnumBigBlind)
    {
        [self sendCommandAction:PokerActionEnumBigBlind];
    }
}

@end

@interface ViewController ()
{
    PokerTableEntity *pokerTable;
    NSMutableArray<PlayerEntity*> *arrayPlayer;
    NSInteger round;
}
@end

@implementation ViewController

-(void)commandReceiveCenter:(PokerAction *)action
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    CardHelper *helper = [CardHelper sharedInstance];
    
//    NSArray<PokerEntity*> *array = [helper getShuffle];
    
//    [helper makePoker:array[2] containerView:self.card01];
//    [helper makePoker:array[40] containerView:self.card02];
//    [helper makePoker:array[42] containerView:self.card03];
//    [helper makePokerByNum:array[14].numberValue pokerSuit:PokerSuitEnumDiamonds containerView:self.card04];
//    [helper makePokerByNum:array[13].numberValue pokerSuit:PokerSuitEnumHearts containerView:self.card05];
//    
//    [helper makePoker:array[0] containerView:self.card1];
//    [helper makePoker:array[1] containerView:self.card0];

    
    [PokerAction sharedInstance].delegateVC = self;
    
    [self initTableLayout];
    
    [self getTableInfoFromService];
}

-(void)initTableLayout
{
    arrayPlayer = [NSMutableArray arrayWithCapacity:10];
    PokerTableEntity *table = [PokerTableEntity new];
    pokerTable = table;
    
    UISeat *seatView01 = [UISeat new];
    seatView01.labName = self.labPlayer02;
    seatView01.labBet = self.labBetPlayer02;
    seatView01.labBringIn = self.labBring02;
    seatView01.labStatus = self.labStatusPlayer02;
    SeatEntity *seat =[SeatEntity new];
    seat.iIndex = 1;
    seat.seatView = seatView01;
    [pokerTable.seats addObject:seat];
    
    seatView01 = [UISeat new];
    seatView01.labName = self.labPlayerName;
    seatView01.labBet = self.labBetPlayer01;
    seatView01.labBringIn = self.labBring01;
    seatView01.labStatus = self.labStatusPlayer01;
    seat = [SeatEntity new];
    seat.iIndex = 0;
    seat.seatView = seatView01;
    [pokerTable.seats addObject:seat];
}

-(void)getTableInfoFromService
{
    if(round == 0)
    {
        PlayerEntity *player02 = [PlayerEntity new];
        player02.iSeatIndex =1;
        player02.bringInMoney = 400;
        player02.name = @"Player02";
        player02.isSmallBlind = YES;
        player02.bet = 10;
        player02.isButton = YES;
        player02.actionStatus = PokerActionStatusEnumWaitingNext;
        player02.isWaitingNextLoop = true;
        [arrayPlayer addObject:player02];
        [self player2Seat];
        [self updateTableInfoUI];
        //round +=1;
    }
    else if (round == 1)
    {
        PlayerEntity *player02 = pokerTable.seats[0].player;
        player02.actionStatus = PokerActionStatusEnumCall;
        player02.bet = 20;
        [PokerAction sharedInstance].player = player02;
        [PokerAction sharedInstance].action = PokerActionEnumCall;
        [[PokerAction sharedInstance] playActionBehaviour];
        [self player2Seat];
        [self updateTableInfoUI];
        //round +=1;
    }
    else if (round == 2)
    {
        
    }
}

-(void)updateTableInfoUI
{
    self.labPotBet.text = [pokerTable.mainPots.mainPot stringValue];
    [pokerTable.seats enumerateObjectsUsingBlock:^(SeatEntity * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj updateSeatUI];
    }];
}

- (IBAction)btnPlayer02_click:(UIButton *)sender
{
    [self getTableInfoFromService];
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
    [arrayPlayer addObject:player];
    [PokerAction sharedInstance].player = player;
    [PokerAction sharedInstance].action = PokerActionEnumBigBlind;
    [[PokerAction sharedInstance] performActiveBehaviour];
}

- (IBAction)btnStandUp_click:(UIButton *)sender
{
}

- (IBAction)btnCall_click:(UIButton *)sender
{
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
