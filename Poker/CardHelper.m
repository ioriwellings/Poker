//
//  CardHelper.m
//  Poker
//
//  Created by Iori on 8/5/16.
//  Copyright © 2016 Hointe. All rights reserved.
//

#import "CardHelper.h"

@implementation CardHelper

static CardHelper* __helper = nil; //仅模块内使用

+(instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __helper = [[CardHelper alloc] init];
    });
    return __helper;
}

//+(id)allocWithZone:(struct _NSZone *)zone
//{
//    return [CardHelper sharedInstance] ;
//}
//
//-(id)copyWithZone:(struct _NSZone *)zone
//{
//    return [CardHelper sharedInstance] ;
//}

-(NSMutableArray *)getShuffle
{
    NSMutableArray *arrayResult = [NSMutableArray arrayWithCapacity:52];
    for (int i = 1; i<14; i++)//A->K
    {
        for (int j=0; j<4; j++)
        {
            PokerEntity *poker = [PokerEntity new];
            poker.numberValue = i;
            poker.pokerSuit = (PokerSuitEnum)j;
            [arrayResult addObject:poker];
        }
    }
    return arrayResult;
}

-(void)makePoker:(PokerEntity*)poker containerView:(UIView *)view
{
    [self makePokerByNum:poker.numberValue pokerSuit:poker.pokerSuit containerView:view];
}

-(void)makePokerByNum:(NSInteger)num pokerSuit:(PokerSuitEnum)suit containerView:(UIView *)view
{
    if([view isKindOfClass:[UIImageView class]])
    {
        ((UIImageView*)view).image = nil;
    }
    [view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
    {
        [obj removeFromSuperview];
    }];
    UILabel *labNum = [UILabel new];
    UILabel *labSuit = [UILabel new];
    labSuit.font = [UIFont systemFontOfSize:26];
    if(num >= 2 && num <=10 )
    {
        labNum.text = [[NSNumber numberWithInteger:num] stringValue];
    }
    else
    {
        if(num == 1)
        {
            labNum.text = @"A";
        }
        else if(num == 11)
        {
            labNum.text = @"J";
        }
        else if (num == 12)
        {
            labNum.text = @"Q";
        }
        else if (num == 13)
        {
            labNum.text = @"K";
        }
    }
    if(suit == PokerSuitEnumSpades)
    {
        labSuit.text = @"\u2660";
    }
    else if (suit == PokerSuitEnumHearts)
    {
        labSuit.text = @"\u2665";
    }
    else if (suit == PokerSuitEnumDiamonds)
    {
        labSuit.text = @"\u2666";
    }
    else
    {
        labSuit.text = @"\u2663";
    }
    [labNum sizeToFit];
    [labSuit sizeThatFits:CGSizeMake(40, 40)];
    [view addSubview:labNum];
    [view addSubview:labSuit];
    view.backgroundColor = [UIColor whiteColor];
    [labNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view.mas_top).offset(2);
        make.left.equalTo(view.mas_left).offset(3);
    }];
    [labSuit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.mas_centerX);
        make.centerY.equalTo(view.mas_centerY).multipliedBy(1.2);
    }];
    view.layer.cornerRadius = 4;
}
@end
