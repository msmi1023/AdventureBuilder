#import <Cedar/Cedar.h>
#import "Flight.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(FlightSpec)

describe(@"Flight", ^{
	__block Flight *subject;
	
	beforeEach(^{
		subject = [Flight alloc];
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
			
			subject.flightNumber should equal(@"");
			subject.price should equal(@0);
			
			subject = [subject initWithDictionary:@{}];
			
			subject.flightNumber should equal(@"");
			subject.price should equal(@0);		});
		
		it(@"should create a new Flight object with the passed in dictionary values", ^{
			
			subject = [subject initWithDictionary:@{@"flightNumber":@"A123",
													@"price":@100}];
			
			subject.flightNumber should equal(@"A123");
			subject.price should equal(@100);
		});
	});
});

SPEC_END
