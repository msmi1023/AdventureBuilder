//
//  ListBookingViewController.m
//  AdventureBuilder
//
//  Created by tstone10 on 7/14/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import "ListBookingViewController.h"
#import "BookingService.h"
#import "JabApiManager.h"

@implementation ListBookingViewController


- (IBAction)buttonPressed:(id)sender {
	
	//set up our service with DI pattern
	BookingService *svc = [[BookingService alloc] initWithApiManager:[JabApiManager sharedManager]];
	
	[svc getBookingsWithCompletionBlock:^(id response) {
		NSLog(@"++++++++++++responsy stuff: %@", response);
	}];
}

@end
