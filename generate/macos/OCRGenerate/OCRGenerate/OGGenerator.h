//
//  OGGenerator.h
//  OCRGenerate
//
//  Created by Andrew Salamon on 5/24/16.
//  Copyright (c) 2016 CaffeOCR. All rights reserved.
//

#import <Foundation/Foundation.h>

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

- (id)initWithDirectory:(NSString *)dir;

// list of fonts
// list of characters?
@end
