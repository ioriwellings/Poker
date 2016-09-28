//////////////////////////////////////////////////////////////////////////////////////
//
//  UIView+AnimationKit.h
//
//  Created by Dalton Cherry on 3/20/14.
//
//////////////////////////////////////////////////////////////////////////////////////

#import <UIKit/UIKit.h>

typedef void (^DCAnimationFinished)(void);

@interface UIView (DCAnimationKit)

-(void)setPoint:(CGPoint)point duration:(NSTimeInterval)time finished:(DCAnimationFinished)finished;
-(void)flip:(DCAnimationFinished)finished delay:(NSTimeInterval)interval;
-(CGPoint)getViewCenterInView:(UIView*)parentView;

// Duplicate UIView
+ (UIView*)duplicate:(UIView*)view;
+(UIImageView*)duplicateImageView:(UIImageView*)view;
+(UIView*)duplicateBetContainer:(UIView *)view;
@end
