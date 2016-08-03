#import <Cedar/Cedar.h>
#import "JabUIViewController.h"

#import "ListBookingViewController.h"
#import "EnterCustomerInformationViewController.h"
#import "SelectAdventureViewController.h"
#import "SelectBookingOptionsViewController.h"
#import "SelectDepartingFlightViewController.h"
#import "SelectReturningFlightViewController.h"
#import "ReviewBookingDetailsViewController.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

@interface JabUIViewController (Test)

- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)nextButtonPressed:(id)sender;

-(BOOL)testField:(UITextField *)field withPredicate:(NSPredicate *)test;
- (void)markValidationFailure:(UITextField *)field;
- (void)markValidationSuccess:(UITextField *)field;

@end

SPEC_BEGIN(JabUIViewControllerSpec)

describe(@"JabUIViewController", ^{
    __block JabUIViewController *subject;

    beforeEach(^{
		subject = [[JabUIViewController alloc] init];
    });
	
	it(@"should exist", ^{
		subject should_not be_nil;
	});
	
	it(@"should inherit from the JabUIController class", ^{
		subject.superclass should equal([UIViewController class]);
	});
	
	it(@"should implement the viewWillAppear, cancel button and next button handlers", ^{
		[subject respondsToSelector:@selector(viewWillAppear:)] should be_truthy;
		[subject respondsToSelector:@selector(cancelButtonPressed:)] should be_truthy;
		[subject respondsToSelector:@selector(nextButtonPressed:)] should be_truthy;
	});
	
	describe(@"viewWillAppear:", ^{
		
		it(@"should set the nav items appropriately when presenting the detail view screen from the list", ^{
			subject = [[ReviewBookingDetailsViewController alloc] init];
			((ReviewBookingDetailsViewController *)subject).bookingService = [[BookingService alloc] init];
			((ReviewBookingDetailsViewController *)subject).bookingService.booking = [[Booking alloc] initWithDictionary:@{@"confirmationNumber": @1234}];
			
			[subject viewWillAppear:YES];
			
			subject.navigationItem.rightBarButtonItem should be_nil;
			subject.navigationItem.title should equal(@"1234");
		});
		
		it(@"should set the rightBarButtonItem with the appropriate target and action", ^{
			__block UIViewController *rightButtonTarget;
			__block SEL rightButtonAction;
			
			//need to build a nested mock for the nav items we are dealing with
			spy_on(subject);
			
			UIBarButtonItem *rightBarButtonFake = fake_for([UIBarButtonItem class]);
			rightBarButtonFake stub_method(@selector(setTarget:)).and_do_block(^(id target){
				rightButtonTarget = target;
			});
			rightBarButtonFake stub_method(@selector(target)).and_do_block(^{
				return rightButtonTarget;
			});
			rightBarButtonFake stub_method(@selector(setAction:)).and_do_block(^(SEL action){
				rightButtonAction = action;
			});
			rightBarButtonFake stub_method(@selector(action)).and_do_block(^{
				return rightButtonAction;
			});
			
			UINavigationItem *navItemFake = fake_for([UINavigationItem class]);
			navItemFake stub_method(@selector(rightBarButtonItem)).and_return(rightBarButtonFake);
			
			subject stub_method(@selector(navigationItem)).and_return(navItemFake);
			
			[subject viewWillAppear:YES];
			
			subject.navigationItem.rightBarButtonItem.target should equal(subject);
			subject.navigationItem.rightBarButtonItem.action should equal(@selector(nextButtonPressed:));
		});
		
		it(@"should set the right bar button to disabled for enter customer information, select departing and select returning flights screens", ^{
			subject = [[EnterCustomerInformationViewController alloc] init];
			
			//need to build a nested mock for the nav items we are dealing with
			spy_on(subject);
			
			UIBarButtonItem *rightBarButtonFake = nice_fake_for([UIBarButtonItem class]);
			UIBarButtonItem *leftBarButtonFake = nice_fake_for([UIBarButtonItem class]);
			UINavigationItem *navItemFake = fake_for([UINavigationItem class]);
			navItemFake stub_method(@selector(rightBarButtonItem)).and_return(rightBarButtonFake);
			navItemFake stub_method(@selector(leftBarButtonItem)).and_return(leftBarButtonFake);
			subject stub_method(@selector(navigationItem)).and_return(navItemFake);
			
			[subject viewWillAppear:YES];
			subject.navigationItem.rightBarButtonItem.enabled should be_falsy;
			
			subject = [[SelectDepartingFlightViewController alloc] init];
			
			//need to build a nested mock for the nav items we are dealing with
			spy_on(subject);
			subject stub_method(@selector(navigationItem)).and_return(navItemFake);
			
			[subject viewWillAppear:YES];
			subject.navigationItem.rightBarButtonItem.enabled should be_falsy;
			
			subject = [[SelectReturningFlightViewController alloc] init];
			
			//need to build a nested mock for the nav items we are dealing with
			spy_on(subject);
			subject stub_method(@selector(navigationItem)).and_return(navItemFake);
			
			[subject viewWillAppear:YES];
			subject.navigationItem.rightBarButtonItem.enabled should be_falsy;
		});
		
		it(@"should set the leftBarButtonItem with the appropriate target and action if the controller is an EnterCustomerInformationViewController", ^{
			__block UIViewController *rightButtonTarget, *leftButtonTarget;
			__block SEL rightButtonAction, leftButtonAction;
			
			//need to build a nested mock for the nav items we are dealing with
			subject = [[EnterCustomerInformationViewController alloc] init];
			spy_on(subject);
			
			UIBarButtonItem *rightBarButtonFake = fake_for([UIBarButtonItem class]);
			rightBarButtonFake stub_method(@selector(setTarget:)).and_do_block(^(id target){
				rightButtonTarget = target;
			});
			rightBarButtonFake stub_method(@selector(target)).and_do_block(^{
				return rightButtonTarget;
			});
			rightBarButtonFake stub_method(@selector(setAction:)).and_do_block(^(SEL action){
				rightButtonAction = action;
			});
			rightBarButtonFake stub_method(@selector(action)).and_do_block(^{
				return rightButtonAction;
			});
			rightBarButtonFake stub_method(@selector(setEnabled:));
			rightBarButtonFake stub_method(@selector(isEnabled));
			
			UIBarButtonItem *leftBarButtonFake = fake_for([UIBarButtonItem class]);
			leftBarButtonFake stub_method(@selector(setTarget:)).and_do_block(^(id target){
				leftButtonTarget = target;
			});
			leftBarButtonFake stub_method(@selector(target)).and_do_block(^{
				return leftButtonTarget;
			});
			leftBarButtonFake stub_method(@selector(setAction:)).and_do_block(^(SEL action){
				leftButtonAction = action;
			});
			leftBarButtonFake stub_method(@selector(action)).and_do_block(^{
				return leftButtonAction;
			});
			
			UINavigationItem *navItemFake = fake_for([UINavigationItem class]);
			navItemFake stub_method(@selector(rightBarButtonItem)).and_return(rightBarButtonFake);
			navItemFake stub_method(@selector(leftBarButtonItem)).and_return(leftBarButtonFake);
			
			subject stub_method(@selector(navigationItem)).and_return(navItemFake);
			
			[subject viewWillAppear:YES];
			
			subject.navigationItem.leftBarButtonItem.target should equal(subject);
			subject.navigationItem.leftBarButtonItem.action should equal(@selector(cancelButtonPressed:));

		});
	});
	
	describe(@"cancelButtonPressed", ^{
		it(@"should use the flow controller to transition back from the controller", ^{
			spy_on([JabUIFlowController sharedController]);
			
			[subject cancelButtonPressed:nil];
			[JabUIFlowController sharedController] should have_received(@selector(transitionBackFromController:)).with(subject);
		});
	});
	
	describe(@"nextButtonPressed", ^{
		beforeEach(^{
			spy_on([JabUIFlowController sharedController]);
		});
		
		it(@"should use the flow controller to present the add booking workflow if we are on the ListBooking screen", ^{
			subject = [[ListBookingViewController alloc] init];
			spy_on(subject);
			
			[subject nextButtonPressed:nil];
			[JabUIFlowController sharedController] should have_received(@selector(presentInitialViewControllerForStoryboardIdentifier:fromController:onWindow:)).with(@"AddBooking", subject, nil);
		});
		
		it(@"should use the booking service to create the booking before navigating back if we are on the ReviewBooking screen", ^{
			subject = [[ReviewBookingDetailsViewController alloc] init];
			((ReviewBookingDetailsViewController *)subject).bookingService = [JabUIFlowController sharedController].bookingServiceInstance;
			
			spy_on(subject);
			spy_on(((ReviewBookingDetailsViewController *)subject).bookingService);
			((ReviewBookingDetailsViewController *)subject).bookingService stub_method(@selector(createBookingWithCompletionBlock:));
			
			[subject nextButtonPressed:nil];
			((ReviewBookingDetailsViewController *)subject).bookingService should have_received(@selector(createBookingWithCompletionBlock:));
			[JabUIFlowController sharedController] should have_received(@selector(transitionForwardFromController:)).with(subject);
		});
		
		it(@"should use the flow controller to navigate forward for other controllers", ^{
			[subject nextButtonPressed:nil];
			[JabUIFlowController sharedController] should have_received(@selector(transitionForwardFromController:)).with(subject);
		});
	});
	
	describe(@"phoneValidation: and emailValidation:", ^{
		it(@"should provide phone number and email input validation", ^{
			[subject respondsToSelector:@selector(phoneValidation:)] should be_truthy;
			[subject respondsToSelector:@selector(emailValidation:)] should be_truthy;
		});
		
		it(@"should return false when given a field with invalid phone numbers", ^{
			UITextField *field = [[UITextField alloc] init];
			
			field.text = @"";
			[subject phoneValidation:field] should be_falsy;
			
			field.text = @"asdf";
			[subject phoneValidation:field] should be_falsy;
			
			field.text = @"aaa.aaa.aaaa";
			[subject phoneValidation:field] should be_falsy;
			
			field.text = @"aaa-aaa-aaaa";
			[subject phoneValidation:field] should be_falsy;
			
			field.text = @"111.111.1111";
			[subject phoneValidation:field] should be_falsy;
			
			field.text = @"111-111-11111";
			[subject phoneValidation:field] should be_falsy;
		});
		
		it(@"should return false when given a field with invalid email addresses", ^{
			UITextField *field = [[UITextField alloc] init];
			
			field.text = @"";
			[subject emailValidation:field] should be_falsy;
			
			field.text = @"asdf";
			[subject emailValidation:field] should be_falsy;
			
			field.text = @"asdf@asdf";
			[subject phoneValidation:field] should be_falsy;
			
			field.text = @"asdf.asdf";
			[subject phoneValidation:field] should be_falsy;
			
			field.text = @"asdf@asdf.asdf";
			[subject phoneValidation:field] should be_falsy;
		});
		
		it(@"should return true when given a field with valid phone number or email address", ^{
			UITextField *field = [[UITextField alloc] init];
			
			field.text = @"111-222-3333";
			[subject phoneValidation:field] should be_truthy;
		
			field.text = @"test@test.com";
			[subject emailValidation:field] should be_truthy;
		});
	});
	
	describe(@"testField:withPredicate:", ^{
		it(@"should evaluate the text in the field against the given predicate", ^{
			NSPredicate *pred = nice_fake_for([NSPredicate class]);
			UITextField *field = [[UITextField alloc] init];
			field.text = @"";
			
			[subject testField:field withPredicate:pred];
			
			pred should have_received(@selector(evaluateWithObject:)).with(field.text);
		});
		
		it(@"should call markValidationSuccess and return true if the predicate test passes", ^{
			NSPredicate *pred = nice_fake_for([NSPredicate class]);
			pred stub_method(@selector(evaluateWithObject:)).and_return(YES);
			UITextField *field = [[UITextField alloc] init];
			field.text = @"";
			
			spy_on(subject);
			
			[subject testField:field withPredicate:pred] should be_truthy;
			subject should have_received(@selector(markValidationSuccess:));
		});
		
		it(@"should call markValidationFailure and return false if the predicate test fails", ^{
			NSPredicate *pred = nice_fake_for([NSPredicate class]);
			pred stub_method(@selector(evaluateWithObject:)).and_return(NO);
			UITextField *field = [[UITextField alloc] init];
			field.text = @"";
			
			spy_on(subject);
			
			[subject testField:field withPredicate:pred] should be_falsy;
			subject should have_received(@selector(markValidationFailure:));
		});
	});
});

SPEC_END
