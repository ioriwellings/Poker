//
//  UserInfo.m
//  QPush
//
//  Created by Iori on 7/21/15.
//  Copyright (c) 2015 Hointe. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

static UserInfo* user = nil; //仅模块内使用

+ (UserInfo*)sharedUser
{
    @synchronized(self)
    {
        if(user == nil)
        {
            user = [[UserInfo alloc] init];
        }
    }
    return user;
}

-(void)exit
{
    self.token = nil;
//    self.userID = nil;
//    self.userDisplayName = nil;
}

@end
