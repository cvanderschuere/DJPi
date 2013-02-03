//
//  PlaylistViewController.m
//  DJPi
//
//  Created by Chris Vanderschuere on 1/26/13.
//  Copyright (c) 2013 CDVConcepts. All rights reserved.
//

#import "PlaylistViewController.h"
#import <RestKit/RestKit.h>

@interface PlaylistViewController ()
@property (nonatomic, strong) NSArray *playlistItems;
@end

@implementation PlaylistViewController

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
}

-(void) updatePlaylistItems{
    //Send request
}

- (IBAction)playPauseHit:(id)sender {
    [[AFJSONRPCClient sharedClient] invokeMethod:@"Player.GetActivePlayers" withParameters:[NSArray array] requestId:@1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSArray class]]) {
            if ([responseObject count]>0) {
                [[AFJSONRPCClient sharedClient] invokeMethod:@"Player.PlayPause" withParameters:@{@"playerid": [[responseObject objectAtIndex:0] objectForKey:@"playerid"]} requestId:@1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    [self.playPauseButton setTitle:[self.playPauseButton.titleLabel.text isEqualToString:@"Play"]?@"Pause":@"Play" forState:UIControlStateNormal];
                } failure:NULL];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark - UICollectionView Datasource
- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.playlistItems.count;
}
- (UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}
- (UICollectionReusableView*) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    return nil;
}
#pragma mark - UICollectionView Delegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSizeMake(50, 50);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)sectio{
    return 10.0;
}
@end
