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

@class PokerAction;

@interface ViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *card01;
@property (strong, nonatomic) IBOutlet UIView *card02;
@property (strong, nonatomic) IBOutlet UIView *card03;
@property (strong, nonatomic) IBOutlet UIView *card04;
@property (strong, nonatomic) IBOutlet UIView *card05;

@property (strong, nonatomic) IBOutlet UIView *card0;
@property (strong, nonatomic) IBOutlet UIView *card1;

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

-(void)commandReceiveCenter:(PokerAction*)action;

- (IBAction)btnPlayer02_click:(UIButton *)sender;

-(void)player2Seat;
-(void)updateTableInfoUI;
-(void)getTableInfoFromService;
- (IBAction)btnSitDown_click:(UIButton *)sender;
- (IBAction)btnStandUp_click:(UIButton *)sender;

- (IBAction)btnCall_click:(UIButton *)sender;
- (IBAction)btnRaise_click:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnFold_click;
- (IBAction)btnAllin_click:(UIButton *)sender;
- (IBAction)btnFold_click:(UIButton *)sender;

@end

typedef NS_ENUM(NSUInteger, PokerActionEnum) {
    PokerActionEnumCheck = 1,
    PokerActionEnumCall,
    PokerActionEnumFold,
    PokerActionEnumAllin,
    PokerActionEnumBigBlind,
    PokerActionEnumSmallBlind
};


@interface PokerAction : NSObject
{
    NSInteger round;
}

@property (nonatomic, assign) PokerActionEnum action;
@property (nonatomic, copy) NSString* name;
@property (nonatomic, assign) NSInteger value;
@property (nonatomic, strong) PlayerEntity *player;
@property (nonatomic, strong) ViewController *delegateVC;
-(void)playActionBehaviour;
-(void)performActiveBehaviour;
+(instancetype)sharedInstance;
@end

