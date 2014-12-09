//
//  WalkThroughViewController.m
//  Events4Vets
//
//  Created by davinorm on 5/20/14.
//  Copyright (c) 2014 David Norman. All rights reserved.
//

#import "WalkThroughViewController.h"
#import "GHWalkThroughView.h"
#import "E4VLoginVC.h"
#import "E4VSignupVC.h"
#import "Predefined.h"


static NSString * const sampleDesc1 = @"Events4Vets is a list of curated events for people who have proudly served in the US Military.";

static NSString * const sampleDesc2 = @"There are amazing events that benefit members of the armed forces all across the United States.";

static NSString * const sampleDesc3 = @"When you find event you like on Events4Vets you can give it a BRAVO ZULU so that other members can find this event easier.";

static NSString * const sampleDesc4 = @"Share events you're going to attend or events you think would be useful to others on Facebook and Twitter.";

static NSString * const sampleDesc5 = @"Check back for more events and more updates often! We're working to bring you the best events and the best App for Veterans!";

@interface WalkThroughViewController () <GHWalkThroughViewDataSource, GHWalkThroughViewDelegate, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

@property (nonatomic, strong) GHWalkThroughView* ghView ;

@property (nonatomic, strong) NSArray* descStrings;

@property (nonatomic, strong) UILabel* welcomeLabel;

@end

@implementation WalkThroughViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.barStyle=UIBarStyleBlackTranslucent;

    self.ghView.isfixedBackground = NO;
    
    self.navigationController.navigationBarHidden = YES;
    
    NSLog(@"%@", self.view);
    
    if (![[NSUserDefaults standardUserDefaults]boolForKey:kFinishedTutorial])
    {

        _ghView = [[GHWalkThroughView alloc] initWithFrame:self.view.bounds];
        [_ghView setDataSource:self];
        [_ghView setDelegate:self];
        [_ghView setWalkThroughDirection:GHWalkThroughViewDirectionVertical];
        UILabel* welcomeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 50)];
        welcomeLabel.text = @"Events4Vets";
        welcomeLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:40];
        welcomeLabel.textColor = [UIColor whiteColor];
        welcomeLabel.textAlignment = NSTextAlignmentCenter;
        self.welcomeLabel = welcomeLabel;
        self.descStrings = [NSArray arrayWithObjects:sampleDesc1,sampleDesc2, sampleDesc3, sampleDesc4, sampleDesc5, nil];
        
        [_ghView setFloatingHeaderView:self.welcomeLabel];
        [self.ghView setWalkThroughDirection:GHWalkThroughViewDirectionHorizontal];

        [self.ghView showInView:self.view animateDuration:0.3];
    }

}

-(void)viewDidAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
}

-(void)walkthroughDidDismissView:(GHWalkThroughView *)walkthroughView
{
    [[NSUserDefaults standardUserDefaults] setBool:true forKey:kFinishedTutorial];
    
    if ([PFUser currentUser])
    {
        [self performSegueWithIdentifier:@"pushMain" sender:self];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - GHWalkThrough Datasource Delegate Methods


-(NSInteger) numberOfPages
{
    return 5;
}

- (void) configurePage:(GHWalkThroughPageCell *)cell atIndex:(NSInteger)index
{
    
    switch (index) {
        case 0:
        cell.title = @"Gouge";
            break;
        case 1:
            cell.title = @"Recco Events";
            break;
        case 2:
            cell.title = @"Bravo Zulu";
            break;
        case 3:
            cell.title = @"Communicate";
            break;
        case 4:
            cell.title = @"We're Underway!";
            break;
        default:
            break;
    }
    
    cell.titleImage = [UIImage imageNamed:[NSString stringWithFormat:@"title%ld", index+1]];
    cell.desc = [self.descStrings objectAtIndex:index];
}

- (UIImage*) bgImageforPage:(NSInteger)index
{
    NSString* imageName =[NSString stringWithFormat:@"tutImage%ld.jpg", index+1];
    UIImage* image = [UIImage imageNamed:imageName];
    return image;
}

- (IBAction)pushedLoginButton:(id)sender
{

    if (![PFUser currentUser])
    { // No user logged in
        // Create the log in view controller
        E4VLoginVC *logInViewController = [[E4VLoginVC alloc] init];
//        logInViewController.view.backgroundColor = [UIColor blackColor];
        [logInViewController setDelegate:self]; // Set ourselves as the delegate
        
        // Create the sign up view controller
        E4VSignupVC *signUpViewController = [[E4VSignupVC alloc] init];
        [signUpViewController setDelegate:self]; // Set ourselves as the delegate
        
        // Assign our sign up controller to be displayed from the login controller
        [logInViewController setSignUpController:signUpViewController];
        
        // Present the log in view controller
        [self presentViewController:logInViewController animated:YES completion:NULL];
    }
    else
    {
        [self performSegueWithIdentifier:@"pushMain" sender:self];
    }
    
}



#pragma mark - PFLogInViewControllerDelegate

// Sent to the delegate to determine whether the log in request should be submitted to the server.
- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
    // Check if both fields are completed
    if (username && password && username.length && password.length) {
        return YES; // Begin login process
    }
    
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Missing Information", nil) message:NSLocalizedString(@"Make sure you fill out all of the information!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
    return NO; // Interrupt login process
}

// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:NULL];
    [self performSegueWithIdentifier:@"pushMain" sender:self];
}

// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    NSLog(@"Failed to log in...");
}

// Sent to the delegate when the log in screen is dismissed.
- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    NSLog(@"User dismissed the logInViewController");
}


#pragma mark - PFSignUpViewControllerDelegate

// Sent to the delegate to determine whether the sign up request should be submitted to the server.
- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info {
    BOOL informationComplete = YES;
    
    // loop through all of the submitted data
    for (id key in info) {
        NSString *field = [info objectForKey:key];
        if (!field || !field.length) { // check completion
            informationComplete = NO;
            break;
        }
    }
    
    // Display an alert if a field wasn't completed
    if (!informationComplete) {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Missing Information", nil) message:NSLocalizedString(@"Make sure you fill out all of the information!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
    }
    
    return informationComplete;
}

// Sent to the delegate when a PFUser is signed up.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

// Sent to the delegate when the sign up attempt fails.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error {
    NSLog(@"Failed to sign up...");
}

// Sent to the delegate when the sign up screen is dismissed.
- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
    NSLog(@"User dismissed the signUpViewController");
}


@end
