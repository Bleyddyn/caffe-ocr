//
//  OGFilelist.m
//  OCRGenerate
//
//  Created by Andrew Salamon on 5/24/16.
//  Copyright (c) 2016 CaffeOCR. All rights reserved.
//

#import "OGFilelist.h"
#import "OGPair.h"

@implementation OGFilelist

- (id)initWithPath:(NSString *)inpath
{
    if( self = [super init] )
    {
        _files = [[NSMutableArray alloc] init];
        [self readFromPath:inpath];
    }
    
    return self;
}

- (BOOL)readFromPath:(NSString *)inpath
{
    NSURL *URL = [NSURL fileURLWithPath:inpath];
    NSError *error = nil;
    
    [_files removeAllObjects];
    
    NSString *stringFromFileAtURL = [[NSString alloc]
                                     initWithContentsOfURL:URL
                                     encoding:NSUTF8StringEncoding
                                     error:&error];
    
    if( stringFromFileAtURL == nil )
    {
        NSLog( @"Error reading file at %@\n%@", URL, [error localizedFailureReason] );
        return NO;
    }

    long int linenum = 0;
    for( NSString *line in [stringFromFileAtURL componentsSeparatedByString:@"\n"] )
    {
        if( [line length] > 0 )
        {
            NSArray *items = [line componentsSeparatedByString:@" "];
            ++linenum;
            
            if( [items count] < 2 )
            {
                NSLog( @"Invalid entry in %@ at line %ld", inpath, linenum );
            }
            else if( [items count] > 2 )
            {
                // assume space(s) in the filename
                NSArray *fileitems = [items objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [items count]-1)]];
                OGPair *pair = [OGPair pairWithFirst:[fileitems componentsJoinedByString:@""] second:[NSNumber numberWithInt:[(NSString *)[items lastObject] intValue]]];
                [_files addObject:pair];
            }
            else
            {
                OGPair *pair = [OGPair pairWithFirst:[items objectAtIndex:0] second:[NSNumber numberWithInt:[(NSString *)[items lastObject] intValue]]];
                [_files addObject:pair];
            }
        }
    }
    
    [self setPath:inpath];
    return YES;
}

- (BOOL)containsPath:(NSString *)inpath
{
    return NO;
}

- (void)addPath:(NSString *)inpath withValue:(NSNumber *)value
{
    OGPair *pair = [OGPair pairWithFirst:inpath second:value];
    [_files addObject:pair];
}

- (void)removePath:(NSString *)inpath
{
    
}

@end
