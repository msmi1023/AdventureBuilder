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
			
			Customer *testCust = [[Customer alloc] init];
			Adventure *testAdv = [[Adventure alloc] init];
			Flight *testDepFlight = [[Flight alloc] init];
			Flight *testRetFlight = [[Flight alloc] init];

			
			subject.uuid should equal(@"");
			subject.confirmationNumber should be_nil;
			subject.note should equal(@"");
			[subject.customer compareTo:testCust] should be_truthy;
			[subject.adventure compareTo:testAdv] should be_truthy;
			[subject.departingFlight compareTo:testDepFlight] should be_truthy;
			[subject.returningFlight compareTo:testRetFlight] should be_truthy;
			subject.startDate should be_nil;
			subject.endDate should be_nil;
			subject.updateTime should be_nil;
			
			subject = [subject initWithDictionary:@{}];
			
			subject.uuid should equal(@"");
			subject.confirmationNumber should be_nil;
			subject.note should equal(@"");
			[subject.customer compareTo:testCust] should be_truthy;
			[subject.adventure compareTo:testAdv] should be_truthy;
			[subject.departingFlight compareTo:testDepFlight] should be_truthy;
			[subject.returningFlight compareTo:testRetFlight] should be_truthy;
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
		
		it(@"should create the appropriate objects if the passed in values are all dictionaries and strings", ^{
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
											  @"price":@389.7
											  },
									  @"returningFlight": @{
											  @"flightNumber":@"NK701",
											  @"price":@289.7
											  },
									  @"startDate":@"Aug-12-2016",
									  @"endDate":@"Sep-11-2016",
									  @"updateTime":@"2016-07-13 13:53:38.609"
									  };
			
			Customer *testCust = [[Customer alloc] initWithDictionary:booking[@"customer"]];
			Adventure *testAdv = [[Adventure alloc] initWithDictionary:booking[@"adventure"]];
			Flight *testDepFlight = [[Flight alloc] initWithDictionary:booking[@"departingFlight"]];
			Flight *testRetFlight = [[Flight alloc] initWithDictionary:booking[@"returningFlight"]];
			
			NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
			[dateFormatter setDateFormat:@"MMM-dd-yyyy"];
			NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
			[dateFormatter setTimeZone:gmt];
			
			NSDate *testStartDate = [dateFormatter dateFromString:booking[@"startDate"]];
			NSDate *testEndDate = [dateFormatter dateFromString:booking[@"endDate"]];
			
			[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
			NSDate *testUpdateTime = [dateFormatter dateFromString:booking[@"updateTime"]];
			
			[subject initWithDictionary:booking];
			
			subject.uuid should equal(@"1");
			subject.confirmationNumber should equal(@78531998);
			subject.note should equal(@"Hawaii vacation");
			[subject.customer compareTo:testCust] should be_truthy;
			[subject.adventure compareTo:testAdv] should be_truthy;
			[subject.departingFlight compareTo:testDepFlight] should be_truthy;
			[subject.returningFlight compareTo:testRetFlight] should be_truthy;
			subject.startDate should equal(testStartDate);
			subject.endDate should equal(testEndDate);
			subject.updateTime should equal(testUpdateTime);
		});
	});
	
	describe(@"serializeToJSONString", ^{
		it(@"should create a JSON string from the properties of the class", ^{
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
			
			subject = [subject initWithDictionary:booking];
			
			NSString *string = [subject serializeToJSONStringForAction:@"non-create"];
			NSError *error;
			NSData *jsonData = [NSJSONSerialization dataWithJSONObject:booking options:0 error:&error];
			NSString *answer = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
			
			string should equal(answer);
		});
	});
});

SPEC_END
