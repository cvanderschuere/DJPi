//
//  Song.h
//  DJPi
//
//  Created by Chris Vanderschuere on 1/24/13.
//  Copyright (c) 2013 CDVConcepts. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Album.h"
#import <RestKit/NSManagedObject+RKAdditions.h>



@interface Song : NSManagedObject

@property (nonatomic, retain) NSNumber * songID;
@property (nonatomic, retain) NSNumber * albumID;
@property (nonatomic, retain) NSNumber * track;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) Album *album;

@end
