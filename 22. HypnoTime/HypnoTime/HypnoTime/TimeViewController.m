//
//  TimeViewController.m
//  HypnoTime
//
//  Created by Joe Conway on 12/28/12.
//  Copyright (c) 2012 Big Nerd Ranch. All rights reserved.
//

#import "TimeViewController.h"

@interface TimeViewController ()

@property (nonatomic, weak) IBOutlet UILabel *timeLabel;

- (IBAction)showCurrentTime:(id)sender;

@end

@implementation TimeViewController
- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil
                           bundle:nibBundleOrNil];
    if (self) {
        // Get the tab bar item
        UITabBarItem *tbi = [self tabBarItem];
        // Give it a label
        [tbi setTitle:@"Time"];
        
        UIImage *i = [UIImage imageNamed:@"Time.png"];
        [tbi setImage:i];
    }
    return self;
}
- (IBAction)showCurrentTime:(id)sender
{
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    [[self timeLabel] setText:[formatter stringFromDate:now]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"TimeViewController loaded its view.");
    NSLog(@"timeLabel = %@", [self timeLabel]);
    [[self timeLabel] setBackgroundColor:[UIColor redColor]];
}
@end
