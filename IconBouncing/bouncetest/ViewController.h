//
//  ViewController.h
//  bouncetest
//
//  Created by Oliver Drobnik on 28.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIView *bounceView;
@property (nonatomic, strong) IBOutlet UIButton *bounceButton;

- (IBAction)ease:(id)sender;
- (IBAction)bounce:(id)sender;
- (IBAction)jump:(id)sender;

@end
