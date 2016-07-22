//
//  JabUIFlowController.m
//  AdventureBuilder
//
//  Created by tstone10 on 7/22/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import "JabUIFlowController.h"

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
	
	if(!self) {
		return nil;
	}
	
	//first time setup - get instances we need and configure the window
	_bookingServiceInstance = [[BookingService alloc] init];
	_mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
	_addBookingStoryboard = [UIStoryboard storyboardWithName:@"AddBooking" bundle:nil];
	
	return self;
};

-(void)presentInitialAppViewControllerOnWindow:(UIWindow *)window {
	UIViewController *vc = [_mainStoryboard instantiateInitialViewController];
	
	[self setDependenciesForNavigationController:vc];
	
	window.rootViewController = vc;
	
	[window makeKeyAndVisible];
}

-(void)presentInitialViewControllerForStoryboardIdentifier:(NSString *)identifier fromController:(UIViewController *)currentVc {
	if([identifier isEqualToString:@"AddBooking"]) {
		UIViewController *vc = [_addBookingStoryboard instantiateInitialViewController];
		
		[self setDependenciesForNavigationController:vc];
		
		[currentVc presentViewController:vc animated:YES completion:nil];
	}
}

-(id)prepareControllerFromStoryboard:(UIStoryboard *)storyboard WithIdentifier:(NSString *)identifier {
	UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:identifier];
	
	[self setDependenciesForViewController:vc];
	
	return vc;
}

-(void)transitionBackFromController:(UIViewController *)vc {
	if([vc isKindOfClass:[EnterCustomerInformationViewController class]]) {
		[vc dismissViewControllerAnimated:YES completion:nil];
	}
}

-(id)transitionForwardFromController:(UIViewController *)vc {
	if([vc isKindOfClass:[EnterCustomerInformationViewController class]]) {
		SelectAdventureViewController *nextVc = [self prepareControllerFromStoryboard:_addBookingStoryboard WithIdentifier:@"SelectAdventure"];
		
		[vc.navigationController pushViewController:nextVc animated:YES];
	}
	else if([vc isKindOfClass:[SelectAdventureViewController class]]) {
		SelectBookingOptionsViewController *nextVc = [self prepareControllerFromStoryboard:_addBookingStoryboard WithIdentifier:@"SelectBookingOptions"];
		
		[vc.navigationController pushViewController:nextVc animated:YES];
	}
	else if([vc isKindOfClass:[SelectBookingOptionsViewController class]]) {
		SelectDepartingFlightViewController *nextVc = [self prepareControllerFromStoryboard:_addBookingStoryboard WithIdentifier:@"SelectDepartingFlight"];
		
		[vc.navigationController pushViewController:nextVc animated:YES];
	}
	else if([vc isKindOfClass:[SelectDepartingFlightViewController class]]) {
		SelectReturningFlightViewController *nextVc = [self prepareControllerFromStoryboard:_addBookingStoryboard WithIdentifier:@"SelectReturningFlight"];
		
		[vc.navigationController pushViewController:nextVc animated:YES];
	}
	else if([vc isKindOfClass:[SelectReturningFlightViewController class]]) {
		ReviewBookingDetailsViewController *nextVc = [self prepareControllerFromStoryboard:_addBookingStoryboard WithIdentifier:@"ReviewBookingDetails"];
		
		[vc.navigationController pushViewController:nextVc animated:YES];
	}
	else if([vc isKindOfClass:[ReviewBookingDetailsViewController class]]) {
		[vc dismissViewControllerAnimated:YES completion:nil];
	}
	
	return nil;
}

- (id)instantiateViewControllerWithIdentifier:(NSString *)identifier {
//	UIViewController *viewController;
//	viewController = [super instantiateViewControllerWithIdentifier:identifier];
//	
//	if([viewController isKindOfClass:[UINavigationController class]]) {
//		for (id childController in [viewController childViewControllers]) {
//			[self setDependenciesForViewController:childController];
//		}
//	} else {
//		[self setDependenciesForViewController:viewController];
//	}
//	return viewController;
	
	return nil;
}

- (void)setDependenciesForNavigationController:(UIViewController *)nvc {
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

//since we are using our custom storyboard, need to init it here
//JabUIStoryboard *storyboard = [JabUIStoryboard storyboardWithName:@"Main" bundle:nil];
//UIViewController *vc = [storyboard instantiateInitialViewController];
//self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//self.window.rootViewController = vc;
//
//[self.window makeKeyAndVisible];

@end