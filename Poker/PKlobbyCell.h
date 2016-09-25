//
//  UITableViewCell+PKlobbyCell.h
//  Poker
//
//  Created by leonky on 16/9/23.
//  Copyright © 2016年 Hointe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PKlobbyCell:UITableViewCell
@property (weak,nonatomic) IBOutlet UILabel *toptitle;
@property (weak,nonatomic) IBOutlet UILabel *labPeople3;


@property (copy,nonatomic) NSString *title;
@property (copy,nonatomic) NSString *people;
@end
