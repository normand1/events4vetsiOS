//
//  LikeView.m
//  Events4Vets
//
//  Created by davinorm on 10/26/14.
//  Copyright (c) 2014 David Norman. All rights reserved.
//

#import "LikeView.h"

@implementation LikeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)startRemovalTimer
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSelector:@selector(removeTheLikeView) withObject:self afterDelay:1.5];
        
    });
    
}

-(void)removeTheLikeView
{
    dispatch_async(dispatch_get_main_queue(), ^{

    [self removeFromSuperview];
    });
}

-(void)drawRect:(CGRect)rect
{
    //// General Declarations
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Color Declarations
    UIColor* e4VGreen = [UIColor colorWithRed: 0.322 green: 0.808 blue: 0.329 alpha: 1];
    
    //// Image Declarations
    UIImage* thumbsUp = [UIImage imageNamed: @"thumb_up-50.png"];
    
    //// Oval Drawing
    UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(0, 0, 60, 60)];
    [e4VGreen setFill];
    [ovalPath fill];
    
    
    //// Oval 2 Drawing
    UIBezierPath* oval2Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(0, 0, 60, 60)];
    CGContextSaveGState(context);
    [oval2Path addClip];
    [thumbsUp drawInRect: CGRectMake(4, 4, thumbsUp.size.width, thumbsUp.size.height)];
    CGContextRestoreGState(context);
}

@end
