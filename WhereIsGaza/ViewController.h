//
//  ViewController.h
//  WhereIsGaza
//
//  Created by Nadav Vanunu on 7/12/14.
//  Copyright (c) 2014 Nadav Vanunu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreMotion/CoreMotion.h>

@interface ViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate> {
    CLLocationManager *locationManager;
}
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) MKPolyline *routeLine; //your line
@property (nonatomic, retain) MKPolylineView *routeLineView; //overlay view
@property (nonatomic) MKUserLocation * lastLocation;
@property (nonatomic) CMMotionManager *motionManager;

- (IBAction)tapOnMapOccured:(id)sender;

@end
