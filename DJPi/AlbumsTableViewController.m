//
//  AlbumsTableViewController.m
//  DJPi
//
//  Created by Chris Vanderschuere on 1/25/13.
//  Copyright (c) 2013 CDVConcepts. All rights reserved.
//

#import "AlbumsTableViewController.h"
#import "Album.h"
#import "SongsTableViewController.h"

@interface AlbumsTableViewController ()

@end

@implementation AlbumsTableViewController

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
    NSFetchRequest *albumFetch = [NSFetchRequest fetchRequestWithEntityName:@"Album"];
    albumFetch.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title.initialCharacter" ascending:YES],[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];
    if (self.selectedArtist) {
        albumFetch.predicate = [NSPredicate predicateWithFormat:@"songs.@count>0 AND self.artists CONTAINS %@",self.selectedArtist];
        self.title = self.selectedArtist.title;
    }
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:albumFetch managedObjectContext:[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext sectionNameKeyPath:@"title.initialCharacter" cacheName:nil];
}
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self performFetch];
    if (self.selectedArtist) {
        //Pull for new albums
    
    }
}
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        Album* selectedAlbum = [self.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForCell:sender]];
        [segue.destinationViewController setSelectedAlbum:selectedAlbum];
    }
}
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"albumCell" forIndexPath:indexPath];
    
    Album *album = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = album.title;
    cell.detailTextLabel.text = [[album.artists anyObject] title];
    
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
