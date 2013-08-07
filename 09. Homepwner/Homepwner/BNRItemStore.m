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


- (void)removeItem:(BNRItem *)p
{
    [_allItems removeObjectIdenticalTo:p];
}

- (void)moveItemAtIndex:(int)from
                toIndex:(int)to
{
    if (from == to) {
        return;
    }
    // Get pointer to object being moved so we can re-insert it
    BNRItem *p = _allItems[from];

    // Remove p from array
    [_allItems removeObjectAtIndex:from];

    // Insert p in array at new location
    [_allItems insertObject:p atIndex:to];
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
