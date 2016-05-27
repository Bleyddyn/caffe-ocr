//
//  OGGenerator.m
//  OCRGenerate
//
//  Created by Andrew Salamon on 5/24/16.
//  Copyright (c) 2016 CaffeOCR. All rights reserved.
//

#import "OGGenerator.h"
#import "OGFilelist.h"
#import "OGPair.h"

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
        
        NSString *labelPath = [dir stringByAppendingPathComponent:@"labels.txt"];
        
        if( [[NSFileManager defaultManager] fileExistsAtPath:labelPath] )
        {
            _labels = [[OGFilelist alloc] initWithPath:labelPath];
        }
        
    }
    return self;
}

- (NSString *)labelString
{
    NSMutableString *labelString = [NSMutableString string];
    
    for( OGPair *entry in [_labels files] )
    {
        if( [[entry first] length] == 1 )
            [labelString appendString:[entry first]];
    }
    
    NSLog( @"%@", labelString );
    
    return labelString;
}

- (NSArray *)generateLabelsForFont:(NSFont *)font
{
    if( !font )
        return nil;
    
    return [self generateFromString:[self labelString] withFont:font];
}

- (NSArray *)generateFromString:(NSString *)chars withFont:(NSFont *)font
{
    NSMutableArray *images = [NSMutableArray array];
    NSDictionary *attr = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,nil];
    NSString *dirName = [[self directory] lastPathComponent];
    
    for( NSUInteger i = 0; i < [chars length]; ++i )
    {
        NSString *c = [chars substringWithRange:NSMakeRange(i,1)];
        NSString *charDir = [[self directory] stringByAppendingPathComponent:c];
        
        NSError *error;
        if( ![[NSFileManager defaultManager] createDirectoryAtPath:charDir withIntermediateDirectories:YES attributes:nil error:&error] )
        {
            NSLog( @"Unable to create directory: %@", charDir );
            continue;
        }
        
        BOOL isLowercase = [[NSCharacterSet lowercaseLetterCharacterSet] characterIsMember:[c characterAtIndex:0]];

        // TODO: Loop over multiple offsets and rotations
        for( int xoffset = 1; xoffset < 10; ++xoffset )
        {
            for( int yoffset = 1; yoffset < 10; ++yoffset )
            {
                NSString *fname = [NSString stringWithFormat:@"%@-%d-%d%@.png", [font fontName], xoffset, yoffset, (isLowercase?@"-l":@"")];
                NSString *fullpath = [charDir stringByAppendingPathComponent:fname];
                
                NSLog( @"%@", fname );
                
                if( ![[NSFileManager defaultManager] fileExistsAtPath:fullpath] )
                {
                    NSImage *img = [[NSImage alloc] initWithSize:NSMakeSize(28, 28)];
                    [img lockFocus];
                    [c drawAtPoint:NSMakePoint(xoffset, yoffset) withAttributes:attr];
                    [img unlockFocus];
                    [images addObject:img];
                    
                    CGImageRef cgRef = [img CGImageForProposedRect:NULL context:nil hints:nil];
                    NSBitmapImageRep *newRep = [[NSBitmapImageRep alloc] initWithCGImage:cgRef];
                    [newRep setSize:[img size]];   // if you want the same resolution
                    NSData *pngData = [newRep representationUsingType:NSPNGFileType properties:nil];
                    if( [pngData writeToFile:fullpath atomically:YES] )
                    {
                        // add to training index
                        NSString *indexPath = [[dirName stringByAppendingPathComponent:c] stringByAppendingPathComponent:fname];
                        NSNumber *label = [[self labels] labelForPath:c];
                        [[self trainingList] addPath:indexPath withValue:label];
                    }
                }
            }
        }
        
    }
    
    [[self trainingList] save];
    
    return images;
}

@end
