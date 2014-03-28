//
//  ViewController.m
//  Pedometer
//
//  Created by Oliver Drobnik on 28.03.14.
//  Copyright (c) 2014 Cocoanetics. All rights reserved.
//

#import "ViewController.h"
#import "DTStepModelController.h"

@interface ViewController ()

@end

@implementation ViewController
{
   DTStepModelController *_stepModel;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
   _stepModel = [[DTStepModelController alloc] init];
   
   [_stepModel addObserver:self forKeyPath:@"stepsToday" options:NSKeyValueObservingOptionNew context:NULL];
   
   [self _updateSteps:_stepModel.stepsToday];
}

- (void)dealloc
{
   [_stepModel removeObserver:self forKeyPath:@"stepsToday"];
}

- (void)_updateSteps:(NSInteger)steps
{
   // force main queue for UIKit
   dispatch_async(dispatch_get_main_queue(), ^{
      if (steps>=0)
      {
         self.stepsLabel.text = [NSString stringWithFormat:@"%ld",
                                 (long)steps];
         self.stepsLabel.textColor = [UIColor colorWithRed:0
                                                     green:0.8
                                                      blue:0
                                                     alpha:1];
      }
      else
      {
         self.stepsLabel.text = @"Not available";
         self.stepsLabel.textColor = [UIColor redColor];
      }
   });
}

#pragma mark - Notifications

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
   [self _updateSteps:_stepModel.stepsToday];
}

@end
