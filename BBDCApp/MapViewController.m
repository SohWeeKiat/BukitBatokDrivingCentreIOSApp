//
//  MapViewController.m
//  BBDCApp
//
//  Created by StudentR on 22/1/16.
//  Copyright (c) 2016 StudentR. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    static NSString* Routes[] = { @"RouteData//route1",
                            @"RouteData//route2",
                            @"RouteData//route3",
                            @"RouteData//route4",
                            @"RouteData//route5",
                            @"RouteData//route6",
                            @"RouteData//route7",
                            @"RouteData//route8"};
    
    NSString* filePath = [[NSBundle mainBundle] pathForResource:Routes[_RouteSelected] ofType:@"csv"];
    //NSString* fileContents = [NSString stringWithContentsOfFile:filePath];
    NSError* Error = nil;
    NSString* fileContents = [NSString stringWithContentsOfFile:filePath encoding:NSASCIIStringEncoding error:&Error];
    NSArray* pointStrings = [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSMutableArray* points = [[NSMutableArray alloc] initWithCapacity:pointStrings.count];
    
    for(int idx = 0; idx < pointStrings.count; idx++)
    {
        // break the string down even further to latitude and longitude fields.
        NSString* currentPointString = [pointStrings objectAtIndex:idx];
        NSArray* latLonArr = [currentPointString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
        
        CLLocationDegrees latitude  = [[latLonArr objectAtIndex:1] doubleValue];
        CLLocationDegrees longitude = [[latLonArr objectAtIndex:0] doubleValue];
        
        CLLocation* currentLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
        [points addObject:currentLocation];
    }
    
    CLLocationDegrees maxLon = 102;
    CLLocationDegrees maxLat = 1;
    
    CLLocationDegrees minLon = 104;
    CLLocationDegrees minLat = 2;
    
    for(int idx = 0; idx < points.count; idx++)
    {
        CLLocation* currentLocation = [points objectAtIndex:idx];
        if(currentLocation.coordinate.latitude > maxLat)
            maxLat = currentLocation.coordinate.latitude;
        if(currentLocation.coordinate.latitude < minLat)
            minLat = currentLocation.coordinate.latitude;
        if(currentLocation.coordinate.longitude > maxLon)
            maxLon = currentLocation.coordinate.longitude;
        if(currentLocation.coordinate.longitude < minLon)
            minLon = currentLocation.coordinate.longitude;
    }
    
    MKCoordinateRegion region;
    region.center.latitude     = (maxLat + minLat) / 2;
    region.center.longitude    = (maxLon + minLon) / 2;
    region.span.latitudeDelta  = 0;//maxLat - minLat;
    region.span.longitudeDelta = maxLon - minLon;
    
    [self.MapView setRegion:region];
    
    NSInteger pointsCount = points.count;
    CLLocationCoordinate2D pointsToUse[pointsCount];
    
    for(int i = 0; i < pointsCount; i++) {
        CLLocation* location = [points objectAtIndex:i];
        pointsToUse[i] = CLLocationCoordinate2DMake(location.coordinate.latitude,location.coordinate.longitude);
    }
    MKPolyline *myPolyline = [MKPolyline polylineWithCoordinates:pointsToUse count:pointsCount];
    
    [self.MapView addOverlay:myPolyline];
    [self.MapView setDelegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    if ([overlay isKindOfClass:MKPolyline.class]) {
        MKPolylineRenderer *lineView = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
        lineView.strokeColor = [UIColor blueColor];
        lineView.lineWidth = 3;
        return lineView;
    }
    return nil;
}

- (IBAction)OnBtnValueChanged:(id)sender {
    switch (_SegmentedCtrl.selectedSegmentIndex) {
        case 0:
            self.MapView.mapType = MKMapTypeStandard;
            break;
        case 1:
            self.MapView.mapType = MKMapTypeHybrid;
            break;
        case 2:
            self.MapView.mapType = MKMapTypeSatellite;
            break;
        default:
            break;
    }
}
@end
