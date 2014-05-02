//
//  DOGManagedObjectViewModelSpec.m
//  ManagedObjectViewModel
//
//  Created by Vasco d'Orey on 30/04/14.
//  Copyright (c) 2014 Delta Dog. All rights reserved.
//

#define EXP_SHORTHAND
#import <Expecta/Expecta.h>
#import <Specta/Specta.h>
#import <MagicalRecord/CoreData+MagicalRecord.h>

#import "DOGManagedObjectTracker.h"
#import "Thing.h"

SpecBegin(DOGManagedObjectViewModelSpec)

describe(@"Initializers should work as intended", ^{
  beforeEach(^{
    [MagicalRecord setupCoreDataStackWithInMemoryStore];
  });
  
  afterAll(^{
    [MagicalRecord cleanUp];
  });
  
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-value"
  it(@"Should raise exceptions on initializing with nil & invalid values", ^{
    expect(^{ [[DOGManagedObjectTracker alloc] init]; }).to.raise(NSInvalidArgumentException);
    expect(^{ [[DOGManagedObjectTracker alloc] initWithManagedObject:nil]; }).to.raise(NSInvalidArgumentException);
  });
#pragma clang diagnostic pop
  
  it(@"Should set the model & managedObjectContext properties correctly", ^{
    Thing *thing = [Thing MR_createEntity];
    DOGManagedObjectTracker *tracker = [[DOGManagedObjectTracker alloc] initWithManagedObject:thing];
    expect(tracker.model).to.equal(thing);
  });

  it(@"Should track managed object changes whenever it's context is saved", ^{
    __block Thing *thing;
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
      thing = [Thing MR_createInContext:localContext];
      thing.name = @"thing";
    }];
    thing = [thing MR_inContext:[NSManagedObjectContext MR_defaultContext]];
    
    // thing has been saved
    expect(thing.name).to.equal(@"thing");
    
    DOGManagedObjectTracker *tracker = [[DOGManagedObjectTracker alloc] initWithManagedObject:thing];
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
      thing = [thing MR_inContext:localContext];
      thing.name = @"new name";
      
      // Name has changed but hasn't been saved. Should still have the old name.
      expect(((Thing *)tracker.model).name).to.equal(@"thing");
    }];
    
    // Context has been saved so name should be 
    expect(((Thing *)tracker.model).name).to.equal(@"new name");
  });
});

SpecEnd
