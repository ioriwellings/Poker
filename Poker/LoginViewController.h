//
//  LoginViewController.h
//  Poker
//
//  Created by Iori on 9/8/16.
//  Copyright © 2016 Hointe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"

@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *txtUserName;
@property (weak, nonatomic) IBOutlet UITextField *txtRoomID;

- (IBAction)btnLogin_click:(UIButton *)sender;

@end
