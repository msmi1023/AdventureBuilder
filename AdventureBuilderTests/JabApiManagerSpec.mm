#import <Cedar/Cedar.h>
#import "JabApiManager.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

/*
//http://twobitlabs.com/2013/01/objective-c-singleton-pattern-unit-testing/
 
//use a category to adjust our singleton for testing purposes
@interface JabApiManager (Test)

+(void)setSharedManager:(JabApiManager *)instance;

@end

@implementation JabApiManager (Test)

static dispatch_once_t pred = 0;
static JabApiManager *sharedManager = nil;

+(void)setSharedManager:(JabApiManager *)instance {
	pred = 0;
	sharedManager = instance;
}

+(JabApiManager *)sharedManager {
	dispatch_once(&pred, ^{
		if(sharedManager == nil) {
			sharedManager = [[self alloc] initWithBaseURL:[NSURL URLWithString:@"http://localhost:9500/api"]];
			//[_sharedManager setUsername:@"wasadm01" andPassword:@"wasadm01"];
		}
	});
	
	return sharedManager;
}
@end
*/
 
SPEC_BEGIN(JabApiManagerSpec)

describe(@"JabApiManager", ^{
    __block JabApiManager *subject;
	
	it(@"should respond to the sharedManager class method", ^{
		[JabApiManager respondsToSelector:@selector(sharedManager)] should be_truthy;
	});
	
	it(@"should return a JabApiManager instance from the sharedManager call", ^{
		subject = [JabApiManager sharedManager];
		[subject isKindOfClass:[JabApiManager class]] should be_truthy;
	});
	
	it(@"should return the same instance on subsequent sharedManager calls", ^{
		subject = [JabApiManager sharedManager];
		JabApiManager *newResult = [JabApiManager sharedManager];
		
		newResult == subject should be_truthy;
	});
	
	it(@"should set the instance up with the appropriate url", ^{
		subject = [JabApiManager sharedManager];
		
		subject.baseURL.absoluteString should equal(@"http://localhost:9500/api/");
	});
	
	/*describe(@"api manager setup", ^{
		beforeEach(^{
			spy_on([JabApiManager sharedManager]);
			
			[JabApiManager sharedManager] stub_method(@selector(initWithBaseURL:));
		});
		it(@"should set up the instance with the appropriate api url", ^{
			subject = [JabApiManager sharedManager];
			subject should have_received(@selector(initWithBaseURL:));
		});
	});*/
});

SPEC_END
