//
//  DOGManagedObjectTracker.m
//  DOGManagedObjectTracker
//
//  Created by Vasco d'Orey on 30/04/14.
//  Copyright (c) 2014 Delta Dog. All rights reserved.
//

#import "DOGManagedObjectTracker.h"

@interface DOGManagedObjectTracker ()

@property (nonatomic, strong, readwrite) NSManagedObject *model;
@property (nonatomic, strong) id savingObserver;

- (void)handleNotification:(NSNotification *)notification;

@end

@implementation DOGManagedObjectTracker

#pragma mark - Properties

- (void)setDelegate:(id<ManagedObjectTracking>)delegate {
  if(![delegate respondsToSelector:@selector(managedObjectTracker:didRefreshManagedObject:)]) {
    
  }
}

#pragma mark - Lifecycle

- (id)init {
  if([self class] == [DOGManagedObjectTracker class]) {
    [[NSException exceptionWithName:NSInvalidArgumentException reason:@"You shouldn't call init. Call initWithManagedObject:" userInfo:nil] raise];
  }
  return [super init];
}

- (id)initWithManagedObject:(NSManagedObject *)managedObject {
  if(!managedObject) {
    [[NSException exceptionWithName:NSInvalidArgumentException reason:@"nil managedObject" userInfo:nil] raise];
  }
  self = [super init];
  if(!self) return nil;
  
  _model = managedObject;
  
  __weak typeof(self) weakself = self;
  _savingObserver = [[NSNotificationCenter defaultCenter]
                     addObserverForName:NSManagedObjectContextDidSaveNotification
                     object:nil
                     queue:nil
                     usingBlock:^(NSNotification *note) {
                       __strong typeof(self) _self = weakself;
                       [_self handleNotification:note];
                     }];
  
  return self;
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self.savingObserver];
}

#pragma mark - Private

- (void)handleNotification:(NSNotification *)notification {
  NSManagedObjectContext *managedObjectContext = self.model.managedObjectContext;
  NSManagedObjectContext *incomingContext = notification.object;
  if(incomingContext.persistentStoreCoordinator == managedObjectContext.persistentStoreCoordinator) {
    NSSet *updatedObjects = [notification userInfo][NSUpdatedObjectsKey];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"objectID == %@", self.model.objectID];
    NSSet *filteredSet = [updatedObjects filteredSetUsingPredicate:predicate];
    if([filteredSet count]) {
      [managedObjectContext performBlock:^{
        [managedObjectContext refreshObject:self.model mergeChanges:YES];
        [self.delegate managedObjectTracker:self didRefreshManagedObject:self.model];
      }];
    }
  }
}

@end
