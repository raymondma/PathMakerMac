//
//  PMMainView.m
//  PathMaker
//
//  Created by 马 俊 on 13-4-5.
//  Copyright (c) 2013年 马 俊. All rights reserved.
//

#import "PMMainView.h"

@implementation PMMainView

@synthesize m_path;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}



-(id) initWithCoder:(NSCoder *) aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        self.m_path = [NSBezierPath bezierPath];
    }

    
    return self;
}




- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
    const CGPoint startPoint = CGPointMake(10.f, 10.f);
    const float WIDTH = 320.f;
    const float HEIGHT = 480.f;
    [self.m_path moveToPoint:startPoint];
    [self.m_path lineToPoint:CGPointMake(startPoint.x+WIDTH, startPoint.y)];
    [self.m_path lineToPoint:CGPointMake(startPoint.x+WIDTH, startPoint.y+HEIGHT)];
    [self.m_path lineToPoint:CGPointMake(startPoint.x, startPoint.y+HEIGHT)];
    [self.m_path closePath];
    [self.m_path stroke];
}



- (void)mouseDown:(NSEvent *)theEvent
{
//    CGPoint pt = [theEvent locationInWindow];
}



- (void)mouseUp:(NSEvent *)theEvent
{
    
}



- (void)mouseMoved:(NSEvent *)theEvent
{
    
}



@end
