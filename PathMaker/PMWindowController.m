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
    
    [self becomeFirstResponder];
    
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


- (IBAction)onPackAll:(id)sender
{
    NSOpenPanel* openPanel = [NSOpenPanel new];
    [openPanel setCanChooseDirectories:YES];
    [openPanel setCanChooseFiles:NO];
    if (NSFileHandlingPanelOKButton != [openPanel runModal])
    {
        return;
    }
    NSString* srcURL = [openPanel URL];
    
    NSSavePanel* panel = [NSSavePanel new];
    [panel setNameFieldStringValue:@"game_path.pmp"];
    if (NSFileHandlingPanelOKButton == [panel runModal])
    {
        NSURL* url = [panel URL];
        if (![self packAllPaths:srcURL FileName:url])
        {
            NSAlert *alert = [[NSAlert alloc] init];

            [alert addButtonWithTitle:@"OK"];
            [alert setMessageText:@"WRONG!"];
            [alert setInformativeText:@"Failed to pack paths!"];
            [alert setAlertStyle:NSWarningAlertStyle];
            [alert runModal];
        }
    }
}



- (BOOL)packAllPaths:(NSURL*)srcURL FileName:(NSURL*)filename
{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSArray* file_arr = [fileManager contentsOfDirectoryAtURL:srcURL includingPropertiesForKeys:[NSArray array] options:NSDirectoryEnumerationSkipsHiddenFiles error:nil];
    NSMutableArray* paths = [NSMutableArray array];
    for (NSURL* each in file_arr)
    {
        NSString* filename;
        NSNumber* isDirectory;
        NSNumber* filesize;

        [each getResourceValue:&filename forKey:NSURLNameKey error:nil];
        [each getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:nil];
        [each getResourceValue:&filesize forKey:NSURLFileSizeKey error:nil];
        if(![isDirectory boolValue] && [[each pathExtension] isEqualToString:@"pm"])
        {
            NSLog(@"[F] %@ (%@ bytes)", filename, filesize);
            NSData* data = [NSData dataWithContentsOfURL:each];
            NSMutableData* md = [NSMutableData data];
            NSData* filenameData = [filename dataUsingEncoding:NSUTF8StringEncoding];
            int32_t filenameLen = (int32_t)[filenameData length];
            [md appendBytes:&filenameLen length:sizeof(int32_t)];
            [md appendData:filenameData];
            [md appendData:data];
            [paths addObject:md];
        }
    }
    
    NSMutableData* data = [NSMutableData data];
    
    uint32_t count = (int32_t)[paths count];
    [data appendBytes:&count length:sizeof(int32_t)];
    int32_t tableLen = sizeof(int32_t) * count * 2;
    int32_t* table = malloc(tableLen);
    [data appendBytes:table length:tableLen];
    int32_t offset = sizeof(int32_t) + tableLen;
    for (uint32_t i = 0; i < count; i++)
    {
        table[i * 2] = offset;
        NSData* newData = [paths objectAtIndex:i];
        table[i * 2 + 1] = (int32_t)[newData length];
        [data appendData:newData];
        offset += table[i * 2 + 1];
    }
    
    [data replaceBytesInRange:NSMakeRange(sizeof(int32_t), tableLen) withBytes:table];
    
    free(table);
    
    return [data writeToURL:filename atomically:NO];
}



@end
