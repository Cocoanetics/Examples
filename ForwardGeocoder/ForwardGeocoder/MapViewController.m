//
//  MapViewController.m
//  ForwardGeocoder
//
//  Created by Oliver Drobnik on 16.05.14.
//  Copyright (c) 2014 Cocoanetics. All rights reserved.
//

#import "MapViewController.h"

@implementation MapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
   [super viewWillAppear:animated];
   
   if (!_placemark)
   {
      return;
   }

   // set title from first address line
   self.navigationItem.title = ABCreateStringWithAddressDictionary(_placemark.addressDictionary, NO);
   
   // set zoom to fit placemark
   CLCircularRegion *circularRegion = (CLCircularRegion *)_placemark.region;
   CLLocationDistance distance = circularRegion.radius*2.0;
   MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(_placemark.location.coordinate, distance, distance);
   [self.mapView setRegion:region animated:NO];
   
   // create annoation
   MKPlacemark *mkPlacemark = [[MKPlacemark alloc] initWithPlacemark:_placemark];
   [self.mapView addAnnotation:mkPlacemark];
}

@end
