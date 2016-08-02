#import <Cedar/Cedar.h>
#import "ListBookingTableCell.h"
#import "JabUIFlowController.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(ListBookingTableCellSpec)

describe(@"ListBookingTableCell", ^{
	__block ListBookingTableCell *subject;
	
	beforeEach(^{
		subject = [[ListBookingTableCell alloc] init];
	});
	
	it(@"should exist", ^{
		subject should_not be_nil;
	});
	
	it(@"should inherit from the UITableViewCell class", ^{
		subject.superclass should equal([UITableViewCell class]);
	});
	
	it(@"should return the height of a cell from a class method", ^{
		[ListBookingTableCell height] should equal(60);
	});
	
	it(@"should return the appropriate margin styles when asked", ^{
		[subject layoutMargins] should equal(UIEdgeInsetsZero);
	});
	
	it(@"should handle the press of the detail indicator icon", ^{
		[subject respondsToSelector:@selector(detailIconPressed:)] should be_truthy;
	});
	
	it(@"should override initWithStyle to have it create the needed labels", ^{
		[subject initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
		
		[subject.confirmationNumberLabel isKindOfClass:[UILabel class]] should be_truthy;
		[subject.emailLabel isKindOfClass:[UILabel class]] should be_truthy;
		[subject.dateLabel isKindOfClass:[UILabel class]] should be_truthy;
		[subject.priceLabel isKindOfClass:[UILabel class]] should be_truthy;
	});
	
	it(@"should use the passed in booking to set up the cell", ^{
		Booking *booking = [[Booking alloc] initWithDictionary: @{
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
		
		[subject setBookingAndLabelsFromBooking:booking];
		
		subject.booking should equal(booking);
		subject.confirmationNumberLabel.text should equal([booking.confirmationNumber stringValue]);
		subject.emailLabel.text should equal(booking.customer.emailAddress);
		subject.dateLabel.text should equal([NSString stringWithFormat:@"%@ - %@", [booking startDateStringForCell], [booking endDateStringForCell]]);
		subject.priceLabel.text should equal([NSString stringWithFormat:@"$%.2f", [[booking totalPrice] floatValue]]);
	});
	
	describe(@"detailIconPressed", ^{
		beforeEach(^{
			spy_on([JabUIFlowController sharedController]);
		});
		
		it(@"should use the flow controller to transition forward when the detail icon is pressed", ^{
			[subject detailIconPressed:nil];
			[JabUIFlowController sharedController] should have_received(@selector(transitionForwardFromController:fromSender:));
			//would like to test params, but not sure how to do it appropriately as in test context we aren't actually in a table view
		});
	});
});

SPEC_END
