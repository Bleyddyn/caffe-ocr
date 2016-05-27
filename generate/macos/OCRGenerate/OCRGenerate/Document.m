//
//  Document.m
//  OCRGenerate
//
//  Created by Andrew Salamon on 5/24/16.
//  Copyright (c) 2016 CaffeOCR. All rights reserved.
//

#import "Document.h"
#import "OGGenerator.h"
#import "OGFilelist.h"
#import "OGPair.h"

@interface Document ()

@end

@implementation Document

- (instancetype)init {
    self = [super init];
    if (self) {
        // Add your subclass-specific initialization here.
    }
    return self;
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController {
    [super windowControllerDidLoadNib:aController];
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
    NSFont *oldFont = [fontExampleField font];
    [fontNameField setStringValue:[oldFont description]];
    [chooseFontButton setEnabled:NO];
    [generateButton setEnabled:NO];
}

+ (BOOL)autosavesInPlace {
    return YES;
}

- (NSString *)windowNibName {
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"Document";
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError {
    // Insert code here to write your document to data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning nil.
    // You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
    [NSException raise:@"UnimplementedMethod" format:@"%@ is unimplemented", NSStringFromSelector(_cmd)];
    return nil;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError {
    // Insert code here to read your document from the given data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning NO.
    // You can also choose to override -readFromFileWrapper:ofType:error: or -readFromURL:ofType:error: instead.
    // If you override either of these, you should also override -isEntireFileLoaded to return NO if the contents are lazily loaded.
    [NSException raise:@"UnimplementedMethod" format:@"%@ is unimplemented", NSStringFromSelector(_cmd)];
    return YES;
}

- (IBAction)chooseDirectory:(id)sender
{
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setCanChooseDirectories:YES];
    [panel setAllowsMultipleSelection:NO];
    [panel setCanChooseFiles:NO];

    [panel beginSheetModalForWindow:mainWindow completionHandler:^(NSInteger result)
     {
         if( NSFileHandlingPanelOKButton == result )
         {
             NSArray *urls = [panel URLs];
             NSURL *url = [urls objectAtIndex:0];
             if( [url isFileURL] )
             {
                 generator = [[OGGenerator alloc] initWithDirectory:[url path]];
                 [directoryField setStringValue:[generator directory]];
                 [trainingFileField setStringValue:[[generator trainingList] path]];
                 [testFileField setStringValue:[[generator testList] path]];
                 [fontExampleField setStringValue:[generator labelString]];
                 [chooseFontButton setEnabled:YES];
                 [generateButton setEnabled:YES];
             }
         }
     }];
}

- (IBAction)chooseFont:(id)sender
{
    NSFontPanel *fontPanel = [NSFontPanel sharedFontPanel];
//    [fontExampleField setStringValue:@"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz.?,'\""];
    //[fontExampleField setStringValue:@"abcd"];
    [mainWindow makeFirstResponder:fontExampleField];
    [fontPanel makeKeyAndOrderFront:sender];
}

- (void)changeFont:(id)sender
{
    NSFont *oldFont = [fontExampleField font];
    NSFont *newFont = [sender convertFont:oldFont];
    [fontExampleField setFont:newFont];
    [fontNameField setStringValue:[newFont description]];
}

- (IBAction)generate:(id)sender
{
    NSFont *oldFont = [fontExampleField font];
    NSArray *images = [generator generateLabelsForFont:oldFont];
    OGPair *next = [OGPair pairWithFirst:images second:[NSNumber numberWithUnsignedInteger:0]];
    [self showImages:next];
    //[imageView setImage:[images objectAtIndex:0]];
}

- (void)showImages:(OGPair *)args
{
    [imageView setImage:[[args first] objectAtIndex:[[args second] unsignedIntegerValue]]];
    OGPair *next = [OGPair pairWithFirst:[args first] second:[NSNumber numberWithUnsignedInteger:[[args second] unsignedIntegerValue]+1]];
    [self performSelector:@selector(showImages:) withObject:next afterDelay:1.0];
}
@end
