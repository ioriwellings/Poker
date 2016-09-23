//
//  UISeat.h
//  Poker
//
//  Created by Iori on 8/8/16.
//  Copyright © 2016 Hointe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PokerEntity.h"
#import "PlayerEntity.h"
#import "CardHelper.h"

@class PokerTableEntity;

@interface UISeat : UIView

@property (nonatomic, weak) UILabel *labStatus;
@property (nonatomic, weak) UILabel *labName;
@property (nonatomic, weak) UIView *betContainer;
@property (nonatomic, weak) UILabel *labBet;
@property (nonatomic, weak) UILabel *labBringIn;
@property (nonatomic, weak) UIView *hiddenCards;
@property (nonatomic, weak) UIView *pokerContainer;
@property (nonatomic, weak) UIView *poker00;
@property (nonatomic, weak) UIView *poker01;
@property (nonatomic, weak) UIImageView *iconWinner;
@property (nonatomic, weak) UIImageView *iconDelear;
@property (nonatomic, weak) UIImageView *waittingView;
@property (nonatomic, weak) UIImageView *iconChip;
@property (nonatomic, weak) UIButton *btnCheck;
@property (nonatomic, weak) UIButton *btnCall;
@property (nonatomic, weak) UIButton *btnRaise;
@property (nonatomic, weak) UILabel *labRaise;
@property (nonatomic, weak) UISlider *slider;
@property (nonatomic, weak) UIButton *btnAllIn;
@property (nonatomic, weak) UIButton *btnFold;
@property (nonatomic, weak) UILabel *labAllIn;
@property (nonatomic, weak) PokerTableEntity *pokerTable;
@property (nonatomic, readonly, getter=userNameBg) UIView *userNameBg;

-(void)clear;
-(void)resetByPlayer:(PlayerEntity*)player;
-(void)updateStatusByPlayer:(PlayerEntity*)player;
-(void)updateHandCards:(NSArray<PokerEntity*>*)pokers;
-(void)foldCard;

@end
