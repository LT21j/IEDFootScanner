//
//  Record Session.h
//  FootScanner
//
//  Created by John Sayour on 4/30/15.
//  Copyright (c) 2015 Rehab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Step.h"

@interface Record_Session : NSObject

@property (nonatomic, strong) NSDate *dateTaken;
@property (nonatomic, strong) NSMutableArray *steps;


@end
