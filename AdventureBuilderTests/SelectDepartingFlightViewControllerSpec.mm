#import <Cedar/Cedar.h>
#import "SelectDepartingFlightViewController.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

//for test purposes get ourselves access to the flow controller's prepareController method
@interface JabUIFlowController (Test)

-(id)prepareControllerFromStoryboard:(UIStoryboard *)storyboard withIdentifier:(NSString *)identifier;

@end

@interface SelectDepartingFlightViewController (Test)

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

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
	});
	
	it(@"should have set itself as delegate and data source for the table view in the viewDidLoad", ^{
		[vc viewWillAppear:NO];
		
		vc.tableView.delegate should equal(vc);
		vc.tableView.dataSource should equal(vc);
	});
});

SPEC_END
