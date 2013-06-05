//
//  PMMainView.m
//  PathMaker
//
//  Created by 马 俊 on 13-4-5.
//  Copyright (c) 2013年 马 俊. All rights reserved.
//

#import "PMMainView.h"
#import "PMSplineMaker.h"

@implementation PMMainView

@synthesize m_controlPoints, m_workAreaOffsetPoint;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }

    return self;
}



- (NSPoint)pointFromView :(NSPoint)pt
{
    pt.x -= m_workAreaOffsetPoint.x;
    pt.y -= m_workAreaOffsetPoint.y;
    
    return pt;
}



- (NSPoint)pointToView :(NSPoint)pt
{
    pt.x += m_workAreaOffsetPoint.x;
    pt.y += m_workAreaOffsetPoint.y;
    
    return pt;
}


-(id) initWithCoder:(NSCoder *) aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    return self;
}



-(void)initialize
{
    NSSize sz = self.frame.size;
    m_workAraeSize.width = 320.f;
    m_workAraeSize.height = 480.f;
    
    m_workAreaOffsetPoint = CGPointMake((sz.width - m_workAraeSize.width) / 2.f,
                                           (sz.height - m_workAraeSize.height) / 2.f);
    
    m_curSelCP = -1;
    m_lockSelCP = NO;
    
    NSTrackingArea* _trackingArea = [[NSTrackingArea alloc] initWithRect:[self frame]
                                                 options:NSTrackingMouseMoved+NSTrackingActiveInKeyWindow+NSTrackingMouseEnteredAndExited
                                                   owner:self
                                                userInfo:nil];
    [self addTrackingArea:_trackingArea];
//    [self becomeFirstResponder];
    
    [m_coordText setStringValue:@"mouse position: 000.0, 000.0"];
    [self setNeedsDisplay:YES];
}



- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    // Drawing code here.
    
    NSBezierPath* path = [NSBezierPath bezierPath];
    
    [path moveToPoint:m_workAreaOffsetPoint];
    [path lineToPoint:CGPointMake(m_workAreaOffsetPoint.x + m_workAraeSize.width, m_workAreaOffsetPoint.y)];
    [path lineToPoint:CGPointMake(m_workAreaOffsetPoint.x + m_workAraeSize.width, m_workAreaOffsetPoint.y + m_workAraeSize.height)];
    [path lineToPoint:CGPointMake(m_workAreaOffsetPoint.x, m_workAreaOffsetPoint.y + m_workAraeSize.height)];
    [path closePath];
    [path stroke];
    
    [[NSColor grayColor] set];
    [path fill];
    
    [self drawControlPoints];
    [self drawHelpLines];
    
    [self drawBezier];
}



- (void)mouseDown:(NSEvent *)theEvent
{
    if (m_curSelCP > -1)
    {
        m_lockSelCP = YES;
    }
}



- (void)mouseUp:(NSEvent *)theEvent
{
    CGPoint pt = [self convertPoint: [theEvent locationInWindow] fromView: nil];
    pt = [self pointFromView:pt];
    
    if (m_lockSelCP)
    {
        [m_controlPoints replaceObjectAtIndex:m_curSelCP withObject:NSStringFromPoint(pt)];
        m_lockSelCP = NO;
    }
    else
    {
        [m_controlPoints addObject:NSStringFromPoint(pt)];
    }

    [self setNeedsDisplay:YES];
    
    NSLog(@"%f, %f", pt.x - m_workAreaOffsetPoint.x, pt.y - m_workAreaOffsetPoint.y);
    
}



- (void)mouseDragged:(NSEvent *)theEvent
{
    CGPoint pt = [self convertPoint: [theEvent locationInWindow] fromView: nil];
    pt = [self pointFromView:pt];
    if (m_lockSelCP)
    {
        [m_controlPoints replaceObjectAtIndex:m_curSelCP withObject:NSStringFromPoint(pt)];
        [self setNeedsDisplay:YES];
    }
}



- (void)mouseMoved:(NSEvent *)theEvent
{
    CGPoint pt = [self convertPoint: [theEvent locationInWindow] fromView: nil];
    NSString* str = [NSString stringWithFormat:@"mouse position: %3.1f, %3.1f", pt.x - m_workAreaOffsetPoint.x, pt.y - m_workAreaOffsetPoint.y];
    [m_coordText setStringValue:str];
    
    pt = [self pointFromView:pt];
    
    if (m_lockSelCP)
    {
        [m_controlPoints replaceObjectAtIndex:m_curSelCP withObject:NSStringFromPoint(pt)];
        [self setNeedsDisplay:YES];
    }
    else
    {
        int curSel = [self CPHitTest:pt];
        
        if (m_curSelCP != curSel)
        {
            [self setNeedsDisplay:YES];
        }
        m_curSelCP = curSel;
    }
    

}



-(void)drawControlPoints
{
    for (id obj in m_controlPoints)
    {
        if ([obj isKindOfClass:[NSString class]])
        {
            NSPoint pt = NSPointFromString(obj);
            pt = [self pointToView:pt];
            [self drawControlPoint:pt];
        }
    }
    
    if (m_curSelCP > -1)
    {
        NSPoint pt = NSPointFromString([m_controlPoints objectAtIndex:m_curSelCP]);
        pt = [self pointToView:pt];
        [self drawSeletedControlPoint:pt];
    }
}



- (void)drawSeletedControlPoint:(CGPoint)point
{
    const float ptRadius = 5.f;
    NSBezierPath* path = [NSBezierPath bezierPath];
    [path appendBezierPathWithArcWithCenter:point radius:ptRadius startAngle:0 endAngle:360];
    [[NSColor redColor] set];
    [path fill];
}



- (void)drawControlPoint:(CGPoint)point
{
    const float ptRadius = 2.f;
    NSBezierPath* path = [NSBezierPath bezierPath];
    [path appendBezierPathWithArcWithCenter:point radius:ptRadius startAngle:0 endAngle:360];
    [[NSColor yellowColor] set];
    [path fill];
}



- (void)drawHelpLines
{
    NSBezierPath* path = [NSBezierPath bezierPath];
    NSUInteger size = [m_controlPoints count];

    [[NSColor yellowColor] set];
    if (size > 1)
    {
        CGPoint pt = NSPointFromString([m_controlPoints objectAtIndex:0]);
        pt = [self pointToView:pt];;
        [path moveToPoint:pt];
        for (NSUInteger i = 1; i < size; ++i)
        {
            pt = NSPointFromString([m_controlPoints objectAtIndex:i]);
            pt = [self pointToView:pt];
            [path lineToPoint:pt];
        }
    }
    
    [path stroke];
}



- (void)drawBezier
{
    PMSplineMaker* spline = [[PMSplineMaker alloc] init];
    if (nil == spline) return;
    
    [spline build:m_controlPoints];
    
    [[NSColor redColor] set];
    
    NSUInteger size = [spline.spline count];

//    NSBezierPath* path = [NSBezierPath bezierPath];
//
//    [path moveToPoint: NSPointFromString([spline.spline objectAtIndex:0])];
//    
//    for (NSUInteger i = 1; i < size; i++)
//    {
//        [path lineToPoint:NSPointFromString([spline.spline objectAtIndex:i])];
//    }
    
//    [path stroke];
    
    for (NSUInteger i = 0; i < size; ++i)
    {
        NSBezierPath* path = [NSBezierPath bezierPath];
        NSPoint pt = NSPointFromString([spline.spline objectAtIndex:i]);
        pt = [self pointToView:pt];
        [path appendBezierPathWithArcWithCenter:pt radius:1.0 startAngle:0 endAngle:360];
        [path fill];
//        [path stroke];
    }
    
    

}



- (int)CPHitTest:(CGPoint)pt
{
    CGPoint point = pt;
    NSUInteger size = [m_controlPoints count];
    for (NSUInteger i = 0; i < size; ++i )
    {
        {
            CGPoint cp = NSPointFromString([m_controlPoints objectAtIndex:i]);
//            NSLog(@"pt: %f, %f ---- cp: %f, %f", point.x, point.y, cp.x, cp.y);
            if (abs(cp.x - point.x) < 5 &&
                abs(cp.y - point.y) < 5)
            {
                return (int)i;
            }
        }
    }
    
    return -1;
}


//- (void)viewDidEndLiveResize
//{
//    [super viewDidEndLiveResize];
//    [self setFrameSize:NSMakeSize(620, 240)];
//    [self setNeedsDisplay:YES];
//}
- (BOOL)acceptsFirstResponder
{
    return YES;
}

 

- (void)keyDown:(NSEvent *)theEvent
{
    NSString* ch = [theEvent characters];
    unichar character = [ch characterAtIndex:0];
    switch (character)
    {
        case 'D':
        case 'd':
            if (m_curSelCP > -1)
            {
                [m_controlPoints removeObjectAtIndex:m_curSelCP];
                m_curSelCP = -1;
                [self setNeedsDisplay:YES];
            }
            break;
        case NSDeleteCharacter:
            if ([m_controlPoints count] > 0)
            {
                [m_controlPoints removeLastObject];
                if (m_curSelCP > [m_controlPoints count])
                {
                    m_curSelCP = -1;
                }
                [self setNeedsDisplay:YES];
            }
            break;
        default:
            break;
    }
}


@end
