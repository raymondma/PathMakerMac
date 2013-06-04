//
//  PMWindowController.m
//  PathMaker
//
//  Created by 马 俊 on 13-4-14.
//  Copyright (c) 2013年 马 俊. All rights reserved.
//

#import "PMWindowController.h"
#import "PMMainView.h"
#import "PMDocument.h"

@interface PMWindowController ()

@end

@implementation PMWindowController


- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)windowDidLoad
{
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    [super windowDidLoad];
    
    PMDocument* doc = self.document;
    view.m_controlPoints = doc.m_controlPoints;
    [self initialize];
}



-(void)initialize
{
    if (view)
    {
        [view initialize];
    }
}

@end
