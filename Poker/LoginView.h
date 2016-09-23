//
//  UIViewController+LoginView.h
//  Poker
//
//  Created by leonky on 16/9/22.
//  Copyright © 2016年 Hointe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"
#import "Pomelo.h"
#import "PKViewTransfer.h"
#import "GloubVariables.h"
#import "PkMainViewController.h"

@interface LoginView:UIViewController <UITextFieldDelegate,PomeloDelegate>{
    Pomelo *pomelo;
}

@property (weak, nonatomic) IBOutlet UITextField *txtUserID;
@property (weak, nonatomic) IBOutlet UITextField *txtPWD;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UIButton *btnForgotPassWord;
@property (weak, nonatomic) IBOutlet UIButton *btnSignUp;

@end
