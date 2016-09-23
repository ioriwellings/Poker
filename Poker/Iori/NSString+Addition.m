//
//  NSString+Addition.m
//  IoriLibrary
//
//  Created by Iori on 6/27/14.
//  Copyright (c) 2014 Iori. All rights reserved.
//

#import "NSString+Addition.h"
//#import <CoreText/CoreText.h>

@implementation NSString (Addition)

+(NSString*)getFormatedInteger:(NSInteger)iValue byLength:(NSInteger)length
{
    return [NSString stringWithFormat:@"%1$ld0%2$d", (long)iValue, (int)length];
}

+(NSString*)getFormatedNumberByInteger:(NSInteger)val
{
    return [[NSString stringWithFormat:@"%ld", (long)val] getFormatedNumber];
}

-(NSString*)getFormatedNumber
{
    return [self getFormatedNumber:NSNumberFormatterDecimalStyle];
}

-(NSString*)getFormatedNumber:(NSNumberFormatterStyle)formateStyle
{
    NSNumberFormatter *formater = [NSNumberFormatter new];
    formater.numberStyle = formateStyle;
    return [formater stringFromNumber:[NSNumber numberWithInteger:self.integerValue]];
}


//CG Draw字符串旋转
//-(void)drawRotateString
//{
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSelectFont (context, "Helvetica-Bold", 16.0, kCGEncodingMacRoman);
//    CGContextSetTextDrawingMode (context, kCGTextFill);
//    CGContextSetRGBFillColor(context, 1.0, 0.0, 0.0, 1.0);
//    CGContextSetTextMatrix (context,
//                            CGAffineTransformRotate(CGAffineTransformScale(CGAffineTransformIdentity, 1.f, -1.f ),
//                                                    M_PI/2));
//    CGContextShowTextAtPoint (context,
//                              21.0,
//                              55.0,
//                              [self cStringUsingEncoding:NSUTF8StringEncoding], [self length]);
//    CGContextRestoreGState(context);
//
//    //CGContextRef context = UIGraphicsGetCurrentContext();
//    CGPoint point = CGPointMake(6.0, 50.0);
//    CGContextSaveGState(context);
//    CGContextTranslateCTM(context, point.x, point.y);
//    CGAffineTransform textTransform = CGAffineTransformMakeRotation(-1.57);
//    CGContextConcatCTM(context, textTransform);
//    CGContextTranslateCTM(context, -point.x, -point.y);
//    [[UIColor redColor] set];
//    [self drawAtPoint:point withFont:[UIFont fontWithName:@"Helvetica-Bold" size:14.0]];
//    CGContextRestoreGState(context);
//
//    //CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSaveGState(context);
//    CGContextRotateCTM(context, -(M_PI/2));
//    [self drawAtPoint:CGPointMake(-57.0, 5.5) withFont:[UIFont fontWithName:@"Helvetica-Bold" size:16.0]];
//    CGContextRestoreGState(context);
//}
//
//-(void)drawAtPoint:(CGPoint)point
//     withTextStyle:(CTextStyle *)style
//         inContext:(CGContextRef)context
//            rotate:(float)rt
//{
//    if ( style.color == nil ) return;
//    BOOL bpop = NO;
//    UIFont *theFont = [UIFont fontWithName:style.fontName size:style.fontSize];
//    
//    CGContextSaveGState(context);
//    CGColorRef textColor = style.color.cgColor;
//    
//    CGContextSetStrokeColorWithColor(context, textColor);
//    CGContextSetFillColorWithColor(context, textColor);
//    
//    if (UIGraphicsGetCurrentContext() != context)
//    {
//        UIGraphicsPushContext(context);
//        bpop = YES;
//    }
//    
//    CGAffineTransform textTransform = CGAffineTransformMakeRotation(rt);//-M_PI/4.0);
//    CGContextTranslateCTM(context, point.x,point.y);
//    CGContextConcatCTM(context, textTransform);
//    CGContextTranslateCTM(context, -point.x, -point.y);
//    
//    [self drawAtPoint:point withFont:theFont];
//    CGContextRestoreGState(context);
//    if (bpop)
//    {
//        UIGraphicsPopContext();
//    }
//}

@end
