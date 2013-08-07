//
//  HomepwnerItemCell.m
//  Homepwner
//
//  Created by Joe Conway on 11/19/12.
//  Copyright (c) 2012 Big Nerd Ranch. All rights reserved.
//

#import "HomepwnerItemCell.h"

@implementation HomepwnerItemCell


- (IBAction)showImage:(id)sender
{
    NSString *selector = NSStringFromSelector(_cmd);
    // selector is now "showImage:atIndexPath:"
    selector = [selector stringByAppendingString:@"atIndexPath:"];
    // Prepare a selector from this string
    SEL newSelector = NSSelectorFromString(selector);
    
    NSIndexPath *indexPath = [[self owningTableView] indexPathForCell:self];
    // Ignore warning for this line - may or may not appear, doesn't matter
    if (indexPath) {
        if ([[self controller] respondsToSelector:newSelector]) {
            [[self controller] performSelector:newSelector
                                    withObject:sender
                                    withObject:indexPath];
        }
    }
}

- (void)awakeFromNib
{
    for(UIView *v in [[self contentView] subviews]) {
        [v setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    NSDictionary *names = @{
        @"image":[self thumbnailView],
        @"name":[self nameLabel],
        @"value":[self valueLabel],
        @"serial":[self serialNumberLabel]
    };

    
    NSString *fmt = @"H:|-2-[image(==40)]-[name]-[value(==42)]-|";
    NSArray *constraints = [NSLayoutConstraint
                            constraintsWithVisualFormat:fmt
                                                options:0
                                                metrics:nil
                                                  views:names];
    [[self contentView] addConstraints:constraints];
    
    fmt = @"V:|-1-[name(==20)]-(>=0)-[serial(==20)]-1-|";
    constraints = [NSLayoutConstraint
                   constraintsWithVisualFormat:fmt
                   options:NSLayoutFormatAlignAllLeft 
                   metrics:nil
                   views:names];
    [[self contentView] addConstraints:constraints];
    
    NSArray * (^constraintBuilder)(UIView *, float) = ^(UIView *v, float height) {
        return @[
            [NSLayoutConstraint constraintWithItem:v
                                         attribute:NSLayoutAttributeCenterY
                                         relatedBy:NSLayoutRelationEqual
                                            toItem:[self contentView]
                                         attribute:NSLayoutAttributeCenterY
                                        multiplier:1.0
                                          constant:0],
            [NSLayoutConstraint constraintWithItem:v
                                         attribute:NSLayoutAttributeHeight
                                         relatedBy:NSLayoutRelationEqual
                                            toItem:nil
                                         attribute:NSLayoutAttributeNotAnAttribute
                                        multiplier:0.0
                                          constant:height]
        ];
    };
    [[self contentView] addConstraints:constraintBuilder([self thumbnailView], 40)];
    [[self contentView] addConstraints:constraintBuilder([self valueLabel], 21)];

    // Create transparent button, give it target-action pair, add it to contentView
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTranslatesAutoresizingMaskIntoConstraints:NO];
    [button addTarget:self
               action:@selector(showImage:)
     forControlEvents:UIControlEventTouchUpInside];
    
    [[self contentView] addSubview:button];
    
    // Configure names dictionary and format string to apply constraints
    names = @{
        @"button" : button,
        @"image" : [self thumbnailView],
        @"name" : [self nameLabel]
    };
    fmt = @"H:|-2-[button(==image)]-[name]";
    
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:fmt
                                                          options:0
                                                          metrics:nil
                                                            views:names];
    [[self contentView] addConstraints:constraints];
    
    // Apply centerY and height constraint
    [[self contentView] addConstraints:constraintBuilder(button, 40)];
}
@end
