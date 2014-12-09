//
//  EventItem.h
//  Events4Vets
//
//  Created by davinorm on 5/24/14.
//  Copyright (c) 2014 David Norman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventItem : NSObject
{
    
}

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *imgString;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, strong) NSURL *link;
@property (nonatomic, strong) NSString *dateString;
@property (nonatomic, strong) NSNumber *identifier;
@property (nonatomic, strong) NSNumber *score;


-(id)initWithTitle:(NSString *)title;
+(id)eventWithTitle:(NSString*)title;


@end
