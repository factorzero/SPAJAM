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
@synthesize teamOne, teamTwo;

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
        
    }
    return self;
}

# pragma mark - Location

- (void)setLocation:(NSString *)name withCoordinate:(CGPoint)coordinate
{
    
}


# pragma mark - Teams

- (void)setTeamOneWithArray:(NSArray *)team
{
 
    teamOne = team;
    
}

- (void)setTeamTwoWithArray:(NSArray *)team
{
    
    teamTwo = team;
    
}


# pragma mark - Create Match

- (void)createMatch
{
    
    PFObject * newMatch = [PFObject objectWithClassName:@"Match"];
    
    // save array of users
    newMatch[@"status"] = MatchStatusUnconfirmed;
    newMatch[@"teamOne"] = teamOne;
    newMatch[@"teamTwo"] = teamTwo;
    
    
    // save the match
    [newMatch saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        
        // save and ask for confirmation through push
        
    }];

    
}


@end
