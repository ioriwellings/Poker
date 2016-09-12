
#import <UIKit/UIKit.h>

@interface IoriVerticalBar : UIView

@property (nonatomic) float gradePercent;

@property (nonatomic, assign) BOOL isAnimatedAble;

@property (nonatomic, strong) CAShapeLayer * chartLine;

@property (nonatomic, strong) UIColor * barColor;

-(void)setSafeLine:(float)percent;

@end

/* NSString *valueString = childAry[j];
 float value = [valueString floatValue];
 float grade = ((float)value-_yValueMin) / ((float)_yValueMax-_yValueMin);
 
 UUBar * bar = [[UUBar alloc] initWithFrame:CGRectMake((j+(_yValues.count==1?0.1:0.05))*_xLabelWidth +i*_xLabelWidth * 0.47, UULabelHeight, _xLabelWidth * (_yValues.count==1?0.8:0.45), chartCavanHeight)];
 bar.barColor = [_colors objectAtIndex:i];
 bar.gradePercent = grade;
 [myScrollView addSubview:bar];
*/