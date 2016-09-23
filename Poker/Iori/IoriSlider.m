//
//  IoriSlider.m
//  Poker
//
//  Created by Iori on 9/23/16.
//  Copyright © 2016 Hointe. All rights reserved.
//

#import "IoriSlider.h"

@implementation IoriSlider

-(CGRect)trackRectForBounds:(CGRect)bounds
{
    return CGRectMake(0, 0, bounds.size.width, 11);
}

@end
