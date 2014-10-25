//
//  EventItem.m
//  Events4Vets
//
//  Created by davinorm on 5/24/14.
//  Copyright (c) 2014 David Norman. All rights reserved.
//

#import "EventItem.h"

@implementation EventItem

-(id)initWithTitle:(NSString *)title
{
    self = [super init];
    
    if (self) {
        //custom initialization
        self.title = title;
    }
    
    return self;
}

+(id)eventWithTitle:(NSString*)title
{
    return [[self alloc] initWithTitle:title];
}


@end
