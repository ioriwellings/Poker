//
//  UIViewController+PkMainViewController.h
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

@interface PkMainViewController:UIViewController<PomeloDelegate>{
    Pomelo *pomelo;
    PkMainViewController *main;
    BOOL isLogin;
}

@property (weak, nonatomic) IBOutlet UILabel *txtUserID;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UIButton *btnGoGame;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *aidView;

@end
