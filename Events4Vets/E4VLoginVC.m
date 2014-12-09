//
//  E4VLoginVC.m
//  Events4Vets
//
//  Created by davinorm on 10/26/14.
//  Copyright (c) 2014 David Norman. All rights reserved.
//

#import "E4VLoginVC.h"
#import <QuartzCore/QuartzCore.h>
#import "Predefined.h"
#import "UIColor+E4VColors.h"

@interface E4VLoginVC ()

@end

@implementation E4VLoginVC

//-(void)viewDidAppear:(BOOL)animated
//{
//    self.view.backgroundColor = [UIColor whiteColor];
//    self.fieldsBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_01.jpg"]];
//    [self.logInView insertSubview:self.fieldsBackground atIndex:1];
//    
//
//}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor E4VBlack];
    self.fieldsBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"passwordField.png"]];
    [self.logInView insertSubview:self.fieldsBackground atIndex:1];
    self.logInView.logo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"smallLogo.png"]];
    
    [self.logInView.usernameField setTextColor:[UIColor E4VGreen]];
    
    UIColor *color = [UIColor whiteColor];
    self.logInView.usernameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"PlaceHolder Text" attributes:@{NSForegroundColorAttributeName: color}];
    
    [self.logInView.usernameField setPlaceholder:@"Username"];
    [self.logInView.passwordField setTextColor:[UIColor E4VGreen]];
    self.logInView.passwordField.placeholder = @"Password";
    
    // fix text shadow
    CALayer *layer = self.logInView.usernameField.layer;
    layer.shadowOpacity = 1.0;
    layer.shadowRadius = 0.0;
    layer.shadowColor = [UIColor whiteColor].CGColor;
    layer.shadowOffset = CGSizeMake(0.0, -1.0);
    layer = self.logInView.passwordField.layer;
    layer.shadowOpacity = 1.0;
    layer.shadowRadius = 0.0;
    layer.shadowColor = [UIColor whiteColor].CGColor;
    layer.shadowOffset = CGSizeMake(0.0, -1.0);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    // Set frame for elements
//    [self.logInView.dismissButton setFrame:CGRectMake(10.0f, 10.0f, 87.5f, 45.5f)];
//    [self.logInView.logo setFrame:CGRectMake(66.5f, 70.0f, 187.0f, 58.5f)];
//    [self.logInView.facebookButton setFrame:CGRectMake(35.0f, 287.0f, 120.0f, 40.0f)];
//    [self.logInView.twitterButton setFrame:CGRectMake(35.0f+130.0f, 287.0f, 120.0f, 40.0f)];
//    [self.logInView.signUpButton setFrame:CGRectMake(35.0f, 385.0f, 250.0f, 40.0f)];
    if (IS_IPHONE)
    {
        float x = 35.0f;
        float y = 200.0f;
        float width = 250.0f;
        float height = 100.0f;
        
        [self.logInView.usernameField setFrame:CGRectMake(x, y, width, 50.0f)];
        [self.logInView.passwordField setFrame:CGRectMake(x, y + 50, width, 50.0f)];
        [self.fieldsBackground setFrame:CGRectMake(x, y, width, height)];
    }
    else
    {
        float x = 260.0f;
        float y = 410.0f;
        float width = 250.0f;
        float height = 100.0f;
        
        [self.logInView.usernameField setFrame:CGRectMake(x, y, width, 50.0f)];
        [self.logInView.passwordField setFrame:CGRectMake(x, y + 50, width, 50.0f)];
        [self.fieldsBackground setFrame:CGRectMake(x, y, width, height)];
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
