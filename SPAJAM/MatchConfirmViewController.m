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
#import "UIImage+fill.h"
#import "UIImageView+effects.h"
#import "UIView+shake.h"

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
    points1 = 0;
    points2 = 0;
    [self loadMatchData];
    [self.winButton setHidden:YES];
    [self.loseButton setHidden:YES];
    [self.confirmButton setHidden:NO];
    [self.teamOnePoint setText:[NSString stringWithFormat:@"%d", points1]];
    [self.teamTwoPoint setText:[NSString stringWithFormat:@"%d", points2]];
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
                    
                    MatchSingleton *sharedManager = [MatchSingleton sharedManager];
                    sharedManager.matchForConfirmation = object;
                    
                    NSArray * teamOneNames = object[@"teamOneNames"];
                    NSArray * teamTwoNames = object[@"teamTwoNames"];
                    // show names
                    [self.captainOneName setText:[teamOneNames objectAtIndex:0]];
                    [self.captainTwoName setText:[teamTwoNames objectAtIndex:0]];
                    
                    [SVProgressHUD showSuccessWithStatus:@"Start!"];
                    
                    NSNumber * status = object[@"status"];
                    
                    if ([status intValue] == 1) {
                        liveMode = YES;
                        self.matchObject = object;
                        // confirmed. go live
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
                liveMode = YES;
                self.matchObject = object;
                // confirmed. go live
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
    
    if (liveMode == YES) {
        NSLog(@"live mode started");
        self.matchTimer = [NSTimer scheduledTimerWithTimeInterval: 2.0
                                                           target: self
                                                         selector:@selector(checkMatchObject)
                                                         userInfo: nil repeats:YES];
    }
    
}


- (IBAction)winButton:(id)sender
{
    self.winButton.enabled = NO;
    [self.matchObject incrementKey:@"points1"];
    [self.matchObject saveInBackgroundWithBlock:^(BOOL success, NSError * error) {
        
        self.winButton.enabled = YES;
        
    }];
}

- (IBAction)loseButton:(id)sender
{
    self.loseButton.enabled = NO;
    [self.matchObject incrementKey:@"points2"];
    [self.matchObject saveInBackgroundWithBlock:^(BOOL success, NSError * error) {
        
        self.loseButton.enabled = YES;
        
    }];
}

- (void)checkMatchObject
{
    //[self.matchObject refresh];
    int one = [self.matchObject[@"points1"]intValue];
    int two = [self.matchObject[@"points2"] intValue];
    [self updatePoints1:one Points2:two];
    
    if (one >= 5 || two >= 5) {
        
        liveMode = NO;
        [self.matchTimer invalidate];
        self.matchTimer = nil;
        
        NSString * finalMessage = [NSString stringWithFormat:@"%@ = %d : %@ = %d", self.captainOneName.text, one, self.captainTwoName.text, two];
        UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"決勝"
                                                         message:finalMessage
                                                        delegate:self
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles: nil];
        //[alert addButtonWithTitle:@"GOO"];
        [alert show];
        
    }
}

- (void)updatePoints1:(int)one Points2:(int)two
{
    
    if (points1 < one) {
        // team one scored
        // animation
        
        // save
        points1 = one;
        
        [self.teamOnePoint setText:[NSString stringWithFormat:@"%d", points1]];
        [self.teamTwoPoint setText:[NSString stringWithFormat:@"%d", points2]];
        [self.captainTwoImage shakeWithCount:10 interval:0.03];
        [self.captainTwoImage whiteFadeInWithDuration:0.3
                                             delay:0.0
                                             block:^(void) {
                                                 
                                                // label animation
                                                 [UIView animateWithDuration:0.3f delay:0.1f options:UIViewAnimationOptionCurveEaseInOut animations:^(void)
                                                  {
                                                      [self.teamOnePoint setTransform:CGAffineTransformMakeScale(2.0, 2.0)];
                                                      
                                                  } completion:^(BOOL complete){
                                                      
                                                      [UIView animateWithDuration:0.1f delay:0.1f options:UIViewAnimationOptionCurveEaseInOut animations:^(void)
                                                       {
                                                           [self.teamOnePoint setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
                                                           
                                                       } completion:nil];
                                                      
                                                  }];
                                                 
                                             }];
        
    } else if (points2 < two)
    {
        // team two scored
        // save
        points2 = two;
        
        [self.teamOnePoint setText:[NSString stringWithFormat:@"%d", points1]];
        [self.teamTwoPoint setText:[NSString stringWithFormat:@"%d", points2]];
        [self.captainOneImage shakeWithCount:10 interval:0.03];
        [self.captainOneImage whiteFadeInWithDuration:0.3
                                                delay:0.0
                                                block:^(void) {
                                                    
                                                    // label animation
                                                    [UIView animateWithDuration:0.3f delay:0.1f options:UIViewAnimationOptionCurveEaseInOut animations:^(void)
                                                     {
                                                         [self.teamTwoPoint setTransform:CGAffineTransformMakeScale(2.0, 2.0)];
                                                         
                                                     } completion:^(BOOL complete){
                                                         
                                                         [UIView animateWithDuration:0.1f delay:0.1f options:UIViewAnimationOptionCurveEaseInOut animations:^(void)
                                                          {
                                                              [self.teamTwoPoint setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
                                                              
                                                          } completion:nil];
                                                         
                                                     }];
                                                    
                                                }];
    }
    
}

- (void) viewDidDisappear:(BOOL)animated
{
    liveMode = NO;
    [self.matchTimer invalidate];
    self.matchTimer = nil;
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
