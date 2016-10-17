
#import "UIView+DCAnimationKit.h"
#import "Masonry.h"

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

// Duplicate UIView
+ (UIView*)duplicate:(UIView*)view
{
    NSData * tempArchive = [NSKeyedArchiver archivedDataWithRootObject:view];
    return [NSKeyedUnarchiver unarchiveObjectWithData:tempArchive];
}

+(UIImageView*)duplicateImageView:(UIImageView*)view
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:view.image];
    imageView.frame = view.frame;
    return imageView;
}

+(UIView*)duplicateBetContainer:(UIView *)view
{
    UILabel *labOrigin = view.subviews[0];
    UIImageView *icon = view.subviews[1];
    UIView *temp = [[UIView alloc] initWithFrame:view.frame];
    UILabel *labTemp = [[UILabel alloc] initWithFrame:labOrigin.frame];
    labTemp.textColor = [UIColor whiteColor];
    labTemp.text = labOrigin.text;
    labTemp.font = labOrigin.font;
    labTemp.textAlignment = NSTextAlignmentCenter;
    [temp addSubview:labTemp];
//    [labTemp sizeToFit];
    UIImageView *iconView = [UIView duplicateImageView:icon];
//    iconView.contentMode = UIViewContentModeScaleAspectFill;
    [temp addSubview:iconView];
//    [labTemp mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(iconView.mas_centerY);
//        make.top.equalTo(temp.mas_top);
//        make.bottom.equalTo(temp.mas_bottom);
//        make.leading.equalTo(iconView.mas_trailing).offset(3);
//        make.trailing.equalTo(temp.mas_trailing);
////        make.
//    }];
//    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(temp.mas_top);
//        make.bottom.equalTo(temp.mas_bottom);
//        make.leading.equalTo(temp.mas_leading);
//    }];
    //[temp setContentCompressionResistancePriority:nil forAxis:nil]
    return temp;
}

@end
