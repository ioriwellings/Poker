//
//  SDTransparentPieProgressView.m
//  SDProgressView
//
//  Created by aier on 15-2-20.
//  Copyright (c) 2015年 GSD. All rights reserved.
//

#import "SDTransparentPieProgressView.h"

#define ToRad(deg) 		( (M_PI * (deg)) / 180.0 )
#define degreesToRadians(x) (M_PI*(x)/180.0) //把角度转换成PI的方式

@implementation SDTransparentPieProgressView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (UIImage*)circularScaleAndCropImage:(UIImage*)image frame:(CGRect)frame
{
    // This function returns a newImage, based on image, that has been:
    // - scaled to fit in (CGRect) rect
    // - and cropped within a circle of radius: rectWidth/2
    
    //Create the bitmap graphics context
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(frame.size.width, frame.size.height), NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //Get the width and heights
    CGFloat imageWidth = image.size.width;
    CGFloat imageHeight = image.size.height;
    CGFloat rectWidth = frame.size.width;
    CGFloat rectHeight = frame.size.height;
    
    //Calculate the scale factor
    //CGFloat scaleFactorX = rectWidth/imageWidth;
    //CGFloat scaleFactorY = rectHeight/imageHeight;
    
    //Calculate the centre of the circle
    CGFloat imageCentreX = rectWidth/2;
    CGFloat imageCentreY = rectHeight/2;
    
    // Create and CLIP to a CIRCULAR Path
    // (This could be replaced with any closed path if you want a different shaped clip)
    

    
    CGFloat radius = rectWidth/2;
    CGContextBeginPath (context);
    CGFloat to = - M_PI * 0.5 + .3 * M_PI * 2 + 0.001;
    CGContextSetLineWidth(context, 1);
    CGContextAddArc (context, imageCentreX, imageCentreY, radius/2,  0, M_PI-1, 0);
    CGContextSetLineWidth(context, radius);
    //CGContextStrokePath(context);
    //CGContextClosePath (context);
    CGContextClip (context);
    
    //Set the SCALE factor for the graphics context
    //All future draw calls will be scaled by this factor
    //CGContextScaleCTM (context, scaleFactorX, scaleFactorY);
    
    // Draw the IMAGE
    CGRect myRect = CGRectMake(0, 0, imageWidth, imageHeight);
    [image drawInRect:myRect];
    
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
    
    
//    UIImage *originalImage = [UIImage imageNamed:@"bg_user_1"];
//    CGFloat oImageWidth = originalImage.size.width;
//    CGFloat oImageHeight = originalImage.size.height;
//    // Draw the original image at the origin
//    CGRect oRect = CGRectMake(0, 0, oImageWidth, oImageHeight);
//    [originalImage drawInRect:oRect];
//    
//    // Set the newRect to half the size of the original image
//    CGRect newRect = CGRectMake(0, 0, oImageWidth, oImageHeight);
//    UIImage *newImage = [self circularScaleAndCropImage:originalImage frame:newRect];
//    
//    CGFloat nImageWidth = newImage.size.width;
//    CGFloat nImageHeight = newImage.size.height;
//    
//    //Draw the scaled and cropped image
//    CGRect thisRect = CGRectMake(oImageWidth+10, 0, nImageWidth, nImageHeight);
//    [newImage drawInRect:thisRect];
}

- (void)drawRect:(CGRect)rect
{
    CALayer *layer = [self getImageLayer:rect];
    [self.layer addSublayer:layer];
    
    UIImage *image = [UIImage imageNamed:@"bg_user_1"];
    layer = [[CALayer alloc] init];
    layer.frame = CGRectMake(100, 0, rect.size.width, rect.size.height);
    layer.contentsScale = [UIScreen mainScreen].scale;
    layer.contents = (__bridge id)image.CGImage;
    layer.contentsGravity = kCAGravityResizeAspectFill;
    [self.layer addSublayer:layer];
    
//    UIImage *image = [UIImage imageNamed:@"bg_user_1"];
//    
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    
//    CGFloat xCenter = rect.size.width * 0.5;
//    CGFloat yCenter = rect.size.height * 0.5;
//    
//    
//    CGFloat radius = MIN(rect.size.width * 0.5, rect.size.height * 0.5) - SDProgressViewItemMargin;
//    
//    // 背景遮罩
//    [SDProgressViewBackgroundColor set];
//    CGFloat lineW = MAX(rect.size.width, rect.size.height) * 0.5;
//    CGContextSetLineWidth(ctx, lineW);
//    CGContextAddArc(ctx, xCenter, yCenter, radius + lineW * 0.5 + 5, 0, M_PI * 2, 1);
//    CGContextClipToMask(ctx, rect, image.CGImage);
//    CGContextStrokePath(ctx);
//    
//    // 进程圆
//    //[SDColorMaker(0, 0, 0, 0.3) set];
//    CGContextSetLineWidth(ctx, 1);
//    CGContextMoveToPoint(ctx, xCenter, yCenter);
//    CGContextAddLineToPoint(ctx, xCenter, 0);
//    CGFloat to = - M_PI * 0.5 + self.progress * M_PI * 2 + 0.001; // 初始值
//    CGContextAddArc(ctx, xCenter, yCenter, radius, - M_PI * 0.5, to, 1);
//    CGContextClosePath(ctx);
//    
//    CGContextFillPath(ctx);
//
//    
//    return;
//    CGPathRef path = [self getPath];
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    CGContextSetLineWidth(ctx, 2);
//    CGContextAddPath(ctx, path);
//    CGContextStrokePath(ctx);
//    CGContextFillPath(ctx);
}

-(CALayer*)getImageLayer:(CGRect)frame
{
    UIImage *image = [UIImage imageNamed:@"bg_user_1"];
    CALayer *layer = [[CALayer alloc] init];
    layer.frame = frame;
    layer.contentsScale = [UIScreen mainScreen].scale;
    layer.contents = (__bridge id)image.CGImage;
    layer.contentsGravity = kCAGravityResizeAspectFill;
    layer.mask = [self getShapeLayer:frame];
    return layer;
}

-(CAShapeLayer*)getShapeLayer:(CGRect)frame;
{
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.frame = frame;
    layer.lineWidth = frame.size.height/1.0;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = [UIColor grayColor].CGColor;
    //layer.path = [self getPath];
    CGFloat from = - M_PI * 0.5;
    CGFloat to = from + (ToRad(self.progress*360));
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(frame.size.width/2, frame.size.height/2)
                                                        radius:frame.size.height/2
                                                    startAngle:from
                                                      endAngle:to
                                                     clockwise:YES];
    layer.path = path.CGPath;
    return layer;
}

-(CGPathRef)getPath
{
//    CGFloat position_y = 0;
//    CGFloat position_x = 0;
//    CGFloat radio = 20;
//    //    NSLog(@"2===%lf, x:%lf, y:%lf, x1:%lf, x2:%lf", radio, position_x, position_y, self.frame.size.height/2, self.frame.size.width/2);
//    return [UIBezierPath bezierPathWithArcCenter:CGPointMake(position_x, position_y)
//                                          radius:position_y - (13*radio)
//                                      startAngle:(-M_PI/2)
//                                        endAngle:(3*M_PI/2)
//                                       clockwise:YES].CGPath;
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddArc(path, nil, 0, 0, 20, 0, 30, 1);
    return path;
    //CGPathAddArcToPoint(<#CGMutablePathRef  _Nullable path#>, <#const CGAffineTransform * _Nullable m#>, <#CGFloat x1#>, <#CGFloat y1#>, <#CGFloat x2#>, <#CGFloat y2#>, <#CGFloat radius#>)
    
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    
//    CGFloat xCenter = rect.size.width * 0.5;
//    CGFloat yCenter = rect.size.height * 0.5;
//    
//    
//    CGFloat radius = MIN(rect.size.width * 0.5, rect.size.height * 0.5) - SDProgressViewItemMargin;
//    
//    // 背景遮罩
//    [SDProgressViewBackgroundColor set];
//    CGFloat lineW = MAX(rect.size.width, rect.size.height) * 0.5;
//    CGContextSetLineWidth(ctx, lineW);
//    CGContextAddArc(ctx, xCenter, yCenter, radius + lineW * 0.5 + 5, 0, M_PI * 2, 1);
//    CGContextStrokePath(ctx);
//    
//    // 进程圆
//    //[SDColorMaker(0, 0, 0, 0.3) set];
//    CGContextSetLineWidth(ctx, 1);
//    CGContextMoveToPoint(ctx, xCenter, yCenter);
//    CGContextAddLineToPoint(ctx, xCenter, 0);
//    CGFloat to = - M_PI * 0.5 + self.progress * M_PI * 2 + 0.001; // 初始值
//    CGContextAddArc(ctx, xCenter, yCenter, radius, - M_PI * 0.5, to, 1);
//    CGContextClosePath(ctx);
    
//    CGContextFillPath(ctx);

}

@end
