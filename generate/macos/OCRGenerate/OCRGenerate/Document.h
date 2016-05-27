//
//  Document.h
//  OCRGenerate
//
//  Created by Andrew Salamon on 5/24/16.
//  Copyright (c) 2016 CaffeOCR. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class OGGenerator;

@interface Document : NSDocument
{
    IBOutlet NSWindow *mainWindow;
    IBOutlet NSTextField *directoryField;
    IBOutlet NSTextField *testFileField;
    IBOutlet NSTextField *trainingFileField;
    
    IBOutlet NSTextField *fontNameField;
    IBOutlet NSTextField *fontExampleField;
    IBOutlet NSImageView *imageView;
    
    IBOutlet NSButton *chooseFontButton;
    IBOutlet NSButton *generateButton;
    
    OGGenerator *generator;
}

- (IBAction)chooseDirectory:(id)sender;
- (IBAction)chooseFont:(id)sender;
- (IBAction)generate:(id)sender;

@end

