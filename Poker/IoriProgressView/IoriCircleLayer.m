//
//  IoriCircleLayer.m
//  PGEBOS
//
//  Created by Iori on 3/2/16.
//  Copyright © 2016 sunny. All rights reserved.
//

#import "IoriCircleLayer.h"

@interface IoriCircleLayer ()
{
    
}
@end

@implementation IoriCircleLayer

@dynamic percent;

-(instancetype)initWithLayer:(id)layer
{
    if(self = [super initWithLayer:layer])
    {
        NSLog(@"%s", __func__);
    }
    return self;
}

-(instancetype)init
{
    self = [super init];
    if(self)
    {
//        CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"position"];
//        animation.duration =5.f;
//        NSMutableDictionary* action = [NSMutableDictionary dictionaryWithDictionary:self.actions];
//        NSLog(@"action = %@",action);
//        action[@"position"] = animation;
//        self.actions = action;
//          self.delegate = self;
    }
    return self;
}

//-(void)display
//{
//    NSLog(@"%s", __func__);
//    NSLog(@"%s", __FUNCTION__);
//}

//delegate
-(void)displayLayer:(CALayer *)layer
{
    NSLog(@"%s", __func__);
    NSLog(@"%s", __FUNCTION__);
}

-(void)drawInContext:(CGContextRef)ctx
{
    NSLog(@"__func__:%s, line:%d", __func__, __LINE__);
    NSLog(@"__FUNCTION__:%s",__FUNCTION__);
    NSLog(@"percent:%lf", [self.presentationLayer percent]);
    
    CGContextSetLineWidth(ctx,5.f);
    CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
    CGContextAddArc(ctx,
                    CGRectGetWidth(self.bounds)/2.,
                    CGRectGetHeight(self.bounds)/2.,
                    CGRectGetWidth(self.bounds)/2. - 6,
                    M_PI_2 * 3,
                    
                    M_PI_2*3+M_PI*2*self.percent/100.0,0);
    
    CGContextStrokePath(ctx);
}

//delegate
-(void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
    NSLog(@"__func__:%s", __func__);
    NSLog(@"__FUNCTION__:%s",__FUNCTION__);
}

+(BOOL)needsDisplayForKey:(NSString *)key
{
    NSLog(@"%s, key = %@", __FUNCTION__,  key);
    if([key isEqualToString:@"percent"])
    {
        return YES;
    }
    return [super needsDisplayForKey:key];
}

-(id<CAAction>)actionForKey:(NSString *)event
{
    NSLog(@"event = %@",event);
    
    if (/*self.presentationLayer !=nil
        &&*/ [event isEqualToString:@"percent"])
    {
        
        NSLog(@"pre = %lf , lay = %lf",[[self.presentationLayer valueForKey:event] floatValue], self.percent);
        
        CABasicAnimation* animat = [CABasicAnimation animationWithKeyPath:@"percent"];
        
        animat.duration = 3;//[CATransaction animationDuration];
        animat.timingFunction = [CATransaction animationTimingFunction];
        
        animat.fromValue = [NSNumber numberWithFloat:[(IoriCircleLayer*)[self presentationLayer] percent]];
        
//        animat.toValue = @(50);
        
        animat.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        
        return animat;
        
    }
    if ([event isEqualToString:@"path"])
    {
        CABasicAnimation *animation = [CABasicAnimation
                                       animationWithKeyPath:event];
        animation.duration = [CATransaction animationDuration];
        animation.timingFunction = [CATransaction
                                    animationTimingFunction];
        return animation;
    }
    
    if ([event isEqualToString:@"strokeEnd"])
    {
        CABasicAnimation *animation = [CABasicAnimation
                                       animationWithKeyPath:event];
        animation.duration = 5;;
        animation.timingFunction = [CATransaction
                                     animationTimingFunction];
        animation.fromValue = @(0.0);
        animation.toValue = @(15.0f);
        return animation;
    }
    
    return [super actionForKey:event];
}

//delegate
//-(id<CAAction>)actionForLayer:(CALayer *)layer forKey:(NSString *)event
//{
//    NSLog(@"%s", __FUNCTION__);
//    return [super actionForLayer:layer forKey:event];
//}

@end
