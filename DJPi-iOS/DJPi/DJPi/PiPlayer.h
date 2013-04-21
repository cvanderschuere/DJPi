//
//  PiPlayer.h
//  DJPi
//
//  Created by Chris Vanderschuere on 4/20/13.
//  Copyright (c) 2013 CDVConcepts. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PiPlayer : NSObject

@property (nonatomic,strong) NSString *title;
@property (nonatomic, strong) NSMutableArray *tracks;
@property (nonatomic, strong) NSArray *trackURLS;
@property BOOL loaded;

+(instancetype) playerWithDictionary:(NSDictionary*)playerDict;

-(void) setTracksWithLinks:(NSArray*)linkArray;

@end
