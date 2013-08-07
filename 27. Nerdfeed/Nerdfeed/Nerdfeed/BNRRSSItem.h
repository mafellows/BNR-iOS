//
//  BNRRSSItem.h
//  Nerdfeed
//
//  Created by Joe Conway on 2/25/13.
//  Copyright (c) 2013 Big Nerd Ranch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BNRJSONObject.h"

@interface BNRRSSItem : NSObject <BNRJSONObject, NSXMLParserDelegate>

@property (nonatomic, weak) id <NSXMLParserDelegate> parentParserDelegate;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *link;
@end
