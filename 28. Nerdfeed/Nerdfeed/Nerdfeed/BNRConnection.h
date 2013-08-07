//
//  BNRConnection.h
//  Nerdfeed
//
//  Created by Joe Conway on 3/26/13.
//  Copyright (c) 2013 Big Nerd Ranch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BNRJSONObject.h"

@interface BNRConnection : NSObject <NSURLConnectionDataDelegate>

- (id)initWithRequest:(NSURLRequest *)req;

@property (nonatomic, copy) NSURLRequest *request;
@property (nonatomic, copy) void (^completionBlock)(id obj, NSError *err);
@property (nonatomic, strong) id <BNRJSONObject> jsonRootObject;
@property (nonatomic, strong) id <NSXMLParserDelegate> xmlRootObject;

- (void)start;

@end
