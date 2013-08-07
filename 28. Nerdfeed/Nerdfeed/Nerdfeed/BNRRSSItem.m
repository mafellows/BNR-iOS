//
//  BNRRSSItem.m
//  Nerdfeed
//
//  Created by Joe Conway on 2/25/13.
//  Copyright (c) 2013 Big Nerd Ranch. All rights reserved.
//

#import "BNRRSSItem.h"

@interface BNRRSSItem ()
{
    NSMutableString *_string;
}
@end

@implementation BNRRSSItem

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_publicationDate forKey:@"_publicationDate"];
    [aCoder encodeObject:_title forKey:@"_title"];
    [aCoder encodeObject:_link forKey:@"_link"];
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _title = [aDecoder decodeObjectForKey:@"_title"];
        _link = [aDecoder decodeObjectForKey:@"_link"];
        _publicationDate = [aDecoder decodeObjectForKey:@"_publicationDate"];
    }
    return self;
}

- (BOOL)isEqual:(id)object
{
    // Make sure we are comparing an BNRRSSItem!
    if (![object isKindOfClass:[BNRRSSItem class]])
        return NO;
    // Now only return YES if the links are equal.
    return [[self link] isEqual:[object link]];
}

- (void)readFromJSONObject:(NSDictionary *)jsonObject
{
    NSDictionary *name = [jsonObject objectForKey:@"im:name"];
    [self setTitle:[name objectForKey:@"label"]];
    
    NSArray *linkArray = [jsonObject objectForKey:@"link"];
    for(NSDictionary *d in linkArray) {
        NSDictionary *attrs = [d objectForKey:@"attributes"];
        if([[attrs objectForKey:@"im:assetType"] isEqualToString:@"preview"]) {
            NSDictionary *attrs = [d objectForKey:@"attributes"];
            [self setLink:[attrs objectForKey:@"href"]];
        }
    }
}

- (void)parser:(NSXMLParser *)parser
    didStartElement:(NSString *)elementName
       namespaceURI:(NSString *)namespaceURI
      qualifiedName:(NSString *)qualifiedName
         attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"title"]) {
        _string = [[NSMutableString alloc] init];
        [self setTitle:_string];
    }
    else if ([elementName isEqualToString:@"link"]) {
        _string = [[NSMutableString alloc] init];
        [self setLink:_string];
    } else if ([elementName isEqualToString:@"pubDate"]) {
        // Create the string, but do not put it into an ivar yet
        _string = [[NSMutableString alloc] init];
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
    // If the pubDate ends, use a date formatter to turn it into an NSDate
    if ([elementName isEqualToString:@"pubDate"]) {
        static NSDateFormatter *dateFormatter = nil;
        if (!dateFormatter) {
            dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss z"];
        }
        [self setPublicationDate:[dateFormatter dateFromString:_string]];
    }
    
    _string = nil;

    if ([elementName isEqual:@"item"])
        [parser setDelegate:[self parentParserDelegate]];
}


@end
