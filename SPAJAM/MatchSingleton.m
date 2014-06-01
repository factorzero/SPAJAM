//
//  MatchSingleton.m
//  SPAJAM
//
//  Created by Corey Lee on 5/31/14.
//  Copyright (c) 2014 Corey Lee. All rights reserved.
//

#import "MatchSingleton.h"
#import <Parse/Parse.h>
#import "SVProgressHUD.h"

@implementation MatchSingleton
@synthesize teamOne, teamTwo, teamOneNames, teamTwoNames, matchForConfirmation;

typedef NS_ENUM(int, MatchStatus) {
    
    MatchStatusUnconfirmed,
    MatchStatusConfirmed,
    MatchStatusFinished
    
};

#pragma mark Singleton Methods

+ (id)sharedManager {
    static MatchSingleton *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        
        teamOne = [[NSArray alloc] init];
        teamTwo = [[NSArray alloc] init];
        teamOneNames = [[NSArray alloc] init];
        teamTwoNames = [[NSArray alloc] init];
        matchForConfirmation = [PFObject alloc];
        
    }
    return self;
}

# pragma mark - Location

- (void)setLocation:(NSString *)name withCoordinate:(CGPoint)coordinate
{
    
}


# pragma mark - Teams

- (void)setTeamOneWithArray:(NSArray *)team andNames:(NSArray *)names
{
 
    teamOne = team;
    teamOneNames = names;
    
}

- (void)setTeamTwoWithArray:(NSArray *)team andNames:(NSArray *)names
{
    
    teamTwo = team;
    teamTwoNames = names;
    
}

- (void)readyForAction
{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"data ready"
     object:self];
}


# pragma mark - Create Match

- (void)createMatch
{
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    PFObject * newMatch = [PFObject objectWithClassName:@"Match"];
    
    // save array of users
    NSNumber *status = @0;
    newMatch[@"status"] = status;
    newMatch[@"teamOne"] = teamOne;
    newMatch[@"teamOneNames"] = teamOneNames;
    newMatch[@"teamTwo"] = teamTwo;
    newMatch[@"teamTwoNames"] = teamTwoNames;
    NSNumber *points1 = @0;
    newMatch[@"points1"] = points1;
    NSNumber *points2 = @0;
    newMatch[@"points2"] = points2;
    
    // save the match
    [newMatch saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        
        // pop to root
        [SVProgressHUD showSuccessWithStatus:@""];
        
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"match created"
         object:self];
    }];

    
}

- (void)confirmMatch
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    NSNumber *status = @1; // confirmed
    matchForConfirmation[@"status"] = status;
    // save the match
    [matchForConfirmation saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        
        // save and ask for confirmation through push
        NSLog(@"confirmed the match!");
        [SVProgressHUD showSuccessWithStatus:@""];
    }];
}


@end
