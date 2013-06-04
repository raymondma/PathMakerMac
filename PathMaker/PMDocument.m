//
//  PMDocument.m
//  PathMaker
//
//  Created by 马 俊 on 13-4-5.
//  Copyright (c) 2013年 马 俊. All rights reserved.
//

#import "PMDocument.h"
#import "PMWindowController.h"

@implementation PMDocument

@synthesize m_controlPoints;


- (id)init
{
    self = [super init];
    if (self) {
        // Add your subclass-specific initialization here.
         m_controlPoints = [NSMutableArray array];
    }
    return self;
}

//- (NSString *)windowNibName
//{
//    // Override returning the nib file name of the document
//    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
//    return @"PMDocument";
//}


- (void)makeWindowControllers
{
    PMWindowController* windowController = [[PMWindowController alloc] initWithWindowNibName:@"PMDocument"];
    [self addWindowController:windowController];
}



//- (void)windowControllerDidLoadNib:(NSWindowController *)aController
//{
//    [super windowControllerDidLoadNib:aController];
//    // Add any code here that needs to be executed once the windowController has loaded the document's window.
//}

+ (BOOL)autosavesInPlace
{
    return YES;
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to write your document to data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning nil.
    // You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
    NSMutableData* data = [NSMutableData data];
    for (id obj in m_controlPoints)
    {
        NSString* str = obj;
        NSPoint pt = NSPointFromString(str);
       
        [data appendBytes: &pt length:sizeof(pt)];
        NSLog(@"%f, %f", pt.x, pt.y);
    }

    return data;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to read your document from the given data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning NO.
    // You can also choose to override -readFromFileWrapper:ofType:error: or -readFromURL:ofType:error: instead.
    // If you override either of these, you should also override -isEntireFileLoaded to return NO if the contents are lazily loaded.
    NSMutableArray* array = [NSMutableArray array];
    NSInteger len = [data length];
    len /= sizeof(NSPoint);
    for (NSInteger i = 0; i < len; ++i)
    {
        NSPoint pt;
        [data getBytes:&pt range:NSMakeRange(i*sizeof(NSPoint), sizeof(NSPoint))];

        NSString* str = NSStringFromPoint(pt);
        [array addObject:str];
    }
    
    self.m_controlPoints = array;
    return YES;
}

@end
