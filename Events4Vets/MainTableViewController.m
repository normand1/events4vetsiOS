//
//  MainTableViewController.m
//  Events4Vets
//
//  Created by davinorm on 5/21/14.
//  Copyright (c) 2014 David Norman. All rights reserved.
//

#import "MainTableViewController.h"
#import "EventItem.h"
#import "EventDetailWebViewController.h"
#import "EventsTableViewCell.h"
#import "UIColor+E4VColors.h"

@interface MainTableViewController ()

@end

@implementation MainTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.clearsSelectionOnViewWillAppear = YES;
    self.navigationController.navigationBarHidden = NO;
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Getting Events";


    [self getEventsFromServer];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    

}

-(void)viewWillDisappear:(BOOL)animated
{
    [PFUser logOut];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [mutableEventsArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MainCellIdentifier";
    
    EventsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundImage.image = [UIImage imageNamed:@"blankImageCheck43"];
    cell.delegate = self;
    cell.leftUtilityButtons = [self leftButtons];
    cell.rightUtilityButtons = [self rightButtons];

    
    EventItem *currentEventItem = mutableEventsArray[indexPath.row];
    [cell setItem:currentEventItem];
    
    
    NSString *imageUrlStr = currentEventItem.imgString;
    
    
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:imageUrlStr]]];
    requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
    {
//        NSLog(@"Response: %@", responseObject);
        cell.backgroundImage.image = responseObject;
        [cell.backgroundImage setClipsToBounds:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Image error: %@", error);
        cell.backgroundImage.image = [UIImage imageNamed:@"splash_screen.png"];
        [cell.backgroundImage setClipsToBounds:YES];
    }];
    
    
    [requestOperation start];

    
    return cell;
}

#pragma mark table refresh methods

- (void)refresh:(UIRefreshControl *)refreshControl {
    [self getEventsFromServer];
}


-(void)getEventsFromServer
{
    [hud show:YES];
    NSString *urlStr = @"http://davidwnorman.com/events4vets/api/getEvents.php";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        NSLog(@"JSON: %@", responseObject);
        returnedEventsArray = [NSMutableArray arrayWithArray:responseObject];
        
        mutableEventsArray = [NSMutableArray arrayWithCapacity:[returnedEventsArray count]];
//        returnedEventsArray = [mutableEventsArray ];
        for (NSDictionary* event in returnedEventsArray)
        {
            EventItem *eventItem = [EventItem eventWithTitle:[event objectForKey:@"title"]];
            eventItem.link = [NSURL URLWithString:[event objectForKey:@"link"]];
            eventItem.imgString = [event objectForKey:@"img"];
            eventItem.price = [event objectForKey:@"price"];
            eventItem.dateString = [event objectForKey:@"date"];
            eventItem.identifier = [event objectForKey:@"id"];
            eventItem.score = [event objectForKey:@"votes"];
            
            [mutableEventsArray addObject:eventItem];
        }
        
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
        NSLog(@"returnedEventsArray count: %lu", (unsigned long)[returnedEventsArray count]);
        [hud hide:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [self.refreshControl endRefreshing];
        [hud hide:YES];
    }];
    
}

-(void)updateScoreEventOnServerWith:(NSNumber*)identifier andScoreType:(NSNumber*)scoreType andCell:(EventsTableViewCell*)cell
{
    NSMutableURLRequest *urlReq = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:@"http://davidwnorman.com/events4vets/inc/insertEvent.php"]];
    [urlReq setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSData *postdata = [[NSString stringWithFormat:@"event_update_score=1&event_id=%d&score_type=%d&user_id=%@",identifier.intValue, scoreType.intValue, [PFUser currentUser].email] dataUsingEncoding:NSUTF8StringEncoding];
    [urlReq setHTTPBody: postdata];
    [urlReq setHTTPMethod:@"POST"];
    [NSURLConnection sendAsynchronousRequest:urlReq queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
    {
        NSLog(@"error: %@", connectionError);
        NSLog(@"response: %@", response);
        NSString *dataString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"data: %@", dataString);
        NSLog(@"location: %lu", (unsigned long)[dataString rangeOfString:@"Duplicate entry"].location);
        if ([dataString rangeOfString:@"Duplicate entry"].location == NSNotFound && [dataString rangeOfString:@"body-500"].location == NSNotFound)
        {
            EventItem* eventItem = mutableEventsArray[[self.tableView indexPathForCell:cell].row];
            eventItem.score = [NSNumber numberWithInt:eventItem.score.intValue + 1];
            mutableEventsArray[[self.tableView indexPathForCell:cell].row] = eventItem;
            
            cell.item = eventItem;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self animateLikeWithCell:cell];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.likeView startRemovalTimer];
                    [self performSelector:@selector(hideTheLikeView) withObject:self afterDelay:1];
                });
                
                cell.scoreLabel.text = [NSString stringWithFormat:@"BZ: %@", eventItem.score];
                [cell setNeedsDisplay];
            });
        }
        else
        {
         
            [self subtractScoreOnServer:identifier andScoreType:0 andCell:cell];
        }

    }];
}

-(void)subtractScoreOnServer:(NSNumber*)identifier andScoreType:(NSNumber*)scoreType andCell:(EventsTableViewCell*)cell
{
    NSMutableURLRequest *urlReq = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:@"http://davidwnorman.com/events4vets/inc/insertEvent.php"]];
    [urlReq setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSData *postdata = [[NSString stringWithFormat:@"event_update_score=1&event_id=%d&score_type=%d&user_id=%@",identifier.intValue, scoreType.intValue, [PFUser currentUser].email] dataUsingEncoding:NSUTF8StringEncoding];
    [urlReq setHTTPBody: postdata];
    [urlReq setHTTPMethod:@"POST"];
    [NSURLConnection sendAsynchronousRequest:urlReq queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSLog(@"error: %@", connectionError);
        NSLog(@"response: %@", response);
        NSString *dataString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"data: %@", dataString);
        NSLog(@"location: %lu", (unsigned long)[dataString rangeOfString:@"Duplicate entry"].location);
        
        EventItem* eventItem = mutableEventsArray[[self.tableView indexPathForCell:cell].row];
        eventItem.score = [NSNumber numberWithInt:eventItem.score.intValue - 1];
        mutableEventsArray[[self.tableView indexPathForCell:cell].row] = eventItem;

        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self animateNOTLikeWithCell:cell];
            [self.likeView startRemovalTimer];
            [self performSelector:@selector(hideTheLikeView) withObject:self afterDelay:1];
            cell.scoreLabel.text = [NSString stringWithFormat:@"BZ: %@", eventItem.score];
            [cell setNeedsDisplay];

        });

        
        
    }];
}

-(void)animateLikeWithCell:(EventsTableViewCell*)cell
{
    counter++;
    self.likeView = [[LikeView alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
    self.likeView.tag = counter;
    self.likeView.center = CGPointMake(cell.center.x, cell.center.y);
    self.likeView.translatesAutoresizingMaskIntoConstraints = YES;
    [self.view addSubview:self.likeView];
    
    
    // Animate the position from the starting Y position of 600 back up to 0
    // which puts it back at the original position
    JNWSpringAnimation *translate = [JNWSpringAnimation
                                     animationWithKeyPath:@"transform.translation.y"];
    translate.damping = 15;
    translate.stiffness = 15;
    translate.mass = 1;
    translate.fromValue = @(600);
    translate.toValue = @(0);
    
    [self.likeView.layer addAnimation:translate forKey:translate.keyPath];
    self.likeView.transform = CGAffineTransformTranslate(self.likeView.transform, 0, 0);
    
    JNWSpringAnimation *scale = [JNWSpringAnimation
                                 animationWithKeyPath:@"transform.scale"];
    scale.damping = 32;
    scale.stiffness = 450;
    scale.mass = 2.4;
    scale.fromValue = @(0);
    scale.toValue = @(1.0);
    
    [self.likeView.layer addAnimation:scale forKey:scale.keyPath];
    self.likeView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);

}

-(void)animateNOTLikeWithCell:(EventsTableViewCell*)cell
{
    counter++;
    self.likeView = [[LikeView alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
    self.likeView.tag = counter;
    self.likeView.center = CGPointMake(cell.center.x, cell.center.y);
    self.likeView.translatesAutoresizingMaskIntoConstraints = YES;
    [self.view addSubview:self.likeView];
    
    
    // Animate the position from the starting Y position of 600 back up to 0
    // which puts it back at the original position
    JNWSpringAnimation *translate = [JNWSpringAnimation
                                     animationWithKeyPath:@"transform.translation.y"];
    translate.damping = 15;
    translate.stiffness = 15;
    translate.mass = 1;
    translate.fromValue = @(-100);
    translate.toValue = @(0);
    
    [self.likeView.layer addAnimation:translate forKey:translate.keyPath];
    self.likeView.transform = CGAffineTransformTranslate(self.likeView.transform, 0, 0);
    
    JNWSpringAnimation *scale = [JNWSpringAnimation
                                 animationWithKeyPath:@"transform.scale"];
    scale.damping = 32;
    scale.stiffness = 450;
    scale.mass = 2.4;
    scale.fromValue = @(0);
    scale.toValue = @(1.0);
    
    [self.likeView.layer addAnimation:scale forKey:scale.keyPath];
    self.likeView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
    
    JNWSpringAnimation *rotate = [JNWSpringAnimation
                                  animationWithKeyPath:@"transform.rotation"];
    rotate.damping = 9;
    rotate.stiffness = 9;
    rotate.mass = 1;
    rotate.fromValue = @(0);
    rotate.toValue = @(M_PI);
    
    [self.likeView.layer addAnimation:rotate forKey:rotate.keyPath];
    self.likeView.transform = CGAffineTransformRotate(self.likeView.transform, M_PI);
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    eventItemToPass = mutableEventsArray[indexPath.row];
    [self performSegueWithIdentifier:@"pushToEventDetailView" sender:self];

}

#pragma mark - SWTableViewCell Button Methods

- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
                                                title:@"More"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"Delete"];
    
    return rightUtilityButtons;
}

- (NSArray *)leftButtons
{
    NSMutableArray *leftUtilityButtons = [NSMutableArray new];
    
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor E4VGreen] icon:[UIImage imageNamed:@"thumb_up-50.png"]];
    
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor E4VLightOrange] icon:[UIImage imageNamed:@"upload-50.png"]];
    return leftUtilityButtons;
}

#pragma mark - SWTableViewDelegate

- (void)swipeableTableViewCell:(SWTableViewCell *)cell scrollingToState:(SWCellState)state
{
    switch (state) {
        case 0:
            NSLog(@"utility buttons closed");
            break;
        case 1:
            NSLog(@"left utility buttons open");
            break;
        case 2:
            NSLog(@"right utility buttons open");
            break;
        default:
            break;
    }
}

- (void)swipeableTableViewCell:(EventsTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index
{
    switch (index) {
        case 0:
        {

            NSLog(@"Like was pressed!");
       
            
            EventItem* eventItem = mutableEventsArray[[self.tableView indexPathForCell:cell].row];
            [self updateScoreEventOnServerWith:eventItem.identifier andScoreType:@1 andCell:cell];

            
            [cell hideUtilityButtonsAnimated:YES];
            break;
        }
        case 1:
        {
            EventItem* eventItem = mutableEventsArray[[self.tableView indexPathForCell:cell].row];
            [self shareButtonWasTappedForEvent:eventItem];
            NSLog(@"left button 1 was pressed");
            [cell hideUtilityButtonsAnimated:YES];

            break;
        }
        default:
        {
            break;
        }
    }
}

-(void)hideTheLikeView
{
    JNWSpringAnimation *scale =
    [JNWSpringAnimation animationWithKeyPath:@"transform.scale"];
    scale.damping = 40;
    scale.stiffness = 540;
    scale.mass = 1;
    
    scale.fromValue = @(1.0);
    scale.toValue = @(0);
    
    [self.likeView.layer addAnimation:scale forKey:scale.keyPath];
    self.likeView.transform = CGAffineTransformMakeScale(0.01, 0.01);
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    switch (index) {
        case 0:
        {
            [self.tableView.delegate tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
            [cell hideUtilityButtonsAnimated:YES];
            break;
        }
        case 1:
        {
            // Delete button was pressed
            NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
            
            [mutableEventsArray removeObjectAtIndex:cellIndexPath.row];
            [self.tableView deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
            break;
        }
        default:
            break;
    }
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell
{
    // allow just one cell's utility button to be open at once
    return YES;
}

- (BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state
{
    switch (state) {
        case 1:
            // set to NO to disable all left utility buttons appearing
            return YES;
            break;
        case 2:
            // set to NO to disable all right utility buttons appearing
            return YES;
            break;
        default:
            break;
    }
    
    return YES;
}

- (void)shareButtonWasTappedForEvent:(EventItem*)eventItem{
    
    NSString *shareText;
    
        shareText = @"Check out this event I found via Events4Vets davidwnorman.com/events4vets";
    
    NSURL *shareURL = eventItem.link;
    UIImage *shareImage = [UIImage imageNamed:@"E4VLogoOnly.png"];
    
    NSArray *items   = [NSArray arrayWithObjects:
                        shareText,
                        shareImage,
                        shareURL, nil];
    
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
    [activityViewController setValue:shareText forKey:@"subject"];
    
//    activityViewController.excludedActivityTypes =   @[UIActivityTypeCopyToPasteboard,
//                                                       UIActivityTypePostToWeibo,
//                                                       UIActivityTypeSaveToCameraRoll,
//                                                       UIActivityTypeCopyToPasteboard,
//                                                       UIActivityTypeMessage,
//                                                       UIActivityTypeAssignToContact,
//                                                       UIActivityTypePrint];
    
    [self presentViewController:activityViewController animated:YES completion:nil];
}




/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    EventDetailWebViewController *eventWebVC = [segue destinationViewController];
    eventWebVC.url = eventItemToPass.link;
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}




@end
