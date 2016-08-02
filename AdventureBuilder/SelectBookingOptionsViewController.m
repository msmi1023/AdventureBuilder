//
//  SelectBookingOptionsViewController.m
//  AdventureBuilder
//
//  Created by tstone10 on 7/20/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import "SelectBookingOptionsViewController.h"

@implementation SelectBookingOptionsViewController {
	NSArray *maxFlightPrices;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	_maxFlightPrice.delegate = self;
	_maxFlightPrice.dataSource = self;
	
	_startDate.date = [[NSDate alloc] init];
	_endDate.date = [[NSDate alloc] init];
	
	[_flightService getMaxFlightPricesWithCompletionBlock:^(id response){
		maxFlightPrices = response;
		
		[_maxFlightPrice reloadAllComponents];
		
		//on load we default to 0,0 selection. kick off our didSelect calls
		[self pickerView:_maxFlightPrice didSelectRow:0 inComponent:0];
	}];
}

- (IBAction)startDateSelected:(id)sender {
	_bookingService.booking.startDate = _startDate.date;
}

- (IBAction)endDateSelected:(id)sender {
	_bookingService.booking.endDate = _endDate.date;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return maxFlightPrices.count;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
	return maxFlightPrices[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	_flightService.maxFlightPrice = maxFlightPrices[row];
}


@end
