//
//  Step.m
//  FootScanner
//
//  Created by John Sayour on 4/30/15.
//  Copyright (c) 2015 Rehab. All rights reserved.
//

#import "Step.h"

@implementation Step

-(id)init
{
    if([super init])
    {
        _sensor1 = [[NSMutableArray alloc] init];
        _sensor2 = [[NSMutableArray alloc] init];
        _sensor3 = [[NSMutableArray alloc] init];
        _sensor4 = [[NSMutableArray alloc] init];
        _sensor5 = [[NSMutableArray alloc] init];
        
    }
    return self;
}


@end
