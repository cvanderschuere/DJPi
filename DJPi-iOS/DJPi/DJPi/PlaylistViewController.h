//
//  PlaylistViewController.h
//  DJPi
//
//  Created by Chris Vanderschuere on 3/31/13.
//  Copyright (c) 2013 CDVConcepts. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaylistViewController : UIViewController

@property (nonatomic,strong) NSDictionary *currentPlayer;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *playerButton;

-(IBAction)unwindFromPlayerSelection:(UIStoryboardSegue*)sender;

@end
