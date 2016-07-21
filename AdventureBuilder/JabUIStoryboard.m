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
	
	[self setDependenciesForViewController:viewController];
	
	return viewController;
}

- (void)setDependenciesForViewController:(UIViewController *)vc {
	if([vc isKindOfClass:[UINavigationController class]]) {
		for (id childController in [vc childViewControllers]) {
			if([childController isKindOfClass:[ListBookingViewController class]]) {
				((ListBookingViewController *)childController).bookingService = _bookingServiceInstance;
			}
			else if([childController isKindOfClass:[EnterCustomerInformationViewController class]]) {
				((EnterCustomerInformationViewController *)childController).bookingService = _bookingServiceInstance;
			}
		}
	}
}

@end
