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
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
	
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

- (void)viewWillDisappear:(BOOL)animated {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
	CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
	
	[UIView animateWithDuration:0.3 animations:^{
		CGRect f = self.view.frame;
		f.origin.y = -keyboardSize.height;
		self.view.frame = f;
	}];
}

- (void)keyboardWillHide:(NSNotification *)notification {
	[UIView animateWithDuration:0.3 animations:^{
		CGRect f = self.view.frame;
		f.origin.y = 0.0f;
		self.view.frame = f;
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

//if this fires, the user didn't tap on a text field.
//don't even need to check anything, just end editing.
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[self.view endEditing:YES];
	[super touchesBegan:touches withEvent:event];
}

@end
