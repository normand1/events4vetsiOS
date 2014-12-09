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
#import "MBProgressHUD.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "LikeView.h"
#import "JNWSpringAnimation.h"


@interface MainTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, SWTableViewCellDelegate, NSURLConnectionDelegate, NSURLConnectionDataDelegate>

{
    NSArray *returnedEventsArray;
    NSMutableArray *mutableEventsArray;
    EventItem *eventItemToPass;
    MBProgressHUD *hud;
    int counter;
    
}

@property(nonatomic, strong) LikeView *likeView;


@end
