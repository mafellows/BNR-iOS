//
//  BNRConnection.m
//  Nerdfeed
//
//  Created by Joe Conway on 3/26/13.
//  Copyright (c) 2013 Big Nerd Ranch. All rights reserved.
//

#import "BNRConnection.h"

static NSMutableArray *sharedConnectionList = nil;

@interface BNRConnection ()
@property (nonatomic, strong) NSMutableData *container;
@property (nonatomic, strong) NSURLConnection *internalConnection;
@end

@implementation BNRConnection

- (id)initWithRequest:(NSURLRequest *)req
{
    self = [super init];
    if (self) {
        [self setRequest:req];
    }
    return self;
}

- (void)start
{
    // Initialize container for data collected from NSURLConnection
    [self setContainer:[[NSMutableData alloc] init]];

    // Spawn connection
    [self setInternalConnection:[[NSURLConnection alloc] initWithRequest:[self request]
                                                                delegate:self
                                                        startImmediately:YES]];
    // If this is the first connection started, create the array
    if (!sharedConnectionList)
        sharedConnectionList = [[NSMutableArray alloc] init];

    // Add the connection to the array so it doesn't get destroyed
    [sharedConnectionList addObject:self];
}

- (void)connection:(NSURLConnection *)connection
            didFailWithError:(NSError *)error
{
    // Pass the error from the connection to the completionBlock
    if ([self completionBlock])
        [self completionBlock](nil, error);

    // Destroy this connection
    [sharedConnectionList removeObject:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [[self container] appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    id rootObject = nil;
    
    // If there is a "root object"
    if ([self jsonRootObject]) {

        // Create a parser with the incoming data and let the root object parse
        // its contents
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:[self container]
                                                                   options:0
                                                                     error:nil];
        [[self jsonRootObject] readFromJSONObject:jsonObject];
        
        rootObject = [self jsonRootObject];
    } else if([self xmlRootObject]) {
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:[self container]];
        [parser setDelegate:[self xmlRootObject]];
        [parser parse];
        
        rootObject = [self xmlRootObject];
    }

    // Then, pass the root object to the completion block - remember,
    // this is the block that the controller supplied.
    if ([self completionBlock])
        [self completionBlock](rootObject, nil);

    // Now, destroy this connection
    [sharedConnectionList removeObject:self];
}

@end
