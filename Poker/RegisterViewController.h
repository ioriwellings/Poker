//
//  UIViewController+registerViewController.h
//  Poker
//
//  Created by leonky on 16/9/22.
//  Copyright © 2016年 Hointe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GloubVariables.h"
#import "Pomelo.h"
@interface RegisterViewController:UIViewController<PomeloDelegate>{
    Pomelo *pomelo;
}
@property (weak, nonatomic) IBOutlet UITextField *txtUserID;
@property (weak, nonatomic) IBOutlet UITextField *txtPWD;

@end
