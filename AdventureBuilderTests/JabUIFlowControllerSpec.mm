#import <Cedar/Cedar.h>
#import "JabUIFlowController.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

//get ourselves access to the normal init method.
//step around the singleton for test purposes
@interface JabUIFlowController (Test)

-(instancetype)init;
-(void)setDependenciesForNavigationController:(UIViewController *)nvc;

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
	
	it(@"should return an instance with bookingService, mainStoryboard and addBookingStoryboard references", ^{
		subject = [JabUIFlowController sharedController];
		
		[subject.bookingServiceInstance isKindOfClass:[BookingService class]] should be_truthy;
		[subject.mainStoryboard isKindOfClass:[UIStoryboard class]] should be_truthy;
		[subject.mainStoryboard valueForKey:@"name"] should equal(@"Main");
		[subject.addBookingStoryboard isKindOfClass:[UIStoryboard class]] should be_truthy;
		[subject.addBookingStoryboard valueForKey:@"name"] should equal(@"AddBooking");
	});
	
	describe(@"presentInitialViewControllerForStoryboardIdentifier:fromController:onWindow", ^{
		__block UIWindow *window;
		
		beforeEach(^{
			subject = [[JabUIFlowController alloc] init];
			spy_on(subject);
			subject stub_method(@selector(setDependenciesForNavigationController:))
			.and_do_block(^(UIViewController *nvc){
				
			});
			
			window = [[UIWindow alloc] init];
			spy_on(window);
			window stub_method(@selector(makeKeyAndVisible));
		});
		
		it(@"should make the returned controller active on the given window", ^{
			UIViewController *vc = [subject presentInitialViewControllerForStoryboardIdentifier:@"Main" fromController:nil onWindow:window];
			
			subject should have_received(@selector(presentInitialViewControllerForStoryboardIdentifier:fromController:onWindow:));
			
			window.rootViewController should equal(vc);
			window should have_received(@selector(makeKeyAndVisible));
		});
	});
});

SPEC_END
