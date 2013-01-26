//
//  AlbumsTableViewController.h
//  DJPi
//
//  Created by Chris Vanderschuere on 1/25/13.
//  Copyright (c) 2013 CDVConcepts. All rights reserved.
//

#import "BaseCoreDataTableViewController.h"
#import "Artist.h"

@interface AlbumsTableViewController : BaseCoreDataTableViewController

@property (nonatomic, strong) Artist* selectedArtist;

@end
