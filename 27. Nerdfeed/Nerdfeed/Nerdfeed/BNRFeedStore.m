//
//  BNRFeedStore.m
//  Nerdfeed
//
//  Created by Joe Conway on 3/26/13.
//  Copyright (c) 2013 Big Nerd Ranch. All rights reserved.
//

#import "BNRFeedStore.h"
#import "BNRRSSFeed.h"
#import "BNRConnection.h"

@implementation BNRFeedStore

+ (BNRFeedStore *)sharedStore
{
    static BNRFeedStore *feedStore = nil;
    if (!feedStore)
        feedStore = [[BNRFeedStore alloc] init];
    return feedStore;
}

- (void)fetchPostsWithCompletion:(void (^)(BNRRSSFeed *obj, NSError *err))block
{
    NSURL *url = [NSURL URLWithString:@"http://forums.bignerdranch.com"
                  @"/smartfeed.php?limit=1_DAY&sort_by=standard"
                  @"&feed_type=RSS2.0&feed_style=COMPACT"];
     
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    
    BNRRSSFeed *feed = [[BNRRSSFeed alloc] init];
    
    BNRConnection *connection = [[BNRConnection alloc] initWithRequest:req];
    
    [connection setCompletionBlock:block];

    [connection setXmlRootObject:feed];
    [connection start];
}

- (void)fetchRSSFeedWithCompletion:(void (^)(BNRRSSFeed *obj, NSError *err))block
{
    NSURL *url =
    [NSURL URLWithString:@"http://itunes.apple.com/us/rss/topsongs/limit=10/json"];
    
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    // Create an empty feed
    BNRRSSFeed *feed = [[BNRRSSFeed alloc] init];

    // Create a connection "actor" object that will transfer data from the server
    BNRConnection *connection = [[BNRConnection alloc] initWithRequest:req];

    // When the connection completes, this block from the controller will be called
    [connection setCompletionBlock:block];

    // Let the empty feed parse the returning data from the web service
    [connection setJsonRootObject:feed];

    // Begin the connection
    [connection start];
}

@end
