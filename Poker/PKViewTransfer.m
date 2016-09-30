//
//  NSObject+PKViewTransfer.m
//  Poker
//
//  Created by leonky on 16/9/22.
//  Copyright © 2016年 Hointe. All rights reserved.
//

#import "PKViewTransfer.h"

@implementation PKViewTransfer
+ (PKViewTransfer*) sharedViewTransfer {
    static PKViewTransfer* sharedViewT = nil;
    static dispatch_once_t one;
    dispatch_once(&one, ^{
        sharedViewT = [[PKViewTransfer alloc] initPrivate];
    });
    
    return sharedViewT;
}

- (instancetype) init {
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use sharedViewTransfer"
                                 userInfo:nil];
    return nil;
}

- (instancetype) initPrivate {
    self = [super init];
    
    return self;
}

- (void) pushViewController:(NSString*)name block:(transfer_block_t)block {
    UIStoryboard* board = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController* vc = [board instantiateViewControllerWithIdentifier:name];
    if(!vc) {
        NSLog(@"load view '%@' error!", name);
        return;
    }
    
    if(block != nil)
        block(vc);
}

- (void) pushViewController:(NSString*)name story:(NSString*)story block:(transfer_block_t)block {
    UIStoryboard* board = [UIStoryboard storyboardWithName:story bundle:[NSBundle mainBundle]];
    
    UIViewController* vc = [board instantiateViewControllerWithIdentifier:name];
    if(!vc) {
        NSLog(@"load view '%@' error!", name);
        return;
    }
    
    if(block != nil)
        block(vc);
}

- (void) pushViewController:(NSString*)name storyboard:(UIStoryboard*)story block:(transfer_block_t)block {
    UIViewController* vc = [story instantiateViewControllerWithIdentifier:name];
    if(!vc) {
        NSLog(@"load view '%@' error!", name);
        return;
    }
    
    if(block != nil)
        block(vc);
}

- (void) showSimpleAlertView:(NSString*)title msg:(NSString*)msg cancelButtonTitle:(NSString*)cancelButtonTitle {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:msg
                                                   delegate:self
                                          cancelButtonTitle:cancelButtonTitle
                                          otherButtonTitles:nil, nil];
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex;{
    // the user clicked OK
    if (buttonIndex == 0)
    {
        //do something here...
        NSLog(@"lost -%s", __func__);
        
    }
}

- (void) drawLabelSqueare:(UILabel*)label color:(UIColor*)color {
    [label sizeToFit];
    
    [label.layer setMasksToBounds:YES];
    [label.layer setCornerRadius:3.0f];
    [label.layer setBorderWidth:1.0f];
    [label.layer setBorderColor:color.CGColor];
    [label setTextColor:color];
    
    CGSize s = [label.text sizeWithAttributes:@{NSFontAttributeName:label.font}];
    s.width += 10.0f;
    CGRect frame = label.frame;
    frame.origin.y -= 3.0;
    s.height += 3.0f;
    
    frame.size = s;
    [label setFrame:frame];
}

- (void) showNoDataAlert {
    [[PKViewTransfer sharedViewTransfer] showSimpleAlertView:NSLocalizedString(@"Error.title", nil)
                                                         msg:NSLocalizedString(@"NOSelectionData.title", nil)
                                           cancelButtonTitle:NSLocalizedString(@"BtnConfirm.title", nil)];
}
@end
