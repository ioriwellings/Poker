//
//  UIImage+ProgressMask.m
//  Poker
//
//  Created by Iori on 9/12/16.
//  Copyright © 2016 Hointe. All rights reserved.
//

#import "UIImageView+ProgressMask.h"

#define ToRad(deg) 		( (M_PI * (deg)) / 180.0 )
#define degreesToRadians(x) (M_PI*(x)/180.0) //把角度转换成PI的方式


@implementation UIImageView (ProgressMask)

-(void)updateImageWithProgress:(CGFloat)progress
{
    UIImage *image = [UIImage imageNamed:@"bg_user_1"];
    CALayer *layer = [[CALayer alloc] init];
    layer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    layer.contentsScale = [UIScreen mainScreen].scale;
    layer.contents = (__bridge id)image.CGImage;
    layer.contentsGravity = kCAGravityResizeAspectFill;
    layer.mask = [self getShapeLayer:layer.frame progress:progress];
    [self setImage:[self imageFromLayer:layer]];
}

-(void)animationCircleProgress
{
    
    NSLog(@"%s", __func__);
    __weak typeof(self) ws = self;
    self.hidden = NO;
    CALayer *layer = self.layer;
    layer.mask = [self getShapeLayer:layer.bounds progress:1];
    
    CALayer *maskLayer = layer.mask;
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    anim.fillMode = kCAFillModeBackwards;
    anim.removedOnCompletion = YES;
    anim.autoreverses = NO;
    anim.fromValue = [NSNumber numberWithFloat:0.0];
    anim.duration = 15;
    anim.byValue = [NSNumber numberWithFloat: .5];
    anim.toValue = [NSNumber numberWithFloat:100/100.0];
    anim.delegate = ws;
    [maskLayer removeAnimationForKey:@"runStroke"];
    [maskLayer addAnimation:anim forKey:@"runStroke"];
}

- (void)animationDidStart:(CAAnimation *)anim
{
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if(flag)
        [self removeCircleProgressAnimation];
}

-(void)removeCircleProgressAnimation
{
    [self.layer.mask removeAnimationForKey:@"runStroke"];
    [self.layer setMask:nil];
    //self.image = nil;
    self.hidden = YES;
}

-(CAShapeLayer*)getShapeLayer:(CGRect)frame progress:(CGFloat)progress
{
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.frame = frame;
    layer.lineWidth = frame.size.height/1.0;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = [UIColor grayColor].CGColor;
    //layer.path = [self getPath];
    CGFloat from = - M_PI * 0.5;
    CGFloat to = from + (ToRad(progress*360));
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(frame.size.width/2, frame.size.height/2)
                                                        radius:frame.size.height/2
                                                    startAngle:from
                                                      endAngle:to
                                                     clockwise:YES];
    layer.path = path.CGPath;
    return layer;
}

- (UIImage *)imageFromLayer:(CALayer *)layer
{
    
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
        UIGraphicsBeginImageContextWithOptions([layer frame].size, NO, [UIScreen mainScreen].scale);
    else
        UIGraphicsBeginImageContext([layer frame].size);
    
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return outputImage;
}

@end
