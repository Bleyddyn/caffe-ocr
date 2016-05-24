//
//  OGGenerator.m
//  OCRGenerate
//
//  Created by Andrew Salamon on 5/24/16.
//  Copyright (c) 2016 CaffeOCR. All rights reserved.
//

#import "OGGenerator.h"
#import "OGFilelist.h"

@implementation OGGenerator

- (id)initWithDirectory:(NSString *)dir
{
    if( self = [super init] )
    {
        _directory = dir;
        
        NSString *test = [dir stringByAppendingPathComponent:@"test_index.txt"];
        
        if( [[NSFileManager defaultManager] fileExistsAtPath:test] )
        {
            _testList = [[OGFilelist alloc] initWithPath:test];
        }
        
        NSString *train = [dir stringByAppendingPathComponent:@"training_index.txt"];
        
        if( [[NSFileManager defaultManager] fileExistsAtPath:train] )
        {
            _trainingList = [[OGFilelist alloc] initWithPath:train];
        }
    }
    return self;
}

@end
