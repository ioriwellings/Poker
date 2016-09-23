
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
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self cache:NO];
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

-(void)setPoint:(CGPoint)point duration:(NSTimeInterval)time finished:(DCAnimationFinished)finished
{
    [UIView animateWithDuration:time animations:^{
        CGRect frame = self.frame;
        frame.origin = point;
        self.frame = frame;
    }completion:^(BOOL f){
        if(finished && f == YES)
            finished();
    }];
}

-(CGPoint)getViewCenterInView:(UIView*)parentView
{
    CGPoint point = CGPointMake(self.frame.origin.x+self.frame.size.width/2.0,
                       self.frame.origin.y+self.frame.size.height/2.0);
    return [self convertPoint:point toView:parentView];
}

@end
