//
//  NSObject+GloubVariables.m
//  Poker
//
//  Created by leonky on 16/9/22.
//  Copyright © 2016年 Hointe. All rights reserved.
//

#import "GloubVariables.h"

@implementation GloubVariables
@synthesize host;
@synthesize port;
@synthesize money;

static GloubVariables *instance_;
+(GloubVariables *)sharedInstance
{
    @synchronized(self)
    {
        if(instance_ == nil)
        {
            instance_ = [[GloubVariables alloc] init];
        }
    }
    return instance_;
}
@end
