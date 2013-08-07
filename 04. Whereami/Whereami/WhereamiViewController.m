//
//  WhereamiViewController.m
//  Whereami
//
//  Created by Joe Conway on 10/23/12.
//  Copyright (c) 2012 Big Nerd Ranch. All rights reserved.
//

#import "WhereamiViewController.h"

@interface WhereamiViewController ()

@end

@implementation WhereamiViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Create location manager object
        _locationManager = [[CLLocationManager alloc] init];
        
        // There will be a warning from this line of code; ignore it for now
        [_locationManager setDelegate:self];
    
        // And we want it to be as accurate as possible
        // regardless of how much time/power it takes
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        // Tell our manager to start looking for its location immediately
        [_locationManager startUpdatingLocation];
    }
    return self;
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    CLLocation *newLocation = [locations lastObject];
    NSLog(@"%@", newLocation);
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    NSLog(@"Could not find location: %@", error);
}

- (void)dealloc
{
    // Tell the location manager to stop sending us messages
    [_locationManager setDelegate:nil];
}

@end
