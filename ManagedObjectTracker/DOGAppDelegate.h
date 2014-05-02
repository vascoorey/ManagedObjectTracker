//
//  DOGAppDelegate.h
//  ManagedObjectTracker
//
//  Created by Vasco d'Orey on 02/05/14.
//  Copyright (c) 2014 Delta Dog. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DOGAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
