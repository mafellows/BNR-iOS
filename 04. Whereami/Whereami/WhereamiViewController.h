//
//  WhereamiViewController.h
//  Whereami
//
//  Created by Joe Conway on 10/23/12.
//  Copyright (c) 2012 Big Nerd Ranch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface WhereamiViewController : UIViewController <CLLocationManagerDelegate>
{
    CLLocationManager *_locationManager;
}
@end