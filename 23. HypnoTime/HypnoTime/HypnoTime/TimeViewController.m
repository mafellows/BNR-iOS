//
//  TimeViewController.m
//  HypnoTime
//
//  Created by Joe Conway on 12/28/12.
//  Copyright (c) 2012 Big Nerd Ranch. All rights reserved.
//

#import "TimeViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface TimeViewController ()

@property (nonatomic, weak) IBOutlet UILabel *timeLabel;

- (IBAction)showCurrentTime:(id)sender;
- (void)spinTimeLabel;
- (void)bounceTimeLabel;
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

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    NSLog(@"%@ finished: %d", anim, flag);
}

- (void)spinTimeLabel
{
    // Create a basic animation
    CABasicAnimation *spin =
                [CABasicAnimation animationWithKeyPath:@"transform.rotation"];

    // fromValue is implied
    [spin setToValue:@(M_PI * 2.0)];
    [spin setDuration:1.0];
    // Set the timing function
    CAMediaTimingFunction *tf =  [CAMediaTimingFunction
                        functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [spin setTimingFunction:tf];
    [spin setDelegate:self];
    
    // Kick off the animation by adding it to the layer
    [[[self timeLabel] layer] addAnimation:spin
                             forKey:@"spinAnimation"];
}

- (IBAction)showCurrentTime:(id)sender
{
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    [[self timeLabel] setText:[formatter stringFromDate:now]];
    
    [self bounceTimeLabel];
}

- (void)bounceTimeLabel
{
    // Create a key frame animation
    CAKeyframeAnimation *bounce =
                    [CAKeyframeAnimation animationWithKeyPath:@"transform"];

    // Create the values it will pass through
    CATransform3D forward = CATransform3DMakeScale(1.3, 1.3, 1);
    CATransform3D back = CATransform3DMakeScale(0.7, 0.7, 1);
    CATransform3D forward2 = CATransform3DMakeScale(1.2, 1.2, 1);
    CATransform3D back2 = CATransform3DMakeScale(0.9, 0.9, 1);
    [bounce setValues:@[
                        [NSValue valueWithCATransform3D:CATransform3DIdentity],
                        [NSValue valueWithCATransform3D:forward],
                        [NSValue valueWithCATransform3D:back],
                        [NSValue valueWithCATransform3D:forward2],
                        [NSValue valueWithCATransform3D:back2],
                        [NSValue valueWithCATransform3D:CATransform3DIdentity]
                        ]];
    // Set the duration
    [bounce setDuration:0.6];

    // Animate the layer
    [[[self timeLabel] layer] addAnimation:bounce
                                    forKey:@"bounceAnimation"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"TimeViewController loaded its view.");
    NSLog(@"timeLabel = %@", [self timeLabel]);
    [[self timeLabel] setBackgroundColor:[UIColor redColor]];
}
@end
