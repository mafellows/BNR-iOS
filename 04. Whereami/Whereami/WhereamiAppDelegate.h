//
//  WhereamiAppDelegate.h
//  Whereami
//
//  Created by Joe Conway on 10/23/12.
//  Copyright (c) 2012 Big Nerd Ranch. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WhereamiViewController;

@interface WhereamiAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) WhereamiViewController *viewController;

@end
