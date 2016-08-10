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

@end
