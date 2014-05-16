//
//  MapViewController.h
//  ForwardGeocoder
//
//  Created by Oliver Drobnik on 16.05.14.
//  Copyright (c) 2014 Cocoanetics. All rights reserved.
//

@interface MapViewController : UIViewController

@property (nonatomic, strong) CLPlacemark *placemark;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
