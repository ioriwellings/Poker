//
//  LoginViewController.h
//  Poker
//
//  Created by Iori on 9/8/16.
//  Copyright © 2016 Hointe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"
#import "SDTransparentPieProgressView.h"

@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *txtUserName;
@property (weak, nonatomic) IBOutlet UITextField *txtRoomID;

- (IBAction)btnLogin_click:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet SDTransparentPieProgressView *progressView;
@property (weak, nonatomic) IBOutlet SDTransparentPieProgressView *view2;
@end
