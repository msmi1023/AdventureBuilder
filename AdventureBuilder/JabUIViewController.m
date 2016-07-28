//
//  JabUIViewController.m
//  AdventureBuilder
//
//  Created by tstone10 on 7/22/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import "JabUIViewController.h"

//need these here for dependency logic. can't have in .h, causes circular deps
#import "ListBookingViewController.h"
#import "EnterCustomerInformationViewController.h"
#import "ReviewBookingDetailsViewController.h"

@implementation JabUIViewController

-(void)viewWillAppear:(BOOL)animated {
	self.navigationItem.rightBarButtonItem.target = self;
	self.navigationItem.rightBarButtonItem.action = @selector(nextButtonPressed:);
	
	if([self isKindOfClass:[EnterCustomerInformationViewController class]]) {
		self.navigationItem.leftBarButtonItem.target = self;
		self.navigationItem.leftBarButtonItem.action = @selector(cancelButtonPressed:);
	}
}

- (IBAction)cancelButtonPressed:(id)sender {
	[[JabUIFlowController sharedController] transitionBackFromController:self];
}

- (IBAction)nextButtonPressed:(id)sender {
	if([self isKindOfClass:[ListBookingViewController class]]) {
		[[JabUIFlowController sharedController] presentInitialViewControllerForStoryboardIdentifier:@"AddBooking" fromController:self onWindow:nil ];
	}
	else {
		if([self isKindOfClass:[ReviewBookingDetailsViewController class]]) {
			[((ReviewBookingDetailsViewController *) self).bookingService createBookingWithCompletionBlock:^(id response){
				
			}];
		}
		
		[[JabUIFlowController sharedController] transitionForwardFromController:self];
	}
}

@end
