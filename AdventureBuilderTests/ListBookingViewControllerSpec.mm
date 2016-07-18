#import <Cedar/Cedar.h>
#import "ListBookingViewController.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(ListBookingViewControllerSpec)

describe(@"ListBookingViewController", ^{
	__block ListBookingViewController *vc;

    beforeEach(^{
		//delegate = [[AppDelegate alloc] init];
		//[delegate application:nil didFinishLaunchingWithOptions:nil];
		
		//get our storyboard and load our controller from within it.
		UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
		vc = [storyboard instantiateViewControllerWithIdentifier:@"listBookingViewController"];
		[vc performSelectorOnMainThread:@selector(loadView) withObject:nil waitUntilDone:YES];
    });
	
	it(@"should exist", ^{
		vc should_not be_nil;
	});
	
	it(@"should be tied to the main storyboard", ^{
		NSLog(@"our controller: %@", vc);
		
		vc.storyboard should_not be_nil;
	});
	
	
});

SPEC_END