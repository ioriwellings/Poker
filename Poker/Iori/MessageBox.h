//
//  MessageBox.h
//  Rockwell
//
//  Created by Iori on 13-1-29.
//  Copyright (c) 2013年 Iori. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DGActivityIndicatorView.h"

@interface MessageBox : NSObject
{
    
}

+(void)showMsg:(NSString*)strMsg;
+(void)showMsg:(NSString*)strMsg viewController:(UIViewController*)vc;
+(DGActivityIndicatorView*)displayLoadingInView:(UIView*)view;
+(void)removeLoading:(DGActivityIndicatorView*)view;
+(BOOL)isLoading;
@end
