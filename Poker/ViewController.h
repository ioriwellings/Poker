//
//  ViewController.h
//  Poker
//
//  Created by Iori on 8/5/16.
//  Copyright © 2016 Hointe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardHelper.h"
#import "UISeat.h"
#import "Pomelo.h"

@class PokerAction;

@interface ViewController : UIViewController <PomeloDelegate>
{
    Pomelo *pomelo;
    SeatEntity *lastActionSeat;
}

@property (strong, nonatomic) IBOutlet UIView *card01;
@property (strong, nonatomic) IBOutlet UIView *card02;
@property (strong, nonatomic) IBOutlet UIView *card03;
@property (strong, nonatomic) IBOutlet UIView *card04;
@property (strong, nonatomic) IBOutlet UIView *card05;

@property (strong, nonatomic) IBOutlet UIView *card0;
@property (strong, nonatomic) IBOutlet UIView *card1;

@property (strong, nonatomic) IBOutlet UIView *seat01;
@property (strong, nonatomic) IBOutlet UIView *seat02;

@property (strong, nonatomic) IBOutlet UILabel *labPlayer02;
@property (strong, nonatomic) IBOutlet UILabel *labPlayer03;
@property (strong, nonatomic) IBOutlet UILabel *labPlayer04;

@property (strong, nonatomic) IBOutlet UILabel *labPlayerName;
@property (strong, nonatomic) IBOutlet UIButton *btnSitDown_click;
@property (strong, nonatomic) IBOutlet UILabel *labStatusPlayer01;
@property (strong, nonatomic) IBOutlet UILabel *labStatusPlayer04;
@property (strong, nonatomic) IBOutlet UILabel *labStatusPlayer03;
@property (strong, nonatomic) IBOutlet UILabel *labStatusPlayer02;

@property (strong, nonatomic) IBOutlet UILabel *labBring01;
@property (strong, nonatomic) IBOutlet UILabel *labBring02;
@property (strong, nonatomic) IBOutlet UILabel *labBring03;
@property (strong, nonatomic) IBOutlet UILabel *labBring04;


@property (strong, nonatomic) IBOutlet UILabel *labBetPlayer01;
@property (strong, nonatomic) IBOutlet UILabel *labBetPlayer02;
@property (strong, nonatomic) IBOutlet UILabel *labBetPlayer03;
@property (strong, nonatomic) IBOutlet UILabel *labBetPlayer04;
@property (strong, nonatomic) IBOutlet UILabel *labPotBet;
@property (strong, nonatomic) IBOutlet UIButton *btnFold_click;

-(void)commandReceiveCenter:(PokerAction*)action;

-(void)player2Seat;
-(void)updateTableInfoUI;
-(void)getTableInfoFromService;
-(void)markerActionSeat:(SeatEntity*)seat;
-(void)markerNormalSeat:(SeatEntity*)seat;
-(void)flopCard;
-(void)turnCard;
-(void)riverCard;
-(void)countBet;

- (IBAction)btnSitDown_click:(UIButton *)sender;
- (IBAction)btnStandUp_click:(UIButton *)sender;

- (IBAction)btnCall_click:(UIButton *)sender;
- (IBAction)btnRaise_click:(UIButton *)sender;

- (IBAction)btnAllin_click:(UIButton *)sender;
- (IBAction)btnFold_click:(UIButton *)sender;

- (IBAction)btnPlayer02_click:(UIButton *)sender;

@end

typedef NS_ENUM(NSUInteger, PokerActionEnum) {
    PokerActionEnumCheck = 1,
    PokerActionEnumCall,
    PokerActionEnumFold,
    PokerActionEnumAllin,
    PokerActionEnumSitDown,
    PokerActionEnumStandUp
};


@interface PokerAction : NSObject
{
}

@property (nonatomic, assign) PokerActionEnum actionType;
@property (nonatomic, strong) PlayerEntity *player;
@end

