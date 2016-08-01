#import <Cedar/Cedar.h>
#import "SelectDepartingFlightViewController.h"
#import "ListFlightTableCell.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

//for test purposes get ourselves access to the flow controller's prepareController method
@interface JabUIFlowController (Test)

-(id)prepareControllerFromStoryboard:(UIStoryboard *)storyboard withIdentifier:(NSString *)identifier;

@end

@interface SelectDepartingFlightViewController (Test)

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

SPEC_BEGIN(SelectDepartingFlightViewControllerSpec)

describe(@"SelectDepartingFlightViewController", ^{
	__block SelectDepartingFlightViewController *vc;
	
	beforeEach(^{
		vc = [[JabUIFlowController sharedController] prepareControllerFromStoryboard:[JabUIFlowController sharedController].addBookingStoryboard withIdentifier:@"SelectDepartingFlight"];
		
		vc.tableView = [[UITableView alloc] init];
	});
	
	it(@"should exist", ^{
		vc should_not be_nil;
	});
	
	it(@"should inherit from the JabUIController class", ^{
		vc.superclass should equal([JabUIViewController class]);
	});
	
	it(@"should be tied to the add booking storyboard and should have an instance of the booking service and the flight service", ^{
		vc.storyboard should_not be_nil;
		vc.bookingService should_not be_nil;
		[vc.bookingService isKindOfClass:[BookingService class]] should be_truthy;
		vc.flightService should_not be_nil;
		[vc.flightService isKindOfClass:[FlightService class]] should be_truthy;
	});
	
	it(@"should implement the necessary ui table view delegate selectors", ^{
		[vc respondsToSelector:@selector(tableView:numberOfRowsInSection:)] should be_truthy;
		[vc respondsToSelector:@selector(tableView:cellForRowAtIndexPath:)] should be_truthy;
		[vc respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)] should be_truthy;
		[vc respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)] should be_truthy;
	});
	
	it(@"should have set itself as delegate and data source for the table view in the viewDidLoad", ^{
		[vc viewWillAppear:NO];
		
		vc.tableView.delegate should equal(vc);
		vc.tableView.dataSource should equal(vc);
	});
	
	describe(@"viewWillAppear", ^{
		__block completion_t localCallback;
		
		beforeEach(^{
			spy_on(vc);
			spy_on(vc.flightService);
			spy_on(vc.tableView);
			
			//mock out the flight getter and get ourselves a copy of the passed in callback.
			vc.flightService stub_method(@selector(getFlightsOfType:withCompletionBlock:))
			.and_do_block(^(NSString *type, completion_t block){
				localCallback = block;
			});
		});
		
		it(@"should retrieve flights from the flight service inside of viewWillAppear", ^{
			[vc viewWillAppear:NO];
			
			vc.flightService should have_received(@selector(getFlightsOfType:withCompletionBlock:)).with(@"departing", Arguments::anything);
		});
		
		it(@"should create the appropriate local objects once the flight list is retrieved", ^{
			NSArray *flights =@[[[Flight alloc] initWithDictionary:@{@"flightNumber":@"CA12",
																	 @"airline":@"Continental Airlines",
																	 @"arrivalTime":@"17:30",
																	 @"departureTime":@"15:30",
																	 @"price":@625.5}],
								[[Flight alloc] initWithDictionary:@{@"flightNumber":@"CA41",
																	 @"airline":@"Continental Airlines",
																	 @"arrivalTime":@"23:30",
																	 @"departureTime":@"15:30",
																	 @"price":@6245.5}]];
			
			[vc viewWillAppear:NO];
			localCallback(flights);
			
			[vc valueForKey:@"flights"] should equal(flights);
			vc.tableView should have_received(@selector(reloadData));
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
	
	describe(@"table view delegate methods", ^{
		__block NSArray *flights;
		
		beforeEach(^{
			flights = @[[[Flight alloc] initWithDictionary:@{@"flightNumber":@"CA12",
																	 @"airline":@"Continental Airlines",
																	 @"arrivalTime":@"17:30",
																	 @"departureTime":@"15:30",
																	 @"price":@625.5}],
								[[Flight alloc] initWithDictionary:@{@"flightNumber":@"CA41",
																	 @"airline":@"Continental Airlines",
																	 @"arrivalTime":@"23:30",
																	 @"departureTime":@"15:30",
																	 @"price":@6245.5}]];
			[vc setValue:flights forKey:@"flights"];
		});
		
		describe(@"tableView:numberOfRowsInSelection", ^{
			it(@"should return the count of the flights array", ^{
				[vc tableView:nil numberOfRowsInSection:0] should equal(flights.count);
			});
		});
		
		describe(@"tableView:cellForRowAtIndexPath", ^{
			it(@"should return a create a ListFlightTableCell with the appropriate flight object provided", ^{
				vc.tableView = [[UITableView alloc] init];
				spy_on(vc.tableView);
				vc.tableView stub_method(@selector(dequeueReusableCellWithIdentifier:))
				.and_do_block(^(NSString *identifier){
					return [[ListFlightTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
				});
				
				UITableViewCell *resultCell = resultCell = [vc tableView:vc.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
				
				[resultCell isKindOfClass:[ListFlightTableCell class]] should be_truthy;
				((ListFlightTableCell *)resultCell).flight should equal(flights[0]);
			});
		});
		
		describe(@"table view delegate - heightForRowAtIndexPath", ^{
			__block CGFloat result;
			
			beforeEach(^{
				result = [vc tableView:nil heightForRowAtIndexPath:nil];
			});
			
			it(@"should return the appropriate height for the custom cells", ^{
				result should equal([ListFlightTableCell height]);
			});
		});
		
		describe(@"tableView:didSelectRowAtIndexPath", ^{
			it(@"should set the bookingService's booking object with the selected flight", ^{
				[vc tableView:nil didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
				
				[vc.bookingService.booking.departingFlight compareTo:flights[1]] should be_truthy;
			});
		});
	});
});

SPEC_END
