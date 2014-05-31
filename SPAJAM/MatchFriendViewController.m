//
//  MatchFriendViewController.m
//  SPAJAM
//
//  Created by Corey Lee on 5/31/14.
//  Copyright (c) 2014 Corey Lee. All rights reserved.
//

#import "MatchFriendViewController.h"
#import <Parse/Parse.h>
#import "MatchSingleton.h"
#import "MatchRegisterViewController.h"

@interface MatchFriendViewController ()

@property (nonatomic, strong) NSMutableArray *friendArray;
@property (nonatomic, strong) NSMutableArray *friendIDArray;
@end

@implementation MatchFriendViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.friendArray = [[NSMutableArray alloc] init];
    self.friendIDArray = [[NSMutableArray alloc] init];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self getFriendsForUser];

}

- (void)viewDidAppear:(BOOL)animated
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [self.friendArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        [cell.imageView setImage:[UIImage imageNamed:@"キャラ_ネイマール風.png"]];
    }
    
    [cell.textLabel setText:[self.friendArray objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // get ids for Facebook users
    PFQuery *userQuery = [PFUser query];
    NSLog(@"friend %@", [self.friendIDArray objectAtIndex:indexPath.row]);
    NSString * selected = [self.friendIDArray objectAtIndex:indexPath.row];
    [userQuery whereKey:@"facebookID" equalTo:selected];
    [userQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %d scores.", objects.count);
            // Do something with the found objects
            for (PFObject *object in objects) {
                NSLog(@"%@", object.objectId);
            }
            
            // set self and opponents for match
            MatchSingleton *sharedManager = [MatchSingleton sharedManager];
             NSArray *teamOne = [NSArray arrayWithObjects:[PFUser currentUser], nil];
             NSArray *teamTwo = objects;
             
             [sharedManager setTeamOneWithArray:teamOne];
             [sharedManager setTeamTwoWithArray:teamTwo];
             
             MatchRegisterViewController * matchRegister = [[MatchRegisterViewController alloc] init];
             [self.navigationController pushViewController:matchRegister animated:YES];
            
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        
    }];
    
    
    
}

# pragma mark - Facebook Data

- (void)getFriendsForUser
{
    // get friends
    [FBRequestConnection startForMyFriendsWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        
        if (!error) {
            
            NSDictionary * resultDict = [result objectForKey:@"data"];
            NSLog(@"user friends: %@", result);
            for (id object in resultDict) {
                NSLog(@"%@", object);
                NSLog(@"name %@", [object objectForKey:@"first_name"]);
                NSLog(@"id %@", [object objectForKey:@"id"]);
                
                [self.friendArray addObject:[object objectForKey:@"last_name"]];
                [self.friendIDArray addObject:[object objectForKey:@"id"]];
            }
            // reload table
            [self.tableView reloadData];
            
        } else {
            NSLog(@"Friend Error:%@", error);
        }
        
            
    }];
    
    
    
    
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

@end
