//
//  UISeat.h
//  Poker
//
//  Created by Iori on 8/8/16.
//  Copyright © 2016 Hointe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UISeat : UIView

@property (nonatomic, weak) UILabel *labStatus;
@property (nonatomic, weak) UILabel *labName;
@property (nonatomic, weak) UILabel *labBet;
@property (nonatomic, weak) UILabel *labBringIn;
@property (nonatomic, weak) UIView *pokerContainer;
@property (nonatomic, weak) UIView *poker00;
@property (nonatomic, weak) UIView *poker01;

@property (nonatomic, weak) UIButton *btnCheck;
@property (nonatomic, weak) UIButton *btnCall;
@property (nonatomic, weak) UIButton *btnRaise;
@property (nonatomic, weak) UITextField *txtRaise;
@property (nonatomic, weak) UIButton *btnAllIn;
@property (nonatomic, weak) UIButton *btnFold;

@end
