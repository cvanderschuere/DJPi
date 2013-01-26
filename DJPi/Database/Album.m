//
//  Album.m
//  DJPi
//
//  Created by Chris Vanderschuere on 1/24/13.
//  Copyright (c) 2013 CDVConcepts. All rights reserved.
//

#import "Album.h"
#import "Artist.h"
#import "Song.h"
#import "SDWebImageDownloader.h"


@implementation Album

@dynamic albumID;
@dynamic artistIDs;
@dynamic title;
@dynamic thumbnail;
@dynamic  thumbnailURL;
@dynamic artists;
@dynamic songs;

-(void) setThumbnailURL:(NSString *)thumbnailURL{
    if (![thumbnailURL isEqualToString:[self primitiveValueForKey:thumbnailURL]]) {
        //Redownload thumbnail image in background
        NSString *stringURL = [NSString stringWithFormat:@"http://%@%@", @"192.168.1.111:80/image/", [thumbnailURL stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
        [SDWebImageDownloader downloaderWithURL:[NSURL URLWithString:stringURL] delegate:self];
    }
    
    [self willChangeValueForKey:@"thumbnailURL"];
    [self setPrimitiveValue:thumbnailURL forKey:@"thumbnailURL"];
    [self didChangeValueForKey:@"thumbnailURL"];
}
#pragma mark - SDWebImageDownloader Delegate
- (void)imageDownloader:(SDWebImageDownloader *)downloader didFinishWithImage:(UIImage *)image{
    //Set thumbnail data
    self.thumbnail = UIImagePNGRepresentation(image);
}
- (void)imageDownloader:(SDWebImageDownloader *)downloader didFailWithError:(NSError *)error{
    NSLog(@"ImageFailed with error: %@",error.localizedFailureReason);
}


@end
