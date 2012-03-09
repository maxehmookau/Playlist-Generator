//
//  playlist2AppDelegate.h
//  Playlist2
//
//  Created by Max Woolf on 25/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class playlist2ViewController;


@interface playlist2AppDelegate : UIResponder <UIApplicationDelegate>
{
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;       
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) playlist2ViewController *viewController;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end
