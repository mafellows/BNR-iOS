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

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _items = [[aDecoder decodeObjectForKey:@"_items"] mutableCopy];
        _title = [aDecoder decodeObjectForKey:@"_title"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_items forKey:@"_items"];
    [aCoder encodeObject:_title forKey:@"_title"];
}

- (id)copyWithZone:(NSZone *)zone
{
    BNRRSSFeed *c = [[[self class] alloc] init];
    [c setTitle:[self title]];
    c->_items = [_items mutableCopy];
    return c;
}

- (void)addItemsFromFeed:(BNRRSSFeed *)otherFeed
{
    for (BNRRSSItem *i in [otherFeed items]) {
        // If self's items does not contain this item, add it
        if (![[self items] containsObject:i])
            [[self items] addObject:i];
    }
    // Sort the array of items by publication date
    [[self items] sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [[obj2 publicationDate] compare:[obj1 publicationDate]];
    }];
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
