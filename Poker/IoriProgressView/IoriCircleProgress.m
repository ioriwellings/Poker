//
//  IoriCircleProgress.m
//  IoriProcessView
//
//  Created by Iori on 2/24/16.
//  Copyright © 2016 com.FlintInfo. All rights reserved.
//

#import "IoriCircleProgress.h"
//#import "IoriCALayer.h"
#import "IoriCircleProgressLayer.h"

@interface IoriCircleProgress ()
{
    UIImageView *bg01;
    UIImageView *bg02;
    CALayer *progressLayer;
    CAShapeLayer *maskLayer;
}
@end

@implementation IoriCircleProgress

+(Class)layerClass
{
    return [IoriCircleProgressLayer class];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

//- (void)drawRect:(CGRect)rect
//{
//    // Drawing code
//    [super drawRect:rect];
//
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    CGContextSetShouldAntialias(ctx, YES);
//    CGContextSetAllowsAntialiasing(ctx, YES);
//    //CGContextTranslateCTM(ctx, 10, 10);
//    //背景色
//    CGPathRef path = [self drawPathWithArcCenter];
//    //[[UIColor colorWithRed:1 green:0 blue:0 alpha:1.0] set];
//    CGContextSetLineCap(ctx, kCGLineCapRound);
//    CGContextSetStrokeColorWithColor(ctx, [UIColor yellowColor].CGColor);
//    CGContextSetLineWidth(ctx, 26);
//    CGContextAddPath(ctx, path);
//    CGContextDrawPath(ctx, kCGPathStroke);//画出上面的线
//    //CGContextDrawImage(ctx, CGRectMake(0, 0, self.frame.size.width, self.frame.size.height), [UIImage imageNamed:@"circle_0.png"].CGImage);
//    //CGContextDrawImage(ctx, CGRectMake(0, 0, self.frame.size.width, self.frame.size.height), [UIImage imageNamed:@"circle_2.png"].CGImage);
//}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
        [self initPrivate];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self initPrivate];
    }
    return self;
}

-(void)initPrivate
{
    UIImage *bg = [UIImage imageNamed:@"circle_0.png"];
    bg01 = [[UIImageView alloc] initWithImage:bg];
    bg01.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:bg01];
    
    bg02 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"circle_bg.png"]];
    bg02.contentMode =  UIViewContentModeScaleToFill;
    [self addSubview:bg02];
    
    bg01.translatesAutoresizingMaskIntoConstraints = NO;
    bg02.translatesAutoresizingMaskIntoConstraints = NO;
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint* leftConstraint = [NSLayoutConstraint constraintWithItem:bg01 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0f constant:0.0f];
    NSLayoutConstraint* rightConstraint = [NSLayoutConstraint constraintWithItem:bg01 attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0.0f];
    NSLayoutConstraint* topConstraint = [NSLayoutConstraint constraintWithItem:bg01 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f];
    NSLayoutConstraint* bottomConstraint = [NSLayoutConstraint constraintWithItem:bg01 attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f];
    [self addConstraints:@[leftConstraint, rightConstraint, topConstraint, bottomConstraint]];
    
    leftConstraint = [NSLayoutConstraint constraintWithItem:bg02 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0f constant:12];
    rightConstraint = [NSLayoutConstraint constraintWithItem:bg02 attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:12];//26
    topConstraint = [NSLayoutConstraint constraintWithItem:bg02 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0f constant:12];
    /*bottomConstraint = [NSLayoutConstraint constraintWithItem:bg02 attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0f constant:12];*/
    //[self addConstraints:@[leftConstraint, rightConstraint, topConstraint/*, bottomConstraint*/]];
    NSLayoutConstraint *equalsWidth = [NSLayoutConstraint constraintWithItem:bg02 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0 constant:-24];
    NSLayoutConstraint *equalsHidth = [NSLayoutConstraint constraintWithItem:bg02 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1.0 constant:-24];
    [self addConstraints:@[/*leftConstraint, rightConstraint, topConstraint, bottomConstraint, */equalsWidth, equalsHidth]];
    [self layoutIfNeeded];
}

-(void)layoutSubviews
{
//    NSLog(@"%@", NSStringFromCGRect(self.frame));
    [super layoutSubviews];
    bg01.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    bg02.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    if(maskLayer)
    {
        CGRect frame = bg02.frame;
        progressLayer.frame = frame;
        maskLayer.path = [self drawPathWithArcCenter];
        CGFloat radio = bg01.frame.size.width/261.0;
        maskLayer.lineWidth = (26*radio);
        return;
//        [progressLayer removeFromSuperlayer];
//        progressLayer = nil;
//        [maskLayer removeFromSuperlayer];
//        maskLayer = nil;
    }
    CAShapeLayer *mask = [CAShapeLayer layer];
    mask.path = [self drawPathWithArcCenter];
    mask.fillColor = [UIColor clearColor].CGColor;
    mask.strokeColor = [UIColor grayColor].CGColor;
    CGFloat radio = bg01.frame.size.width/261.0;
//    NSLog(@"bg01:%f===%lf", bg01.frame.size.width,radio);
    mask.lineWidth = (26*radio);
    mask.lineCap = kCALineCapRound;
    mask.lineJoin = kCALineJoinMiter;
    
    UIImage *imageProgress = [UIImage imageNamed:@"circle_2.png"];
    progressLayer = [CALayer layer];
    progressLayer.contentsScale = [UIScreen mainScreen].scale;
    progressLayer.contents = (__bridge id)imageProgress.CGImage;
    progressLayer.contentsGravity = kCAGravityResizeAspectFill;
    CGRect frame = bg02.frame;
    progressLayer.frame = frame;
    progressLayer.mask = mask;
    maskLayer = mask;
    [self.layer addSublayer:progressLayer];
}

- (CGPathRef)drawPathWithArcCenter
{
    //    CGMutablePathRef arcPath = CGPathCreateMutable();
    ////    CGPathAddRect(arcPath, nil, CGRectMake(0, 0, 50, 50));
    //    CGPathAddArc(arcPath,
    //                 nil,
    //                 bg02.frame.size.width/2,
    //                 bg02.frame.size.height/2,
    //                 (self.frame.size.width)/2-13,
    //                 (-M_PI/2),
    //                 (3*M_PI/2),
    //                 YES);
    //    return arcPath;
    CGFloat position_y = bg02.frame.size.height/2;
    CGFloat position_x = bg02.frame.size.width/2;
    CGFloat radio = bg01.frame.size.width/261.0;
//    NSLog(@"2===%lf, x:%lf, y:%lf, x1:%lf, x2:%lf", radio, position_x, position_y, self.frame.size.height/2, self.frame.size.width/2);
    return [UIBezierPath bezierPathWithArcCenter:CGPointMake(position_x, position_y)
                                          radius:position_y - (13*radio)
                                      startAngle:(-M_PI/2)
                                        endAngle:(3*M_PI/2)
                                       clockwise:YES].CGPath;
}

-(void)setPercent:(NSInteger)val animated:(BOOL)flag
{
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    anim.fillMode = kCAFillModeForwards;
    anim.removedOnCompletion = NO;
    anim.autoreverses = NO;
    anim.fromValue = [NSNumber numberWithFloat:0.0];
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    anim.duration = 1;
    anim.fromValue = [[maskLayer animationForKey:@"runStroke"] valueForKey:@"toValue"];
    anim.byValue = [NSNumber numberWithFloat: .5];
    anim.toValue = [NSNumber numberWithFloat:val/100.0];
    [maskLayer removeAnimationForKey:@"runStroke"];
    [maskLayer addAnimation:anim forKey:@"runStroke"];
//    UIGraphicsBeginImageContext(CGSizeMake(CGRectGetWidth(self.bounds),
//                                           CGRectGetHeight(self.bounds)));
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
////    CGContextSetFillColor(ctx, <#const CGFloat * _Nullable components#>)
//    CGContextSetLineCap(ctx, kCGLineCapRound);
//    CGContextSetFillColorWithColor(ctx, maskLayer.fillColor);
//    CGContextSetStrokeColorWithColor(ctx, maskLayer.strokeColor);
//    CGContextSetLineWidth(ctx, maskLayer.lineWidth);
//    CGContextSetLineCap(ctx, kCGLineCapRound);
//    CGContextSetLineJoin(ctx, kCGLineJoinMiter);
//    CGContextAddPath(ctx, maskLayer.path);
//    CGContextDrawPath(ctx, kCGPathStroke);
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
}

//+ (Class) layerClass
//{
//    return [IoriCALayer class];
//}
@end
