//
//  SongsTableViewController.m
//  DJPi
//
//  Created by Chris Vanderschuere on 1/25/13.
//  Copyright (c) 2013 CDVConcepts. All rights reserved.
//

#import "SongsTableViewController.h"
#import "Song.h"

@interface SongsTableViewController ()

@end

@implementation SongsTableViewController

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
            
    //Setup FRC
    NSFetchRequest *songFetch = [NSFetchRequest fetchRequestWithEntityName:@"Song"];
    songFetch.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title.initialCharacter" ascending:YES],[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];
    if (self.selectedAlbum) {
        songFetch.predicate = [NSPredicate predicateWithFormat:@"album == %@",self.selectedAlbum];
        self.title = self.selectedAlbum.title;
    }
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:songFetch managedObjectContext:[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext sectionNameKeyPath:@"title.initialCharacter" cacheName:nil];

}
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"songCell" forIndexPath:indexPath];
    
    Song *song = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = song.title;
    cell.detailTextLabel.text = song.album.title;
    
    return cell;
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //Queue selected song
    Song *song = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [[AFJSONRPCClient sharedClient] invokeMethod:@"Playlist.Add" withParameters:@{@"playlistid":@0,@"item":@{@"songid":song.songID}} requestId:@1 success:NULL failure:NULL];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
