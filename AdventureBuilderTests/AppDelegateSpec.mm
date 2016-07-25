#import <Cedar/Cedar.h>
#import "AppDelegate.h"
#import "ListBookingViewController.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(AppDelegateSpec)

describe(@"AppDelegate", ^{
    __block AppDelegate *subject;

    beforeEach(^{
		subject = [[AppDelegate alloc] init];

    });
	
	it(@"should exist", ^{
		subject should_not be_nil;
	});
	
	it(@"should respond to the didFinishLaunchingWithOptions selector", ^{
		[subject respondsToSelector:@selector(application:didFinishLaunchingWithOptions:)] should be_truthy;
		
	});
	
	describe(@"didFinishLaunchingWithOptions", ^{
		beforeEach(^{
			//ignore the nullable warning here, doesn't matter for the purposes of our test
			[subject application:nil didFinishLaunchingWithOptions:nil];
		});
		
		it(@"should create a window object and store it on the delegate's property", ^{
			[subject.window isKindOfClass:[UIWindow class]] should be_truthy;
		});
		
		it(@"should have loaded the root view controller into the window object", ^{
			[subject.window.rootViewController isKindOfClass:[UINavigationController class]] should be_truthy;
			
			[subject.window.rootViewController.childViewControllers.firstObject isKindOfClass:[ListBookingViewController class]] should be_truthy;
		});
		
		it(@"should have injected the appropriate dependencies into the initial view controller", ^{
			[((ListBookingViewController *)subject.window.rootViewController.childViewControllers.firstObject).bookingService isKindOfClass:[BookingService class]] should be_truthy;
		});
	});
});

SPEC_END
