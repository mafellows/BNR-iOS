//
//  BNRImageStore.h
//  Homepwner
//
//  Created by Joe Conway on 10/26/12.
//  Copyright (c) 2012 Big Nerd Ranch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNRImageStore : NSObject
+ (BNRImageStore *)sharedStore;


- (void)setImage:(UIImage *)i forKey:(NSString *)s;
- (UIImage *)imageForKey:(NSString *)s;
- (void)deleteImageForKey:(NSString *)s;
@end
