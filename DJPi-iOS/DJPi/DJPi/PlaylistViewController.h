//
//  PlaylistViewController.h
//  DJPi
//
//  Created by Chris Vanderschuere on 3/31/13.
//  Copyright (c) 2013 CDVConcepts. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaylistViewController : UIViewController <UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property (nonatomic,strong) NSDictionary *currentPlayer;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *playerButton;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

-(IBAction)unwindFromPlayerSelection:(UIStoryboardSegue*)sender;
-(IBAction)unwindFromTrackSelection:(UIStoryboardSegue*)sender;

@end
