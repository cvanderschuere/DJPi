//
//  PlaylistViewController.m
//  DJPi
//
//  Created by Chris Vanderschuere on 3/31/13.
//  Copyright (c) 2013 CDVConcepts. All rights reserved.
//

#import "PlaylistViewController.h"
#import "PlayersTableViewController.h"

@interface PlaylistViewController ()

@end

@implementation PlaylistViewController

- (void) setCurrentPlayer:(NSDictionary *)currentPlayer{
    
    _currentPlayer = currentPlayer;
    self.playerButton.title = [_currentPlayer objectForKey:@"title"];
    
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)unwindFromPlayerSelection:(UIStoryboardSegue*)sender{
    NSLog(@"Unwind with player: %@",[sender.sourceViewController selectedPlayer]);
    self.currentPlayer = [sender.sourceViewController selectedPlayer];
    
}
@end
