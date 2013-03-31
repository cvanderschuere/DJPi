//
//  PlayersTableViewController.h
//  DJPi
//
//  Created by Chris Vanderschuere on 3/30/13.
//  Copyright (c) 2013 CDVConcepts. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayersTableViewController : UITableViewController

@property (nonatomic,strong) NSDictionary* selectedPlayer;
- (IBAction)cancelSelection:(id)sender;

@end
