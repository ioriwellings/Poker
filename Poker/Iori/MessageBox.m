//
//  MessageBox.m
//  Rockwell
//
//  Created by Iori on 13-1-29.
//  Copyright (c) 2013年 Iori. All rights reserved.
//

#import "MessageBox.h"

static DGActivityIndicatorView* loadingView;

@implementation MessageBox

+(void)showMsg:(NSString*)strMsg
{
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Infomation", @"AlertView Common's Title, eg Hi, Hello")
                                                         message:strMsg
                                                        delegate:nil
                                               cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    
}

+(void)showMsg:(NSString*)strMsg viewController:(UIViewController*)vc;
{
    if(vc)
    {
        [self showMsg:strMsg];
    }
}

+(DGActivityIndicatorView*)displayLoadingInView:(UIView*)view
{
    DGActivityIndicatorView *activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeBallSpinFadeLoader
                                                                                         tintColor:[UIColor whiteColor]];
    loadingView = activityIndicatorView;
    CGFloat width = 60;
    CGFloat height = 60;
    
    activityIndicatorView.frame = CGRectMake(CGRectGetWidth(view.frame)/2-width/2, CGRectGetHeight(view.frame)/2-width/2, width, height);
    activityIndicatorView.backgroundColor = [UIColor blackColor];
    activityIndicatorView.tintColor = [UIColor whiteColor];
    activityIndicatorView.layer.cornerRadius = 10;
    [view addSubview:activityIndicatorView];
    [activityIndicatorView startAnimating];
    return activityIndicatorView;
}

+(void)removeLoading:(DGActivityIndicatorView*)view
{
    if(view == nil)
        view = loadingView;
    [view stopAnimating];
    [view removeFromSuperview];
    loadingView = nil;
}

+(BOOL)isLoading
{
    return loadingView!=nil;
}

@end
