//
//  ArtistsTableViewController.m
//  DJPi
//
//  Created by Chris Vanderschuere on 1/25/13.
//  Copyright (c) 2013 CDVConcepts. All rights reserved.
//

#import "ArtistsTableViewController.h"
#import "Artist.h"
#import "Album.h"
#import "AlbumsTableViewController.h"

@interface ArtistsTableViewController ()

@end

@implementation ArtistsTableViewController

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
        
    //Setup FRC
    NSFetchRequest *artistFetch = [NSFetchRequest fetchRequestWithEntityName:@"Artist"];
    artistFetch.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title.initialCharacter" ascending:YES],[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:artistFetch managedObjectContext:[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext sectionNameKeyPath:@"title.initialCharacter" cacheName:nil];
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self performFetch];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        Artist* selectedArtist = [self.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForCell:sender]];
        [segue.destinationViewController setSelectedArtist:selectedArtist];
    }
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"artistCell" forIndexPath:indexPath];
    
    Artist *artist = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = artist.title;
    
    
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
