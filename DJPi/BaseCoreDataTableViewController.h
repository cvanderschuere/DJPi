//
//  BaseCoreDataTableViewController.h
//  DJPi
//
//  Created by Chris Vanderschuere on 1/25/13.
//  Copyright (c) 2013 CDVConcepts. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface BaseCoreDataTableViewController : CoreDataTableViewController<MPMediaPickerControllerDelegate>

- (IBAction)addMediaItems:(id)sender;

@end
