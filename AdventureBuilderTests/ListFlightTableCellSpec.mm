#import <Cedar/Cedar.h>
#import "ListFlightTableCell.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(ListFlightTableCellSpec)

describe(@"ListFlightTableCell", ^{
	__block ListFlightTableCell *subject;
	
	beforeEach(^{
		subject = [[ListFlightTableCell alloc] init];
	});
	
	it(@"should exist", ^{
		subject should_not be_nil;
	});
	
	it(@"should inherit from the UITableViewCell class", ^{
		subject.superclass should equal([UITableViewCell class]);
	});
	
	it(@"should return the height of a cell from a class method", ^{
		[ListFlightTableCell height] should equal(60);
	});
	
	it(@"should return the appropriate margin styles when asked", ^{
		[subject layoutMargins] should equal(UIEdgeInsetsZero);
	});
	
	it(@"should override initWithStyle to have it create the needed labels", ^{
		[subject initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
		
		[subject.flightNumberLabel isKindOfClass:[UILabel class]] should be_truthy;
		[subject.airlineLabel isKindOfClass:[UILabel class]] should be_truthy;
		[subject.timeLabel isKindOfClass:[UILabel class]] should be_truthy;
		[subject.priceLabel isKindOfClass:[UILabel class]] should be_truthy;
	});
	
	it(@"should use the passed in flight to set up the cell", ^{
		Flight *flight = [[Flight alloc] initWithDictionary:@{}];
		
		[subject setFlightandLabelsFromFlight:flight];
		
		subject.flight should equal(flight);
		subject.flightNumberLabel.text should equal(flight.flightNumber);
		subject.airlineLabel.text should equal(flight.airline);
		subject.timeLabel.text should equal([NSString stringWithFormat:@"%@ - %@", flight.departureTime, flight.arrivalTime]);
		subject.priceLabel.text should equal([NSString stringWithFormat:@"$%.2f", [flight.price floatValue]]);
	});
});

SPEC_END
