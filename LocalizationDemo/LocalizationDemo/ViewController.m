//
//  ViewController.m
//  LocalizationDemo
//
//  Created by Oliver Drobnik on 19.03.13.
//  Copyright (c) 2013 Drobnik KG. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSLocalizedString(@"ALERT_VIEW_MSG", @"Message in an alert view");
    NSLocalizedString(@"ALERT_VIEW_TITLE", @"Title in an alert view");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
