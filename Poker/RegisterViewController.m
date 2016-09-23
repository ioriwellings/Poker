//
//  UIViewController+registerViewController.m
//  Poker
//
//  Created by leonky on 16/9/22.
//  Copyright © 2016年 Hointe. All rights reserved.
//

#import "RegisterViewController.h"

@implementation RegisterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (IBAction)btnRegister:(id)sender
{
    NSString* name = self.txtUserID.text;
    NSString* channel = self.txtPWD.text;
    __weak typeof(self) ws = self;
    pomelo = [[Pomelo alloc] initWithDelegate:ws];
    
    if (([name length] > 0) && ([channel length] > 0)) {
        [pomelo connectToHost:[GloubVariables sharedInstance].host
                       onPort:[GloubVariables sharedInstance].port
                 withCallback:^(Pomelo *p){
                     NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                             name, @"loginName",
                                             channel, @"passWord",
                                             nil];
                     [p requestWithRoute:@"connector.entryHandler.register"
                               andParams:params
                             andCallback:^(NSDictionary *result){
                         //   NSArray *userList = [result objectForKey:@"users"];
                         NSString *error = [result objectForKey:@"error"];
                         NSString *msg = [result objectForKey:@"msg"];
                         if ([error isKindOfClass:[NSNull class]]) {
                             //失败
                             UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"MESSAGE" message:error preferredStyle:UIAlertControllerStyleAlert];
                             UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancel"
                                                                                    style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                                                                                        //取消按钮
                                                                                        NSLog(@"我是取消按钮");
                                                                                    }];
                             [alertControl addAction:cancelAction];//cancel
                             //显示警报框
                             [self presentViewController:alertControl animated:YES completion:nil];
                         }else{
                             //注册成功
                             UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"MESSAGE" message:msg preferredStyle:UIAlertControllerStyleAlert];
                             UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancel"
                                                                                    style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                                                                                        //取消按钮
                                                                                        NSLog(@"我是取消按钮");
                                                                                    }];
                             [alertControl addAction:cancelAction];//cancel
                             //显示警报框
                             [self presentViewController:alertControl animated:YES completion:nil];
                             [self dismissViewControllerAnimated:YES completion:nil];
                         }                         
                     }];
                 }];
    }
    
    
}

- (IBAction)backBtnClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)dealloc
{
    
}

@end
