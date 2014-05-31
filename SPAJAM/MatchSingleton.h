//
//  MatchSingleton.h
//  SPAJAM
//
//  Created by Corey Lee on 5/31/14.
//  Copyright (c) 2014 Corey Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface MatchSingleton : NSObject {
    
    NSArray *teamOne;
    NSArray *teamOneNames;
    NSArray *teamTwo;
    NSArray *teamTwoNames;
    PFObject *matchForConfirmation;
}

@property (nonatomic, strong, readonly) NSArray *teamOne;
@property (nonatomic, strong, readonly) NSArray *teamOneNames;
@property (nonatomic, strong, readonly) NSArray *teamTwo;
@property (nonatomic, strong, readonly) NSArray *teamTwoNames;
@property (nonatomic, strong) PFObject *matchForConfirmation;

+ (id)sharedManager;
- (void)createMatch;
- (void)setTeamOneWithArray:(NSArray *)team andNames:(NSArray *)names;
- (void)setTeamTwoWithArray:(NSArray *)team andNames:(NSArray *)names;
- (void)readyForAction;
- (void)confirmMatch;

@end
