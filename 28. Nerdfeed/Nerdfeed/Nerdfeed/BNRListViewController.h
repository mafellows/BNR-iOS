//
//  BNRListViewController.h
//  Nerdfeed
//
//  Created by Joe Conway on 2/25/13.
//  Copyright (c) 2013 Big Nerd Ranch. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BNRWebViewController;

@interface BNRListViewController : UITableViewController

@property (nonatomic, strong) BNRWebViewController *webViewController;

@end
