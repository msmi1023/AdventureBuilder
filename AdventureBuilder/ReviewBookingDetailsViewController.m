//
//  ReviewBookingDetailsViewController.m
//  AdventureBuilder
//
//  Created by tstone10 on 7/20/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import "ReviewBookingDetailsViewController.h"

@implementation ReviewBookingDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	_fullName.text = [NSString stringWithFormat:@"%@ %@", _bookingService.booking.customer.firstName, _bookingService.booking.customer.lastName];
	_emailAddress.text = _bookingService.booking.customer.emailAddress;
	_phone.text = _bookingService.booking.customer.phone;
	_adventureType.text = _bookingService.booking.adventure.type;
	_adventure.text = _bookingService.booking.adventure.name;
	_startDate.text = [_bookingService.booking startDateString];
	_endDate.text = [_bookingService.booking endDateString];
	_departingFlight.text = _bookingService.booking.departingFlight.flightNumber;
	_returningFlight.text = _bookingService.booking.returningFlight.flightNumber;
	_totalPrice.text = [NSString stringWithFormat:@"Total Price: $%@",[_bookingService.booking totalPrice]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
