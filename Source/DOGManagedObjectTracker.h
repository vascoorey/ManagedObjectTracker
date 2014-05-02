//
//  DOGManagedObjectTracker.h
//  DOGManagedObjectTracker
//
//  Created by Vasco d'Orey on 30/04/14.
//  Copyright (c) 2014 Delta Dog. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@protocol ManagedObjectTracking;

@interface DOGManagedObjectTracker : NSObject

/*!
 @abstract Creates a new \c DOGManagedObjectViewModel that tracks the given \c NSManagedObject for changes.
 
 @param managedObject The \c NSManagedObject to track
 
 @return A new instance of \c DOGManagedObjectViewModel ready to roll
 */
- (id)initWithManagedObject:(NSManagedObject *)managedObject;

/*!
 @abstract The \c NSManagedObject that's being tracked by this view model
 */
@property (nonatomic, readonly) NSManagedObject *model;

/*!
 @abstract Set the delegate in order to track changes to the given managed object.
 */
@property (nonatomic, weak) id <ManagedObjectTracking> delegate;

@end

@protocol ManagedObjectTracking <NSObject>

@required

/*!
 @abstract \c managedObjectTracker:didRefreshManagedObject: is called every time the \c NSManagedObjectContext being tracked is saved & updates the 
   tracked \c NSManagedObject
 
 You should subclass & use this method in the case that you need to update stuff (i.e. UI updates to reflect the new model changes).
 
 @param managedObject Purely for convenience (avoids having to access the current \c NSManagedObject via \c self.model)
 */
- (void)managedObjectTracker:(DOGManagedObjectTracker *)tracker didRefreshManagedObject:(NSManagedObject *)managedObject;

@end
