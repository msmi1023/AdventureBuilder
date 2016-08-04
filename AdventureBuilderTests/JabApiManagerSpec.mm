#import <Cedar/Cedar.h>
#import "JabApiManager.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;
 
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
	
	it(@"should set the instance up with the appropriate url and timeout", ^{
		subject = [JabApiManager sharedManager];
		
		subject.baseURL.absoluteString should equal(@"http://10.3.70.115:9500/api/");
		[subject.requestSerializer timeoutInterval] should equal(10);
	});
});

SPEC_END
