//
//  EventsTableViewCell.m
//  Events4Vets
//
//  Created by davinorm on 5/25/14.
//  Copyright (c) 2014 David Norman. All rights reserved.
//

#import "EventsTableViewCell.h"

@implementation EventsTableViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setItem:(EventItem*)item {
    if (_item) {
        [_item removeObserver:self forKeyPath:@"lastSeenBeacon"];
    }
    
    _item = item;
    [_item addObserver:self forKeyPath:@"lastSeenBeacon" options:NSKeyValueObservingOptionNew context:NULL];
    
    NSString *titleStr = self.item.title;
    NSString *dateStr = [NSString stringWithFormat:@"Event Begins: %@", _item.dateString];
    
    _titleLabel.text = titleStr;
    _dateLabel.text = dateStr;
    _scoreLabel.text = [NSString stringWithFormat:@"BZ:%@", _item.score];

    dispatch_async(dispatch_get_main_queue(), ^{
        [self setNeedsDisplay];
    });
}

- (void)dealloc {
    [_item removeObserver:self forKeyPath:@"lastSeenBeacon"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([object isEqual:self.item] && [keyPath isEqualToString:@"lastSeenBeacon"])
    {
        self.scoreLabel.text = [NSString stringWithFormat:@"BZ: %@", _item.score];
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
