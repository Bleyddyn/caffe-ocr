//
//  OGPair.m
//  OCRGenerate
//
//  Created by Andrew Salamon on 5/24/16.
//  Copyright (c) 2016 CaffeOCR. All rights reserved.
//

#import "OGPair.h"

@implementation OGPair
+(OGPair *) pairWithFirst:(id)_first second:(id)_second
{
    OGPair *pair = [[OGPair alloc] initWithFirst:_first second:_second];
    return pair;
}

-(OGPair *) initWithFirst:(id)first second:(id)second
{
    if( self = [super init] )
    {
        _first = first;
        _second = second;
    }
    
    return self;
}

-(NSString*) description
{
    return [NSString stringWithFormat:@"%@ %@", [[self first] description], [[self second] description]];
}

-(NSComparisonResult) compare:(OGPair*)rhs
{
    NSComparisonResult res = [[self first] compare:[rhs first]];
    if( NSOrderedSame == res )
    {
        res = [[self second] compare:[rhs second]];
    }
    return res;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:[self first] forKey:@"first"];
    [encoder encodeObject:[self second] forKey:@"second"];
}
- (id)initWithCoder:(NSCoder *)decoder
{
    id first = [decoder decodeObjectForKey:@"first"];
    id second = [decoder decodeObjectForKey:@"second"];
    return [self initWithFirst:first second:second];
}

@end
