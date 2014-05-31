//
//  MatchSingleton.h
//  SPAJAM
//
//  Created by Corey Lee on 5/31/14.
//  Copyright (c) 2014 Corey Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MatchSingleton : NSObject {
    
    NSArray *teamOne;
    NSArray *teamTwo;
    
}

@property (nonatomic, strong, readonly) NSArray *teamOne;
@property (nonatomic, strong, readonly) NSArray *teamTwo;

+ (id)sharedManager;

@end
