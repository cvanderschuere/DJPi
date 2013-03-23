//
//  AFJSONRPCClient+SharedClient.h
//  DJPi
//
//  Created by Chris Vanderschuere on 3/22/13.
//  Copyright (c) 2013 CDVConcepts. All rights reserved.
//

#import "AFJSONRPCClient.h"

@interface AFJSONRPCClient (SharedClient)

+(AFJSONRPCClient*)sharedClient;
+(void)setSharedClient:(AFJSONRPCClient*)sharedClient;

@end
