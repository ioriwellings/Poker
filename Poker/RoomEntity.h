//
//  RoomEntity.h
//  Poker
//
//  Created by Iori on 8/18/16.
//  Copyright © 2016 Hointe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RoomEntity : NSObject
@property (nonatomic, copy) NSString *roomID;
@property (nonatomic, copy) NSString *roomNumber;
@property (nonatomic, copy) NSString *roomPassWord;
@property (nonatomic, copy) NSString *roomName;
@property (nonatomic, assign) NSInteger roomMaxPlayerCount;
@property (nonatomic, assign) NSInteger roomBaseSmallBlind;
@property (nonatomic, assign) NSInteger roomBaseBigBlind;
@property (nonatomic, assign) NSInteger roomBaseMinJetton;
@property (nonatomic, assign) NSInteger addMaxJettom;
@property (nonatomic, copy) NSString *roomPlayTime;
@property (nonatomic, copy) NSString *roomCreateTime;
@property (nonatomic, copy) NSString *roomMaster;
@property (nonatomic, copy) NSString *roomMasterID;
@property (nonatomic, assign) NSInteger ante;
@property (nonatomic, assign) BOOL bAdvancedSettings;
@end
