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
    float spanX = 0.00725;
    float spanY = 0.00725;
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
}


- (void)updateMap:(MKUserLocation *)location
{

    float spanX = 0.00725;
    float spanY = 0.00725;
    MKCoordinateRegion region;
    region.center.latitude = location.coordinate.latitude;
    region.center.longitude = location.coordinate.longitude;
    region.span.latitudeDelta = spanX;
    region.span.longitudeDelta = spanY;
    
    [self.mapView setRegion:region animated:YES];
    
    CLLocationCoordinate2D coordinateArray[2];
    coordinateArray[0] = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
    coordinateArray[1] = CLLocationCoordinate2DMake(31.4167, 34.3333);

    if (self.routeLine) {
        [self.mapView removeOverlay:self.routeLine];
    }
    self.routeLine = [MKPolyline polylineWithCoordinates:coordinateArray count:2];
    //[self.mapView setVisibleMapRect:[self.routeLine boundingMapRect]]; //If you want the route to be visible
    [self.mapView addOverlay:self.routeLine];
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
    [self.mapView setCenterCoordinate:userLocation.coordinate animated:YES];
    //[self.mapView addOverlay:self.routeLine];
    [self updateMap:userLocation];
}


@end
