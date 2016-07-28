#import <Cedar/Cedar.h>
#import "Customer.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(CustomerSpec)

describe(@"Customer", ^{
	__block Customer *subject;
	
	beforeEach(^{
		subject = [Customer alloc];
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
			
			subject.emailAddress should equal(@"");
			subject.firstName should equal(@"");
			subject.lastName should equal(@"");
			subject.phone should equal(@"");
			
			subject = [subject initWithDictionary:@{}];
			
			subject.emailAddress should equal(@"");
			subject.firstName should equal(@"");
			subject.lastName should equal(@"");
			subject.phone should equal(@"");

		});
		
		it(@"should create a new Customer object with the passed in dictionary values", ^{
			
			subject = [subject initWithDictionary:@{@"emailAddress":@"test@test.com",
													@"firstName":@"Test",
													@"lastName":@"User",
													@"phone":@"123-4567890"}];
			
			subject.emailAddress should equal(@"test@test.com");
			subject.firstName should equal(@"Test");
			subject.lastName should equal(@"User");
			subject.phone should equal(@"123-4567890");
		});
	});
	
	describe(@"serializeToJSON", ^{
		it(@"should create a JSON string from the properties of the class", ^{
			NSDictionary *customer = @{@"emailAddress":@"test@test.com",
										@"firstName":@"Test",
										@"lastName":@"User",
										@"phone":@"123-4567890"};
			
			subject = [subject initWithDictionary:customer];
			
			NSString *string = [subject serializeToJSON];
			NSError *error;
			NSData *jsonData = [NSJSONSerialization dataWithJSONObject:customer options:0 error:&error];
			NSString *answer = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
			
			string should equal(answer);
		});
	});
});

SPEC_END
