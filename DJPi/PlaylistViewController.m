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
    [[AFJSONRPCClient sharedClient] invokeMethod:@"Player.PlayPause" withParameters:@{@"playerid":@0} requestId:@1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //Play pause suceeded
            [self.playPauseButton setTitle:[self.playPauseButton.titleLabel.text isEqualToString:@"Play"]?@"Pause":@"Play" forState:UIControlStateNormal];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (error.code == -32100) {
                //Failed to execute method...should open new player
                [[AFJSONRPCClient sharedClient] invokeMethod:@"Player.Open" withParameters:@{@"item":@{@"playlistid": @0}} requestId:@1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    [self.playPauseButton setTitle:@"Pause" forState:UIControlStateNormal];
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"Fail");
                }];
            }
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
    return CGSizeMake(50, 50);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)sectio{
    return 10.0;
}
@end
