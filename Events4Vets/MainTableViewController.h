//
//  MainTableViewController.h
//  Events4Vets
//
//  Created by davinorm on 5/21/14.
//  Copyright (c) 2014 David Norman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventItem.h"
#import "SWTableViewCell.h"

@interface MainTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, SWTableViewCellDelegate>

{
    NSArray *returnedEventsArray;
    NSMutableArray *mutableEventsArray;
    EventItem *eventItemToPass;
    
}

@end
