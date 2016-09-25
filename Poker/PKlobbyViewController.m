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

@implementation PKlobbyViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.historyTable.delegate = self;
    self.historyTable.dataSource = self;
    [self.historyTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    NSString * moneyQWE = [GloubVariables sharedInstance].money;
    
    NSString *longMoney = [NSString stringWithFormat:@"%@",moneyQWE];
    
    [self.money setText:longMoney];
    [self getdata];
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
    PokerTableViewControler *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];
    [self presentViewController:vc animated:YES completion:NULL];
}

-(void)getdata{
    NSString *name;
    NSString *channel;
    __weak typeof(self) ws = self;
    pomelo = [[Pomelo alloc] initWithDelegate:ws];
    [pomelo connectToHost:[GloubVariables sharedInstance].host
                   onPort:[GloubVariables sharedInstance].port
             withCallback:^(Pomelo *p){
                 NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                         name, @"loginName",
                                         channel, @"passWord",
                                         nil];
                 [p requestWithRoute:@"connector.entryHandler.getHall" andParams:params andCallback:^(NSDictionary *result){
                     //                            NSArray *userList = [result objectForKey:@"users"];
                     NSArray *roomList = [result objectForKey:@"roomList"];
                     if (roomList.count > 0) {
                         self.arrOnlineCheckHistory = roomList;
                         [ws.historyTable reloadData];
                     }
                 }];
             }];
}

- (IBAction)reloadlist:(id)sender
{
    [self getdata];
}

- (IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)dealloc
{
    [pomelo disconnect];
    pomelo = nil;
    NSLog(@"%@:%s",self,__func__);
}
@end

