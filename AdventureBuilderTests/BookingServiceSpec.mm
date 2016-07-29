#import <Cedar/Cedar.h>
#import "BookingService.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(BookingServiceSpec)

describe(@"BookingService", ^{
    __block BookingService *subject;
	__block JabApiManager *apiManager;
	
	//all of this business (16 thru 33) is setting up a mock for the AFNetworking GET call.
	//doing it this way gives us access to the success and failure callbacks, so we can test them appropriately.
	//unfortunately the GET call takes lots of params, so we have to prep the stub with the appropriate types (including these block typedefs)
	typedef void (^downloadProgress)(NSProgress * _Nonnull);
	typedef void (^bodyBlock)(id<AFMultipartFormData> _Nonnull __strong);
	typedef void (^successHandler)(NSURLSessionDataTask * _Nonnull, id _Nullable);
	typedef void (^errorHandler)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull);
	
	__block successHandler localSuccess = nil;
	__block errorHandler localError = nil;
	__block bodyBlock localBodyBlock = nil;

    beforeEach(^{
		apiManager = fake_for([JabApiManager class]);
		
		subject = [[BookingService alloc] initWithApiManager:apiManager];
    });
	
	it(@"should exist", ^{
		subject should_not be_nil;
	});
	
	describe(@"getBookingsWithCompletionBlock", ^{
		beforeEach(^{
			apiManager stub_method(@selector(GET:parameters:progress:success:failure:))
			.and_do_block(^NSURLSessionDataTask *(NSString *url, id parameters, downloadProgress progress, successHandler success, errorHandler failure) {
				localSuccess = success;
				localError = failure;
				return nil;
			});
		});
		
		it(@"should have a method for retrieving bookings", ^{
			[subject respondsToSelector:@selector(getBookingsWithCompletionBlock:)] should be_truthy;
		});
		
		it(@"should call the api manager's GET selector when getBookings is called", ^{
			[subject getBookingsWithCompletionBlock:^(id response){}];
			apiManager should have_received(@selector(GET:parameters:progress:success:failure:));
		});
		
		context(@"when the service returns data", ^{
			__block NSArray *testData = nil;
			
			beforeEach(^{
				__block completion_t localComplete = ^(id response) {
					//do something with success here. doesn't matter what (we're overriding the prod callback with our own for testing), just do something to show it's called.
					testData = response;
				};
				
				[subject getBookingsWithCompletionBlock:localComplete];
				
				localSuccess should_not be_nil;
			});
			
			it(@"should call the success callback with the data processed as a bookings array", ^{
				Booking *booking1 = [[Booking alloc] initWithDictionary:@{@"confirmationNumber": @1}];
				Booking *booking2 = [[Booking alloc] initWithDictionary:@{@"confirmationNumber": @2}];
				__block NSArray *sampleReturn = @[booking1, booking2];
				
				localSuccess(nil, @[@{@"confirmationNumber": @1}, @{@"confirmationNumber": @2}]);
			
				for(int i=0; i<testData.count; i++) {
					[testData[i] isKindOfClass:[Booking class]] should be_truthy;
					//make sure the id is of type booking first. then typecast for the property check
					((Booking *)testData[i]).confirmationNumber should equal(((Booking *)sampleReturn[i]).confirmationNumber);
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
				
				[subject getBookingsWithCompletionBlock:localComplete];
				
				localError should_not be_nil;
			});
			
			
			it(@"should call the error callback with the error", ^{
				__block NSError *sampleError = [NSError errorWithDomain:@"testing" code:000 userInfo:nil];
				
				localError(nil, sampleError);
				
				testError should equal(sampleError);
			});
		});
	});
	
	describe(@"booking creation", ^{
		
		beforeEach(^{
			apiManager stub_method(@selector(POST:parameters:progress:success:failure:))
			.and_do_block(^NSURLSessionDataTask *(NSString *url, id parameters, downloadProgress progress, successHandler success, errorHandler failure) {
				localSuccess = success;
				localError = failure;
				return nil;
			});
		});
	
		it(@"should have a property to hold an in-progress booking", ^{
			[subject respondsToSelector:@selector(booking)] should be_truthy;
		});
		
		it(@"should be able to submit a prepped booking to the api", ^{
			[subject respondsToSelector:@selector(createBookingWithCompletionBlock:)] should be_truthy;
		});
		
		/*describe(@"createBookingWithCompletionBlock", ^{
			it(@"should call the api manager's POST selector when createBooking is called", ^{
				[subject createBookingWithCompletionBlock:^(id response){}];
				apiManager should have_received(@selector(POST:parameters:progress:success:failure:));
			});
		});*/
	
	});
	
});

SPEC_END