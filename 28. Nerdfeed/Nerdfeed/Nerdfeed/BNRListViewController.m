//
//  BNRListViewController.m
//  Nerdfeed
//
//  Created by Joe Conway on 2/25/13.
//  Copyright (c) 2013 Big Nerd Ranch. All rights reserved.
//

#import "BNRListViewController.h"
#import "BNRRSSFeed.h"
#import "BNRRSSItem.h"
#import "BNRWebViewController.h"
#import "BNRFeedStore.h"

typedef enum {
    BNRListViewControllerRSSTypeBNR,
    BNRListViewControllerRSSTypeApple
} BNRListViewControllerRSSType;

@interface BNRListViewController ()

@property (nonatomic, strong) BNRRSSFeed *feed;
@property (nonatomic) BNRListViewControllerRSSType rssType;

- (void)fetchFeed;

@end

@implementation BNRListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if(self) {
        UISegmentedControl *rssTypeControl =
                            [[UISegmentedControl alloc] initWithItems:@[@"BNR", @"Apple"]];
        [rssTypeControl setSelectedSegmentIndex:0];
        [rssTypeControl setSegmentedControlStyle:UISegmentedControlStyleBar];
        [rssTypeControl addTarget:self
                           action:@selector(changeType:)
                 forControlEvents:UIControlEventValueChanged];
        [[self navigationItem] setTitleView:rssTypeControl];
        
        [self fetchFeed];
    }
    return self;
}

- (void)changeType:(id)sender
{
    [self setRssType:[sender selectedSegmentIndex]];
    [self fetchFeed];
}

- (void)fetchFeed
{
    // Get ahold of the segmented control that is currently in the title view
    UIView *currentTitleView = [[self navigationItem] titleView];

    // Create a activity indicator and start it spinning in the nav bar
    UIActivityIndicatorView *aiView = [[UIActivityIndicatorView alloc]
                    initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [[self navigationItem] setTitleView:aiView];
    [aiView startAnimating];
    
    void (^completionBlock)(BNRRSSFeed *obj, NSError *err) =
    ^(BNRRSSFeed *obj, NSError *err) {
        NSLog(@"Completion block called!");
        // When the request completes, this block will be called.
        // When the request completes - success or failure - replace the activity
        // indicator with the segmented control
        [[self navigationItem] setTitleView:currentTitleView];

        if (!err) {
            // If everything went ok, grab the feed object and
            // reload the table.
            [self setFeed:obj];
            [[self tableView] reloadData];
        } else {

            // If things went bad, show an alert view
            NSString *errorString = [NSString stringWithFormat:@"Fetch failed: %@",
                                     [err localizedDescription]];

            // Create and show an alert view with this error displayed
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error"
                                                         message:errorString
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
            [av show];
        }
    };

    // Initiate the request...
    if ([self rssType] == BNRListViewControllerRSSTypeBNR) {
        BNRRSSFeed *currentFeed = [[BNRFeedStore sharedStore] fetchPostsWithCompletion:^(BNRRSSFeed *obj, NSError *err) {
            // Replace the activity indicator.
            [[self navigationItem] setTitleView:currentTitleView];
            if (!err) {
                // How many items are there currently?
                int currentItemCount = [[[self feed] items] count];
                // Set our feed to the merged one
                [self setFeed:obj];
                // How many items are there now?
                int newItemCount = [[[self feed] items] count];
                // For each new item, insert a new row. The data source
                // will take care of the rest.
                int itemDelta = newItemCount - currentItemCount;
                if (itemDelta > 0) {
                    NSMutableArray *rows = [NSMutableArray array];
                    for (int i = 0; i < itemDelta; i++) {
                        NSIndexPath *ip = [NSIndexPath indexPathForRow:i
                                                             inSection:0];
                        [rows addObject:ip];
                    }
                    [[self tableView] insertRowsAtIndexPaths:rows
                                            withRowAnimation:UITableViewRowAnimationTop];
                }
            }
        }];
        [self setFeed:currentFeed];
        [[self tableView] reloadData];
    } else if ([self rssType] == BNRListViewControllerRSSTypeApple)
        [[BNRFeedStore sharedStore] fetchRSSFeedWithCompletion:completionBlock];
    
    NSLog(@"Executing code at the end of fetchEntries");
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![self splitViewController]) {
        [[self navigationController] pushViewController:[self webViewController]
                                               animated:YES];
    }
    
    BNRRSSItem *i = [[[self feed] items] objectAtIndex:[indexPath row]];
    [[self webViewController] setLink:[i link]];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [[[self feed] items] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *c = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if(!c) {
        c = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    
    BNRRSSItem *i = [[[self feed] items] objectAtIndex:[indexPath row]];
    [[c textLabel] setText:[i title]];
    
    return c;
}
@end
