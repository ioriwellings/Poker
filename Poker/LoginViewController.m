//
//  LoginViewController.m
//  Poker
//
//  Created by Iori on 9/8/16.
//  Copyright © 2016 Hointe. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnLogin_click:(UIButton *)sender
{
    [UserInfo sharedUser].userID = self.txtUserName.text;
    [UserInfo sharedUser].roomName = self.txtRoomID.text;
    [self performSegueWithIdentifier:@"segueLogin" sender:sender];
}
@end
