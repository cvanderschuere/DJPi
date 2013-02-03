//
//  AppDelegate.m
//  DJPi
//
//  Created by Chris Vanderschuere on 1/24/13.
//  Copyright (c) 2013 CDVConcepts. All rights reserved.
//

#import "AppDelegate.h"
#import "Artist.h"
#import "Album.h"
#import "Song.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    //Init RPC Client
    AFJSONRPCClient *client = [AFJSONRPCClient clientWithEndpointURL:[NSURL URLWithString:@"http://192.168.1.111:80/jsonrpc"]];
    [AFJSONRPCClient setSharedClient:client];
    
    // Initialize managed object store
    NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
    NSError *error = nil;
    BOOL success = RKEnsureDirectoryExistsAtPath(RKApplicationDataDirectory(), &error);
    if (! success) {
        RKLogError(@"Failed to create Application Data Directory at path '%@': %@", RKApplicationDataDirectory(), error);
    }
    NSString *path = [RKApplicationDataDirectory() stringByAppendingPathComponent:@"Store.sqlite"];
    NSPersistentStore *persistentStore = [managedObjectStore addSQLitePersistentStoreAtPath:path fromSeedDatabaseAtPath:nil withConfiguration:nil options:nil error:&error];
    if (! persistentStore) {
        RKLogError(@"Failed adding persistent store at path '%@': %@", path, error);
    }
    [managedObjectStore createManagedObjectContexts];    
    [RKManagedObjectStore setDefaultStore:managedObjectStore];

    //RKLogConfigureByName("RestKit/CoreData", RKLogLevelTrace);
    
    //Load all information initially
    self.background = [[NSOperationQueue alloc] init];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    //Update information
    [self.background addOperation:[self allArtistsRequestOperation]];
    [self.background addOperation:[self allAlbumsRequestOperation]];
    [self.background addOperation:[self allSongsRequestOperation]];
    
    //Check if playlist has been opened
    //Get active players
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.1.111:80/jsonrpc"]];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    request.HTTPMethod = @"POST";
    NSDictionary *jsonDict = @{@"jsonrpc":@"2.0",@"method": @"Player.GetActivePlayers",@"id": @1};
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:jsonDict options:0 error:nil];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse* response, NSData*json,NSError*error){
        //Serialize json
        id object = [NSJSONSerialization JSONObjectWithData:json options:0 error:NULL];
        if ([object isKindOfClass:[NSDictionary class]]) {
            NSArray *result = [object objectForKey:@"result"];
            if (result.count==0) {
                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.1.111:80/jsonrpc"]];
                [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                request.HTTPMethod = @"POST";
                NSDictionary *jsonDict = @{@"jsonrpc":@"2.0",@"method": @"Player.Open",@"params":@{@"playlistid":@0},@"id": @1};
                request.HTTPBody = [NSJSONSerialization dataWithJSONObject:jsonDict options:0 error:nil];
                [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:NULL];
            }
        }
    }];

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Load Information
-(RKManagedObjectRequestOperation*) allArtistsRequestOperation{
    //Load all artists
    RKEntityMapping *artistMapping = [RKEntityMapping mappingForEntityForName:@"Artist" inManagedObjectStore:[RKManagedObjectStore defaultStore]];
    [artistMapping addAttributeMappingsFromDictionary:@{@"artist":@"title", @"artistid":@"artistID"}];
    
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful); // Anything in 2xx
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:artistMapping pathPattern:nil keyPath:@"result.artists" statusCodes:statusCodes];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.1.111:80/jsonrpc"]];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    request.HTTPMethod = @"POST";
    NSDictionary *jsonDict = @{@"jsonrpc":@"2.0",@"method": @"AudioLibrary.GetArtists",@"id": @1};
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:jsonDict options:0 error:nil];
    
    RKManagedObjectRequestOperation *operation = [[RKManagedObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[responseDescriptor]];
    operation.managedObjectContext = [RKManagedObjectStore defaultStore].mainQueueManagedObjectContext;
    operation.managedObjectCache = [RKManagedObjectStore defaultStore].managedObjectCache;
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
        Artist *artist = [result firstObject];
        NSLog(@"Mapped the artist: %@", artist);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Failed with error: %@", [error localizedDescription]);
    }];
    return operation;
}
-(RKManagedObjectRequestOperation*) allAlbumsRequestOperation{
    //Load all albums
    RKEntityMapping *albumMapping = [RKEntityMapping mappingForEntityForName:@"Album" inManagedObjectStore:[RKManagedObjectStore defaultStore]];
    [albumMapping addAttributeMappingsFromDictionary:@{@"label":@"title",@"albumid":@"albumID",@"artistid":@"artistIDs"}];
    //Connect relationship
    NSRelationshipDescription *artists = [[NSEntityDescription entityForName:@"Album" inManagedObjectContext:[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext] relationshipsByName][@"artists"]; // To many relationship for the `Artist` entity
    RKConnectionDescription *connection = [[RKConnectionDescription alloc] initWithRelationship:artists attributes:@{@"artistIDs":@"artistID"}];
    [albumMapping addConnection:connection];
    
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful); // Anything in 2xx
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:albumMapping pathPattern:nil keyPath:@"result.albums" statusCodes:statusCodes];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.1.111:80/jsonrpc"]];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    request.HTTPMethod = @"POST";
    NSDictionary *jsonDict = @{@"jsonrpc":@"2.0",@"method": @"AudioLibrary.GetAlbums",@"params":@{@"properties":@[@"artistid"]},@"id": @1};
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:jsonDict options:0 error:nil];
    
    RKManagedObjectRequestOperation *operation = [[RKManagedObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[responseDescriptor]];
    operation.managedObjectContext = [RKManagedObjectStore defaultStore].mainQueueManagedObjectContext;
    operation.managedObjectCache = [RKManagedObjectStore defaultStore].managedObjectCache;
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
        Album *album = [result firstObject];
        NSLog(@"Mapped the album: %@", album);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Failed with error: %@", [error localizedDescription]);
    }];
    return operation;
}
-(RKManagedObjectRequestOperation*) allSongsRequestOperation{
    //Load all songs
    RKEntityMapping *songMapping = [RKEntityMapping mappingForEntityForName:@"Song" inManagedObjectStore:[RKManagedObjectStore defaultStore]];
    [songMapping addAttributeMappingsFromDictionary:@{@"label":@"title", @"albumid":@"albumID",@"songid":@"songID"}];

    //Map relationship
    NSRelationshipDescription *album = [[NSEntityDescription entityForName:@"Song" inManagedObjectContext:[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext] relationshipsByName][@"album"]; // To many relationship for the `Artist` entity
    RKConnectionDescription *connection = [[RKConnectionDescription alloc] initWithRelationship:album attributes:@{@"albumID":@"albumID"}];
    [songMapping addConnection:connection];

    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful); // Anything in 2xx
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:songMapping pathPattern:nil keyPath:@"result.songs" statusCodes:statusCodes];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.1.111:80/jsonrpc"]];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    request.HTTPMethod = @"POST";
    NSDictionary *jsonDict = @{@"jsonrpc":@"2.0",@"method": @"AudioLibrary.GetSongs",@"params": @{ @"properties":@[@"albumid"]}, @"id": @1};
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:jsonDict options:0 error:nil];

    RKManagedObjectRequestOperation *operation = [[RKManagedObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[responseDescriptor]];
    operation.managedObjectContext = [RKManagedObjectStore defaultStore].mainQueueManagedObjectContext;
    operation.managedObjectCache = [RKManagedObjectStore defaultStore].managedObjectCache;
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
        Song *song = [result firstObject];
        NSLog(@"Mapped the song: %@", song);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Failed with error: %@", [error localizedDescription]);
    }];
    return operation;
}

@end
