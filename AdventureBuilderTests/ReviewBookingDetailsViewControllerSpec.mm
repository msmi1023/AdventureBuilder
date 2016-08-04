#import <Cedar/Cedar.h>
#import "ReviewBookingDetailsViewController.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

//for test purposes get ourselves access to the flow controller's prepareController method
@interface JabUIFlowController (Test)

-(id)prepareControllerFromStoryboard:(UIStoryboard *)storyboard withIdentifier:(NSString *)identifier;

@end

@interface ReviewBookingDetailsViewController (Test)

@end

SPEC_BEGIN(ReviewBookingDetailsViewControllerSpec)

describe(@"ReviewBookingDetailsViewController", ^{
	__block ReviewBookingDetailsViewController *vc;
	
	beforeEach(^{
		vc = [[JabUIFlowController sharedController] prepareControllerFromStoryboard:[JabUIFlowController sharedController].addBookingStoryboard withIdentifier:@"ReviewBookingDetails"];
		
		vc.fullName = [[UILabel alloc] init];
		vc.emailAddress = [[UILabel alloc] init];
		vc.fullAddress = [[UILabel alloc] init];
		vc.phone = [[UILabel alloc] init];
		vc.adventureType = [[UILabel alloc] init];
		vc.adventure = [[UILabel alloc] init];
		vc.startDate = [[UILabel alloc] init];
		vc.endDate = [[UILabel alloc] init];
		vc.departingFlight = [[UILabel alloc] init];
		vc.returningFlight = [[UILabel alloc] init];
		vc.totalPrice = [[UILabel alloc] init];
	});
	
	it(@"should exist", ^{
		vc should_not be_nil;
	});
	
	it(@"should inherit from the JabUIController class", ^{
		vc.superclass should equal([JabUIViewController class]);
	});
	
	it(@"should be tied to the add booking storyboard and should have an instance of the booking service", ^{
		vc.storyboard should_not be_nil;
		vc.bookingService should_not be_nil;
		[vc.bookingService isKindOfClass:[BookingService class]] should be_truthy;
	});
	
	describe(@"viewWillAppear", ^{
		it(@"should set the labels with text from the booking object held in the service", ^{
			NSDictionary *booking = @{
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
									  };
			
			vc.bookingService.booking = [[Booking alloc] initWithDictionary: booking];
			
			[vc viewWillAppear:NO];
			
			vc.fullName.text should equal([NSString stringWithFormat:@"%@ %@", vc.bookingService.booking.customer.firstName, vc.bookingService.booking.customer.lastName]);
			vc.emailAddress.text should equal(vc.bookingService.booking.customer.emailAddress);
			vc.phone.text should equal(vc.bookingService.booking.customer.phone);
			vc.adventureType.text should equal(vc.bookingService.booking.adventure.type);
			vc.adventure.text should equal(vc.bookingService.booking.adventure.name);
			vc.startDate.text should equal([vc.bookingService.booking startDateString]);
			vc.endDate.text should equal([vc.bookingService.booking endDateString]);
			vc.departingFlight.text should equal(vc.bookingService.booking.departingFlight.flightNumber);
			vc.returningFlight.text should equal(vc.bookingService.booking.returningFlight.flightNumber);
			vc.totalPrice.text should equal([NSString stringWithFormat:@"Total Price: $%.2f",[[vc.bookingService.booking totalPrice] floatValue]]);
		});
	});
});

SPEC_END
