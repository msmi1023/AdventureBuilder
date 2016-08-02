#import <Cedar/Cedar.h>
#import "ListBookingViewController.h"
#import "ListBookingTableCell.h"

@interface ListBookingViewController (Test)

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)viewDidLoad;
- (void)viewWillAppear:(BOOL)animated;
- (void)retrieveBookingData;
- (IBAction)unwindToListBooking:(UIStoryboardSegue *)segue;

@end

@interface JabUIFlowController (Test)

-(id)prepareControllerFromStoryboard:(UIStoryboard *)storyboard withIdentifier:(NSString *)identifier;

@end

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(ListBookingViewControllerSpec)

describe(@"ListBookingViewController", ^{
	__block ListBookingViewController *vc;

    beforeEach(^{
		//UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
		//vc = (ListBookingViewController *)[[JabUIFlowController sharedController] presentInitialViewControllerForStoryboardIdentifier:@"Main" fromController:nil onWindow:window].childViewControllers.firstObject;
		vc = [[JabUIFlowController sharedController] prepareControllerFromStoryboard:[JabUIFlowController sharedController].mainStoryboard withIdentifier:@"listBookingViewController"];
    });
	
	it(@"should exist", ^{
		vc should_not be_nil;
	});
	
	it(@"should inherit from the JabUIController class", ^{
		vc.superclass should equal([JabUIViewController class]);
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
		[vc respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)] should be_truthy;
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
		Booking *booking1 = [[Booking alloc] initWithDictionary:@{
																  @"uuid":@"1",
																  @"confirmationNumber":@78531998,
																  @"note":@"Hawaii vacation",
																  @"customer": @{
																		  @"emailAddress":@"wasadm01@ford.com",
																		  @"firstName":@"Unit",
																		  @"lastName":@"Test",
																		  @"phone":@"313-0000000"
																		  },
																  @"adventure": @{
																		  @"type":@"Island",
																		  @"name":@"Maui Survival",
																		  @"dailyPrice":@165,
																		  @"activities":@[@"Helicopter Ride",@"Snorkeling",@"Surfing"]
																		  },
																  @"departingFlight": @{
																		  @"flightNumber":@"NK211",
																		  @"airline":@"",
																		  @"arrivalTime":@"",
																		  @"departureTime":@"",
																		  @"price":@389.7
																		  },
																  @"returningFlight": @{
																		  @"flightNumber":@"NK701",
																		  @"airline":@"",
																		  @"arrivalTime":@"",
																		  @"departureTime":@"",
																		  @"price":@289.7
																		  },
																  @"startDate":@"Aug-12-2016",
																  @"endDate":@"Sep-11-2016",
																  @"updateTime":@"2016-07-13 13:53:38.609"
																  }];
		Booking *booking2 = [[Booking alloc] initWithDictionary:@{
																  @"uuid":@"1",
																  @"confirmationNumber":@78531998,
																  @"note":@"Hawaii vacation",
																  @"customer": @{
																		  @"emailAddress":@"wasadm01@ford.com",
																		  @"firstName":@"Unit",
																		  @"lastName":@"Test",
																		  @"phone":@"313-0000000"
																		  },
																  @"adventure": @{
																		  @"type":@"Island",
																		  @"name":@"Maui Survival",
																		  @"dailyPrice":@165,
																		  @"activities":@[@"Helicopter Ride",@"Snorkeling",@"Surfing"]
																		  },
																  @"departingFlight": @{
																		  @"flightNumber":@"NK211",
																		  @"airline":@"",
																		  @"arrivalTime":@"",
																		  @"departureTime":@"",
																		  @"price":@389.7
																		  },
																  @"returningFlight": @{
																		  @"flightNumber":@"NK701",
																		  @"airline":@"",
																		  @"arrivalTime":@"",
																		  @"departureTime":@"",
																		  @"price":@289.7
																		  },
																  @"startDate":@"Aug-12-2016",
																  @"endDate":@"Sep-11-2016",
																  @"updateTime":@"2016-07-13 13:53:38.609"
																  }];
		
		beforeEach(^{
			vc.bookingList = @[booking1, booking2];
			vc.tableView = [[UITableView alloc] init];
			spy_on(vc.tableView);
			vc.tableView stub_method(@selector(dequeueReusableCellWithIdentifier:))
			.and_do_block(^(NSString *identifier){
				return [[ListBookingTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
			});
			
			resultCell = [vc tableView:vc.tableView cellForRowAtIndexPath:path];
		});
		
		it(@"should create a ListBookingTableCell with the appropriate booking object provided", ^{
			[resultCell isKindOfClass:[ListBookingTableCell class]] should be_truthy;
			((ListBookingTableCell *)resultCell).booking should equal(booking1);
		});
		
		it(@"should stripe the cell backgrounds based on indexPath", ^{
			UITableViewCell *resultCell1 = [vc tableView:vc.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
			UITableViewCell *resultCell2 = [vc tableView:vc.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
			
			resultCell1.backgroundColor should equal([UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]);
			resultCell2.backgroundColor should equal([UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0]);
		});
	});
	
	describe(@"table view delegate - heightForRowAtIndexPath", ^{
		__block CGFloat result;
		
		beforeEach(^{
			result = [vc tableView:nil heightForRowAtIndexPath:nil];
		});
		
		it(@"should return the appropriate height for the custom cells", ^{
			result should equal([ListBookingTableCell height]);
		});
	});
	
	describe(@"viewDidLoad", ^{
		beforeEach(^{
			//get our spys in place
			//use nice fake here as we don't need to fully stub out
			vc.tableView = nice_fake_for([UITableView class]);
		});
		
		it(@"should set up the nib for cell creation", ^{
			[vc viewDidLoad];
			
			vc.tableView should have_received(@selector(registerNib:forCellReuseIdentifier:));
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