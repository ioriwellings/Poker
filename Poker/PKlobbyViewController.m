//
//  UIViewController+PKlobbyViewController.m
//  Poker
//
//  Created by leonky on 16/9/23.
//  Copyright © 2016年 Hointe. All rights reserved.
//

#import "PKlobbyViewController.h"
#import "PKlobbyCell.h"

@implementation PKlobbyViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.historyTable.delegate = self;
    self.historyTable.dataSource = self;
    [self.historyTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    NSString * moneyQWE = [GloubVariables sharedInstance].money;
    [self.money setText:moneyQWE];
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
    
    cell.title = [NSString stringWithFormat:@"sb:%@ bb:%@ player: %@/%@",
                  [rowData objectForKey:@"smallBlind"],
                  [rowData objectForKey:@"bigBlind"]
                  ,[rowData objectForKey:@"playerCount"],
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
@end

