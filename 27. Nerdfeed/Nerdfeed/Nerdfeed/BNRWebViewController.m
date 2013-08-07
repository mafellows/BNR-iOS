//
//  BNRWebViewController.m
//  Nerdfeed
//
//  Created by Joe Conway on 2/25/13.
//  Copyright (c) 2013 Big Nerd Ranch. All rights reserved.
//

#import "BNRWebViewController.h"


@implementation BNRWebViewController

- (void)splitViewController:(UISplitViewController *)svc
     willHideViewController:(UIViewController *)aViewController
          withBarButtonItem:(UIBarButtonItem *)barButtonItem
       forPopoverController:(UIPopoverController *)pc
{
    // If this bar button item doesn't have a title, it won't appear at all.
    [barButtonItem setTitle:@"List"];
    // Take this bar button item and put it on the left side of our nav item.
    [[self navigationItem] setLeftBarButtonItem:barButtonItem];
}

- (void)splitViewController:(UISplitViewController *)svc
     willShowViewController:(UIViewController *)aViewController
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Remove the bar button item from our navigation item
    // We'll double check that its the correct button, even though we know it is
    if (barButtonItem == [[self navigationItem] leftBarButtonItem])
        [[self navigationItem] setLeftBarButtonItem:nil];
}

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
