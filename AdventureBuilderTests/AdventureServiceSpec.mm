#import <Cedar/Cedar.h>
#import "AdventureService.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(AdventureServiceSpec)

describe(@"AdventureService", ^{
	__block AdventureService *subject;
	__block JabApiManager *apiManager;
	
	//all of this business (16 thru 33) is setting up a mock for the AFNetworking GET call.
	//doing it this way gives us access to the success and failure callbacks, so we can test them appropriately.
	//unfortunately the GET call takes lots of params, so we have to prep the stub with the appropriate types (including these block typedefs)
	typedef void (^downloadProgress)(NSProgress * _Nonnull);
	typedef void (^successHandler)(NSURLSessionDataTask * _Nonnull, id _Nullable);
	typedef void (^errorHandler)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull);
	
	__block successHandler localSuccess = nil;
	__block errorHandler localError = nil;
	
	beforeEach(^{
		apiManager = fake_for([JabApiManager class]);
		
		subject = [[AdventureService alloc] initWithApiManager:apiManager];
	});
	
	it(@"should exist", ^{
		subject should_not be_nil;
	});
	
	describe(@"getAdventuresWithCompletionBlock", ^{
		beforeEach(^{
			apiManager stub_method(@selector(GET:parameters:progress:success:failure:))
			.and_do_block(^NSURLSessionDataTask *(NSString *url, id parameters, downloadProgress progress, successHandler success, errorHandler failure) {
				localSuccess = success;
				localError = failure;
				return nil;
			});
		});
		
		it(@"should have a method for retrieving adventures", ^{
			[subject respondsToSelector:@selector(getAdventuresWithCompletionBlock:)] should be_truthy;
		});
		
		it(@"should call the api manager's GET selector when getAdventures is called", ^{
			[subject getAdventuresWithCompletionBlock:^(id response){}];
			apiManager should have_received(@selector(GET:parameters:progress:success:failure:)).with(@"adventures", Arguments::anything, Arguments::anything, Arguments::anything, Arguments::anything);
		});
		
		context(@"when the service returns data", ^{
			__block NSArray *testData = nil;
			
			beforeEach(^{
				__block completion_t localComplete = ^(id response) {
					//do something with success here. doesn't matter what (we're overriding the prod callback with our own for testing), just do something to show it's called.
					testData = response;
				};
				
				[subject getAdventuresWithCompletionBlock:localComplete];
				
				localSuccess should_not be_nil;
			});
			
			it(@"should call the success callback with the data processed as an adventures array", ^{
				Adventure *adventure1 = [[Adventure alloc] initWithDictionary:@{@"type": @"one"}];
				Adventure *adventure2 = [[Adventure alloc] initWithDictionary:@{@"type": @"two"}];
				__block NSArray *sampleReturn = @[adventure1, adventure2];
				
				localSuccess(nil, @[@{@"type": @"one"}, @{@"type": @"two"}]);
				
				for(int i=0; i<testData.count; i++) {
					[testData[i] isKindOfClass:[Adventure class]] should be_truthy;
					((Adventure *)testData[i]).type should equal(((Adventure *)sampleReturn[i]).type);
				}
				
				//testData should equal(sampleReturn);
			});
		});
		
		context(@"when the service returns an error", ^{
			__block NSError *testError = nil;
			
			beforeEach(^{
				__block completion_t localComplete = ^(id response) {
					//do something with success here. doesn't matter what (we're overriding the prod callback with our own for testing), just do something to show it's called.
					testError = response;
				};
				
				[subject getAdventuresWithCompletionBlock:localComplete];
				
				localError should_not be_nil;
			});
			
			
			it(@"should call the error callback with the error", ^{
				__block NSError *sampleError = [NSError errorWithDomain:@"testing" code:000 userInfo:nil];
				
				localError(nil, sampleError);
				
				testError should equal(sampleError);
			});
		});
	});
});

SPEC_END