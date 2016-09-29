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
#import "PKlobbyViewController.h"
#import "LoginView.h"
#import "ResumptionOfMethod.h"

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
    for (int index = 0; index < 5; index++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"banner%02d",index]];
        [self.imageArray addObject:image];
    }
    [self.txtUserID setText:self.name];
    [self setupUI];
    
}



- (IBAction)btnLogin_click:(id)sender
{
  
}
- (IBAction)btnGoGame_click:(id)sender
{
    NSLog(@"1111111");
    [[PKViewTransfer sharedViewTransfer] pushViewController:@"lobbyVC"
                                                      story:@"Login"
                                                      block:^(UIViewController *vc) {
                                                          PKlobbyViewController* pkvc = (PKlobbyViewController*)vc;
                                                          pkvc.OnePomelo = self.OnePomelo;
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
    
    if (([name length] > 0) && ([channel length] > 0)) {
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                name, @"loginName",
                                channel, @"passWord",
                                nil];
        [self.OnePomelo requestWithRoute:@"connector.entryHandler.login" andParams:params andCallback:^(NSDictionary *result){
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

- (void)setupUI {
    // self.centerView.bounds.size.width;
    // 获取当前屏幕的大小
//    CGRect frame = [UIScreen mainScreen].applicationFrame;
    //设置我们的View的中心点
//    CGPoint center = CGPointMake(self.centerView.bounds.origin.x + ceil(self.centerView.bounds.size.width/2),
//                                 self.centerView.bounds.origin.y + ceil(self.centerView.bounds.size.width/2));

    //6SPLUS,7PLUS 0-130,40
    //5S,5 0-200,10
    //6,6S,7P 0-160,40
    NSLog(@"BBBBBB=== %@",[self deviceModelName]);
    float px;
    float py;
    if([[self deviceModelName] isEqualToString:@"iPhone 5S" ]||
       [[self deviceModelName] isEqualToString:@"iPhone 5" ]||
       [[self deviceModelName] isEqualToString:@"iPhone 5C"]){
        px =-200;
        py =10;
    }
    else if ([[self deviceModelName] isEqualToString:@"iPhone 6"] ||
             [[self deviceModelName] isEqualToString:@"iPhone 6s"]){
        px =-160;
        py =40;
    }
    else if ([[self deviceModelName] isEqualToString:@"iPhone 6 Plus"] ||
             [[self deviceModelName] isEqualToString:@"iPhone 6s Plus"]){
        px =-130;
        py =40;
    }else{
        px =-160;
        py =40;
    }
    NewPagedFlowView *pageFlowView = [[NewPagedFlowView alloc]
                                      initWithFrame:CGRectMake(px,py, self.centerView.bounds.size.width, 200)];
    pageFlowView.backgroundColor = [UIColor clearColor];
    pageFlowView.delegate = self;
    pageFlowView.dataSource = self;
    pageFlowView.minimumPageAlpha = 0.4;
    // pageFlowView.minimumPageScale = 0.9;
    
    //5,5s，6 0-10, 185,
    //6PLUS,0-10, 185,
    //初始化pageControl
    UIPageControl *pageControl = [[UIPageControl alloc]
                                  initWithFrame:CGRectMake(0-10, 185,                                                                                self.centerView.bounds.size.width, 8)];
    pageFlowView.pageControl = pageControl;
    [pageFlowView addSubview:pageControl];
    [pageFlowView startTimer];
    [self.centerView addSubview:pageFlowView];
    
    //添加到主view上
//    [self.centerView addSubview:self.indicateLabel];
    
    
}

#pragma mark NewPagedFlowView Delegate
- (CGSize)sizeForPageInFlowView:(NewPagedFlowView *)flowView {
    return CGSizeMake(191/0.95, 200/0.95);
}

#pragma mark NewPagedFlowView Datasource
- (NSInteger)numberOfPagesInFlowView:(NewPagedFlowView *)flowView {
    return self.imageArray.count;
}

- (UIView *)flowView:(NewPagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index{
    PGIndexBannerSubiew *bannerView = (PGIndexBannerSubiew *)[flowView dequeueReusableCell];
    if (!bannerView) {
        bannerView = [[PGIndexBannerSubiew alloc] initWithFrame:CGRectMake(0, 0, 191, 200)];
        bannerView.layer.cornerRadius = 4;
        bannerView.layer.masksToBounds = YES;
    }
    
    //    [bannerView.mainImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:hostUrlsImg,imageDict[@"img"]]] placeholderImage:[UIImage imageNamed:@""]];
    bannerView.mainImageView.image = self.imageArray[index];
    bannerView.allCoverButton.tag = index;
    [bannerView.allCoverButton addTarget:self action:@selector(didSelectBannerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return bannerView;
}

#pragma mark --点击轮播图
- (void)didSelectBannerButtonClick:(UIButton *) sender {
    
    NSInteger index = sender.tag;
    
    NSLog(@"点击了第%ld张图",(long)index + 1);
    
//    self.indicateLabel.text = [NSString stringWithFormat:@"点击了第%ld张图",(long)index + 1];
    
}

- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(NewPagedFlowView *)flowView {
    
//    NSLog(@"滚动到了第%ld页",pageNumber);
}

- (NSMutableArray *)imageArray {
    if (_imageArray == nil) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}

- (UILabel *)indicateLabel {
    
    if (_indicateLabel == nil) {
        _indicateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 300, Width, 16)];
        _indicateLabel.textColor = [UIColor blueColor];
        _indicateLabel.font = [UIFont systemFontOfSize:16.0];
        _indicateLabel.textAlignment = NSTextAlignmentCenter;
        _indicateLabel.text = @"指示Label";
    }
    
    return _indicateLabel;
}

- (IBAction)btnTest:(id)sender
{
    
    [[PKViewTransfer sharedViewTransfer] pushViewController:@"mainRom"
                                                      story:@"MainResumption"
                                                      block:^(UIViewController *vc) {
                                                          ResumptionOfMethod *romd = (ResumptionOfMethod*)vc;
                                                          romd.OnePomelo = self.OnePomelo;
                                                          [self presentViewController:vc animated:YES completion:nil];
                                                      }];
}


- (NSString*)deviceModelName
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    //iPhone 系列
    if ([deviceModel isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceModel isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceModel isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceModel isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceModel isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceModel isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceModel isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
    if ([deviceModel isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
    if ([deviceModel isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
    if ([deviceModel isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    if ([deviceModel isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceModel isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceModel isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceModel isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    
    //iPod 系列
    if ([deviceModel isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceModel isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceModel isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceModel isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceModel isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    
    //iPad 系列
    if ([deviceModel isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceModel isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([deviceModel isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceModel isEqualToString:@"iPad2,4"])      return @"iPad 2 (32nm)";
    if ([deviceModel isEqualToString:@"iPad2,5"])      return @"iPad mini (WiFi)";
    if ([deviceModel isEqualToString:@"iPad2,6"])      return @"iPad mini (GSM)";
    if ([deviceModel isEqualToString:@"iPad2,7"])      return @"iPad mini (CDMA)";
    
    if ([deviceModel isEqualToString:@"iPad3,1"])      return @"iPad 3(WiFi)";
    if ([deviceModel isEqualToString:@"iPad3,2"])      return @"iPad 3(CDMA)";
    if ([deviceModel isEqualToString:@"iPad3,3"])      return @"iPad 3(4G)";
    if ([deviceModel isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad3,5"])      return @"iPad 4 (4G)";
    if ([deviceModel isEqualToString:@"iPad3,6"])      return @"iPad 4 (CDMA)";
    
    if ([deviceModel isEqualToString:@"iPad4,1"])      return @"iPad Air";
    if ([deviceModel isEqualToString:@"iPad4,2"])      return @"iPad Air";
    if ([deviceModel isEqualToString:@"iPad4,3"])      return @"iPad Air";
    if ([deviceModel isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    if ([deviceModel isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    if ([deviceModel isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceModel isEqualToString:@"x86_64"])       return @"Simulator";
    
    if ([deviceModel isEqualToString:@"iPad4,4"]
        ||[deviceModel isEqualToString:@"iPad4,5"]
        ||[deviceModel isEqualToString:@"iPad4,6"])      return @"iPad mini 2";
    
    if ([deviceModel isEqualToString:@"iPad4,7"]
        ||[deviceModel isEqualToString:@"iPad4,8"]
        ||[deviceModel isEqualToString:@"iPad4,9"])      return @"iPad mini 3";
    
    return deviceModel;
}


-(void)dealloc
{
}

@end
