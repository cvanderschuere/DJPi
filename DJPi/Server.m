//
//  Server.m
//  DJPi
//
//  Created by Chris Vanderschuere on 3/1/13.
//  Copyright (c) 2013 CDVConcepts. All rights reserved.
//

#import "Server.h"

@implementation Server
+ (instancetype) serverWithAddress:(NSString*)address Port:(int)port{
    if (!address || !port)
        return nil; //Prevent from creating incomplete server
    
    Server* server = [[Server alloc] init];
    server.address = address;
    server.port = [NSNumber numberWithInt:port];
    
    return server;
}

- (NSString*) serverString{
    return [NSString stringWithFormat:@"http://%@:%d/jsonrpc",self.address,self.port.intValue];
}

#pragma mark - NSCoding
-(void) encodeWithCoder:(NSCoder*)coder{
    [coder encodeObject:self.address forKey:@"address"];
    [coder encodeObject:self.port forKey:@"port"];
}
-(instancetype) initWithCoder:(NSCoder*)coder{
    self = [super init];
    if (self) {
        _address = [coder decodeObjectForKey:@"address"];
        _port = [coder decodeObjectForKey:@"port"];
    }
    return self;
}

@end
