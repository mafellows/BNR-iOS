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

@interface BNRListViewController () <NSURLConnectionDataDelegate>

@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSMutableData *jsonData;
@property (nonatomic, strong) BNRRSSFeed *feed;

- (void)fetchFeed;

@end

@implementation BNRListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if(self) {
        [self fetchFeed];
    }
    return self;
}

- (void)fetchFeed
{
    [self setJsonData:[[NSMutableData alloc] init]];
        
    NSString *requestString = [NSString stringWithFormat:@"http://itunes.apple.com/us/rss/topsongs/limit=10/json"];
    NSURL *url = [NSURL URLWithString:requestString];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    
    NSURLConnection *c = [[NSURLConnection alloc] initWithRequest:req delegate:self startImmediately:YES];
    
    [self setConnection:c];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [[self jsonData] appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self setConnection:nil];
    [self setJsonData:nil];
    
    NSString *errString = [error localizedDescription];
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error"
                                                 message:errString delegate:nil
                                       cancelButtonTitle:@"OK"
                                       otherButtonTitles:nil];
    [av show];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:[self jsonData]
                                                               options:0
                                                                 error:nil];
    
    BNRRSSFeed *c = [[BNRRSSFeed alloc] init];
    [c readFromJSONObject:jsonObject];
    [self setFeed:c];
    
        NSLog(@"%@", [[self feed] title]);
    
    [[self tableView] reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BNRRSSItem *i = [[[self feed] items] objectAtIndex:[indexPath row]];
    [[self webViewController] setLink:[i link]];
    [[self navigationController] pushViewController:[self webViewController]
                                           animated:YES];
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
