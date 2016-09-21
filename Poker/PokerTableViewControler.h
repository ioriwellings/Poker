//
//  PokerTableViewControler.h
//  Poker
//
//  Created by Iori on 9/2/16.
//  Copyright © 2016 Hointe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardHelper.h"
#import "UISeat.h"
#import "Pomelo.h"
#import "UserInfo.h"
#import "IoriJsonHelper.h"
#import "UIImageView+ProgressMask.h"

@interface PokerTableViewControler : UIViewController <PomeloDelegate, PokerTableUpdateUIDelegate>
{
    Pomelo *pomelo;
    SeatEntity *lastActionSeat;
    NSString *strServerIP;
    NSInteger iServerPort;
    
    PokerTableEntity* pokerTable;
    NSMutableArray<PlayerEntity*> *arrayPlayer;
    NSMutableArray<PlayerEntity*> *arrayAudience;
}

@property (weak, nonatomic) IBOutlet UIButton *btnCheck;
@property (weak, nonatomic) IBOutlet UIButton *btnCall;
@property (weak, nonatomic) IBOutlet UIButton *btnRaise;
@property (weak, nonatomic) IBOutlet UIButton *btnFold;
@property (weak, nonatomic) IBOutlet UIButton *btnAllIn;

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *seatView;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *commCards;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *betViews;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *iconChips;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *labBet;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *labBringBet;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *bg_User;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *iconDelear;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *labStatus;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *labUserName;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *hiddenCardContainer;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *handCardContainer;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btnSits;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *waittingImageViews;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *betPots;

@property (weak, nonatomic) IBOutlet UILabel *labMainBot;
@property (weak, nonatomic) IBOutlet UILabel *labBlindBet;
@property (weak, nonatomic) IBOutlet UITextField *txtRaise;
@property (weak, nonatomic) IBOutlet UILabel *labAllIn;
@property (weak, nonatomic) IBOutlet UILabel *labCardType;

- (IBAction)btnSit_click:(UIButton *)sender;

- (IBAction)btnMenu_click:(UIButton *)sender;
- (IBAction)btnMore_click:(UIButton *)sender;
- (IBAction)btnCheck_click:(UIButton *)sender;
- (IBAction)btnCall_click:(UIButton *)sender;
- (IBAction)btnRaise_click:(UIButton *)sender;
- (IBAction)btnAllin_click:(UIButton *)sender;
- (IBAction)btnFold_click:(UIButton *)sender;

@end
