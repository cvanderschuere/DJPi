//
//  PiPlayer.m
//  DJPi
//
//  Created by Chris Vanderschuere on 4/20/13.
//  Copyright (c) 2013 CDVConcepts. All rights reserved.
//

#import "PiPlayer.h"

@implementation PiPlayer

-(id)init{
    self = [super init];
    if (self) {
        self.tracks = [NSMutableArray array];
    }
    return self;
}

+(instancetype)playerWithDictionary:(NSDictionary *)playerDict{
    if (!playerDict)
        return nil;
    
    PiPlayer* newPlayer = [[PiPlayer alloc] init];
    newPlayer.loaded = NO;
    newPlayer.title = [playerDict objectForKey:@"title"];
    [newPlayer setTracksWithLinks:[playerDict objectForKey:@"tracks"]];

    return newPlayer;
}

-(void)setTracksWithLinks:(NSArray *)linkArray{
    [self.tracks removeAllObjects];
    self.loaded = NO;
    for(NSString *link in linkArray){
        [SPTrack trackForTrackURL:[NSURL URLWithString:link] inSession:[SPSession sharedSession] callback:^(SPTrack *track) {
            [self.tracks addObject:track];
            if (self.tracks.count == linkArray.count)
                self.loaded = YES;
        }];
    }
}

@end
