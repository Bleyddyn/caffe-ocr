//
//  OGGenerator.h
//  OCRGenerate
//
//  Created by Andrew Salamon on 5/24/16.
//  Copyright (c) 2016 CaffeOCR. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class OGFilelist;

/** OGGenerator
 Keep track of two lists of files, one for testing one for training.
 Along with a directory that will be the root of the images.
 Generate new test/training images, put them in the appropriate directory, add to the test or training file.
 Write everything out when done.
 */
@interface OGGenerator : NSObject

@property (readwrite,retain) NSString *directory;
@property (readwrite,retain) OGFilelist *trainingList;
@property (readwrite,retain) OGFilelist *testList;
@property (readwrite,retain) OGFilelist *labels;

- (id)initWithDirectory:(NSString *)dir;

- (NSString *)labelString;

- (NSArray *)generateLabelsForFont:(NSFont *)font;
- (NSArray *)generateFromString:(NSString *)chars withFont:(NSFont *)font;

// list of fonts
// list of characters?
@end
