
#import "UIView+DCAnimationKit.h"

@interface UIImageView (DCAnimationKit)

@end

@implementation UIView (DCAnimationKit)


-(void)flip:(DCAnimationFinished)finished delay:(NSTimeInterval)interval
{
//    [UIView transitionWithView:self
//                      duration:.65
//                       options:UIViewAnimationCurveEaseInOut | UIViewAnimationTransitionFlipFromLeft
//                    animations:^
//    {
//        ;
//    }
//                    completion:^(BOOL flagfinished)
//    {
//        if(finished && flagfinished)
//        {
//            finished();
//        }
//    }];
    self.alpha = 0;
    [UIView animateWithDuration:.65 delay:interval options:0 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self cache:YES];
        self.alpha = 1;
    } completion:^(BOOL flag)
    {
        self.alpha = 1;
        if(finished && flag)
        {
            finished();
        }
    }];
}

+ (void)animationFlipFromLeft:(UIView *)view
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.35f];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:view cache:NO];
    [UIView commitAnimations];
}



@end
