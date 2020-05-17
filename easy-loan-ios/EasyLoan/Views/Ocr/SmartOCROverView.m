#import "SmartOCROverView.h"
#import <CoreText/CoreText.h>

@implementation SmartOCROverView {
    CGRect _smallRect;
}

- (id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    return self;
}

- (void)setSmallrect:(CGRect)smallrect {
    _smallRect = smallrect;
    [self setNeedsDisplay];
    
}

- (void) drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    [[UIColor greenColor] set];
    //获得当前画布区域
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    //设置线的宽度
    CGContextSetLineWidth(currentContext, 2.0f);
    
    CGContextMoveToPoint(currentContext, CGRectGetMinX(_smallRect), CGRectGetMinY(_smallRect));
    CGContextAddLineToPoint(currentContext, CGRectGetMaxX(_smallRect), CGRectGetMinY(_smallRect));
    CGContextAddLineToPoint(currentContext, CGRectGetMaxX(_smallRect), CGRectGetMaxY(_smallRect));
    CGContextAddLineToPoint(currentContext, CGRectGetMinX(_smallRect), CGRectGetMaxY(_smallRect));
    CGContextAddLineToPoint(currentContext, CGRectGetMinX(_smallRect), CGRectGetMinY(_smallRect));
    CGContextStrokePath(currentContext);
}

@end
