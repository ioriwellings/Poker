//
//  SDLoopProgressView2.m
//  SDProgressView
//
//  Created by Iori on 3/9/16.
//  Copyright © 2016 GSD. All rights reserved.
//

#import "SDLoopProgressView2.h"

@implementation SDLoopProgressView2

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGFloat xCenter = rect.size.width * 0.5;
    CGFloat yCenter = rect.size.height * 0.5;
    
    [[UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1] set];
    CGContextSetLineWidth(ctx, 15 * SDProgressViewFontScale);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGFloat to = - M_PI * 0.5 + M_PI * 2 + 0.00; // 初始值0.05
    CGFloat radius = MIN(rect.size.width, rect.size.height) * 0.5 - SDProgressViewItemMargin;
    CGContextAddArc(ctx, xCenter, yCenter, radius, - M_PI * 0.5, to, 0);
    CGContextStrokePath(ctx);
    
    [[UIColor colorWithRed:254/255.0 green:142/255.0 blue:22/255.0 alpha:1] set];
    CGContextSetLineWidth(ctx, 15 * SDProgressViewFontScale);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    to = - M_PI * 0.5 + self.progress * M_PI * 2 + 0.05; // 初始值0.05
    radius = MIN(rect.size.width, rect.size.height) * 0.5 - SDProgressViewItemMargin;
    CGContextAddArc(ctx, xCenter, yCenter, radius, - M_PI * 0.5, to, 0);
    CGContextStrokePath(ctx);
    
    // 进度数字
    NSString *progressStr = [NSString stringWithFormat:@"%.0f%% ", self.progress * 100];
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    attributes[NSFontAttributeName] = [UIFont boldSystemFontOfSize:20 * SDProgressViewFontScale];
    attributes[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    [self setCenterProgressText:progressStr withAttributes:attributes];
}

@end
