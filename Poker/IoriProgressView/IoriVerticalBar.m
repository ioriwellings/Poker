
#import "IoriVerticalBar.h"


@implementation IoriVerticalBar
{
    UIImageView *imageSafeLine;
}

-(void)initPrivate
{
    _gradePercent = .1;
    _chartLine = [CAShapeLayer layer];
    _chartLine.lineCap = kCALineCapButt;
    _chartLine.fillColor = [UIColor whiteColor].CGColor;
    _chartLine.lineWidth = 1;
    _chartLine.strokeEnd = 0.0;
    _chartLine.cornerRadius = 2;
    _chartLine.borderWidth =  1;
    [self.layer addSublayer:_chartLine];
//    self.clipsToBounds = YES;
    self.layer.cornerRadius = 2.0;
//    self.layer.borderWidth+= 1;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
        [self initPrivate];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        [self initPrivate];
    }
    return self;
}

-(void)setGradePercent:(float)gradePercent
{
    if (gradePercent==0)
    return;
    
	_gradePercent = gradePercent;
    if(_gradePercent >1) _gradePercent = 1;
	UIBezierPath *progressline = [UIBezierPath bezierPath];
    progressline = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0,
                                                       (1-_gradePercent)*self.frame.size.height,
                                                       self.frame.size.width,
                                                       (_gradePercent)*self.frame.size.height)
                               cornerRadius:2];
    
//    [progressline moveToPoint:CGPointMake(self.frame.size.width/2.0,
//                                          self.frame.size.height)];
//	[progressline addLineToPoint:CGPointMake(self.frame.size.width/2.0,
//                                              (1-0.8) * self.frame.size.height)];
    
	_chartLine.path = progressline.CGPath;
    _chartLine.fillColor = _barColor.CGColor ?: [UIColor blueColor].CGColor;
}

- (void)drawRect:(CGRect)rect
{
	//Draw BG
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
	CGContextFillRect(context, rect);
}

-(void)setSafeLine:(float)percent
{
    if(imageSafeLine == nil)
    {
        UIImage *image = [UIImage imageNamed:@"safe_line"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        [self addSubview:imageView];
        imageSafeLine = imageView;
    }
    if (percent > 1)
    {
        percent = 1;
    }
    imageSafeLine.frame = CGRectMake((self.frame.size.width-imageSafeLine.frame.size.width)/2,
                                 (1-percent) * self.frame.size.height,
                                 imageSafeLine.frame.size.width,
                                 imageSafeLine.frame.size.height);

}

@end
