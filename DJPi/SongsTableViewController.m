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
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.1.111:80/jsonrpc"]];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    request.HTTPMethod = @"POST";
    NSDictionary *jsonDict = @{@"jsonrpc":@"2.0",@"method": @"Playlist.Add",@"params":@{@"playlistid" : @0,@"item":@{@"songid":song.songID}},@"id": @1};
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:jsonDict options:0 error:nil];

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,NSData*data,NSError*error){
        if (error) {
            NSLog(@"Playlist.Add Error: %@",error.localizedFailureReason);
        }
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
