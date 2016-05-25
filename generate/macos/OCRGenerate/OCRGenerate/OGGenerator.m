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
        
        // look for a labels file, read it into a dictionary? Pair of arrays?
        // Use it to generate a string of characters
    }
    return self;
}

- (NSArray *)generateFromString:(NSString *)chars withFont:(NSFont *)font
{
    NSMutableArray *images = [NSMutableArray array];
    NSDictionary *attr = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,nil];
    
    for( NSUInteger i = 0; i < 2 /* [chars length] */; ++i )
    {
        NSString *c = [chars substringWithRange:NSMakeRange(i,1)];
        NSString *test = [[self directory] stringByAppendingPathComponent:c];
        
        NSError *error;
        if( ![[NSFileManager defaultManager] createDirectoryAtPath:test withIntermediateDirectories:YES attributes:nil error:&error] )
        {
            NSLog( @"Unable to create directory: %@", test );
            continue;
        }

        int xoffset = 5;
        int yoffset = 5;
        
        BOOL isLowercase = [[NSCharacterSet lowercaseLetterCharacterSet] characterIsMember:[c characterAtIndex:0]];
        NSString *fname = [NSString stringWithFormat:@"%@-%d-%d%@.png", [font fontName], xoffset, yoffset, (isLowercase?@"-l":@"")];
        test = [test stringByAppendingPathComponent:fname];

        if( ![[NSFileManager defaultManager] fileExistsAtPath:test] )
        {
            NSImage *img = [[NSImage alloc] initWithSize:NSMakeSize(28, 28)];
            [img lockFocus];
            [c drawAtPoint:NSMakePoint(xoffset, yoffset) withAttributes:attr];
            [img unlockFocus];
            [images addObject:img];
            
            //NSData *tiffData = [img TIFFRepresentation];
            // when you want to write it to a JPEG
            //            NSData *dat = [NSBitmapImageRep
            //                           representationOfImageRepsInArray:[img representations]
            //                           usingType:NSPNGFileType
            //                           properties:nil];
            //            [dat writeToFile:test atomically:YES];
            
            /* screen resolution independence: */
            
            CGImageRef cgRef = [img CGImageForProposedRect:NULL context:nil hints:nil];
            NSBitmapImageRep *newRep = [[NSBitmapImageRep alloc] initWithCGImage:cgRef];
            [newRep setSize:[img size]];   // if you want the same resolution
            NSData *pngData = [newRep representationUsingType:NSPNGFileType properties:nil];
            [pngData writeToFile:test atomically:YES];
        }
    }
    return images;
}

@end
