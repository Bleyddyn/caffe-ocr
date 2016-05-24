//
//  OGPair.h
//  OCRGenerate
//
//  Created by Andrew Salamon on 5/24/16.
//  Copyright (c) 2016 CaffeOCR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OGPair : NSObject

@property (readonly,nonatomic) id first;
@property (readonly,nonatomic) id second;

+(OGPair *) pairWithFirst:(id)_first second:(id)_second;

-(OGPair *) initWithFirst:(id)_first second:(id)_second;

-(NSComparisonResult) compare:(OGPair *)rhs;

- (void)encodeWithCoder:(NSCoder *)encoder;
- (id)initWithCoder:(NSCoder *)decoder;

@end
