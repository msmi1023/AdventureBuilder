//
//  JabUIFlowController.h
//  AdventureBuilder
//
//  Created by tstone10 on 7/22/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BookingService.h"
#import "AdventureService.h"
#import "FlightService.h"

@interface JabUIFlowController : NSObject

@property(strong, nonatomic) BookingService *bookingServiceInstance;
@property(strong, nonatomic) AdventureService *adventureServiceInstance;
@property(strong, nonatomic) FlightService *flightServiceInstance;
@property(strong, nonatomic) UIStoryboard *mainStoryboard;
@property(strong, nonatomic) UIStoryboard *addBookingStoryboard;

-(void)transitionBackFromController:(UIViewController *)vc;
-(void)transitionForwardFromController:(UIViewController *)vc;

-(UINavigationController *)presentInitialViewControllerForStoryboardIdentifier:(NSString *)identifier fromController:(UIViewController *)currentVc onWindow:(UIWindow *)window;

+(instancetype)sharedController;

@end
