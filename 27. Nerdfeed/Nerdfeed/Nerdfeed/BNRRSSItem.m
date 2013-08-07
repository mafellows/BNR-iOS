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

    if ([elementName isEqual:@"item"])
        [parser setDelegate:[self parentParserDelegate]];
}


@end
