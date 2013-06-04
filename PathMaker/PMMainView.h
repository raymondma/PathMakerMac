//
//  PMMainView.h
//  PathMaker
//
//  Created by 马 俊 on 13-4-5.
//  Copyright (c) 2013年 马 俊. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PMMainView : NSView
{
    CGSize m_workAraeSize;
    CGPoint m_workAreaOffsetPoint;
    int m_curSelCP;
    BOOL m_lockSelCP;
    IBOutlet NSTextField* m_coordText;
}

@property (retain) NSMutableArray* m_controlPoints;
@property (assign) CGPoint m_workAreaOffsetPoint;

-(void)initialize;

@end
