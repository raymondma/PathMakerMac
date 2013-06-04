//
//  PMWindowController.h
//  PathMaker
//
//  Created by 马 俊 on 13-4-14.
//  Copyright (c) 2013年 马 俊. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class PMMainView;

@interface PMWindowController : NSWindowController
{
    IBOutlet PMMainView* view;
}

-(void)initialize;

@end
