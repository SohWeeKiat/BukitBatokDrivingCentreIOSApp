//
//  MapViewController.h
//  BBDCApp
//
//  Created by StudentR on 22/1/16.
//  Copyright (c) 2016 StudentR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController<MKMapViewDelegate>

@property long RouteSelected;
@property (weak, nonatomic) IBOutlet MKMapView *MapView;
- (IBAction)OnBtnValueChanged:(id)sender;
@property (weak, nonatomic) IBOutlet UISegmentedControl *SegmentedCtrl;

@end
