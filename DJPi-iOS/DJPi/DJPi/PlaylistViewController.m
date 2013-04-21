//
//  PlaylistViewController.m
//  DJPi
//
//  Created by Chris Vanderschuere on 3/31/13.
//  Copyright (c) 2013 CDVConcepts. All rights reserved.
//

#import "PlaylistViewController.h"
#import "PlayersTableViewController.h"
#import "TrackSearchViewController.h"
#import "AppDelegate.h"
#import "TrackCell.h"

@interface PlaylistViewController ()

@end

@implementation PlaylistViewController

- (void) setCurrentPlayer:(PiPlayer *)currentPlayer{
    [_currentPlayer removeObserver:self forKeyPath:@"loaded"];
    
    _currentPlayer = currentPlayer;
    
    //Add observer
    [_currentPlayer addObserver:self forKeyPath:@"loaded" options:NSKeyValueObservingOptionInitial context:NULL];
    
    //Update top bottom
    if (_currentPlayer)
        self.playerButton.title = _currentPlayer.title;
    else
        self.playerButton.title = @"Select Player";
        
    //Save for later
    [[NSUserDefaults standardUserDefaults] setValue:_currentPlayer.title forKey:@"previousPlayer"];
    [[NSUserDefaults standardUserDefaults]synchronize];
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
        NSString* urlString = [[@"http://cdv-djpi.appspot.com/rest/player?title=" stringByAppendingString:previousPlayerTitle] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
        [request setValue:@"christopher.vanderschuere@gmail.com" forHTTPHeaderField:@"username"];
        [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
        
        AFJSONRequestOperation* operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            //Use Response to reload data
            NSArray* arrayOfPlayers = [JSON objectForKey:@"players"];
            if (arrayOfPlayers.count>0)
                self.currentPlayer = [PiPlayer playerWithDictionary:arrayOfPlayers[0]]; //Setting current player will trigger all update necessary
            else
                self.currentPlayer = nil;
            
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            NSLog(@"Error:%@ %@",error.localizedDescription,JSON);
        }];
        
        AppDelegate* delegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
        [delegate.requestQueue addOperation:operation];
    }
}
- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"loaded"]) {
        //Refresh playlist
        [self.collectionView reloadData];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) refreshPlaylist:(UIRefreshControl*)sender{
    //Refresh tracks for selected player
    
    NSString* previousPlayerTitle = [[NSUserDefaults standardUserDefaults] valueForKey:@"previousPlayer"];
    if (previousPlayerTitle) {
        //Populate new request
        NSString* urlString = [[@"http://cdv-djpi.appspot.com/rest/player/tracks?playerTitle=" stringByAppendingString:previousPlayerTitle] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
        [request setValue:@"christopher.vanderschuere@gmail.com" forHTTPHeaderField:@"username"];
        [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
        
        AFJSONRequestOperation* operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            //Use Response to reload data
            NSLog(@"Tracks: %@",JSON);
            [self.currentPlayer setTracksWithLinks:[JSON objectForKey:@"tracks"]];
                        
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            NSLog(@"Error:%@ %@",error.localizedDescription,JSON);
        }];
        
        AppDelegate* delegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
        [delegate.requestQueue addOperation:operation];
    }

    
    [sender endRefreshing];
}
#pragma mark - UICollectionView Datasource methods
-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.currentPlayer.tracks.count;
}
- (UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TrackCell* cell = (TrackCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"trackCell" forIndexPath:indexPath];
    
    SPTrack* track = [self.currentPlayer.tracks objectAtIndex:indexPath.row];
    cell.trackTitle.text = track.name;
    
    //Load art in background
    cell.albumArt.image = track.album.cover.image;
    
    return cell;
}

#pragma mark - UIStoryboard Segue Methods
-(IBAction)unwindFromPlayerSelection:(UIStoryboardSegue*)sender{
    //Set current Player base upon selected player...could have been done with a delegate
    PiPlayer* selectedPlayer = [PiPlayer playerWithDictionary:[sender.sourceViewController selectedPlayer]];
    if (selectedPlayer && ![selectedPlayer.title isEqualToString:self.currentPlayer.title]) {
        self.currentPlayer = selectedPlayer;
    }
    
}
-(IBAction)unwindFromTrackSelection:(UIStoryboardSegue *)sender{
    //Get selected track from 
    TrackSearchViewController* trackVC = sender.sourceViewController;
    NSLog(@"Track: %@",trackVC.selectedTrackURL);
    
    if (trackVC.selectedTrackURL && self.currentPlayer) {
        //Send track to server and update playlist
        NSString* urlString = [[@"http://cdv-djpi.appspot.com/rest/player/tracks?playerTitle=" stringByAppendingString:self.currentPlayer.title] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"christopher.vanderschuere@gmail.com" forHTTPHeaderField:@"username"];
        
        NSError* error = nil;
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:@{@"addedTracks":@[trackVC.selectedTrackURL.absoluteString],@"deletedTracks":@[]} options:NSJSONWritingPrettyPrinted error:&error];
        
        if (error)
            NSLog(@"Failure Reason: %@",error.localizedDescription);
        
        [request setHTTPBody:jsonData];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        NSError* error2 = nil;
        [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error2];
        if (error2) {
            NSLog(@"Error: %@",error2.localizedFailureReason);
        }
    }
    
}
@end
