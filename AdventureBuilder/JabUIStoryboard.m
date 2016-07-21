//
//  JabUIStoryboard.m
//  AdventureBuilder
//
//  Created by tstone10 on 7/21/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import "JabUIStoryboard.h"
#import "ListBookingViewController.h"
#import "EnterCustomerInformationViewController.h"
#import "SelectAdventureViewController.h"
#import "SelectBookingOptionsViewController.h"
#import "SelectDepartingFlightViewController.h"
#import "SelectReturningFlightViewController.h"
#import "ReviewBookingDetailsViewController.h"

//this storyboard subclass will override the default controller initialization code.
//this will allow us to add code here to give the controllers the dependencies they need.
//found this idea here:
//https://github.com/briancroom/BlindsidedStoryboard/blob/master/Pod/Classes/BlindsidedStoryboardClass.m

@implementation JabUIStoryboard

//override storyboardWithName so we return our instance instead of the default
+ (instancetype)storyboardWithName:(NSString *)name bundle:(NSBundle *)storyboardBundleOrNil {
	JabUIStoryboard *storyboard = (JabUIStoryboard *)[super storyboardWithName:name bundle:storyboardBundleOrNil];
	storyboard.bookingServiceInstance = [[BookingService alloc] init];
	return storyboard;
}

//override default behaviors for starting up a controller! the real meat of this subclass.
- (id)instantiateViewControllerWithIdentifier:(NSString *)identifier {
	UIViewController *viewController;
	viewController = [super instantiateViewControllerWithIdentifier:identifier];
	
	if([viewController isKindOfClass:[UINavigationController class]]) {
		for (id childController in [viewController childViewControllers]) {
			[self setDependenciesForViewController:childController];
		}
	} else {
		[self setDependenciesForViewController:viewController];
	}
	return viewController;
}

- (void)setDependenciesForViewController:(UIViewController *)vc {
	if([vc isKindOfClass:[ListBookingViewController class]]) {
		((ListBookingViewController *)vc).bookingService = _bookingServiceInstance;
	}
	else if([vc isKindOfClass:[EnterCustomerInformationViewController class]]) {
		((EnterCustomerInformationViewController *)vc).bookingService = _bookingServiceInstance;
	}
	else if([vc isKindOfClass:[SelectAdventureViewController class]]) {
		((SelectAdventureViewController *)vc).bookingService = _bookingServiceInstance;
	}
	else if([vc isKindOfClass:[SelectBookingOptionsViewController class]]) {
		((SelectBookingOptionsViewController *)vc).bookingService = _bookingServiceInstance;
	}
	else if([vc isKindOfClass:[SelectDepartingFlightViewController class]]) {
		((SelectDepartingFlightViewController *)vc).bookingService = _bookingServiceInstance;
	}
	else if([vc isKindOfClass:[SelectReturningFlightViewController class]]) {
		((SelectReturningFlightViewController *)vc).bookingService = _bookingServiceInstance;
	}
	else if([vc isKindOfClass:[ReviewBookingDetailsViewController class]]) {
		((ReviewBookingDetailsViewController *)vc).bookingService = _bookingServiceInstance;
	}
}

@end
