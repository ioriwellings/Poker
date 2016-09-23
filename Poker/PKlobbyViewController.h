//
//  UIViewController+PKlobbyViewController.h
//  Poker
//
//  Created by leonky on 16/9/23.
//  Copyright © 2016年 Hointe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GloubVariables.h"
#import "Pomelo.h"
#import "Config.h"
#import "PKViewTransfer.h"

@interface PKlobbyViewController:UIViewController <UITableViewDelegate,UITableViewDataSource,PomeloDelegate>{
    Pomelo *pomelo;
}
@property (weak, nonatomic) IBOutlet UITableView *historyTable;
@property (weak, nonatomic) IBOutlet UILabel *money;
@property (nonatomic, strong) NSArray* arrOnlineCheckHistory;
@end
