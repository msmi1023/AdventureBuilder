#import <Cedar/Cedar.h>
#import "JabUIViewController.h"

#import "ListBookingViewController.h"
#import "EnterCustomerInformationViewController.h"
#import "ReviewBookingDetailsViewController.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

@interface JabUIViewController (Test)

- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)nextButtonPressed:(id)sender;

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
});

SPEC_END
