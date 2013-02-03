//
//  PlaylistViewController.h
//  DJPi
//
//  Created by Chris Vanderschuere on 1/26/13.
//  Copyright (c) 2013 CDVConcepts. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaylistViewController : UIViewController <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UIButton *playPauseButton;
- (IBAction)playPauseHit:(id)sender;
@property (weak, nonatomic) IBOutlet UICollectionView *playlistCollectionView;

@end
