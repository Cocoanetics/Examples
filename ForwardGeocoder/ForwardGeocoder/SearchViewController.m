//
//  ViewController.m
//  ForwardGeocoder
//
//  Created by Oliver Drobnik on 16.05.14.
//  Copyright (c) 2014 Cocoanetics. All rights reserved.
//

#import "SearchViewController.h"
#import "PlacemarkCell.h"
#import "MapViewController.h"

@interface SearchViewController () <UISearchDisplayDelegate>

@end

@implementation SearchViewController
{
   CLGeocoder *_geoCoder;
   NSArray *_searchResults;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
   _geoCoder = [[CLGeocoder alloc] init];
   
   // register the cell for both table views
   [self.tableView registerClass:[PlacemarkCell class] forCellReuseIdentifier:@"placemarkCell"];
   [self.searchDisplayController.searchResultsTableView registerClass:[PlacemarkCell class] forCellReuseIdentifier:@"placemarkCell"];
}

#pragma mark - Helpers

- (NSString *)_addressStringAtIndexPath:(NSIndexPath *)indexPath
{
   CLPlacemark *placemark = _searchResults[indexPath.row];
   return ABCreateStringWithAddressDictionary(placemark.addressDictionary, NO);
}

- (NSAttributedString *)_attributedAddressStringAtIndexPath:(NSIndexPath *)indexPath
{
   NSString *string = [self _addressStringAtIndexPath:indexPath];
   
   // get standard body font and bold variant
   UIFont *bodyFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
   UIFontDescriptor *descriptor = [bodyFont fontDescriptor];
   UIFontDescriptor *boldDescriptor = [descriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold];
   UIFont *highlightFont = [UIFont fontWithDescriptor:boldDescriptor size:bodyFont.pointSize];
   
   NSDictionary *attributes = @{NSFontAttributeName: bodyFont};
   NSMutableAttributedString *attribString = [[NSMutableAttributedString alloc] initWithString:string attributes:attributes];

   // show search terms in bold
   if ([self.searchDisplayController isActive])
   {
      NSString *searchText = self.searchDisplayController.searchBar.text;
      NSArray *searchTerms = [searchText componentsSeparatedByCharactersInSet:[[NSCharacterSet alphanumericCharacterSet] invertedSet]];
      
      for (NSString *term in searchTerms)
      {
         if (![term length])
         {
            continue;
         }
         
         NSRange matchRange = [string rangeOfString:term options:NSDiacriticInsensitiveSearch | NSCaseInsensitiveSearch];
         
         if (matchRange.location != NSNotFound)
         {
            [attribString addAttribute:NSFontAttributeName value:highlightFont range:matchRange];
         }
      }
   }
   
   return attribString;
}


- (void)_performGeocodingForString:(NSString *)searchString
{
   [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
   
   [_geoCoder geocodeAddressString:searchString completionHandler:^(NSArray *placemarks, NSError *error) {
      if (!error)
      {
         _searchResults = placemarks;
         [self.searchDisplayController.searchResultsTableView reloadData];
         [self.tableView reloadData];
      }
      else
      {
         NSLog(@"error: %@", error);
      }
      
      [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
   }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return [_searchResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   PlacemarkCell *cell = [tableView dequeueReusableCellWithIdentifier:@"placemarkCell" forIndexPath:indexPath];
   cell.addressLabel.attributedText = [self _attributedAddressStringAtIndexPath:indexPath];
   cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
   
   return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   NSAttributedString *attributedString = [self _attributedAddressStringAtIndexPath:indexPath];
   CGSize neededSize = [attributedString size];
   
   return ceilf(neededSize.height) + 20;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   [self performSegueWithIdentifier:@"showMap" sender:nil];
}

#pragma mark - UISearchDisplayDelegate

// return YES to reload table. called when search string/option changes. convenience methods on top UISearchBar delegate methods
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
   // cancel previous in flight geocoding
   [_geoCoder cancelGeocode];
   
   if ([searchString length]>=3)
   {
      // add minimal delay to search to avoid searching for something outdated
      [NSObject cancelPreviousPerformRequestsWithTarget:self];
      [self performSelector:@selector(_performGeocodingForString:) withObject:searchString afterDelay:0.1];
      
      // results are asynchronous, will reload tableView once we have results
      return NO;
   }
   else
   {
      // reset search results table immediately
      _searchResults = nil;
      return YES;
   }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
   if ([segue.identifier isEqualToString:@"showMap"])
   {
      MapViewController *map = [segue destinationViewController];
      
      NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
      CLPlacemark *placemark = _searchResults[indexPath.row];
      map.placemark = placemark;
   }
}

@end
