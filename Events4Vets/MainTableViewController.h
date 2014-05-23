//
//  MainTableViewController.h
//  Events4Vets
//
//  Created by davinorm on 5/21/14.
//  Copyright (c) 2014 David Norman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

{
    NSArray *returnedEventsArray;
}

@end
