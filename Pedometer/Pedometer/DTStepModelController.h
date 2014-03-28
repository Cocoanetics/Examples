//
//  DTStepModelController.h
//  Pedometer
//
//  Created by Oliver Drobnik on 28.03.14.
//  Copyright (c) 2014 Cocoanetics. All rights reserved.
//

// model controller that takes care of interacting with the Core Motion CMStepCounter.
// Property stepsToday is observable.
@interface DTStepModelController : NSObject

// returns number of steps or -1 if they are not available
@property (readonly) NSInteger stepsToday;

@end
