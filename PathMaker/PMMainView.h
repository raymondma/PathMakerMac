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
    NSBezierPath* m_path;
}

@property (retain) NSBezierPath* m_path;

@end
