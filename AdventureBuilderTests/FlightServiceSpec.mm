#import <Cedar/Cedar.h>
#import "FlightService.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(FlightServiceSpec)

describe(@"FlightService", ^{
	__block FlightService *subject;
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
		
		subject = [[FlightService alloc] initWithApiManager:apiManager];
	});
	
	it(@"should exist", ^{
		subject should_not be_nil;
	});
	
	describe(@"getFlightsOfType:withCompletionBlock", ^{
		beforeEach(^{
			apiManager stub_method(@selector(GET:parameters:progress:success:failure:))
			.and_do_block(^NSURLSessionDataTask *(NSString *url, id parameters, downloadProgress progress, successHandler success, errorHandler failure) {
				localSuccess = success;
				localError = failure;
				return nil;
			});
		});
		
		it(@"should have a method for retrieving flights", ^{
			[subject respondsToSelector:@selector(getFlightsOfType:withCompletionBlock:)] should be_truthy;
		});
		
		it(@"should call the api manager's GET selector with the appropriate endpoint when GET is called", ^{
			[subject getFlightsOfType:@"type" withCompletionBlock:^(id response){}];
			apiManager should have_received(@selector(GET:parameters:progress:success:failure:)).with(@"flights/type", Arguments::anything, Arguments::anything, Arguments::anything, Arguments::anything);
		});
		
		context(@"when the service returns data", ^{
			__block NSArray *testData = nil;
			
			beforeEach(^{
				__block completion_t localComplete = ^(id response) {
					//do something with success here. doesn't matter what (we're overriding the prod callback with our own for testing), just do something to show it's called.
					testData = response;
				};
				
				[subject getFlightsOfType:@"type" withCompletionBlock:localComplete];
				
				localSuccess should_not be_nil;
			});
			
			it(@"should call the success callback with the data processed as a flights array", ^{
				Flight *flight1 = [[Flight alloc] initWithDictionary:@{@"flightNumber": @"A1"}];
				Flight *flight2 = [[Flight alloc] initWithDictionary:@{@"flightNumber": @"A2"}];
				__block NSArray *sampleReturn = @[flight1, flight2];
				
				localSuccess(nil, @[@{@"flightNumber": @"A1"}, @{@"flightNumber": @"A2"}]);
				
				for(int i=0; i<testData.count; i++) {
					[testData[i] isKindOfClass:[Flight class]] should be_truthy;
					((Flight *)testData[i]).flightNumber should equal(((Flight *)sampleReturn[i]).flightNumber);
				}
				
				//testData should equal(sampleReturn);
			});
		});
		
		context(@"when the service returns data and a max flight price was set", ^{
			__block NSArray *testData = nil;
			
			beforeEach(^{
				__block completion_t localComplete = ^(id response) {
					//do something with success here. doesn't matter what (we're overriding the prod callback with our own for testing), just do something to show it's called.
					testData = response;
				};
				
				subject.maxFlightPrice = @"400";
				
				[subject getFlightsOfType:@"type" withCompletionBlock:localComplete];
				
				localSuccess should_not be_nil;
			});
			
			it(@"should call the success callback with the data processed as a filtered flights array", ^{
				localSuccess(nil, @[@{@"flightNumber": @"A1", @"price": @200}, @{@"flightNumber": @"A2", @"price": @500}]);
				testData.count should equal(1);
			});
		});
		
		context(@"when the service returns an error", ^{
			__block NSError *testError = nil;
			
			beforeEach(^{
				__block completion_t localComplete = ^(id response) {
					//do something with success here. doesn't matter what (we're overriding the prod callback with our own for testing), just do something to show it's called.
					testError = response;
				};
				
				[subject getFlightsOfType:@"type" withCompletionBlock:localComplete];
				
				localError should_not be_nil;
			});
			
			
			it(@"should call the error callback with the error", ^{
				__block NSError *sampleError = [NSError errorWithDomain:@"testing" code:000 userInfo:nil];
				
				localError(nil, sampleError);
				
				testError should equal(sampleError);
			});
		});
	});
	
	describe(@"getMaxFlightPricesWithCompletionBlock", ^{
		beforeEach(^{
			apiManager stub_method(@selector(GET:parameters:progress:success:failure:))
			.and_do_block(^NSURLSessionDataTask *(NSString *url, id parameters, downloadProgress progress, successHandler success, errorHandler failure) {
				localSuccess = success;
				localError = failure;
				return nil;
			});
		});
		
		it(@"should have a method for retrieving flight price fliters", ^{
			[subject respondsToSelector:@selector(getMaxFlightPricesWithCompletionBlock:)] should be_truthy;
		});
		
		it(@"should call the api manager's GET selector with the appropriate endpoint when GET is called", ^{
			[subject getMaxFlightPricesWithCompletionBlock:^(id response){}];
			apiManager should have_received(@selector(GET:parameters:progress:success:failure:)).with(@"flightpriceoptions/maxflightprice", Arguments::anything, Arguments::anything, Arguments::anything, Arguments::anything);
		});
		
		context(@"when the service returns data", ^{
			__block NSArray *testData = nil;
			
			beforeEach(^{
				__block completion_t localComplete = ^(id response) {
					//do something with success here. doesn't matter what (we're overriding the prod callback with our own for testing), just do something to show it's called.
					testData = response;
				};
				
				[subject getMaxFlightPricesWithCompletionBlock:localComplete];
				
				localSuccess should_not be_nil;
			});
			
			it(@"should call the success callback with the data processed as an array of strings", ^{
				__block NSArray *sampleReturn = @[@"100", @"200"];
				
				localSuccess(nil, @[@"100", @"200"]);
				
				for(int i=0; i<testData.count; i++) {
					[testData[i] isKindOfClass:[NSString class]] should be_truthy;
					testData[i] should equal(sampleReturn[i]);
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
				
				[subject getMaxFlightPricesWithCompletionBlock:localComplete];
				
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