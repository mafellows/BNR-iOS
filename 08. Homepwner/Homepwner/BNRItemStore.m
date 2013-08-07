//
//  BNRItemStore.m
//  Homepwner
//
//  Created by Joe Conway on 10/25/12.
//  Copyright (c) 2012 Big Nerd Ranch. All rights reserved.
//

#import "BNRItemStore.h"
#import "BNRItem.h"

@interface BNRItemStore ()
{
    NSMutableArray *_allItems;
}
@end

@implementation BNRItemStore
@synthesize allItems = _allItems;

- (id)init
{
    self = [super init];
    if (self) {
        _allItems = [[NSMutableArray alloc] init];
    }

    return self;
}

+ (BNRItemStore *)sharedStore
{
    static BNRItemStore *sharedStore = nil;
    if (!sharedStore)
        sharedStore = [[super allocWithZone:nil] init];
    return sharedStore;
}

- (BNRItem *)createItem
{
    BNRItem *p = [BNRItem randomItem];

    [_allItems addObject:p];

    return p;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedStore];
}

@end
