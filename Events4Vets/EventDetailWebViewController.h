//
//  EventDetailWebViewController.h
//  Events4Vets
//
//  Created by davinorm on 5/25/14.
//  Copyright (c) 2014 David Norman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventDetailWebViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, strong) NSURL *url;
@property (weak, nonatomic) IBOutlet UIWebView *wv;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityInd;


@end
