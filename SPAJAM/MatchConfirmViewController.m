//
//  MatchConfirmViewController.m
//  SPAJAM
//
//  Created by Corey Lee on 6/1/14.
//  Copyright (c) 2014 Corey Lee. All rights reserved.
//

#import "MatchConfirmViewController.h"
#import <Parse/Parse.h>
#import "MatchSingleton.h"
#import "SVProgressHUD.h"

@interface MatchConfirmViewController () {
    
    BOOL liveMode;
    int points1;
    int points2;
}

@end

@implementation MatchConfirmViewController

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
    liveMode = NO;
    [self loadMatchData];
    [self.winButton setHidden:YES];
    [self.loseButton setHidden:YES];
    [self.confirmButton setHidden:NO];
    [self.teamOnePoint setText:[NSString stringWithFormat:@"%d", points1]];
    [self.teamOnePoint setText:[NSString stringWithFormat:@"%d", points2]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - Parse

- (void)loadMatchData
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    // search for match
    PFQuery * query = [PFQuery queryWithClassName:@"Match"];
    [query whereKey:@"teamTwo" equalTo:[PFUser currentUser]];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        
        if (!object) {
            NSLog(@"The getFirstObject request failed.");
            
            // check for confirmed match
            PFQuery * query = [PFQuery queryWithClassName:@"Match"];
            [query whereKey:@"teamOne" equalTo:[PFUser currentUser]];
            
            [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                
                if (!object) {
                    NSLog(@"The getFirstObject request failed.");
                    [SVProgressHUD showErrorWithStatus:@"no match!"];
                } else {
                    // The find succeeded.
                    NSLog(@"Successfully retrieved the object.");
                    
                    
                    [SVProgressHUD showSuccessWithStatus:@"Start!"];
                    
                    NSNumber * status = object[@"status"];
                    
                    if ([status intValue] == 1) {
                        [self showResultButtons];
                    }
                }
                
                
            }];

            
        } else {
            // The find succeeded.
            NSLog(@"Successfully retrieved the object.");
            
            MatchSingleton *sharedManager = [MatchSingleton sharedManager];
            sharedManager.matchForConfirmation = object;
            
            NSArray * teamOneNames = object[@"teamOneNames"];
            NSArray * teamTwoNames = object[@"teamTwoNames"];
            // show names
            [self.captainOneName setText:[teamOneNames objectAtIndex:0]];
            [self.captainTwoName setText:[teamTwoNames objectAtIndex:0]];
         
            [SVProgressHUD showSuccessWithStatus:@""];
            
            NSNumber * status = object[@"status"];
            
            if ([status intValue] == 1) {
                [self showResultButtons];
            }
        }
        
        
    }];
    
}

- (IBAction)confirmMatch:(id)sender
{
    MatchSingleton *sharedManager = [MatchSingleton sharedManager];
    [sharedManager confirmMatch];
    
    
}

- (void)showResultButtons
{
    [self.winButton setHidden:NO];
    [self.loseButton setHidden:NO];
    [self.confirmButton setHidden:YES];
}


- (IBAction)winButton:(id)sender
{
    
}

- (IBAction)loseButton:(id)sender
{
    
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

@end
