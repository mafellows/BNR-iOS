//
//  WhereamiViewController.m
//  Whereami
//
//  Created by Joe Conway on 10/23/12.
//  Copyright (c) 2012 Big Nerd Ranch. All rights reserved.
//

#import "WhereamiViewController.h"
#import "BNRMapPoint.h"

@interface WhereamiViewController ()
{
    CLLocationManager *_locationManager;
}
@property (nonatomic, strong) IBOutlet MKMapView *worldView;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) IBOutlet UITextField *locationTitleField;

- (void)findLocation;
- (void)foundLocation:(CLLocation *)loc;

@end

@implementation WhereamiViewController

- (void)findLocation
{
    [_locationManager startUpdatingLocation];
    [[self activityIndicator] startAnimating];
    [[self locationTitleField] setHidden:YES];
}
- (void)foundLocation:(CLLocation *)loc
{
    CLLocationCoordinate2D coord = [loc coordinate];
    // Create an instance of BNRMapPoint with the current data
    BNRMapPoint *mp = [[BNRMapPoint alloc] initWithCoordinate:coord
                                                        title:[_locationTitleField text]];
    // Add it to the map view
    [[self worldView] addAnnotation:mp];
    
    // Zoom the region to this location
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, 250, 250);
    [[self worldView] setRegion:region animated:YES];
    
    // Reset the UI
    [[self locationTitleField] setText:@""];
    [[self activityIndicator] stopAnimating];
    [[self locationTitleField] setHidden:NO];
    [_locationManager stopUpdatingLocation];
}

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

    }
    return self;
}

- (void)viewDidLoad
{
    [[self worldView] setShowsUserLocation:YES];
}

- (void)mapView:(MKMapView *)mapView
    didUpdateUserLocation:(MKUserLocation *)userLocation
{
    CLLocationCoordinate2D loc = [userLocation coordinate];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, 250, 250);
    [[self worldView] setRegion:region animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // This method isn't implemented yet - but will be soon.
    [self findLocation];
    [textField resignFirstResponder];
    return YES;
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    CLLocation *newLocation = [locations lastObject];
    NSLog(@"%@", newLocation);
    
    // How many seconds ago was this new location created?
    NSTimeInterval t = [[newLocation timestamp] timeIntervalSinceNow];
    // CLLocationManagers will return the last found location of the
    // device first, you don't want that data in this case.
    // If this location was made more than 3 minutes ago, ignore it.
    if (t < -180) {
        // This is cached data, you don't want it, keep looking
        return;
    }
    [self foundLocation:newLocation];
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
