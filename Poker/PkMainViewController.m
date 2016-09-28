//
//  UIViewController+PkMainViewController.m
//  Poker
//
//  Created by leonky on 16/9/23.
//  Copyright © 2016年 Hointe. All rights reserved.
//

#import "PkMainViewController.h"
#import "PKlobbyViewController.h"

#import "NewPagedFlowView.h"
#import "PGIndexBannerSubiew.h"

#define Width [UIScreen mainScreen].bounds.size.width

@interface PkMainViewController ()<NewPagedFlowViewDelegate, NewPagedFlowViewDataSource>\
/**
 *  图片数组
 */
@property (nonatomic, strong) NSMutableArray *imageArray;

/**
 *  指示label
 */
@property (nonatomic, strong) UILabel *indicateLabel;

@end

@implementation PkMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
//    banner00
//    banner01.png
//    banner02.png
//    banner03.png
//    banner04.png
//    for (int index = 0; index < 5; index++) {
//        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"Yosemite%02d",index]];
//        [self.imageArray addObject:image];
//    }
    
    [self initData];
}

- (void)initData{
    isLogin = false;
    
  //  if (!isLogin) {
  //      [self.btnGoGame setEnabled:NO];//不能点击
  //  }
 //   [self.btnLogin setEnabled:NO];
    __weak typeof(self) ws = self;
    pomelo = [[Pomelo alloc] initWithDelegate:ws];
    [pomelo connectToHost:PK_SERVER_IP onPort:PK_SERVER_PORT withCallback:^(Pomelo *p){
        NSDictionary *params = [NSDictionary dictionaryWithObject:@"13" forKey:@"uid"];
        self.aidView.hidden = NO;
        [self.aidView startAnimating];
        
        [pomelo requestWithRoute:@"gate.gateHandler.queryEntry" andParams:params andCallback:^(NSDictionary *result){
            NSLog(@"abc host== %@",[result objectForKey:@"host"]);
            [pomelo disconnectWithCallback:^(Pomelo *p){
                [ws entryWithData:result];
                [self lodaData];
            }];
        }]; 
    }];
    
}

- (void)entryWithData:(NSDictionary *)data
{
    [GloubVariables sharedInstance].host = [data objectForKey:@"host"];
    [GloubVariables sharedInstance].port = [[data objectForKey:@"port"] intValue];
}


- (IBAction)btnLogin_click:(id)sender
{
    [[PKViewTransfer sharedViewTransfer] pushViewController:@"loginviewcontroler"
                                                      story:@"Login"
                                                      block:^(UIViewController *vc) {
                                                          [self presentViewController:vc animated:YES completion:nil];
                                                      }];
}
- (IBAction)btnGoGame_click:(id)sender
{
    NSLog(@"1111111");
    [[PKViewTransfer sharedViewTransfer] pushViewController:@"lobbyVC"
                                                      story:@"Login"
                                                      block:^(UIViewController *vc) {
                                                          [self presentViewController:vc animated:YES completion:nil];
                                                      }];
    
//    PKlobbyViewController *vc = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateInitialViewController];
//    [self presentViewController:vc animated:YES completion:NULL];
    
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    if (nc) {
        [nc addObserver:self
               selector:@selector(handleColorChange:)
                   name:@"do"
                 object:nil];
    }
}

-(void)handleColorChange:(NSNotification*)noti{
    NSLog(@"XXXXXCC %@",noti);
//    [self firstView里面方法]
    NSDictionary *dict = noti.userInfo;
    NSLog(@"%@",dict[@"btnColor"]);
    self.btnLogin.hidden = YES;
    self.txtUserID.hidden = NO;

    NSString *name = [dict objectForKey:@"name"];
    [self.txtUserID setText:name];
    isLogin = true;
    [self.btnGoGame setEnabled:YES];
}


-(void)lodaData{
    //创建
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    // 读取账户
    NSString * playerNickName = [userDefaults objectForKey:@"playerNickName"];
    //读取钱
    NSString * playerMoney = [userDefaults objectForKey:@"playerMoney"];
    //读取密码
    NSString * playerPassword = [userDefaults objectForKey:@"playerPassword"];
    NSMutableDictionary *dict  = [NSMutableDictionary dictionary];
    //这里判空避免拿不到数据 崩溃
    if (playerNickName != nil && playerMoney != nil && playerPassword != nil) {
        
        [dict setObject:playerNickName forKey:@"loginName"];
        [dict setObject:playerPassword forKey:@"password"];
        [self loginIn:dict]; //调登录借口
        isLogin = true;
        
    }else{
        self.aidView.hidden =YES;
        [self.aidView stopAnimating];
       //  [self.btnLogin setEnabled:YES];
    }
}


-(void)loginIn:(NSDictionary*)dict{

    NSString* name = [dict objectForKey:@"loginName"];
    NSString* channel = [dict objectForKey:@"password"];
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
                     [p requestWithRoute:@"connector.entryHandler.login" andParams:params andCallback:^(NSDictionary *result){
                         //                            NSArray *userList = [result objectForKey:@"users"];
                         NSString *error = [result objectForKey:@"error"];
                         NSString *msg = [result objectForKey:@"msg"];
                         if (error) {
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
                             self.aidView.hidden =YES;
                             [self.aidView stopAnimating];
                             
                         }else{
                             
                             NSDictionary *data = [result objectForKey:@"playerInfo"];
                             //成功
                             NSString *playerNickName = [data objectForKey:@"playerNickName"];
                             NSString *playerMoney = [data objectForKey:@"playerMoney"];
                             [GloubVariables sharedInstance].money = playerMoney;
                             [self newNSUserDefault:data];
                             [self dismissViewControllerAnimated:YES completion:^{
                                 NSDictionary *dictionary = [NSDictionary dictionaryWithObject:playerNickName forKey:@"name"];
                                 [[NSNotificationCenter defaultCenter] postNotificationName:@"do" object:self userInfo:dictionary];
                             }];
                             
                             self.btnLogin.hidden = YES;
                             self.txtUserID.hidden = NO;
                             self.txtUserID .font = [UIFont fontWithName:PK_FONT_A size:100];
                             [self.txtUserID setText:playerNickName];
                             
                             NSString *longMoney = [NSString stringWithFormat:@"%@",playerMoney];
                             [GloubVariables sharedInstance].money = longMoney;
                             
                             [self.btnGoGame setEnabled:YES];
                             self.aidView.hidden =YES;
                             [self.aidView stopAnimating];
                         }
                     }];
                 }];
    }
}


/*
 *简单的存储数据
 */
- (void)newNSUserDefault:(NSDictionary *)userInfo{
    NSString *playerNickName = [userInfo objectForKey:@"playerNickName"];
    NSString *playerMoney = [userInfo objectForKey:@"playerMoney"];
    //快速创建
    [[NSUserDefaults standardUserDefaults] setObject:userInfo forKey:@"userLoginInfo"];
    //储存MONEY
    [[NSUserDefaults standardUserDefaults]setObject:playerMoney forKey:@"playerMoney"];
    //储存账户
    [[NSUserDefaults standardUserDefaults ]setObject:playerNickName forKey:@"playerNickName"];
    //密码
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * playerPassword = [userDefaults objectForKey:@"playerPassword"];
    [[NSUserDefaults standardUserDefaults ]setObject:playerPassword forKey:@"playerPassword"];
    //必须
    [[NSUserDefaults standardUserDefaults]synchronize];
}


-(void)dealloc
{
    [pomelo disconnect];
    pomelo = nil;
    NSLog(@"%@:%s",self,__func__);
}

@end
