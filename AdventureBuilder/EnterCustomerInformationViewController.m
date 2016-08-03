//
//  EnterCustomerInformationViewController.m
//  AdventureBuilder
//
//  Created by tstone10 on 7/20/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import "EnterCustomerInformationViewController.h"

@implementation EnterCustomerInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	_emailAddress.delegate = self;
	_firstName.delegate = self;
	_lastName.delegate = self;
	_phone.delegate = self;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
	if(textField == _emailAddress) {
		_bookingService.booking.customer.emailAddress = _emailAddress.text;
	}
	else if(textField == _firstName) {
		_bookingService.booking.customer.firstName = _firstName.text;
	}
	else if(textField == _lastName) {
		_bookingService.booking.customer.lastName = _lastName.text;
	}
	else if(textField == _phone) {
		_bookingService.booking.customer.phone = _phone.text;
	}
}

-(IBAction)textFieldValueChanged:(id)sender {
	if(![_emailAddress.text isEqualToString:@""] && ![_firstName.text isEqualToString:@""] &&
	   ![_lastName.text isEqualToString:@""] && ![_phone.text isEqualToString:@""]) {
		self.navigationItem.rightBarButtonItem.enabled = YES;
	}
	else {
		self.navigationItem.rightBarButtonItem.enabled = NO;
	}
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
	return YES;
}

// It is important for you to hide the keyboard
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}

@end
