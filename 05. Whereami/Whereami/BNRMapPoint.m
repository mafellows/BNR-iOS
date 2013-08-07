//
//  BNRMapPoint.m
//  Whereami
//
//  Created by Joe Conway on 10/25/12.
//  Copyright (c) 2012 Big Nerd Ranch. All rights reserved.
//

#import "BNRMapPoint.h"

@implementation BNRMapPoint
- (id)initWithCoordinate:(CLLocationCoordinate2D)c title:(NSString *)t
{
    self = [super init];
    if (self) {
        _coordinate = c;
        [self setTitle:t];
    }
    return self;
}

- (id)init {
    return [self initWithCoordinate:CLLocationCoordinate2DMake(43.07, -89.32)
                              title:@"Hometown"];
}
@end
