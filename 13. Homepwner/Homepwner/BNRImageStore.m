//
//  BNRImageStore.m
//  Homepwner
//
//  Created by Joe Conway on 10/26/12.
//  Copyright (c) 2012 Big Nerd Ranch. All rights reserved.
//

#import "BNRImageStore.h"

@interface BNRImageStore ()
{
    NSMutableDictionary *_dictionary;
}
@end

@implementation BNRImageStore

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedStore];
}

+ (BNRImageStore *)sharedStore
{
    static BNRImageStore *sharedStore = nil;
    if (!sharedStore) {
        // Create the singleton
        sharedStore = [[super allocWithZone:NULL] init];
    }
    return sharedStore;
}

- (id)init
{
    self = [super init];
    if (self) {
        _dictionary = [[NSMutableDictionary alloc] init];
    }

    return self;
}

- (void)setImage:(UIImage *)i forKey:(NSString *)s
{
    _dictionary[s] = i;
}

- (UIImage *)imageForKey:(NSString *)s
{
    return _dictionary[s];
}

- (void)deleteImageForKey:(NSString *)s
{
    if (!s)
        return;
    [_dictionary removeObjectForKey:s];
}
@end
