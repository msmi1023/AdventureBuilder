#import <Cedar/Cedar.h>
#import "ListBookingViewController.h"

@interface ListBookingViewController (Test)

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)viewDidLoad;
- (void)viewWillAppear:(BOOL)animated;
- (void)retrieveBookingData;
- (IBAction)unwindToListBooking:(UIStoryboardSegue *)segue;

@end

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(ListBookingViewControllerSpec)

describe(@"ListBookingViewController", ^{
	__block ListBookingViewController *vc;

    beforeEach(^{
		UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
		vc = (ListBookingViewController *)[[JabUIFlowController sharedController] presentInitialViewControllerForStoryboardIdentifier:@"Main" fromController:nil onWindow:window].childViewControllers.firstObject;
    });
	
	it(@"should exist", ^{
		vc should_not be_nil;
	});
	
	it(@"should be tied to the main storyboard and should have an instance of the booking service", ^{
		NSLog(@"our controller: %@", vc);
		
		vc.storyboard should_not be_nil;
		vc.bookingService should_not be_nil;
		[vc.bookingService isKindOfClass:[BookingService class]] should be_truthy;
	});
	
	it(@"should implement the necessary table view delegate and data source selectors", ^{
		[vc respondsToSelector:@selector(tableView:numberOfRowsInSection:)] should be_truthy;
		[vc respondsToSelector:@selector(tableView:cellForRowAtIndexPath:)] should be_truthy;
	});
	
	describe(@"table view delegate - numberOfRowsInSection", ^{
		__block NSInteger result;
		
		beforeEach(^{
			//put in our own mock for this test, as we will only need the count
			vc.bookingList = @[@"thing1", @"thing2"];
			result = [vc tableView:nil numberOfRowsInSection:0];
		});
		
		it(@"should return the count of the booking list", ^{
			result should equal(vc.bookingList.count);
		});
	});
	
	describe(@"table view delegate - cellForRowAtIndexPath", ^{
		__block UITableViewCell *resultCell;
		__block NSIndexPath *path = [NSIndexPath indexPathForItem:0 inSection:0];
		Booking *booking1 = [[Booking alloc] initWithDictionary:@{@"confirmationNumber":@1}];
		Booking *booking2 = [[Booking alloc] initWithDictionary:@{@"confirmationNumber":@2}];
		
		beforeEach(^{
			vc.bookingList = @[booking1, booking2];
			
			resultCell = [vc tableView:vc.tableView cellForRowAtIndexPath:path];
		});
		
		it(@"should return the count of the booking list", ^{
			resultCell.textLabel.text should equal(@"1");
		});
	});
	
	describe(@"viewWillAppear", ^{
		beforeEach(^{
			//get our spys in place
			//use nice fake here as we don't need to fully stub out
			vc.bookingService = nice_fake_for([BookingService class]);
		});
		
		it(@"should retrieve booking data when viewWillAppear is called", ^{
			[vc viewWillAppear:YES];
			
			vc.bookingService should have_received(@selector(getBookingsWithCompletionBlock:));
		});
	});
	
	describe(@"retrieveBookingData - success", ^{
		Booking *booking1 = [[Booking alloc] initWithDictionary:@{@"confirmationNumber":@1}];
		Booking *booking2 = [[Booking alloc] initWithDictionary:@{@"confirmationNumber":@2}];

		beforeEach(^{
			vc.bookingList = nil;
			vc.tableView = nice_fake_for([UITableView class]);
			
			vc.bookingService = fake_for([BookingService class]);
			vc.bookingService stub_method(@selector(getBookingsWithCompletionBlock:))
			.and_do_block(^(completion_t callback){
				callback(@[booking1, booking2]);
			});
		});
		
		it(@"should call the booking service to retrieve data, and in the callback should set the bookinglist and reload the table", ^{
			[vc retrieveBookingData];
			
			vc.bookingList should equal(@[booking1, booking2]);
			vc.tableView should have_received(@selector(reloadData));
		});
		
	});
	
	describe(@"retrieveBookingData - failure", ^{
		beforeEach(^{
			vc.bookingList = nil;
			vc.tableView = nice_fake_for([UITableView class]);
			
			vc.bookingService = fake_for([BookingService class]);
			vc.bookingService stub_method(@selector(getBookingsWithCompletionBlock:))
			.and_do_block(^(completion_t callback){
				callback([[NSError alloc] init]);
			});
		});
		
		it(@"should do nothing if the data retrieval came back with an error", ^{
			[vc retrieveBookingData];
			
			vc.bookingList should equal(nil);
			vc.tableView should_not have_received(@selector(reloadData));
		});
	});
});

SPEC_END