//
//  OGFilelist.h
//  OCRGenerate
//
//  Created by Andrew Salamon on 5/24/16.
//  Copyright (c) 2016 CaffeOCR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OGFilelist : NSObject
{
    NSMutableArray *_files; ///< Array of OGPair of: filename and y-value
}

@property (readwrite,retain) NSString *path;
@property (readonly,retain) NSArray *files;

- (id)initWithPath:(NSString *)inpath;
- (BOOL)readFromPath:(NSString *)inpath;
- (BOOL)writeToPath:(NSString *)inpath;
- (BOOL)save;

- (NSNumber *)labelForPath:(NSString *)inpath;
- (BOOL)containsPath:(NSString *)inpath;
- (void)addPath:(NSString *)inpath withValue:(NSNumber *)value;
- (void)removePath:(NSString *)inpath;

@end
