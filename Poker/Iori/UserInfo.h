//
//  UserInfo.h
//  QPush
//
//  Created by Iori on 7/21/15.
//  Copyright (c) 2015 Hointe. All rights reserved.
//

#ifndef QPush_UserInfo_h
#define QPush_UserInfo_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UserInfo : NSObject
{
    
}
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *userLoginName;
@property (nonatomic, copy) NSString *pwd;
@property (nonatomic, strong) NSString *userDisplayName;

+ (UserInfo*)sharedUser;
- (void)exit;

@end

#endif
