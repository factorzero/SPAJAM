//
//  MatchRegisterViewController.m
//  SPAJAM
//
//  Created by Corey Lee on 6/1/14.
//  Copyright (c) 2014 Corey Lee. All rights reserved.
//

#import "MatchRegisterViewController.h"
#import "MatchSingleton.h"
#import <Parse/Parse.h>

@interface MatchRegisterViewController ()

@end

@implementation MatchRegisterViewController

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
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateUI)
                                                 name:@"data ready"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(popToRootController)
                                                 name:@"match created"
                                               object:nil];
    
}

- (void)updateUI
{
    MatchSingleton *sharedManager = [MatchSingleton sharedManager];
    // show names
    [self.captainOneName setText:[sharedManager.teamOneNames objectAtIndex:0]];
    [self.captainTwoName setText:[sharedManager.teamTwoNames objectAtIndex:0]];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - Confirm

- (IBAction)confirmMatch:(id)sender
{

    MatchSingleton *sharedManager = [MatchSingleton sharedManager];
    // save match
    [sharedManager createMatch];

    
}

- (void)popToRootController
{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
