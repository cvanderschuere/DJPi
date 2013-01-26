//
//  SongsTableViewController.h
//  DJPi
//
//  Created by Chris Vanderschuere on 1/25/13.
//  Copyright (c) 2013 CDVConcepts. All rights reserved.
//

#import "BaseCoreDataTableViewController.h"
#import "Album.h"

@interface SongsTableViewController : BaseCoreDataTableViewController

@property (nonatomic, retain) Album *selectedAlbum;

@end
