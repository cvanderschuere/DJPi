//
//  AppDelegate.h
//  DJPi
//
//  Created by Chris Vanderschuere on 1/24/13.
//  Copyright (c) 2013 CDVConcepts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Server.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,NSNetServiceBrowserDelegate,NSNetServiceDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) NSOperationQueue *background;
@property (nonatomic,strong) Server* currentServer;

@end
