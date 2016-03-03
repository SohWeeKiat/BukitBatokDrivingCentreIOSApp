//
//  ContactVC.h
//  BBDCApp
//
//  Created by StudentR on 25/2/16.
//  Copyright © 2016 StudentR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface ContactVC : UIViewController
{
    MKPointAnnotation *point;
}

@property (weak, nonatomic) IBOutlet MKMapView *myMap;

@property (weak,nonatomic) IBOutlet UIBarButtonItem* barButton;

@end
