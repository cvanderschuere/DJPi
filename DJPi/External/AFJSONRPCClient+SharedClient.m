//
//  AFJSONRPCClient+SharedClient.m
//  DJPi
//
//  Created by Chris Vanderschuere on 3/22/13.
//  Copyright (c) 2013 CDVConcepts. All rights reserved.
//

#import "AFJSONRPCClient+SharedClient.h"

@implementation AFJSONRPCClient (SharedClient)

static AFJSONRPCClient *shared = nil;

+(AFJSONRPCClient *)sharedClient {
    return shared;
}
+(void)setSharedClient:(AFJSONRPCClient *)sharedClient{
    shared = sharedClient;
}

@end
