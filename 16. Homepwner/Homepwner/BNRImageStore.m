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
- (NSString *)imagePathForKey:(NSString *)key;
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
        
        
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self         
               selector:@selector(clearCache:)
                   name:UIApplicationDidReceiveMemoryWarningNotification
                 object:nil];
    }

    return self;
}

- (void)clearCache:(NSNotification *)note
{
    NSLog(@"flushing %d images out of the cache", [_dictionary count]);
    [_dictionary removeAllObjects];
}

- (NSString *)imagePathForKey:(NSString *)key
{
    NSArray *documentDirectories =
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                        NSUserDomainMask,
                                        YES);
    NSString *documentDirectory = documentDirectories[0];
    return [documentDirectory stringByAppendingPathComponent:key];
}

- (void)setImage:(UIImage *)i forKey:(NSString *)s
{
    _dictionary[s] = i;
    
    // Create full path for image
    NSString *imagePath = [self imagePathForKey:s];
    // Turn image into JPEG data,
    NSData *d = UIImageJPEGRepresentation(i, 0.5);
    // Write it to full path
    [d writeToFile:imagePath atomically:YES];
}

- (UIImage *)imageForKey:(NSString *)s
{
    // If possible, get it from the dictionary
    UIImage *result = _dictionary[s];
    if (!result) {
        // Create UIImage object from file
        result = [UIImage imageWithContentsOfFile:[self imagePathForKey:s]];
        // If we found an image on the file system, place it into the cache
        if (result)
            _dictionary[s] = result;
        else
            NSLog(@"Error: unable to find %@", [self imagePathForKey:s]);
    }
    return result;
}

- (void)deleteImageForKey:(NSString *)s
{
    if (!s)
        return;
    [_dictionary removeObjectForKey:s];
    
    NSString *path = [self imagePathForKey:s];
    [[NSFileManager defaultManager] removeItemAtPath:path
                                               error:nil];
}
@end
