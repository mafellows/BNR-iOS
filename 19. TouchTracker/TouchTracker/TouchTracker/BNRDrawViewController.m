//
//  BNRDrawViewController.m
//  TouchTracker
//
//  Created by Joe Conway on 12/26/12.
//  Copyright (c) 2012 Big Nerd Ranch. All rights reserved.
//

#import "BNRDrawViewController.h"
#import "BNRDrawView.h"

@implementation BNRDrawViewController

- (void)loadView
{
    [self setView:[[BNRDrawView alloc] initWithFrame:CGRectZero]];
}

@end
