#import <Cedar/Cedar.h>
#import "JabApiManager.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

/*
 http://twobitlabs.com/2013/01/objective-c-singleton-pattern-unit-testing/
 
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
	
	beforeEach(^{
		//[JabApiManager setSharedManager:nil];
		//subject = nil;
	});
	
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
	
	//TODO: come back and try with spy_on!!!
	
	/*describe(@"api manager setup", ^{
		beforeEach(^{
			JabApiManager *fake = nice_fake_for([JabApiManager class]);
			fake stub_method(@selector(initWithBaseURL:));
			
			//set up our test object with the instance we just created.
			[JabApiManager setSharedManager:fake];
		});
		it(@"should set up the instance with the appropriate api url", ^{
			subject = [JabApiManager sharedManager];
			subject should have_received(@selector(initWithBaseURL:));
		});
	});*/
});

SPEC_END
