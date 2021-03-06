//
//  JabUIFlowController.m
//  AdventureBuilder
//
//  Created by msmi1023 on 7/22/16.

#import "JabUIFlowController.h"

//need these here for dependency logic. can't have in .h, causes circular deps
#import "ListBookingViewController.h"
#import "EnterCustomerInformationViewController.h"
#import "SelectAdventureViewController.h"
#import "SelectBookingOptionsViewController.h"
#import "SelectDepartingFlightViewController.h"
#import "SelectReturningFlightViewController.h"
#import "ReviewBookingDetailsViewController.h"
#import "ListBookingTableCell.h"

@implementation JabUIFlowController

+(instancetype)sharedController {
	static JabUIFlowController *sharedController;
	static dispatch_once_t token;
	
	dispatch_once(&token, ^{
		sharedController = [[JabUIFlowController alloc] init];
	});
	
	return sharedController;
};

-(instancetype)init {
	self = [super init];
	
	//first time setup - get instances we need and configure the window
	_bookingServiceInstance = [[BookingService alloc] init];
	_adventureServiceInstance = [[AdventureService alloc] init];
	_flightServiceInstance = [[FlightService alloc] init];
	_mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
	_addBookingStoryboard = [UIStoryboard storyboardWithName:@"AddBooking" bundle:nil];
	
	return self;
};

//return navigation controller for some type safety. could be a plain view controller
//return type, but it SHOULD be a navigation controller.
-(UINavigationController *)presentInitialViewControllerForStoryboardIdentifier:(NSString *)identifier fromController:(UIViewController *)currentVc onWindow:(UIWindow *)window {
	UINavigationController *vc;
	if([identifier isEqualToString:@"Main"]) {
		vc = [_mainStoryboard instantiateInitialViewController];
		[self setDependenciesForNavigationController:vc];
		
		window.rootViewController = vc;
		[window makeKeyAndVisible];
	}
	else if([identifier isEqualToString:@"AddBooking"]) {
		vc = [_addBookingStoryboard instantiateInitialViewController];
		[self setDependenciesForNavigationController:vc];
		
		[currentVc presentViewController:vc animated:YES completion:nil];
	}
	
	return vc;
}

-(id)prepareControllerFromStoryboard:(UIStoryboard *)storyboard withIdentifier:(NSString *)identifier {
	UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:identifier];
	
	[self setDependenciesForViewController:vc];
	
	return vc;
}

-(void)transitionBackFromController:(UIViewController *)vc {
	if([vc isKindOfClass:[EnterCustomerInformationViewController class]]) {
		[vc dismissViewControllerAnimated:YES completion:nil];
	}
}

-(void)transitionForwardFromController:(UIViewController *)vc {
	[self transitionForwardFromController:vc fromSender:nil];
};

-(void)transitionForwardFromController:(UIViewController *)vc fromSender:(id)sender {
	if([vc isKindOfClass:[ListBookingViewController class]] && [sender isKindOfClass:[ListBookingTableCell class]]) {
		ReviewBookingDetailsViewController *nextVc = [self prepareControllerFromStoryboard:_addBookingStoryboard withIdentifier:@"ReviewBookingDetails"];
		
		//semantically should probably live in setDeps method, but keeping here due to scoping
		nextVc.bookingService.booking = ((ListBookingTableCell *)sender).booking;
		
		[vc.navigationController pushViewController:nextVc animated:YES];
	}
	else if([vc isKindOfClass:[EnterCustomerInformationViewController class]]) {
		SelectAdventureViewController *nextVc = [self prepareControllerFromStoryboard:_addBookingStoryboard withIdentifier:@"SelectAdventure"];
		
		[vc.navigationController pushViewController:nextVc animated:YES];
	}
	else if([vc isKindOfClass:[SelectAdventureViewController class]]) {
		SelectBookingOptionsViewController *nextVc = [self prepareControllerFromStoryboard:_addBookingStoryboard withIdentifier:@"SelectBookingOptions"];
		
		[vc.navigationController pushViewController:nextVc animated:YES];
	}
	else if([vc isKindOfClass:[SelectBookingOptionsViewController class]]) {
		SelectDepartingFlightViewController *nextVc = [self prepareControllerFromStoryboard:_addBookingStoryboard withIdentifier:@"SelectDepartingFlight"];
		
		[vc.navigationController pushViewController:nextVc animated:YES];
	}
	else if([vc isKindOfClass:[SelectDepartingFlightViewController class]]) {
		SelectReturningFlightViewController *nextVc = [self prepareControllerFromStoryboard:_addBookingStoryboard withIdentifier:@"SelectReturningFlight"];
		
		[vc.navigationController pushViewController:nextVc animated:YES];
	}
	else if([vc isKindOfClass:[SelectReturningFlightViewController class]]) {
		ReviewBookingDetailsViewController *nextVc = [self prepareControllerFromStoryboard:_addBookingStoryboard withIdentifier:@"ReviewBookingDetails"];
		
		[vc.navigationController pushViewController:nextVc animated:YES];
	}
	else if([vc isKindOfClass:[ReviewBookingDetailsViewController class]]) {
		[vc dismissViewControllerAnimated:YES completion:nil];
	}
}

- (void)setDependenciesForNavigationController:(UINavigationController *)nvc {
	for (id childController in [nvc childViewControllers]) {
		[self setDependenciesForViewController:childController];
	}
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
		((SelectAdventureViewController *)vc).adventureService = _adventureServiceInstance;
	}
	else if([vc isKindOfClass:[SelectBookingOptionsViewController class]]) {
		((SelectBookingOptionsViewController *)vc).bookingService = _bookingServiceInstance;
		((SelectBookingOptionsViewController *)vc).flightService = _flightServiceInstance;
	}
	else if([vc isKindOfClass:[SelectDepartingFlightViewController class]]) {
		((SelectDepartingFlightViewController *)vc).bookingService = _bookingServiceInstance;
		((SelectDepartingFlightViewController *)vc).flightService = _flightServiceInstance;
	}
	else if([vc isKindOfClass:[SelectReturningFlightViewController class]]) {
		((SelectReturningFlightViewController *)vc).bookingService = _bookingServiceInstance;
		((SelectReturningFlightViewController *)vc).flightService = _flightServiceInstance;
	}
	else if([vc isKindOfClass:[ReviewBookingDetailsViewController class]]) {
		((ReviewBookingDetailsViewController *)vc).bookingService = _bookingServiceInstance;
	}
}

@end