//
//  BNRDrawView.m
//  TouchTracker
//
//  Created by Joe Conway on 12/26/12.
//  Copyright (c) 2012 Big Nerd Ranch. All rights reserved.
//

#import "BNRDrawView.h"
#import "BNRLine.h"

@interface BNRDrawView ()
{
    NSMutableDictionary *_linesInProgress;
    NSMutableArray *_finishedLines;
}
@end

@implementation BNRDrawView

- (id)initWithFrame:(CGRect)r
{
    self = [super initWithFrame:r];

    if (self) {
        _linesInProgress = [[NSMutableDictionary alloc] init];
        _finishedLines = [[NSMutableArray alloc] init];

        [self setBackgroundColor:[UIColor grayColor]];
        [self setMultipleTouchEnabled:YES];
    }

    return self;
}

- (void)touchesBegan:(NSSet *)touches
           withEvent:(UIEvent *)event
{
    for(UITouch *t in touches) {
        CGPoint location = [t locationInView:self];
        BNRLine *line = [[BNRLine alloc] init];
        [line setBegin:location];
        [line setEnd:location];
        
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        
        [_linesInProgress setObject:line
                             forKey:key];
    }
    [self setNeedsDisplay];
}
- (void)touchesMoved:(NSSet *)touches
           withEvent:(UIEvent *)event
{
    for(UITouch *t in touches) {
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        BNRLine *line = [_linesInProgress objectForKey:key];
        
        [line setEnd:[t locationInView:self]];
    }

    [self setNeedsDisplay];
}
- (void)touchesEnded:(NSSet *)touches
           withEvent:(UIEvent *)event
{
    for(UITouch *t in touches) {
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        BNRLine *line = [_linesInProgress objectForKey:key];

        [_finishedLines addObject:line];
        [_linesInProgress removeObjectForKey:key];
    }

    [self setNeedsDisplay];
}

- (void)touchesCancelled:(NSSet *)touches
                withEvent:(UIEvent *)events
{
    for(UITouch *t in touches) {
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        [_linesInProgress removeObjectForKey:key];
    }
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    // Create a block that will configure and draw a BNRLine
    void (^strokeLine)(BNRLine *) = ^(BNRLine *line) {
        UIBezierPath *bp = [UIBezierPath bezierPath];
        [bp moveToPoint:[line begin]];
        [bp addLineToPoint:[line end]];
        [bp setLineWidth:10];
        [bp setLineCapStyle:kCGLineCapRound];
    
        [bp stroke];
    };

    // Draw finished lines in black
    [[UIColor blackColor] set];
    for (BNRLine *line in _finishedLines) {
        strokeLine(line);
    }
    
    [[UIColor redColor] set];
    for(NSValue *key in _linesInProgress) {
        strokeLine([_linesInProgress objectForKey:key]);
    }
}

@end
