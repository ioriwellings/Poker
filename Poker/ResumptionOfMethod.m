//
//  ResumptionOfMethod.m
//  Poker
//
//  Created by admin on 16/9/25.
//  Copyright © 2016年 Hointe. All rights reserved.
//

#import "ResumptionOfMethod.h"
#import "MessageBox.h"
#import "GloubVariables.h"

@implementation ResumptionOfMethod
@synthesize arrData;

- (void)initData:(NSArray* )arrData_
{
    
    arrData = arrData_;
    nowCountNum=0;//当前播放到什么事件的count
    timeNum=0;//当前时间
    clickCountNum=0;//点击次数
    btnFlag=YES;
    // Do any additional setup after loading the view.
    timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(playFunction) userInfo:nil repeats:YES];
}
- (NSString*)getTimer:(double)time
{
    int hours =(int) (time/(60*60));
    int minutes = (int) (time/60-hours*60);
    int seconds = (int) (time-minutes*60-hours*60*60);
    NSString *m;
    if(minutes>=10){
        m = [NSString stringWithFormat:@"%d",minutes];
    }else{
        m = [NSString stringWithFormat:@"0%d",minutes];
    }
    
    NSString *s;
    if(seconds>=10){
        s = [NSString stringWithFormat:@"%d",seconds];
    }else{
        s = [NSString stringWithFormat:@"0%d",seconds];
    }
    
    NSString *strTime = [NSString stringWithFormat:@"%@:%@",m,s];
    
    return strTime;
}
//正常的play方法
-(void)playFunction{
    timeNum+=0.1;
    [self.timeLb setText:[self getTimer:timeNum]];
    //    NSLog(@"播放时间%f",timeNum);
    if (nowCountNum<[arrData count]) {
        NSDictionary *dictData = [arrData objectAtIndex:nowCountNum];
        double time =[[dictData objectForKey:@"time"] doubleValue];
        NSDictionary * data = [dictData objectForKey:@"data"];
        NSString * route = [dictData objectForKey:@"route"];
        if(timeNum>=time && time<timeNum+0.1){
            nowCountNum++;
            //调用某个方法将data传递给播放界面
            //            NSLog(@"%@调用某个方法将data传递给播放界面--------%@",route,data);
            [self getResumptionData:data getRoute:route];
        }
    }else{
        //        NSLog(@"之后调用某个函数告诉播放界面---播放结束");
        [self closeTimer];
        //之后调用某个函数告诉播放界面---播放结束
        _playBtn.selected =YES;
        btnFlag=NO;
    }
}
//快进
-(void)fastForward{
    NSLog(@"快进开始");
    [self stop];
    nowCountNum++;
    if (nowCountNum<[arrData count]) {
        NSDictionary *dictData = [arrData objectAtIndex:nowCountNum-1];
        double time =[[dictData objectForKey:@"time"] doubleValue];
        NSDictionary * data = [dictData objectForKey:@"data"];
        timeNum=time;
        NSLog(@"调用某个方法将data传递给播放界面---data:%@",data);
        //调用某个方法将data传递给播放界面
    }else{
        [self closeTimer];
        //之后调用某个函数告诉播放界面---播放结束
    }
    [self play];
}
//快退 --- count 快退了几步
-(void)fastRewind:(int)count{
    NSLog(@"快退开始");
    [self stop];
    nowCountNum-=count;
    if (nowCountNum<0) {
        nowCountNum=0;
    }
    NSMutableArray *arr1 = [[NSMutableArray alloc] init];
    if (nowCountNum<[arrData count] && nowCountNum>=0) {
        NSDictionary *dictData = [arrData objectAtIndex:nowCountNum];
        double time =[[dictData objectForKey:@"time"] doubleValue];
        timeNum=time;
        for (int i=0;i<nowCountNum;i++) {
            NSDictionary *dict = [arrData objectAtIndex:i];
            NSDictionary * data = [dict objectForKey:@"data"];
            [arr1 addObject:data];
        }
    }
    for (NSDictionary* dict in arr1) {
        NSLog(@"将数组传给界面----arr1：%@",dict);
    }
    //将数组传给界面----arr1
    [self play];
}
//停止
-(void)stop{
    NSLog(@"停止");
    [timer setFireDate:[NSDate distantFuture]];
}
//播放
-(void)play{
    NSLog(@"播放");
    [timer setFireDate:[NSDate distantPast]];
}

-(void)closeTimer{
    [timer invalidate];//将播放永远关掉
    timer=NULL;
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    
    //设置未滑动位置背景图片
    [self.slider setMinimumTrackImage:[UIImage imageNamed:@"slider_1_new"] forState:UIControlStateNormal];
    //设置已滑动位置背景图
    [self.slider setMaximumTrackImage:[UIImage imageNamed:@"slider_bg_new"] forState:UIControlStateNormal];
    //设置滑块图标图片
    [self.slider setThumbImage:[UIImage imageNamed:@"btn_raise_1"] forState:UIControlStateNormal];
    //设置点击滑块状态图标
    //    [self.slider setThumbImage:[UIImage imageNamed:@"main_slider_btn.png"] forState:UIControlStateHighlighted];
    
    [self initTableLayout];
    
    [self reconnectToHost];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleActionNotificationWithPlayer:) name:ShowPlayerActionNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleActionNotificationWithPlayer:) name:ClosePlayerActionNotification object:nil];
    [self entryWithData];
}

- (void)PomeloDidDisconnect:(Pomelo *)_pomelo withError:(NSError *)error{}
-(void)reconnectToHost{}
- (void)entryWithData{
    __weak typeof(self) ws = self;
    
    NSLog(@"%@",[GloubVariables sharedInstance].host);
    NSLog(@"%ld",(long)[GloubVariables sharedInstance].port);
    
    //创建
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    // 读取账户
    NSString * playerNickName = [userDefaults objectForKey:@"playerNickName"];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"1", @"gameReplayType",
                            playerNickName,@"playerID",
                            nil];
    [self.OnePomelo requestWithRoute:@"connector.entryHandler.gameReplay" andParams:params andCallback:^(NSDictionary *result){
        
        NSLog(@"result:%@",result);
        
        NSString *error = [result objectForKey:@"error"];
        if (error && ![error isEqual:@""]) {
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
            //                            NSDictionary *dict = [result objectForKey:@"body"]  ;
            NSArray *arr1 = [result objectForKey:@"gameReplayData"];
            [self updateRoomLb:arr1];
            [self initData:arr1];
        }
    }];
}

-(void)updateRoomLb:(NSArray*)arr{
    NSDictionary *dict1 = [arr objectAtIndex:0];
    NSDictionary *dict = [dict1 objectForKey:@"data"];
    NSDictionary *room = [dict objectForKey:@"room"];
    NSDictionary *game = [dict objectForKey:@"game"];
    
    NSString *roomID = [room objectForKey:@"roomID"];
    NSMutableString *beginTime = [game objectForKey:@"beginTime"];
    
    NSString *yaer = [beginTime substringToIndex:10];
    
    NSString *time =  [beginTime substringWithRange:NSMakeRange(11,5)];
    
    [self.roomLb setText:[NSString stringWithFormat:@"[复盘]%@ %@开局   房间：%@",yaer,time,roomID]];
    
}
#pragma mark -cy复牌B
-(void)getResumptionData:(NSDictionary*)dictData_ getRoute:(NSString*)route_{
    //    NSLog(@"-------->getRseumptingData:%@",dictData_);
    __weak typeof(self) ws = self;
    
    if([route_ compare:@"createRoom"]==0){//初始化数据
        [ws initTableLayout];
        //观战者
        //        NSArray *userList = [[dictData_ objectForKey:@"dataInfo"] objectForKey:@"observerPlayerList"];
        //        NSLog(@"%@",userList);
        //房间信息
        NSDictionary *room = [IoriJsonHelper getDictForKey:@"room" fromDict:dictData_];
        RoomEntity *roomInfo = [RoomEntity new];
        roomInfo.roomBaseBigBlind = [IoriJsonHelper getIntegerForKey:@"roomBaseBigBlind" fromDict:room];
        roomInfo.roomBaseSmallBlind = [IoriJsonHelper getIntegerForKey:@"roomBaseSmallBlind" fromDict:room];
        pokerTable.sb = roomInfo.roomBaseSmallBlind;
        pokerTable.bb = roomInfo.roomBaseBigBlind;
        pokerTable.roomInfo = roomInfo;
        
        //在坐玩家
        NSArray *arrayPlayerList = [[dictData_ objectForKey:@"game"]  objectForKey:@"playerList"];
        [arrayPlayerList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if([obj isKindOfClass:[NSNull class]] == NO)
            {
                NSDictionary *dictPlayer = obj;
                PlayerEntity *player = [self getPlayerFromDictionary:dictPlayer];
                [arrayPlayer addObject:player];
            }
        }];
        [ws player2Seat];
        [ws updateTableInfoUI];
        [MessageBox removeLoading:nil];
    }
    if([route_ compare:@"onNewPlayerEnter"]==0)
    {
        [ws onNewPlayerEnter:dictData_];
    }
    if([route_ compare:@"onFlop" ]==0)
    {
        [ws onFlop:(NSDictionary *)dictData_];
    }
    if([route_ compare:@"onTurn" ]==0)
    {
        [ws onTurn:(NSDictionary *)dictData_];
    }
    if([route_ compare:@"onRiver" ]==0)
    {
        [ws onRiver:(NSDictionary *)dictData_];
    }
    if([route_ compare:@"onSitDown" ]==0)
    {
        [ws onSitDown:(NSDictionary *)dictData_];
    }
    if([route_ compare:@"onEnterRomm" ]==0)
    {
        ;
    }
    if([route_ compare:@"onGameStart" ]==0)
    {
        NSMutableDictionary *dict1 = [NSMutableDictionary dictionaryWithCapacity:1];
        NSMutableDictionary *dict2 = [NSMutableDictionary dictionaryWithCapacity:1];
        [dict2 setObject:dictData_ forKey:@"Data"];
        [dict1 setObject:dict2 forKey:@"body"];
        
        [ws onGameStart:(NSDictionary *)dict1];
    }
    if([route_ compare:@"onCall" ]==0)
    {
        [ws onCall:(NSDictionary *)dictData_];
    }
    if([route_ compare:@"onCheck"]==0)
    {
        [ws onCheck:(NSDictionary *)dictData_];
    }
    if([route_ compare:@"onAllIn" ]==0){
        
        [ws onAllIn:(NSDictionary *)dictData_];
    }
    if([route_ compare:@"onRaise" ]==0)
    {
        [ws onRaise:(NSDictionary *)dictData_];
    }
    if([route_ compare:@"onFold" ]==0)
    {
        [ws onFold:(NSDictionary *)dictData_];
    }
    if([route_ compare:@"onShowdown" ]==0)
    {
        [ws onShowdown:(NSDictionary *)dictData_];
    }
    if([route_ compare:@"onPlayerKick" ]==0)
    {
        [ws onPlayerKick:(NSDictionary *)dictData_];
    }
}
#pragma mark -cy复牌E
//关闭按钮
- (IBAction)btnMenu_click:(UIButton *)sender
{
    [self closeTimer];
    [self dismissViewControllerAnimated:YES completion:NULL];
}
//play按钮
- (IBAction)playBtn:(id)sender{
    
    //    _playBtn.selected =YES;
    
    //    [self.playBtn setImage:@"btn_play" forState:UIControlStateNormal];
    
    if(btnFlag){
        _playBtn.selected =YES;
        btnFlag=NO;
        NSLog(@"stopBtn");
        [self stop];
    }else{
        _playBtn.selected =NO;
        btnFlag=YES;
        
        NSLog(@"playBtn");
        if(timer){
            [self play];
        }
        else{
            nowCountNum=0;//当前播放到什么事件的count
            timeNum=0;//当前时间
            clickCountNum=0;//点击次数
            timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(playFunction) userInfo:nil repeats:YES];
        }
    }
    
    
}
//stop按钮
- (IBAction)stopBtn:(id)sender{
    NSLog(@"stopBtn");
    [self stop];
}

@end
