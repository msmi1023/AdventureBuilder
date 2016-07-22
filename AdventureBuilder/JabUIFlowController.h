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

#import "ListBookingViewController.h"
#import "EnterCustomerInformationViewController.h"
#import "SelectAdventureViewController.h"
#import "SelectBookingOptionsViewController.h"
#import "SelectDepartingFlightViewController.h"
#import "SelectReturningFlightViewController.h"
#import "ReviewBookingDetailsViewController.h"

@interface JabUIFlowController : NSObject

@property(strong, nonatomic) BookingService *bookingServiceInstance;
@property(strong, nonatomic) UIStoryboard *mainStoryboard;
@property(strong, nonatomic) UIStoryboard *addBookingStoryboard;

-(void)transitionBackFromController:(UIViewController *)vc;
-(id)transitionForwardFromController:(UIViewController *)vc;

-(void)presentInitialAppViewControllerOnWindow:(UIWindow *)window;
-(void)presentInitialViewControllerForStoryboardIdentifier:(NSString *)identifier fromController:(UIViewController *)currentVc;

-(instancetype)init;

+(instancetype)sharedController;

@end
