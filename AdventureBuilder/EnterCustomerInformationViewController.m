//
//  EnterCustomerInformationViewController.m
//  AdventureBuilder
//
//  Created by msmi1023 on 7/20/16.

#import "EnterCustomerInformationViewController.h"

@implementation EnterCustomerInformationViewController {
	BOOL emailValid, phoneValid;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	_emailAddress.delegate = self;
	_firstName.delegate = self;
	_lastName.delegate = self;
	_phone.delegate = self;
	
	emailValid = NO;
	phoneValid = NO;
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
	//can't run these directly in the if statement - they will be short-circuited
	if(sender == _emailAddress) {
		emailValid = [super emailValidation:_emailAddress];
	}
	else if(sender == _phone) {
		//[self addDashesToPhone];
		
		phoneValid = [super phoneValidation:_phone];
	}
	
	if(emailValid && ![_firstName.text isEqualToString:@""] &&
	   ![_lastName.text isEqualToString:@""] && phoneValid) {
		self.navigationItem.rightBarButtonItem.enabled = YES;
	}
	else {
		self.navigationItem.rightBarButtonItem.enabled = NO;
	}
}

-(void)autoformatPhone {
	if([_phone.text length] == 3 || [_phone.text length] == 7) {
		_phone.text = [_phone.text stringByAppendingString:@"-"];
	}
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	if(textField == _phone) {
		//if we are adding a new character and just hit a separator
		if(range.length == 0 && range.location == [_phone.text length]) {
			[self autoformatPhone];
		}
	}

	return YES;
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
