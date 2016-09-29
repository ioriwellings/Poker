//
//  UIViewController+LoginView.m
//  Poker
//
//  Created by leonky on 16/9/22.
//  Copyright © 2016年 Hointe. All rights reserved.
//

#import "LoginView.h"
#import "RegisterViewController.h"
#import "PkMainViewController.h"
@interface LoginView ()
{
   // NSString *host;
   // NSInteger port;
}
@end

@implementation LoginView


- (void)viewDidLoad
{
    [super viewDidLoad];
    __weak typeof(self) ws = self;
    pomelo = [[Pomelo alloc] initWithDelegate:ws];
    self.txtUserID.delegate = self;
    self.txtPWD.delegate = self;
    self.txtPWD.secureTextEntry = YES;
    self.aidView.hidden =YES;
    [self.aidView stopAnimating];
    [self initData];
}

- (void)initData{
    __weak typeof(self) ws = self;
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
    [pomelo connectToHost:[GloubVariables sharedInstance].host
                   onPort:[GloubVariables sharedInstance].port
             withCallback:^(Pomelo *p){
                 self.aidView.hidden =YES;
                 [self.aidView stopAnimating];
             }];
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
        [self.txtUserID setText:playerNickName];
    }
}



- (IBAction)btnLogin_click:(id)sender
{
    NSString* name = self.txtUserID.text;
    NSString* channel = self.txtPWD.text;
    if (([name length] > 0) && ([channel length] > 0)) {
        [self doLogin];
    }else{
    }
}

- (IBAction)btnForgotPassWord_click:(id)sender
{
}

- (IBAction)btnSignUp_click:(id)sender
{
    [[PKViewTransfer sharedViewTransfer] pushViewController:@"registerVC"
                                                      story:@"Login"
                                                      block:^(UIViewController *vc) {
                                                          RegisterViewController *revc = (RegisterViewController*)vc;
                                                          revc.OnePomelo = pomelo;
                                                          [self presentViewController:vc animated:YES completion:nil];
                                                      }];
}

- (void) doLogin
{
    self.aidView.hidden = NO;
    [self.aidView startAnimating];    
    NSString* name = self.txtUserID.text;
    NSString* channel = self.txtPWD.text;
    if (([name length] > 0) && ([channel length] > 0)) {
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                name, @"loginName",
                                channel, @"passWord",
                                nil];
        [pomelo requestWithRoute:@"connector.entryHandler.login" andParams:params andCallback:^(NSDictionary *result){
            //                            NSArray *userList = [result objectForKey:@"users"];
            self.aidView.hidden =YES;
            [self.aidView stopAnimating];
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
            }else{
                NSDictionary *data = [result objectForKey:@"playerInfo"];
                //成功
                NSString *playerNickName = [data objectForKey:@"playerNickName"];
                NSString *playerMoney = [data objectForKey:@"playerMoney"];
                [GloubVariables sharedInstance].money = playerMoney;
                [self newNSUserDefault:data];
                
//                [self dismissViewControllerAnimated:YES completion:^{
//                    NSDictionary *dictionary = [NSDictionary dictionaryWithObject:playerNickName forKey:@"name"];
//                    [[NSNotificationCenter defaultCenter] postNotificationName:@"do" object:self userInfo:dictionary];
//                }];
                
                [[PKViewTransfer sharedViewTransfer] pushViewController:@"mainvc"
                                                                  story:@"Login"
                                                                  block:^(UIViewController *vc) {
                                                                      PkMainViewController* pkmvc = (PkMainViewController*)vc;
                                                                      pkmvc.OnePomelo = pomelo;
                                                                      pkmvc.name = playerNickName;
                                                                      [self presentViewController:vc animated:YES completion:nil];
                                                                  }];
                
            }
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
    [[NSUserDefaults standardUserDefaults ]setObject:self.txtPWD.text forKey:@"playerPassword"];
    //必须
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (void) setDefaulName:(NSString*)name{
//    Student *s1 = [[Student alloc] init];
//    s1.name = @"zzz";
//    s1.age = 18;
    NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    // 这个文件后缀可以是任意的，只要不与常用文件的后缀重复即可，我喜欢用data
    NSString *filePath = [path stringByAppendingPathComponent:@"student.data"];
    // 归档
    [NSKeyedArchiver archiveRootObject:name toFile:filePath];
}

-(void)alertViewcontrol
{
    
    //UIAlertControllerStyleAlert
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"司小文的博客" message:@"http://blog.csdn.net/siwen1990" preferredStyle:UIAlertControllerStyleAlert];
    
    //UIAlertControllerStyleActionSheet
    //    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"司小文的博客" message:@"http://blog.csdn.net/siwen1990" preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //普通按钮
        NSLog(@"我是普通按钮");
    }];
    
    UIAlertAction *aaaAction = [UIAlertAction actionWithTitle:@"aaa" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        //红色按键
        NSLog(@"我是红色按键");
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //取消按钮
        NSLog(@"我是取消按钮");
    }];
    
    
    //如果是UIAlertControllerStyleActionSheet 不能使用添加输入框的方法
    [alertControl addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        //添加输入框(已经自动add，不需要手动)
        
        textField.text = @"可以在这里写textfield的一些属性";
        
        //监听
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(listeningTextField:) name:UITextFieldTextDidChangeNotification object:textField];
        
    }];
    
    //添加按钮（按钮的排列与添加顺序一样，唯独取消按钮会一直在最下面）
    [alertControl addAction:okAction];//ok
    [alertControl addAction:aaaAction];//aaa
    [alertControl addAction:cancelAction];//cancel
    
    //显示警报框
    [self presentViewController:alertControl animated:YES completion:nil];
    
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
