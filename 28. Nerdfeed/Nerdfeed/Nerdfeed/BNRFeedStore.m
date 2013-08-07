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

@interface BNRFeedStore ()
@property (nonatomic, strong) NSDate *topSongsCacheDate;
@end

@implementation BNRFeedStore
@dynamic topSongsCacheDate;

+ (BNRFeedStore *)sharedStore
{
    static BNRFeedStore *feedStore = nil;
    if (!feedStore)
        feedStore = [[BNRFeedStore alloc] init];
    return feedStore;
}


- (void)setTopSongsCacheDate:(NSDate *)topSongsCacheDate
{
    [[NSUserDefaults standardUserDefaults] setObject:topSongsCacheDate
                                              forKey:@"topSongsCacheDate"];
}
- (NSDate *)topSongsCacheDate
{
    return [[NSUserDefaults standardUserDefaults]
                        objectForKey:@"topSongsCacheDate"];
}

- (BNRRSSFeed *)fetchPostsWithCompletion:(void (^)(BNRRSSFeed *obj, NSError *err))block
{
    NSURL *url = [NSURL URLWithString:@"http://forums.bignerdranch.com"
                  @"/smartfeed.php?limit=1_DAY&sort_by=standard"
                  @"&feed_type=RSS2.0&feed_style=COMPACT"];
     
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    
    BNRRSSFeed *feed = [[BNRRSSFeed alloc] init];
    
    BNRConnection *connection = [[BNRConnection alloc] initWithRequest:req];
    
    NSString *cachePath =
    NSSearchPathForDirectoriesInDomains(NSCachesDirectory,
                                        NSUserDomainMask,
                                        YES)[0];
    cachePath = [cachePath stringByAppendingPathComponent:@"nerd.archive"];
    // Load the cached feed
    BNRRSSFeed *cachedFeed =
    [NSKeyedUnarchiver unarchiveObjectWithFile:cachePath];
    // If one hasn't already been cached, create a blank one to fill up
    if (!cachedFeed)
        cachedFeed = [[BNRRSSFeed alloc] init];
    
    BNRRSSFeed *feedCopy = [cachedFeed copy];
    
    [connection setCompletionBlock:^(BNRRSSFeed *obj, NSError *err) {
        // This is the store's callback code
        if (!err) {
            [feedCopy addItemsFromFeed:obj];
            [NSKeyedArchiver archiveRootObject:feedCopy toFile:cachePath];
        }
        // This is the controller's callback code
        block(feedCopy, err);
    }];

    [connection setXmlRootObject:feed];
    [connection start];
    return cachedFeed;
}

- (void)fetchRSSFeedWithCompletion:(void (^)(BNRRSSFeed *obj, NSError *err))block
{
// Construct the cache path
    NSString *cachePath =
        NSSearchPathForDirectoriesInDomains(NSCachesDirectory,
                                             NSUserDomainMask,
                                             YES)[0];
    cachePath = [cachePath stringByAppendingPathComponent:@"apple.archive"];

// Make sure we have cached at least once before by checking to see
    // if this date exists!
    NSDate *tscDate = [self topSongsCacheDate];
    if (tscDate) {
        // How old is the cache?
        NSTimeInterval cacheAge = [tscDate timeIntervalSinceNow];
        if (cacheAge > -300.0) {
            // If it is less than 300 seconds (5 minutes) old, return cache
            // in completion block
            NSLog(@"Reading cache!");
            BNRRSSFeed *cachedFeed = [NSKeyedUnarchiver
                                            unarchiveObjectWithFile:cachePath];
            if (cachedFeed) {
                // Execute the controller's completion block to reload its table
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    block(cachedFeed, nil);
                }];
                // Don't need to make the request, just get out of this method
                return;
            }
        }
    }

    NSURL *url =
    [NSURL URLWithString:@"http://itunes.apple.com/us/rss/topsongs/limit=10/json"];
    
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    // Create an empty feed
    BNRRSSFeed *feed = [[BNRRSSFeed alloc] init];

    // Create a connection "actor" object that will transfer data from the server
    BNRConnection *connection = [[BNRConnection alloc] initWithRequest:req];

    [connection setCompletionBlock:^(BNRRSSFeed *obj, NSError *err) {
        // This is the store's completion code:
        // If everything went smoothly, save the feed to disk and set cache date
        if (!err) {
            [self setTopSongsCacheDate:[NSDate date]];
            [NSKeyedArchiver archiveRootObject:obj toFile:cachePath];
        }
        // This is the controller's completion code:
        block(obj, err);
    }];
    // Let the empty feed parse the returning data from the web service
    [connection setJsonRootObject:feed];

    // Begin the connection
    [connection start];
}

@end
