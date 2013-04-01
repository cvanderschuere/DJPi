//
//  PlaylistViewController.m
//  DJPi
//
//  Created by Chris Vanderschuere on 3/31/13.
//  Copyright (c) 2013 CDVConcepts. All rights reserved.
//

#import "PlaylistViewController.h"
#import "PlayersTableViewController.h"
#import "AppDelegate.h"

@interface PlaylistViewController ()

@end

@implementation PlaylistViewController

- (void) setCurrentPlayer:(NSDictionary *)currentPlayer{
    _currentPlayer = currentPlayer;
    
    //Update top bottom
    if (_currentPlayer)
        self.playerButton.title = [_currentPlayer objectForKey:@"title"];
    else
        self.playerButton.title = @"Select Player";
    
    //Refresh playlist
    [self.collectionView reloadData];
    
    //Save for later
    [[NSUserDefaults standardUserDefaults] setValue:[_currentPlayer objectForKey:@"title"] forKey:@"previousPlayer"];
    [[NSUserDefaults standardUserDefaults]synchronize];
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
    
    //Add refresh control
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor lightGrayColor];
    [refreshControl addTarget:self action:@selector(refreshPlaylist:) forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:refreshControl];
    self.collectionView.alwaysBounceVertical = YES;
    
    //Refresh UI for previously selected player
    NSString* previousPlayerTitle = [[NSUserDefaults standardUserDefaults] valueForKey:@"previousPlayer"];
    if (previousPlayerTitle) {
        //Populate new request
        NSString* urlString = [[@"http://localhost:9090/rest/player?title=" stringByAppendingString:previousPlayerTitle] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
        [request setValue:@"chris.vanderschuere@gmail.com" forHTTPHeaderField:@"username"];
        
        AFJSONRequestOperation* operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            //Use Response to reload data
            NSDictionary* playerDict = (NSDictionary*) JSON;
            NSArray* arrayOfPlayers = [playerDict objectForKey:@"players"];
            if (arrayOfPlayers.count>0) {
                self.currentPlayer = arrayOfPlayers[0]; //Setting current player will trigger all update necessary
            }
            
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            NSLog(@"Error:%@",error.localizedDescription);
        }];
        
        AppDelegate* delegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
        [delegate.requestQueue addOperation:operation];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) refreshPlaylist:(UIRefreshControl*)sender{
    //Refresh tracks for selected player
    
    [sender endRefreshing];
}
#pragma mark - UICollectionView Datasource methods
-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [[self.currentPlayer objectForKey:@"tracks"] count];
}
- (UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"trackCell" forIndexPath:indexPath];
    
    return cell;
}

#pragma mark - UIStoryboard Segue Methods
-(IBAction)unwindFromPlayerSelection:(UIStoryboardSegue*)sender{
    //Set current Player base upon selected player...could have been done with a delegate
    self.currentPlayer = [sender.sourceViewController selectedPlayer];
    
}
@end
