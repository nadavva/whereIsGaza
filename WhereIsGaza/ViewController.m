//
//  ViewController.m
//  WhereIsGaza
//
//  Created by Nadav Vanunu on 7/12/14.
//  Copyright (c) 2014 Nadav Vanunu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mapView.delegate = self;

	// Do any additional setup after loading the view, typically from a nib.
    float spanX = 0.00025;
    float spanY = 0.00025;
    MKCoordinateRegion region;
    region.center.latitude = self.mapView.userLocation.coordinate.latitude;
    region.center.longitude = self.mapView.userLocation.coordinate.longitude;
    region.span.latitudeDelta = spanX;
    region.span.longitudeDelta = spanY;
    
    [self.mapView setRegion:region animated:YES];
    [self.mapView setUserTrackingMode:MKUserTrackingModeFollowWithHeading];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    
    
    self.motionManager = [[CMMotionManager alloc] init];
    
    
    //Gyroscope
    if([self.motionManager isGyroAvailable])
    {
        /* Start the gyroscope if it is not active already */
        if([self.motionManager isGyroActive] == NO)
        {
            /* Update us 2 times a second */
            [self.motionManager setGyroUpdateInterval:1.0f / 2.0f];
            
            /* Add on a handler block object */
            
            /* Receive the gyroscope data on this block */
            [self.motionManager startGyroUpdatesToQueue:[NSOperationQueue mainQueue]
                                            withHandler:^(CMGyroData *gyroData, NSError *error)
             {
//                 NSString *x = [[NSString alloc] initWithFormat:@"%.02f",gyroData.rotationRate.x];
//                 NSLog(@"X = %@",x);
//                 
//                 NSString *y = [[NSString alloc] initWithFormat:@"%.02f",gyroData.rotationRate.y];
//                 NSLog(@"Y = %@",y);
//                 
//                 NSString *z = [[NSString alloc] initWithFormat:@"%.02f",gyroData.rotationRate.z];
//                 NSLog(@"Z = %@",z);
//                 
//                 NSLog(@"-------------------------------------------------------");
                 
                 if (gyroData.rotationRate.z > 0.2) {
                     [self updateMap];
                 }

             }];
        }
    }
    else
    {
        NSLog(@"Gyroscope not Available!");
    }
}


- (void) updateMap
{
    [self focusOnRegion];

    CLLocationCoordinate2D coordinateArray[2];
    coordinateArray[0] = CLLocationCoordinate2DMake(_lastLocation.coordinate.latitude, _lastLocation.coordinate.longitude);
    coordinateArray[1] = CLLocationCoordinate2DMake(31.4167, 34.3333);

    self.routeLine = [MKPolyline polylineWithCoordinates:coordinateArray count:2];
    //[self.mapView setVisibleMapRect:[self.routeLine boundingMapRect]]; //If you want the route to be visible
    [self.mapView addOverlay:self.routeLine];
}

- (void) focusOnRegion
{
    [self.mapView setCenterCoordinate:_lastLocation.coordinate animated:YES];
    float spanX = 0.00025;
    float spanY = 0.00025;
    MKCoordinateRegion region;
    region.center.latitude = _lastLocation.coordinate.latitude;
    region.center.longitude = _lastLocation.coordinate.longitude;
    region.span.latitudeDelta = spanX;
    region.span.longitudeDelta = spanY;
    [self.mapView setRegion:region animated:YES];

}

-(MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay
{
    if(overlay == self.routeLine)
    {
        if(nil == self.routeLineView)
        {
            self.routeLineView = [[MKPolylineView alloc] initWithPolyline:self.routeLine] ;
            self.routeLineView.fillColor = [UIColor redColor];
            self.routeLineView.strokeColor = [UIColor redColor];
            self.routeLineView.lineWidth = 5;
        }
        return self.routeLineView;
    }
    return nil;
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    _lastLocation = userLocation;
    [self updateMap];
}


- (IBAction)tapOnMapOccured:(id)sender {
    [self focusOnRegion];
}
@end
