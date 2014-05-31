//
//  MatchSingleton.m
//  SPAJAM
//
//  Created by Corey Lee on 5/31/14.
//  Copyright (c) 2014 Corey Lee. All rights reserved.
//

#import "MatchSingleton.h"
#import <Parse/Parse.h>

@implementation MatchSingleton
@synthesize teamOne, teamTwo, teamOneNames, teamTwoNames;

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
    
}

- (void)setTeamTwoWithArray:(NSArray *)team andNames:(NSArray *)names
{
    
    teamTwo = team;
    
}


# pragma mark - Create Match

- (void)createMatch
{
    
    PFObject * newMatch = [PFObject objectWithClassName:@"Match"];
    
    // save array of users
    NSNumber *status = @0;
    newMatch[@"status"] = status;
    newMatch[@"teamOne"] = teamOne;
    newMatch[@"teamTwo"] = teamTwo;
    
    
    // save the match
    [newMatch saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        
        // save and ask for confirmation through push
        
    }];

    
}


@end
