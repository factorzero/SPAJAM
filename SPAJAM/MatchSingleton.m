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

# pragma mark - Create Match

- (void)createMatch
{
    
    PFObject * newMatch = [PFObject objectWithClassName:@"Match"];
    
    // save array of users
    
    newMatch[@"status"] = MatchStatusUnconfirmed;
    
    // save the match
    [newMatch saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        
    }];

    
}


@end
