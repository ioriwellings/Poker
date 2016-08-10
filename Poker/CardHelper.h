//
//  CardHelper.h
//  Poker
//
//  Created by Iori on 8/5/16.
//  Copyright © 2016 Hointe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Masonry.h"
#import "PokerTableEntity.h"

@interface CardHelper : NSObject

+(instancetype)sharedInstance;

-(NSMutableArray*)getShuffle;

-(void)makePoker:(PokerEntity*)poker containerView:(UIView *)view;

-(void)makePokerByNum:(NSInteger)num pokerSuit:(PokerSuitEnum)suit containerView:(UIView*)view;

@end
