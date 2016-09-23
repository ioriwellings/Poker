//
//  NSObject+GloubVariables.h
//  Poker
//
//  Created by leonky on 16/9/22.
//  Copyright © 2016年 Hointe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GloubVariables:NSObject
{
    NSString *host;
    NSInteger port;
    NSString *money;
}

@property(nonatomic,strong) NSString *host;
@property(nonatomic) NSInteger port;
@property(nonatomic,strong) NSString *money;
+(GloubVariables *)sharedInstance;
@end
