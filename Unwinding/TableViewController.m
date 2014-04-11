//
//  TableViewController.m
//  Unwinding
//
//  Created by Oliver Drobnik on 11.04.14.
//  Copyright (c) 2014 Cocoanetics. All rights reserved.
//

#import "TableViewController.h"

@implementation TableViewController

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
   // Return the number of sections.
   return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   // Return the number of rows in the section.
   return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"basic" forIndexPath:indexPath];
   
   // Configure the cell...
   cell.textLabel.text = @"Contents";
   
   return cell;
}

#pragma mark - Navigation

// here we get back from both styles
- (IBAction)unwindFromDetailViewController:(UIStoryboardSegue *)segue
{
   // ViewController *detailViewController = [segue sourceViewController];
   NSLog(@"%@", segue.identifier);
}

@end
