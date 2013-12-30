//
//  BeaconLocatorViewController.h
//  BeaconLocator
//
//  Created by Joris Verbogt on 12/12/13.
//  Copyright (c) 2013 Notificare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface BeaconLocatorViewController : UIViewController <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLBeaconRegion *beaconRegion;
@property (nonatomic, assign) BOOL ranging;
@property (weak, nonatomic) IBOutlet UILabel *beaconRSSILabel;
@property (weak, nonatomic) IBOutlet UILabel *beaconMajorLabel;
@property (weak, nonatomic) IBOutlet UILabel *beaconMinorLabel;


@end
