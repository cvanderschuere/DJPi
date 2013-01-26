//
//  AppDelegate.h
//  DJPi
//
//  Created by Chris Vanderschuere on 1/24/13.
//  Copyright (c) 2013 CDVConcepts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) NSOperationQueue *background;

@end
