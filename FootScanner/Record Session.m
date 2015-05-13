//
//  Record Session.m
//  FootScanner
//
//  Created by John Sayour on 4/30/15.
//  Copyright (c) 2015 Rehab. All rights reserved.
//

#import "Record Session.h"

@implementation Record_Session
-(id)init
{
    if([super init])
    {
        _steps = [[NSMutableArray alloc]init];
    }
    return self;
}

@end
