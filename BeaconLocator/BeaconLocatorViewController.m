//
//  BeaconLocatorViewController.m
//  BeaconLocator
//
//  Created by Joris Verbogt on 12/12/13.
//  Copyright (c) 2013 Notificare. All rights reserved.
//

#import "BeaconLocatorViewController.h"

@interface BeaconLocatorViewController ()
- (void) displayBeacon:(CLBeacon *)beacon;
- (void) clearDisplay;
- (void) sendNotification:(NSString *) message;
@end

@implementation BeaconLocatorViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set up an iBeacon region for our own UUID
    _beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:@"fa676db0-1568-4823-a490-1e94337756f4"] identifier:@"Notificare"];
//    [_beaconRegion setNotifyEntryStateOnDisplay:YES];
    [_beaconRegion setNotifyOnEntry:YES];
    [_beaconRegion setNotifyOnExit:YES];

    // Start locationManager
    _locationManager = [[CLLocationManager alloc] init];
    [_locationManager setDelegate:self];
    [_locationManager startMonitoringForRegion:_beaconRegion];
    [self setRanging:NO];
    [self clearDisplay];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
    NSLog(@"Monitoring failed: %@", error.localizedDescription);
}

- (void) locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region {
    NSLog(@"Region state changed for %@",[region identifier]);
}

- (void) locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    NSLog(@"Entered region for %@",[region identifier]);
    if ([CLLocationManager isRangingAvailable] == YES) {
        [_locationManager startRangingBeaconsInRegion:(CLBeaconRegion *)region];
        [self setRanging:YES];
    }
    [self sendNotification:[NSString stringWithFormat:@"Welcome to %@", [region identifier]]];
}

- (void) locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    [_locationManager stopRangingBeaconsInRegion:(CLBeaconRegion *)region];
    [self setRanging:NO];
    NSLog(@"Exit region for %@",[region identifier]);
    [self clearDisplay];
    [self sendNotification:[NSString stringWithFormat:@"Goodbye, hope to see you soon at %@", [region identifier]]];
    [_locationManager startMonitoringForRegion:_beaconRegion];
}

- (void) locationManager:(CLLocationManager *)manager rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region withError:(NSError *)error {
    NSLog(@"Ranging failed: %@", error.localizedDescription);
    [self setRanging:NO];
}

- (void) locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    NSLog(@"Ranging %@ beacons for %@",
          [NSNumber numberWithUnsignedInteger:[beacons count]],
          [[region proximityUUID] UUIDString]);

    if ([self ranging] == YES && [beacons count] > 0) {
        [self displayBeacon:[beacons objectAtIndex:0]];
    }
}

- (void) displayBeacon:(CLBeacon *)beacon {
    [_beaconMajorLabel setText:[NSString stringWithFormat:@"Major %@",[beacon major]]];
    [_beaconMinorLabel setText:[NSString stringWithFormat:@"Minor%@",[beacon major]]];
    [_beaconRSSILabel setText:[NSString stringWithFormat:@"RSSI %@",[NSNumber numberWithInteger:[beacon rssi]]]];
}

- (void) clearDisplay {
    [_beaconMajorLabel setText:@""];
    [_beaconMinorLabel setText:@""];
    [_beaconRSSILabel setText:@""];
}

- (void) sendNotification:(NSString *) message {
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    if (notification != nil) {
        [notification setAlertBody:message];
        [notification setAlertAction:NSLocalizedString(@"OK", nil)];
        [notification setSoundName:UILocalNotificationDefaultSoundName];
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}

@end
