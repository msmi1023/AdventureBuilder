#import <Cedar/Cedar.h>
#import "Booking.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(BookingSpec)

describe(@"Booking", ^{
    __block Booking *subject;

    beforeEach(^{
		subject = [Booking alloc];
    });
	
	it(@"should be defined", ^{
		subject should_not be_nil;
	});
	
	it(@"should respond to the initWithDictionary selector", ^{
		[subject respondsToSelector:@selector(initWithDictionary:)] should be_truthy;
	});
	
	describe(@"initWithDictionary", ^{
		it(@"should create a blank object if no dictionary or an empty dictionary is passed in", ^{
			subject = [subject initWithDictionary:nil];
			
			subject.uuid should equal(@"");
			subject.confirmationNumber should be_nil;
			subject.note should equal(@"");
			subject.customer should be_nil;
			subject.adventure should be_nil;
			subject.departingFlight should be_nil;
			subject.returningFlight should be_nil;
			subject.startDate should be_nil;
			subject.endDate should be_nil;
			subject.updateTime should be_nil;
			
			subject = [subject initWithDictionary:@{}];
			
			subject.uuid should equal(@"");
			subject.confirmationNumber should be_nil;
			subject.note should equal(@"");
			subject.customer should be_nil;
			subject.adventure should be_nil;
			subject.departingFlight should be_nil;
			subject.returningFlight should be_nil;
			subject.startDate should be_nil;
			subject.endDate should be_nil;
			subject.updateTime should be_nil;
		});
		
		it(@"should create a new booking object with the passed in dictionary values", ^{
			Customer *testCust = [[Customer alloc] init];
			Adventure *testAdv = [[Adventure alloc] init];
			Flight *testDepFlight = [[Flight alloc] init];
			Flight *testRetFlight = [[Flight alloc] init];
			NSDate *testStartDate = [[NSDate alloc] init];
			NSDate *testEndDate = [[NSDate alloc] init];
			NSDate *testUpdateTime = [[NSDate alloc] init];
			
			subject = [subject initWithDictionary:@{@"uuid": @"asdf",
													@"confirmationNumber": @1,
													@"note": @"a vacation",
													@"customer": testCust,
													@"adventure": testAdv,
													@"departingFlight": testDepFlight,
													@"returningFlight": testRetFlight,
													@"startDate": testStartDate,
													@"endDate": testEndDate,
													@"updateTime": testUpdateTime}];
			
			subject.uuid should equal(@"asdf");
			subject.confirmationNumber should equal(@1);
			subject.note should equal(@"a vacation");
			subject.customer should equal(testCust);
			subject.adventure should equal(testAdv);
			subject.departingFlight should equal(testDepFlight);
			subject.returningFlight should equal(testRetFlight);
			subject.startDate should equal(testStartDate);
			subject.endDate should equal(testEndDate);
			subject.updateTime should equal(testUpdateTime);
		});
	});
});

SPEC_END
