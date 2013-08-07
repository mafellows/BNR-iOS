//
//  BNRChannel.m
//  Nerdfeed
//
//  Created by Joe Conway on 2/25/13.
//  Copyright (c) 2013 Big Nerd Ranch. All rights reserved.
//

#import "BNRRSSFeed.h"
#import "BNRRSSItem.h"

@implementation BNRRSSFeed
- (id)init
{
    self = [super init];
    if (self) {
        _items = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)readFromJSONObject:(NSDictionary *)jsonObject
{
    NSDictionary *feed = [jsonObject objectForKey:@"feed"];
    NSDictionary *author = [feed objectForKey:@"author"];
    NSDictionary *name = [author objectForKey:@"name"];
    [self setTitle:[name objectForKey:@"label"]];
    
    for(NSDictionary *item in [feed objectForKey:@"entry"]) {
        BNRRSSItem *i = [[BNRRSSItem alloc] init];
        [i readFromJSONObject:item];
        [[self items] addObject:i];
    }
}

@end
