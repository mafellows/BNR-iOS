//
//  BNRJSONObject.h
//  Nerdfeed
//
//  Created by Joe Conway on 2/25/13.
//  Copyright (c) 2013 Big Nerd Ranch. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BNRJSONObject <NSObject>

- (void)readFromJSONObject:(NSDictionary *)jsonObject;

@end
