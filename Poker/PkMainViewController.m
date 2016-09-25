//
//  UIViewController+PkMainViewController.m
//  Poker
//
//  Created by leonky on 16/9/23.
//  Copyright © 2016年 Hointe. All rights reserved.
//

#import "PkMainViewController.h"
#import "PKlobbyViewController.h"

@implementation PkMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initData];
}

- (void)initData{
    isLogin = false;
    
    if (!isLogin) {
        [self.btnGoGame setEnabled:NO];//不能点击
    }
    [self lodaData];
    __weak typeof(self) ws = self;
    pomelo = [[Pomelo alloc] initWithDelegate:ws];
    [pomelo connectToHost:@"192.168.0.101" onPort:3014 withCallback:^(Pomelo *p){
        NSDictionary *params = [NSDictionary dictionaryWithObject:@"13" forKey:@"uid"];
        [pomelo requestWithRoute:@"gate.gateHandler.queryEntry" andParams:params andCallback:^(NSDictionary *result){
            NSLog(@"abc%@",[result objectForKey:@"host"]);
            [pomelo disconnectWithCallback:^(Pomelo *p){
                [ws entryWithData:result];
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
    //读取密码
    NSString * playerMoney = [userDefaults objectForKey:@"playerMoney"];
//    NSMutableDictionary *dict  = [NSMutableDictionary dictionary];
    //这里判空避免拿不到数据 崩溃
    if (playerNickName != nil && playerMoney != nil) {
//        [dict setObject:name forKey:@"phone"];
//        [dict setObject:password forKey:@"password"];
//        [memberMan loginIn:dict];//调登录借口
        self.btnLogin.hidden = YES;
        self.txtUserID.hidden = NO;        
        [self.txtUserID setText:playerNickName];
        
        
//        NSInteger dcm = 10;
//        相应的字符串为
//        NSString *str = [NSString stringWithFormat:@"zd%",dcm];
        NSString *longMoney = [NSString stringWithFormat:@"%@",playerMoney];
        [GloubVariables sharedInstance].money = longMoney;
        isLogin = true;
        [self.btnGoGame setEnabled:YES];
    }
}


-(void)dealloc
{
    [pomelo disconnect];
    pomelo = nil;
    NSLog(@"%@:%s",self,__func__);
}

@end
