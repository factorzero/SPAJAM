//
//  MatchConfirmViewController.h
//  SPAJAM
//
//  Created by Corey Lee on 6/1/14.
//  Copyright (c) 2014 Corey Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface MatchConfirmViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIImageView *captainOneImage;
@property (nonatomic, weak) IBOutlet UIImageView *captainTwoImage;
@property (nonatomic, weak) IBOutlet UILabel *captainOneName;
@property (nonatomic, weak) IBOutlet UILabel *teamOnePoint;
@property (nonatomic, weak) IBOutlet UILabel *captainTwoName;
@property (nonatomic, weak) IBOutlet UILabel *teamTwoPoint;
@property (nonatomic, weak) IBOutlet UIButton *winButton;
@property (nonatomic, weak) IBOutlet UIButton *loseButton;
@property (nonatomic, weak) IBOutlet UIButton *confirmButton;
@property (nonatomic, strong) PFObject *matchObject;
@end
