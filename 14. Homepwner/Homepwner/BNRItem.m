//
//  BNRItem.m
//  RandomPossessions
//
//  Created by Joe Conway on 10/12/12.
//  Copyright (c) 2012 Big Nerd Ranch. All rights reserved.
//

#import "BNRItem.h"

@implementation BNRItem


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        [self setItemName:[aDecoder decodeObjectForKey:@"itemName"]];
        [self setSerialNumber:[aDecoder decodeObjectForKey:@"serialNumber"]];
        [self setImageKey:[aDecoder decodeObjectForKey:@"imageKey"]];
        [self setValueInDollars:[aDecoder decodeIntForKey:@"valueInDollars"]];
        _dateCreated = [aDecoder decodeObjectForKey:@"dateCreated"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:[self itemName] forKey:@"itemName"];
    [aCoder encodeObject:[self serialNumber] forKey:@"serialNumber"];
    [aCoder encodeObject:[self dateCreated] forKey:@"dateCreated"];
    [aCoder encodeObject:[self imageKey] forKey:@"imageKey"];
    [aCoder encodeInt:[self valueInDollars] forKey:@"valueInDollars"];
}

+ (id)randomItem
{
    // Create an array of three adjectives
    NSArray *randomAdjectiveList = @[@"Fluffy", @"Rusty", @"Shiny"];
    // Create an array of three nouns
    NSArray *randomNounList = @[@"Bear", @"Spork", @"Mac"];
    // Get the index of a random adjective/noun from the lists
    // Note: The % operator, called the modulo operator, gives
    // you the remainder. So adjectiveIndex is a random number
    // from 0 to 2 inclusive.
    NSInteger adjectiveIndex = rand() % [randomAdjectiveList count];
    NSInteger nounIndex = rand() % [randomNounList count];
    // Note that NSInteger is not an object, but a type definition
    // for "unsigned long"
    NSString *randomName = [NSString stringWithFormat:@"%@ %@",
                                randomAdjectiveList[adjectiveIndex],
                                randomNounList[nounIndex]];
    int randomValue = rand() % 100;
    NSString *randomSerialNumber = [NSString stringWithFormat:@"%c%c%c%c%c",
                                        '0' + rand() % 10,
                                        'A' + rand() % 26,
                                        '0' + rand() % 10,
                                        'A' + rand() % 26,
                                        '0' + rand() % 10];
    BNRItem *newItem =
        [[self alloc] initWithItemName:randomName
                        valueInDollars:randomValue
                          serialNumber:randomSerialNumber];
    return newItem;
}

- (id)initWithItemName:(NSString *)name
        valueInDollars:(int)value
          serialNumber:(NSString *)sNumber
{
    // Call the superclass's designated initializer
    self = [super init];
    // Did the superclass's designated initializer succeed?
    if (self) {
        // Give the instance variables initial values
        [self setItemName:name];
        [self setSerialNumber:sNumber];
        [self setValueInDollars:value];
        _dateCreated = [[NSDate alloc] init];
    }
    
    // Return the address of the newly initialized object
    return self;
}

- (id)init {
    return [self initWithItemName:@"Item"
                   valueInDollars:0
                     serialNumber:@""];
}


- (void)setContainedItem:(BNRItem *)i
{
    _containedItem = i;
    // When given an item to contain, the contained
    // item will be given a pointer to its container
    [i setContainer:self];
}
- (NSString *)description
{
    NSString *descriptionString =
        [[NSString alloc] initWithFormat:@"%@ (%@): Worth $%d, recorded on %@",
                            [self itemName],
                            [self serialNumber],
                            [self valueInDollars],
                            [self dateCreated]];
    return descriptionString;
}

- (void)dealloc
{
    NSLog(@"Destroyed: %@", self);
}

@end
