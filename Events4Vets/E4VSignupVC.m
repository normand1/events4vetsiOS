//
//  E4VSignupVC.m
//  Events4Vets
//
//  Created by davinorm on 10/26/14.
//  Copyright (c) 2014 David Norman. All rights reserved.
//

#import "E4VSignupVC.h"
#import <QuartzCore/QuartzCore.h>
#import "Predefined.h"
#import "UIColor+E4VColors.h"


@interface E4VSignupVC ()

@end

@implementation E4VSignupVC

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor E4VBlack];
    self.fieldsBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"signupField.png"]];
    [self.signUpView insertSubview:self.fieldsBackground atIndex:1];
    self.signUpView.logo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"smallLogo.png"]];
    
    // Set field text color
    [self.signUpView.usernameField setTextColor:[UIColor E4VGreen]];
    self.signUpView.usernameField.placeholder = @"Username";
    [self.signUpView.passwordField setTextColor:[UIColor E4VGreen]];
    self.signUpView.passwordField.placeholder = @"Password";
    [self.signUpView.emailField setTextColor:[UIColor E4VGreen]];
    self.signUpView.emailField.placeholder = @"Email";
    
    // fix text shadow
    CALayer *layer = self.signUpView.usernameField.layer;
    layer.shadowOpacity = 1.0;
    layer.shadowRadius = 0.0;
    layer.shadowColor = [UIColor whiteColor].CGColor;
    layer.shadowOffset = CGSizeMake(0.0, -1.0);
    layer = self.signUpView.passwordField.layer;
    layer.shadowOpacity = 1.0;
    layer.shadowRadius = 0.0;
    layer.shadowColor = [UIColor whiteColor].CGColor;
    layer.shadowOffset = CGSizeMake(0.0, -1.0);
    layer = self.signUpView.emailField.layer;
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
    if (IS_IPHONE)
    {
        float x = 35.0f;
        float y = 200.0f;
        float width = 250.0f;
        float height = 150.0f;
        
        [self.signUpView.usernameField setFrame:CGRectMake(x, y, width, 50.0f)];
        [self.signUpView.passwordField setFrame:CGRectMake(x, y + 50, width, 50.0f)];
        [self.signUpView.emailField setFrame:CGRectMake(x, y + 100, width, 50.0f)];
        [self.fieldsBackground setFrame:CGRectMake(x, y, width, height)];
    }
    else
    {
        float x = 260.0f;
        float y = 430.0f;
        float width = 250.0f;
        float height = 150.0f;
        
        [self.signUpView.usernameField setFrame:CGRectMake(x, y, width, 50.0f)];
        [self.signUpView.passwordField setFrame:CGRectMake(x, y + 50, width, 50.0f)];
        [self.signUpView.emailField setFrame:CGRectMake(x, y + 100, width, 50.0f)];
        [self.fieldsBackground setFrame:CGRectMake(x, y, width, height)];
    }
}

@end
