#import <Cedar/Cedar.h>
#import "JabUIFlowController.h"

#import "ListBookingViewController.h"
#import "EnterCustomerInformationViewController.h"
#import "SelectAdventureViewController.h"
#import "SelectBookingOptionsViewController.h"
#import "SelectDepartingFlightViewController.h"
#import "SelectReturningFlightViewController.h"
#import "ReviewBookingDetailsViewController.h"

#import "ListBookingTableCell.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

//get ourselves access to the normal init method.
//step around the singleton for test purposes
@interface JabUIFlowController (Test)

-(instancetype)init;
-(void)setDependenciesForNavigationController:(UINavigationController *)nvc;
- (void)setDependenciesForViewController:(UIViewController *)vc;
-(id)prepareControllerFromStoryboard:(UIStoryboard *)storyboard withIdentifier:(NSString *)identifier;

@end

SPEC_BEGIN(JabUIFlowControllerSpec)

describe(@"JabUIFlowController", ^{
	__block JabUIFlowController *subject;
	
	it(@"should respond to the sharedController class method", ^{
		[JabUIFlowController respondsToSelector:@selector(sharedController)] should be_truthy;
	});
	
	it(@"should return a JabUIFlowController instance from the sharedController call", ^{
		subject = [JabUIFlowController sharedController];
		[subject isKindOfClass:[JabUIFlowController class]] should be_truthy;
	});
	
	it(@"should return the same instance on subsequent sharedController calls", ^{
		subject = [JabUIFlowController sharedController];
		JabUIFlowController *newResult = [JabUIFlowController sharedController];
		
		newResult == subject should be_truthy;
	});
	
	it(@"should return an instance with bookingService, adventureService, flightService, mainStoryboard and addBookingStoryboard references", ^{
		subject = [JabUIFlowController sharedController];
		
		[subject.bookingServiceInstance isKindOfClass:[BookingService class]] should be_truthy;
		[subject.adventureServiceInstance isKindOfClass:[AdventureService class]] should be_truthy;
		[subject.flightServiceInstance isKindOfClass:[FlightService class]] should be_truthy;
		[subject.mainStoryboard isKindOfClass:[UIStoryboard class]] should be_truthy;
		[subject.mainStoryboard valueForKey:@"name"] should equal(@"Main");
		[subject.addBookingStoryboard isKindOfClass:[UIStoryboard class]] should be_truthy;
		[subject.addBookingStoryboard valueForKey:@"name"] should equal(@"AddBooking");
	});
	
	describe(@"presentInitialViewControllerForStoryboardIdentifier:fromController:onWindow", ^{
		__block UIWindow *window;
		__block UIViewController *currentVc;
		
		beforeEach(^{
			subject = [[JabUIFlowController alloc] init];
			spy_on(subject);
			spy_on(subject.mainStoryboard);
			spy_on(subject.addBookingStoryboard);
			
			window = [[UIWindow alloc] init];
			spy_on(window);
			
			currentVc = [[UIViewController alloc] init];
			spy_on(currentVc);
		});
		
		it(@"should make the returned controller active on the given window", ^{
			UINavigationController *vc = [subject presentInitialViewControllerForStoryboardIdentifier:@"Main" fromController:nil onWindow:window];
			
			//should get the controller from the main storyboard
			subject.mainStoryboard should have_received(@selector(instantiateInitialViewController));
			//shuld set its dependencies
			subject should have_received(@selector(setDependenciesForNavigationController:));
			
			//should make it active on the window
			window.rootViewController should equal(vc);
			window should have_received(@selector(makeKeyAndVisible));
		});
		
		it(@"should make the returned controller active by calling presentViewController on the passed in controller", ^{
			[subject presentInitialViewControllerForStoryboardIdentifier:@"AddBooking" fromController:currentVc onWindow:nil];
			
			//should get the controller from the addBooking storyboard
			subject.addBookingStoryboard should have_received(@selector(instantiateInitialViewController));
			//shuld set its dependencies
			subject should have_received(@selector(setDependenciesForNavigationController:));
			
			//should make it active via the presentViewController call
			currentVc should have_received(@selector(presentViewController:animated:completion:));
		});
	});
	
	describe(@"prepareControllerFromStoryboard:withIdentifier:", ^{
		beforeEach(^{
			subject = [[JabUIFlowController alloc] init];
			
			spy_on(subject);
			spy_on(subject.addBookingStoryboard);
		});
		
		it(@"should grab the appropriate controller from the passed in storyboard, set its dependencies and return it", ^{
			UIViewController *vc = [subject prepareControllerFromStoryboard:subject.addBookingStoryboard withIdentifier:@"SelectAdventure"];
			
			//should get the controller from the main storyboard
			subject.addBookingStoryboard should have_received(@selector(instantiateViewControllerWithIdentifier:));
			//shuld set its dependencies
			subject should have_received(@selector(setDependenciesForViewController:));
			
			[vc isKindOfClass:[SelectAdventureViewController class]] should be_truthy;
		});
	});
	
	describe(@"transitionBackFromController:", ^{
		__block EnterCustomerInformationViewController *evc = [[EnterCustomerInformationViewController alloc] init];
		__block UIViewController *ovc = [[UIViewController alloc] init];
		
		beforeEach(^{
			subject = [[JabUIFlowController alloc] init];
			
			spy_on(subject);
			
			spy_on(evc);
			spy_on(ovc);
		});
		
		it(@"should dismiss the controller if the passed in vc is an EnterCustomerInformationViewController", ^{
			[subject transitionBackFromController:evc];
			evc should have_received(@selector(dismissViewControllerAnimated:completion:));
		});
		it(@"should not attempt a dismissal if any other controller type is passed in", ^{
			[subject transitionBackFromController:ovc];
			ovc should_not have_received(@selector(dismissViewControllerAnimated:completion:));

		});
	});
	
	describe(@"transitionForwardFromController:", ^{
		__block ListBookingViewController *vc0;
		__block EnterCustomerInformationViewController *vc1;
		__block SelectAdventureViewController *vc2;
		__block SelectBookingOptionsViewController *vc3;
		__block SelectDepartingFlightViewController *vc4;
		__block SelectReturningFlightViewController *vc5;
		__block ReviewBookingDetailsViewController *vc6;
		__block UINavigationController *mockNavVc;
		__block NSArray *args;
		
		beforeEach(^{
			subject = [[JabUIFlowController alloc] init];
			spy_on(subject);
			
			//need to mock a nav controller into all of these vcs.
			mockNavVc = nice_fake_for([UINavigationController class]);
			mockNavVc stub_method(@selector(pushViewController:animated:))
			.and_do_block(^(UIViewController *viewController, BOOL animated){
				args = @[viewController, [NSNumber numberWithBool:animated]];
			});
			
			vc0 = [[ListBookingViewController alloc] init];
			spy_on(vc0);
			vc0 stub_method(@selector(navigationController)).and_return(mockNavVc);
			
			vc1 = [[EnterCustomerInformationViewController alloc] init];
			spy_on(vc1);
			vc1 stub_method(@selector(navigationController)).and_return(mockNavVc);
			
			vc2 = [[SelectAdventureViewController alloc] init];
			spy_on(vc2);
			vc2 stub_method(@selector(navigationController)).and_return(mockNavVc);
			
			vc3 = [[SelectBookingOptionsViewController alloc] init];
			spy_on(vc3);
			vc3 stub_method(@selector(navigationController)).and_return(mockNavVc);
			
			vc4 = [[SelectDepartingFlightViewController alloc] init];
			spy_on(vc4);
			vc4 stub_method(@selector(navigationController)).and_return(mockNavVc);
			
			vc5 = [[SelectReturningFlightViewController alloc] init];
			spy_on(vc5);
			vc5 stub_method(@selector(navigationController)).and_return(mockNavVc);
			
			vc6 = [[ReviewBookingDetailsViewController alloc] init];
			spy_on(vc6);
			vc6 stub_method(@selector(navigationController)).and_return(mockNavVc);
			
		});
		
		it(@"should call the two-arg method if the single arg version is called", ^{
			[subject transitionForwardFromController:nil];
			
			subject should have_received(@selector(transitionForwardFromController:fromSender:)).with(nil, nil);
		});
		
		it(@"should push the ReviewBookingDetailsController if the passed in vc is a ListBookingViewController and the sender is a ListBookingTableCell", ^{
			ListBookingTableCell *cell = [[ListBookingTableCell alloc] init];
			cell.booking = [[Booking alloc] initWithDictionary:nil];
			
			[subject transitionForwardFromController:vc0 fromSender:cell];
			
			subject should have_received(@selector(prepareControllerFromStoryboard:withIdentifier:)).with(subject.addBookingStoryboard, @"ReviewBookingDetails");
			mockNavVc should have_received(@selector(pushViewController:animated:));
			
			[args[0] isKindOfClass:[ReviewBookingDetailsViewController class]] should be_truthy;
			((ReviewBookingDetailsViewController *)args[0]).bookingService.booking should equal(cell.booking);
			args[1] should be_truthy;
		});
		
		it(@"should push the SelectAdventureViewController if the passed in vc is an EnterCustomerInformationViewController", ^{
			[subject transitionForwardFromController:vc1];
			
			subject should have_received(@selector(prepareControllerFromStoryboard:withIdentifier:)).with(subject.addBookingStoryboard, @"SelectAdventure");
			mockNavVc should have_received(@selector(pushViewController:animated:));
			
			[args[0] isKindOfClass:[SelectAdventureViewController class]] should be_truthy;
			args[1] should be_truthy;
		});
		
		it(@"should push the SelectBookingOptionsViewController if the passed in vc is a SelectAdventureViewController", ^{
			[subject transitionForwardFromController:vc2];
			
			subject should have_received(@selector(prepareControllerFromStoryboard:withIdentifier:)).with(subject.addBookingStoryboard, @"SelectBookingOptions");
			mockNavVc should have_received(@selector(pushViewController:animated:));
			
			[args[0] isKindOfClass:[SelectBookingOptionsViewController class]] should be_truthy;
			args[1] should be_truthy;
		});
		
		it(@"should push the SelectDepartingFlightViewController if the passed in vc is a SelectBookingOptionsViewController", ^{
			[subject transitionForwardFromController:vc3];
			
			subject should have_received(@selector(prepareControllerFromStoryboard:withIdentifier:)).with(subject.addBookingStoryboard, @"SelectDepartingFlight");
			mockNavVc should have_received(@selector(pushViewController:animated:));
			
			[args[0] isKindOfClass:[SelectDepartingFlightViewController class]] should be_truthy;
			args[1] should be_truthy;
		});
		
		it(@"should push the SelectReturningFlightViewController if the passed in vc is a SelectDepartingFlightViewController", ^{
			[subject transitionForwardFromController:vc4];
			
			subject should have_received(@selector(prepareControllerFromStoryboard:withIdentifier:)).with(subject.addBookingStoryboard, @"SelectReturningFlight");
			mockNavVc should have_received(@selector(pushViewController:animated:));
			
			[args[0] isKindOfClass:[SelectReturningFlightViewController class]] should be_truthy;
			args[1] should be_truthy;
		});
		
		it(@"should push the ReviewBookingDetailsViewController if the passed in vc is a SelectReturningFlightViewController", ^{
			[subject transitionForwardFromController:vc5];
			
			subject should have_received(@selector(prepareControllerFromStoryboard:withIdentifier:)).with(subject.addBookingStoryboard, @"ReviewBookingDetails");
			mockNavVc should have_received(@selector(pushViewController:animated:));
			
			[args[0] isKindOfClass:[ReviewBookingDetailsViewController class]] should be_truthy;
			args[1] should be_truthy;
		});
		
		it(@"should dismiss the ReviewBookingDetailsViewController if the passed in vc is a ReviewBookingDetailsViewController", ^{
			[subject transitionForwardFromController:vc6];
			
			vc6 should have_received(@selector(dismissViewControllerAnimated:completion:));
		});
	});
	
	describe(@"setDependenciesForNavigationController:", ^{
		__block UINavigationController *mockNavVc;
		__block EnterCustomerInformationViewController *vc1;
		__block SelectAdventureViewController *vc2;

		beforeEach(^{
			subject = [[JabUIFlowController alloc] init];
			spy_on(subject);
			
			vc1 = [[EnterCustomerInformationViewController alloc] init];
			vc2 = [[SelectAdventureViewController alloc] init];
			
			//need to mock a nav controller with some fake children
			mockNavVc = nice_fake_for([UINavigationController class]);
			//doesn't matter what the children are, but we need to test child iteration of known types
			mockNavVc stub_method(@selector(childViewControllers)).and_return(@[vc1, vc2]);
		});
		
		it(@"should loop through the navigation controller's children and set dependencies for each", ^{
			[subject setDependenciesForNavigationController:mockNavVc];
			
			subject should have_received(@selector(setDependenciesForViewController:)).with(vc1);
			subject should have_received(@selector(setDependenciesForViewController:)).with(vc2);
		});

	});
	
	describe(@"setDependenciesForViewController:", ^{
		__block EnterCustomerInformationViewController *vc1;
		__block SelectAdventureViewController *vc2;
		__block SelectBookingOptionsViewController *vc3;
		__block SelectDepartingFlightViewController *vc4;
		__block SelectReturningFlightViewController *vc5;
		__block ReviewBookingDetailsViewController *vc6;
		__block ListBookingViewController *vc7;
		
		beforeEach(^{
			subject = [[JabUIFlowController alloc] init];
			spy_on(subject);
			
			vc1 = [[EnterCustomerInformationViewController alloc] init];
			vc2 = [[SelectAdventureViewController alloc] init];
			vc3 = [[SelectBookingOptionsViewController alloc] init];
			vc4 = [[SelectDepartingFlightViewController alloc] init];
			vc5 = [[SelectReturningFlightViewController alloc] init];
			vc6 = [[ReviewBookingDetailsViewController alloc] init];
			vc7 = [[ListBookingViewController alloc] init];
		});
		
		it(@"should set the bookingService dependency for all known controller types", ^{
			[subject setDependenciesForViewController:vc1];
			vc1.bookingService should equal(subject.bookingServiceInstance);
			[subject setDependenciesForViewController:vc2];
			vc2.bookingService should equal(subject.bookingServiceInstance);
			[subject setDependenciesForViewController:vc3];
			vc3.bookingService should equal(subject.bookingServiceInstance);
			[subject setDependenciesForViewController:vc4];
			vc4.bookingService should equal(subject.bookingServiceInstance);
			[subject setDependenciesForViewController:vc5];
			vc5.bookingService should equal(subject.bookingServiceInstance);
			[subject setDependenciesForViewController:vc6];
			vc6.bookingService should equal(subject.bookingServiceInstance);
			[subject setDependenciesForViewController:vc7];
			vc7.bookingService should equal(subject.bookingServiceInstance);
		});
		
	});
	
});

SPEC_END
