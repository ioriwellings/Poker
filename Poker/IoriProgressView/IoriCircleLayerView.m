//
//  IoriCircleLayerView.m
//  PGEBOS
//
//  Created by Iori on 3/2/16.
//  Copyright © 2016 sunny. All rights reserved.
//

#import "IoriCircleLayerView.h"
#import "IoriCircleLayer.h"

@implementation IoriCircleLayerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+(Class)layerClass
{
    return [IoriCircleLayer class];
}

- (void)setPercent:(CGFloat)percent
{
    
    _percent = percent;
    
//    [CATransaction begin];
//    
//    [CATransaction setDisableActions:YES];
    
    [self.layer setValue:@(percent) forKey:@"percent"];
    
//    [CATransaction commit];
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
}

@end
