//
//  JabUIViewController.m
//  AdventureBuilder
//
//  Created by msmi1023 on 7/22/16.

#import "JabUIViewController.h"

//need these here for dependency logic. can't have in .h, causes circular deps
#import "ListBookingViewController.h"
#import "EnterCustomerInformationViewController.h"
#import "SelectAdventureViewController.h"
#import "SelectBookingOptionsViewController.h"
#import "SelectDepartingFlightViewController.h"
#import "SelectReturningFlightViewController.h"
#import "ReviewBookingDetailsViewController.h"

@implementation JabUIViewController

-(void)viewWillAppear:(BOOL)animated {
	//this checks to see if we are loading up the detail view from the list booking screen.
	//if we are, adjust the nav items to reflect this.
	if([self isKindOfClass:[ReviewBookingDetailsViewController class]] && self.navigationController.childViewControllers.count < 3) {
		self.navigationItem.title = [((ReviewBookingDetailsViewController *)self).bookingService.booking.confirmationNumber stringValue];
		self.navigationItem.rightBarButtonItem = nil;
	}
	else {
		//adventure and booking options select screens start with pre-selected values.
		//no need to disable the button there.
		//review booking screen doesn't require selections, so no need to disable there either.
		if([self isKindOfClass:[EnterCustomerInformationViewController class]] || [self isKindOfClass:[SelectDepartingFlightViewController class]] ||
		   [self isKindOfClass:[SelectReturningFlightViewController class]]) {
			self.navigationItem.rightBarButtonItem.enabled = NO;
		}
		self.navigationItem.rightBarButtonItem.target = self;
		self.navigationItem.rightBarButtonItem.action = @selector(nextButtonPressed:);
	}
	
	if([self isKindOfClass:[EnterCustomerInformationViewController class]]) {
		self.navigationItem.leftBarButtonItem.target = self;
		self.navigationItem.leftBarButtonItem.action = @selector(cancelButtonPressed:);
	}
	
	[super viewWillAppear:animated];
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
			[((ReviewBookingDetailsViewController *) self).bookingService createBookingWithCompletionBlock:nil];
		}
		
		[[JabUIFlowController sharedController] transitionForwardFromController:self];
	}
}

- (BOOL)phoneValidation:(id)sender {
	NSString *regex = @"[0-9]{3}+[-][0-9]{3}+[-][0-9]{4}|[0-9]{10}";
	NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
	
	return [self testField:((UITextField *)sender) withPredicate:test];
}

- (BOOL)emailValidation:(id)sender {
	NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
	NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
	
	return [self testField:((UITextField *)sender) withPredicate:test];
}

-(BOOL)testField:(UITextField *)field withPredicate:(NSPredicate *)test {
	if([test evaluateWithObject:field.text]){
		[self markValidationSuccess:field];
		return YES;
	}
	else {
		[self markValidationFailure:field];
		return NO;
	}
}

- (void)markValidationFailure:(UITextField *)field {
	field.layer.borderWidth = 1.0f;
	field.layer.borderColor = [[UIColor redColor] CGColor];
	field.layer.cornerRadius = 5;
	field.clipsToBounds = YES;
}

- (void)markValidationSuccess:(UITextField *)field {
	field.layer.borderWidth = 1.0f;
	field.layer.borderColor = [[UIColor clearColor] CGColor];
	field.layer.cornerRadius = 5;
	field.clipsToBounds = YES;
}

@end
