#import <Cedar/Cedar.h>
#import "Adventure.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(AdventureSpec)

describe(@"Adventure", ^{
	__block Adventure *subject;
	
	beforeEach(^{
		subject = [Adventure alloc];
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
			
			subject.type should equal(@"");
			subject.name should equal(@"");
			subject.dailyPrice should equal(@0);
			subject.activities should equal(@[]);
			
			subject = [subject initWithDictionary:@{}];
			
			subject.type should equal(@"");
			subject.name should equal(@"");
			subject.dailyPrice should equal(@0);
			subject.activities should equal(@[]);
		});
		
		it(@"should create a new Adventure object with the passed in dictionary values", ^{
			
			subject = [subject initWithDictionary:@{@"type":@"TestAdventure",
													@"name":@"TestFun",
													@"dailyPrice":@100,
													@"activities":@[@"thing1", @"thing2"]}];
			
			subject.type should equal(@"TestAdventure");
			subject.name should equal(@"TestFun");
			subject.dailyPrice should equal(@100);
			subject.activities should equal(@[@"thing1", @"thing2"]);
		});
	});
});

SPEC_END
