//
//  BaseCoreDataTableViewController.m
//  DJPi
//
//  Created by Chris Vanderschuere on 1/25/13.
//  Copyright (c) 2013 CDVConcepts. All rights reserved.
//

#import "BaseCoreDataTableViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface BaseCoreDataTableViewController ()

@end

@implementation BaseCoreDataTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationController.navigationBar.tintColor = [UIColor lightGrayColor];
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, tableView.sectionHeaderHeight)];
    [header setBackgroundColor:[UIColor lightGrayColor]];
    header.textColor = [UIColor whiteColor];
    header.text = [@"\t" stringByAppendingString:[self tableView:tableView titleForHeaderInSection:section]];
    
    return header;
}
-(IBAction)addMediaItems:(id)sender{
    MPMediaPickerController* mediaPicker = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeMusic];
    mediaPicker.showsCloudItems = NO;
    mediaPicker.delegate = self;
    
    self.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    [self presentViewController:mediaPicker animated:YES completion:NULL];
}
#pragma mark MPMediaPlayer Delegate
-(void) mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection{
    NSURL *assetURL = [[mediaItemCollection.items lastObject] valueForProperty:MPMediaItemPropertyAssetURL];
    if (assetURL) {
        
        NSURL *url = [mediaItemCollection.items.lastObject valueForProperty: MPMediaItemPropertyAssetURL];
        
        AVURLAsset *songAsset = [AVURLAsset URLAssetWithURL:url options:0];
        
        if (songAsset.exportable && !songAsset.hasProtectedContent) {

            AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset: songAsset
                                                                              presetName: AVAssetExportPresetAppleM4A];
            
            exporter.outputFileType = AVFileTypeAppleM4A;
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *exportFile = [documentsDirectory stringByAppendingPathComponent:
                                    @"exported.m4a"];
            
            NSURL *exportURL = [NSURL fileURLWithPath:exportFile];
            exporter.outputURL = exportURL;
            
            // do the export
            // (completion handler block omitted)
            [exporter exportAsynchronouslyWithCompletionHandler:
             ^{
                 NSData *data = [NSData dataWithContentsOfFile: [documentsDirectory
                                                                 stringByAppendingPathComponent:@"exported.m4a"]];
                 
                 NSLog(@"Data: %d",data.length);
                 NSLog(@"Exporter Status: %d Error: %@",exporter.status,exporter.error.localizedFailureReason);
                 
                 
                 //Upload over ftp
                 //AFURLConnectionOperation *upload = [[AFURLConnectionOperation alloc] initWithRequest:[NSURLRequest requestWithURL:@"ftp://piraspberry@192.168.1.111"]];
                 
                 
             }];
        }
    }
    
}
-(void) mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker{
    [self dismissViewControllerAnimated:YES completion:NO];
}
@end
