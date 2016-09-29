//
//  UIViewController+PKlobbyViewController.m
//  Poker
//
//  Created by leonky on 16/9/23.
//  Copyright © 2016年 Hointe. All rights reserved.
//

#import "PKlobbyViewController.h"
#import "PKlobbyCell.h"
#import "UserInfo.h"
#import "PokerTableViewControler.h"

@interface PKlobbyViewController (){
    
}
@end
@implementation PKlobbyViewController

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(BOOL)prefersStatusBarHidden
{
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
 
    self.historyTable.delegate = self;
    self.historyTable.dataSource = self;
    [self.historyTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    
    NSString * moneyQWE = [GloubVariables sharedInstance].money;
    NSString *longMoney = [NSString stringWithFormat:@"%@",moneyQWE];
    [self.money setText:[self positiveFormat:longMoney]];
    [self getdata];
    self.tmpBtn = self.btnBtnA;
    self.btnBtnA.selected = YES;
    self.btnBtnB.selected = NO;
    
    

//    NSArray * array = [NSArray arrayWithObjects:@"默认",@"销量",@"价格",@"时间", nil];
//    for (int i = 0; i<4; i ++) {
//        UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(80*i, 0, 80, 40)];
//        [button setTitle:[array objectAtIndex:i] forState:UIControlStateNormal];
//        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//        [button setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
//        [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
//        [button.layer setBorderWidth:0.3];
//        button.userInteractionEnabled = YES;
//        [button addTarget:self action:@selector(buttonSelected:) forControlEvents:UIControlEventTouchUpInside];
//        [button setBackgroundColor:[UIColor whiteColor]];
//        [button setTag:i];
//        [self.view addSubview:button];
//    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrOnlineCheckHistory.count;
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PKlobbyCell *cell =[tableView dequeueReusableCellWithIdentifier:@"PKlobbyCell"];
    //去掉分割线
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSInteger row = [indexPath row];
    NSDictionary *rowData = [self.arrOnlineCheckHistory objectAtIndex:row];
    
    cell.title = [NSString stringWithFormat:@"NO.%@   sb:%@ bb:%@ ",
                  [rowData objectForKey:@"roomID"],
                  [rowData objectForKey:@"smallBlind"],
                  [rowData objectForKey:@"bigBlind"]];
    
    cell.people =[NSString stringWithFormat:@"%@/%@",
                  [rowData objectForKey:@"playerCount"],
                  [rowData objectForKey:@"maxPlayerCount"]];
//    sb:50 bb:100 player: 3/9
//    roomID  smallBlind bigBlind playerCount maxPlayerCount
//    [self.labTeacherName setText:
//     [NSString stringWithFormat:@"%@",
//      [data objectForKey:@"teacherName"]]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{//该方法响应列表中行的点击事件
    NSInteger row = [indexPath row];
    NSDictionary *rowData = [self.arrOnlineCheckHistory objectAtIndex:row];
    NSString *roomID = [NSString stringWithFormat:@"%@",[rowData objectForKey:@"roomID"]];
    NSLog(@"roomID ==== %@",roomID);
//    __weak typeof(self) weakSelf = self;
    //创建
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    // 读取账户
    NSString * playerNickName = [userDefaults objectForKey:@"playerNickName"];
    [UserInfo sharedUser].userID = playerNickName;
    [UserInfo sharedUser].roomName = roomID;
    PokerTableViewControler *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PokerTableViewControler"];
    vc.OnePomelo = self.OnePomelo;
    [self presentViewController:vc animated:YES completion:NULL];
}

-(void)getdata{
    NSString *name;
    NSString *channel;
    __weak typeof(self) ws = self;
     __weak typeof(self) weakSelf = self;
//    [self.OnePomelo connectToHost:[GloubVariables sharedInstance].host
//                   onPort:[GloubVariables sharedInstance].port
//             withCallback:^(Pomelo *p){
//                 NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
//                                         name, @"loginName",
//                                         channel, @"passWord",
//                                         nil];
//                 [p requestWithRoute:@"connector.entryHandler.getHall" andParams:params andCallback:^(NSDictionary *result){
//                     //                            NSArray *userList = [result objectForKey:@"users"];
//                     NSArray *roomList = [result objectForKey:@"roomList"];
//                     if (roomList.count > 0) {
//                         self.arrOnlineCheckHistory = roomList;
//                         [weakSelf.historyTable reloadData];
//                     }
//                 }];
//             }];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            name, @"loginName",
                            channel, @"passWord",
                            nil];
    [self.OnePomelo requestWithRoute:@"connector.entryHandler.getHall" andParams:params andCallback:^(NSDictionary *result){
        //                            NSArray *userList = [result objectForKey:@"users"];
        NSArray *roomList = [result objectForKey:@"roomList"];
        if (roomList.count > 0) {
            self.arrOnlineCheckHistory = roomList;
            [weakSelf.historyTable reloadData];
        }
    }];
}

- (IBAction)reloadlist:(id)sender
{
    UIButton*btn = (UIButton *)sender;
    btn.selected = !btn.selected;
    [self getdata];
}

- (IBAction)reloadlist_B:(id)sender
{
//   self.btnBtnA.highlighted = NO;
    self.btnBtnB.highlighted = YES;
//    [self getdata];
}

- (IBAction)buttonSelected:(id)sender{
        UIButton*btn = (UIButton *)sender;
        if (_tmpBtn == nil){
            btn.selected = YES;
            _tmpBtn = sender;
        }
        else if (_tmpBtn !=nil && _tmpBtn == sender){
            btn.selected = YES;
        }
        else if (_tmpBtn!= btn && _tmpBtn!=nil){
            _tmpBtn.selected = NO;
            btn.selected = YES;
            _tmpBtn = btn;
            [self getdata];
        }
}


- (IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

//-(void)buttonSelected:(UIButton*)sender{
//    if (_tmpBtn == nil){
//        sender.selected = YES;
//        _tmpBtn = sender;
//    }
//    else if (_tmpBtn !=nil && _tmpBtn == sender){
//        sender.selected = YES;
//        
//    }
//    else if (_tmpBtn!= btn && _tmpBtn!=nil){
//        _tmpBtn.selected = NO;
//        sender.selected = YES;
//        _tmpBtn = btn;
//    }
//}

-(NSString *)positiveFormat:(NSString *)text{
    
    if(!text || [text floatValue] == 0){
//        return @"0.00";
        return @"0";
    }else{
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
//        [numberFormatter setPositiveFormat:@",###.00;"];
        [numberFormatter setPositiveFormat:@",###;"];
        return [numberFormatter stringFromNumber:[NSNumber numberWithDouble:[text doubleValue]]];
    }
    return @"";
}

-(void)dealloc
{
    NSLog(@"%@:%s",self,__func__);
}
@end

