//
//  SelectBookingOptionsViewController.m
//  AdventureBuilder
//
//  Created by msmi1023 on 7/20/16.

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
	[self startDateSelected:nil];
	[self endDateSelected:nil];
	
	_notes.delegate = self;
	_notes.text = @"Enter notes here...";
	_notes.textColor = [UIColor lightGrayColor];
	_notes.layer.borderColor = [[UIColor grayColor] CGColor];
	_notes.layer.cornerRadius = 5;
	
	[_flightService getMaxFlightPricesWithCompletionBlock:^(id response){
		maxFlightPrices = response;
		
		[_maxFlightPrice reloadAllComponents];
		
		//on load we default to 0,0 selection. kick off our didSelect calls
		[self pickerView:_maxFlightPrice didSelectRow:0 inComponent:0];
	}];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
	if([textView.text isEqualToString:@"Enter notes here..."]) {
		textView.text = @"";
		textView.textColor = [UIColor blackColor];
	}
	
	[textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
	_bookingService.booking.note = textView.text;
	
	if([textView.text isEqualToString:@""]) {
		textView.text = @"Enter notes here...";
		textView.textColor = [UIColor lightGrayColor];
	}
	
	[textView resignFirstResponder];
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
