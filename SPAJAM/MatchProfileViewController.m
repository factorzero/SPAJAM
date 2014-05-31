//
//  MatchProfileViewController.m
//  SPAJAM
//
//  Created by Corey Lee on 5/31/14.
//  Copyright (c) 2014 Corey Lee. All rights reserved.
//

#import "MatchProfileViewController.h"
#import <Parse/Parse.h>
#import "MatchFriendViewController.h"

@interface MatchProfileViewController ()

@end

@implementation MatchProfileViewController

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
    // Do any additional setup after loading the view from its nib.
    //[self.navigationController setNavigationBarHidden:YES];
    
    
    //[self getSportsForUser];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self loginUser];
}

# pragma mark - Facebook
- (void)loginUser
{
    // show the signup or login screen | ログイン画面を表示
    NSArray * permissions = [NSArray arrayWithObjects:@"public_profile",@"user_friends",@"email",@"user_likes",@"read_friendlists", nil];
    [PFFacebookUtils logInWithPermissions:permissions block:^(PFUser *user, NSError *error) {
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
        } else if (user.isNew) {
            NSLog(@"User signed up and logged in through Facebook!");
        } else {
            NSLog(@"User logged in through Facebook!");
            
            
        }
    }];
    
}

- (void)getSportsForUser
{
    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // Success! Include your code to handle the results here
            //NSLog(@"user info: %@", result);
            
            // Parse results
            NSError * error;
            NSDictionary *jsonDict = result;
            
            NSLog(@"Item: %@", jsonDict);
            
            if (error) {
                NSLog(@"Error parsing JSON: %@", error);
            } else {
                
                NSString *sports = [jsonDict objectForKey:@"sports"];
                NSLog(@"Sports: %@", sports);
                
            }
            
            
        } else {
            // An error occurred, we need to handle the error
            // See: https://developers.facebook.com/docs/ios/errors
        }
    }];
}

# pragma mark - Create Match

- (IBAction)searchForMatch:(id)sender
{
    MatchFriendViewController * friendSearchView = [[MatchFriendViewController alloc] init];
    [self.navigationController pushViewController:friendSearchView animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
