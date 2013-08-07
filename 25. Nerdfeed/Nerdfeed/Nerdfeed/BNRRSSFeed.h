//
//  BNRChannel.h
//  Nerdfeed
//
//  Created by Joe Conway on 2/25/13.
//  Copyright (c) 2013 Big Nerd Ranch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BNRJSONObject.h"

@interface BNRRSSFeed : NSObject <BNRJSONObject>

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong, readonly) NSMutableArray *items;

@end
