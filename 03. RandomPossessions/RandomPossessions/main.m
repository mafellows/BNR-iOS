//
//  main.m
//  RandomPossessions
//
//  Created by Joe Conway on 10/12/12.
//  Copyright (c) 2012 Big Nerd Ranch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BNRItem.h"

int main(int argc, const char * argv[])
{

    @autoreleasepool {
    

        BNRItem *backpack = [[BNRItem alloc] init];
        [backpack setItemName:@"Backpack"];
        
        
        BNRItem *calculator = [[BNRItem alloc] init];
        [calculator setItemName:@"Calculator"];
        
        
        [backpack setContainedItem:calculator];
        
        // Destroy the array pointed to by items
        backpack = nil;
        
        NSLog(@"%@", [calculator container]);
        
        calculator = nil;
    }
    return 0;
}

