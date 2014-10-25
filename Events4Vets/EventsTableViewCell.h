//
//  EventsTableViewCell.h
//  Events4Vets
//
//  Created by davinorm on 5/25/14.
//  Copyright (c) 2014 David Norman. All rights reserved.
//

#import "SWTableViewCell.h"

@interface EventsTableViewCell : SWTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;

@end