//
//  NSObject+PKViewTransfer.h
//  Poker
//
//  Created by leonky on 16/9/22.
//  Copyright © 2016年 Hointe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef void (^transfer_block_t)(UIViewController*);
@interface PKViewTransfer:NSObject<UIAlertViewDelegate>
+ (PKViewTransfer*) sharedViewTransfer;

- (void) pushViewController:(NSString*)name block:(transfer_block_t)block;
- (void) pushViewController:(NSString*)name story:(NSString*)story block:(transfer_block_t)block;
- (void) pushViewController:(NSString*)name storyboard:(UIStoryboard*)story block:(transfer_block_t)block;
- (void) showSimpleAlertView:(NSString*)title msg:(NSString*)msg cancelButtonTitle:(NSString*)cancelButtonTitle;
- (void) showNoDataAlert;
- (void) drawLabelSqueare:(UILabel*)label color:(UIColor*)color;
@end
