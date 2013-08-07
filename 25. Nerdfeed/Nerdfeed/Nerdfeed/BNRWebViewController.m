//
//  BNRWebViewController.m
//  Nerdfeed
//
//  Created by Joe Conway on 2/25/13.
//  Copyright (c) 2013 Big Nerd Ranch. All rights reserved.
//

#import "BNRWebViewController.h"


@implementation BNRWebViewController


- (void)loadView
{
    UIWebView *wv = [[UIWebView alloc] init];
    [self setView:wv];
}

- (void)setLink:(NSString *)link
{
    _link = link;
    if(_link) {
        NSURL *url = [NSURL URLWithString:[self link]];
        NSURLRequest *req = [NSURLRequest requestWithURL:url];
        [(UIWebView *)[self view] loadRequest:req];
    }
}

@end
