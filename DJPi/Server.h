//
//  Server.h
//  DJPi
//
//  Created by Chris Vanderschuere on 3/1/13.
//  Copyright (c) 2013 CDVConcepts. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Server : NSObject <NSCoding>

@property (nonatomic,strong) NSString* address;
@property (nonatomic, strong) NSString* username;
@property (nonatomic, strong) NSString* password;
@property (nonatomic, strong) NSNumber* port;
@property (nonatomic, weak, readonly) NSString *serverString;

+ (instancetype) serverWithAddress:(NSString*)address Port:(int)port;

@end
