//
//  UITableViewCell+PKlobbyCell.m
//  Poker
//
//  Created by leonky on 16/9/23.
//  Copyright © 2016年 Hointe. All rights reserved.
//

#import "PKlobbyCell.h"

@implementation PKlobbyCell
@synthesize title;

-(void) setTitle:(NSString *)title_txt{
    if (![title_txt isEqualToString:title]) {
        title = [title_txt copy];
        self.toptitle.text = title;
    }
}
@end
