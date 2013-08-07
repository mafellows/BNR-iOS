//
//  BNRChannel.m
//  Nerdfeed
//
//  Created by Joe Conway on 2/25/13.
//  Copyright (c) 2013 Big Nerd Ranch. All rights reserved.
//

#import "BNRRSSFeed.h"
#import "BNRRSSItem.h"

@interface BNRRSSFeed ()
{
    NSMutableString *_string;
}
@end

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

- (void)parser:(NSXMLParser *)parser
    didStartElement:(NSString *)elementName
       namespaceURI:(NSString *)namespaceURI
      qualifiedName:(NSString *)qualifiedName
         attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqual:@"title"]) {
        _string = [[NSMutableString alloc] init];
        [self setTitle:_string];
    } else if([elementName isEqualToString:@"item"]) {
        BNRRSSItem *i = [[BNRRSSItem alloc] init];
        
        [i setParentParserDelegate:self];
        
        [[self items] addObject:i];
        
        [parser setDelegate:i];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)str
{
    [_string appendString:str];
}

- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
{
    _string = nil;
}


@end
