#import <Cedar/Cedar.h>
#import "SelectBookingOptionsViewController.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

//for test purposes get ourselves access to the flow controller's prepareController method
@interface JabUIFlowController (Test)

-(id)prepareControllerFromStoryboard:(UIStoryboard *)storyboard withIdentifier:(NSString *)identifier;

@end

@interface SelectBookingOptionsViewController (Test)

-(IBAction)startDateSelected:(id)sender;
-(IBAction)endDateSelected:(id)sender;
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;

@end

SPEC_BEGIN(SelectBookingOptionsViewControllerSpec)

describe(@"SelectBookingOptionsViewController", ^{
	__block SelectBookingOptionsViewController *vc;
	
	beforeEach(^{
		vc = [[JabUIFlowController sharedController] prepareControllerFromStoryboard:[JabUIFlowController sharedController].addBookingStoryboard withIdentifier:@"SelectBookingOptions"];
		
		vc.startDate = [[UIDatePicker alloc] init];
		vc.endDate = [[UIDatePicker alloc] init];
		vc.maxFlightPrice = [[UIPickerView alloc] init];
		vc.notes = [[UITextView alloc] init];
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
	
	it(@"should implement the necessary ui picker view delegate selectors", ^{
		[vc respondsToSelector:@selector(numberOfComponentsInPickerView:)] should be_truthy;
		[vc respondsToSelector:@selector(pickerView:numberOfRowsInComponent:)] should be_truthy;
		[vc respondsToSelector:@selector(pickerView:titleForRow:forComponent:)] should be_truthy;
		[vc respondsToSelector:@selector(pickerView:didSelectRow:inComponent:)] should be_truthy;
	});
	
	it(@"should have set itself as delegate and data source for the picker in the viewDidLoad", ^{
		[vc viewWillAppear:NO];
		
		vc.maxFlightPrice.delegate should equal(vc);
		vc.maxFlightPrice.dataSource should equal(vc);
	});
	
	describe(@"viewWillAppear", ^{
		__block completion_t localCallback;
		
		beforeEach(^{
			spy_on(vc);
			spy_on(vc.flightService);
			spy_on(vc.maxFlightPrice);
			
			//mock out the flight price getter and get ourselves a copy of the passed in callback.
			vc.flightService stub_method(@selector(getMaxFlightPricesWithCompletionBlock:))
			.and_do_block(^(completion_t block){
				localCallback = block;
			});
		});
		
		it(@"should retrieve maxFlightPrices from the flight service inside of viewWillAppear", ^{
			[vc viewWillAppear:NO];
			
			vc.flightService should have_received(@selector(getMaxFlightPricesWithCompletionBlock:));
		});
		
		it(@"should create the appropriate local objects once the price list is retrieved", ^{
			NSArray *prices =@[@"200", @"400", @"600"];
			
			[vc viewWillAppear:NO];
			localCallback(prices);
			
			[vc valueForKey:@"maxFlightPrices"] should equal(prices);
			vc.maxFlightPrice should have_received(@selector(reloadAllComponents));
			vc should have_received(@selector(pickerView:didSelectRow:inComponent:)).with(vc.maxFlightPrice, 0, 0);
		});
	});
	
	describe(@"numberOfComponentsInPickerView", ^{
		it(@"should return 1", ^{
			[vc numberOfComponentsInPickerView:nil] should equal(1);
		});
	});
	
	describe(@"pickerView:numberRowsInComponent", ^{
		it(@"should return the number of maxFlightPrices", ^{
			//doesn't matter what's in the array, the method only grabs its count
			[vc setValue:@[@"1", @"2"] forKey:@"maxFlightPrices"];
			
			[vc pickerView:nil numberOfRowsInComponent:0] should equal(2);
		});
	});
	
	describe(@"pickerView:titleForRow:forComponent", ^{
		it(@"should return the text of the corresponding price for the given row", ^{
			[vc setValue:@[@"1", @"2"] forKey:@"maxFlightPrices"];
			
			[vc pickerView:nil titleForRow:1 forComponent:0] should equal(@"2");
		});
	});
	
	describe(@"pickerView:didSelectRow:inComponent", ^{
		beforeEach(^{
			[vc setValue:@[@"1", @"2"] forKey:@"maxFlightPrices"];
		});
		
		it(@"should set the selected price in the flight service", ^{
			[vc pickerView:nil didSelectRow:1 inComponent:0];
			
			vc.flightService.maxFlightPrice should equal(@"2");
		});
	});
	
	describe(@"startDateSelected", ^{
		it(@"should set the selected date into the start date field on the booking service", ^{
			NSDate *sampleDate = [[NSDate alloc] init];
			
			[vc.startDate setDate:sampleDate];
			
			[vc startDateSelected:nil];
			
			vc.bookingService.booking.startDate should equal(sampleDate);
		});
	});
	
	describe(@"endDateSelected", ^{
		it(@"should set the selected date into the end date field on the booking service", ^{
			NSDate *sampleDate = [[NSDate alloc] init];
			
			[vc.endDate setDate:sampleDate];

			[vc endDateSelected:nil];
			
			vc.bookingService.booking.endDate should equal(vc.endDate.date);

		});
	});
});

SPEC_END
