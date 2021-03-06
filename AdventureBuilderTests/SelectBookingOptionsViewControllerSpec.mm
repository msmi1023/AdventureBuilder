#import <Cedar/Cedar.h>
#import "SelectBookingOptionsViewController.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

//for test purposes get ourselves access to the flow controller's prepareController method
@interface JabUIFlowController (Test)

-(id)prepareControllerFromStoryboard:(UIStoryboard *)storyboard withIdentifier:(NSString *)identifier;

@end

@interface SelectBookingOptionsViewController (Test)

-(IBAction)startDateSelected:(id)sender;
-(IBAction)endDateSelected:(id)sender;
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
- (void)keyboardWillShow:(NSNotification *)notification;
- (void)keyboardWillHide:(NSNotification *)notification;

@end

SPEC_BEGIN(SelectBookingOptionsViewControllerSpec)

describe(@"SelectBookingOptionsViewController", ^{
	__block SelectBookingOptionsViewController *vc;
	
	beforeEach(^{
		vc = [[JabUIFlowController sharedController] prepareControllerFromStoryboard:[JabUIFlowController sharedController].addBookingStoryboard withIdentifier:@"SelectBookingOptions"];
		
		vc.startDate = [[UIDatePicker alloc] init];
		vc.endDate = [[UIDatePicker alloc] init];
		vc.maxFlightPrice = [[UIPickerView alloc] init];
		vc.notes = [[UITextView alloc] init];
	});
	
	it(@"should exist", ^{
		vc should_not be_nil;
	});
	
	it(@"should inherit from the JabUIController class", ^{
		vc.superclass should equal([JabUIViewController class]);
	});
	
	it(@"should be tied to the add booking storyboard and should have an instance of the booking service and the flight service", ^{
		vc.storyboard should_not be_nil;
		vc.bookingService should_not be_nil;
		[vc.bookingService isKindOfClass:[BookingService class]] should be_truthy;
		vc.flightService should_not be_nil;
		[vc.flightService isKindOfClass:[FlightService class]] should be_truthy;
	});
	
	it(@"should implement the necessary ui picker view delegate selectors", ^{
		[vc respondsToSelector:@selector(numberOfComponentsInPickerView:)] should be_truthy;
		[vc respondsToSelector:@selector(pickerView:numberOfRowsInComponent:)] should be_truthy;
		[vc respondsToSelector:@selector(pickerView:titleForRow:forComponent:)] should be_truthy;
		[vc respondsToSelector:@selector(pickerView:didSelectRow:inComponent:)] should be_truthy;
	});
	
	it(@"should implement the necessary ui text view delegate selectors", ^{
		[vc respondsToSelector:@selector(textViewDidBeginEditing:)] should be_truthy;
		[vc respondsToSelector:@selector(textViewDidEndEditing:)] should be_truthy;
	});
	
	it(@"should have set itself as delegate and data source for the picker and as delegate for the text view in the viewDidAppear", ^{
		[vc viewWillAppear:NO];
		
		vc.maxFlightPrice.delegate should equal(vc);
		vc.maxFlightPrice.dataSource should equal(vc);
		vc.notes.delegate should equal(vc);
	});
	
	describe(@"viewWillAppear", ^{
		__block completion_t localCallback;
		
		beforeEach(^{
			spy_on(vc);
			spy_on(vc.flightService);
			spy_on(vc.maxFlightPrice);
			
			//mock out the flight price getter and get ourselves a copy of the passed in callback.
			vc.flightService stub_method(@selector(getMaxFlightPricesWithCompletionBlock:))
			.and_do_block(^(completion_t block){
				localCallback = block;
			});
		});
		
		xdescribe(@"NotificationCenter use", ^{
			beforeEach(^{
				//here's the trick. don't try to spy on defaultCenter.
				//instead, mock out the notification center class so we can stub the defaultCenter method.
				//this lets us return the fake we really need without screwing up the
				//singleton for the rest of the app lifecycle.
				spy_on([NSNotificationCenter class]);
				NSNotificationCenter *fake = fake_for([NSNotificationCenter class]);
				fake stub_method(@selector(addObserver:selector:name:object:));
				fake stub_method(@selector(postNotificationName:object:));
				fake stub_method(@selector(addObserverForName:object:queue:usingBlock:));
				fake stub_method(@selector(removeObserver:));
				[NSNotificationCenter class] stub_method(@selector(defaultCenter)).and_return(fake);
			});
			
			afterEach(^{
				//make sure we stop spying when we're done, to put the singleton back to normal.
				stop_spying_on([NSNotificationCenter class]);
			});
			
			it(@"should subscribe to keyboard events through the notification center", ^{
				[vc viewWillAppear:NO];
				
				[NSNotificationCenter defaultCenter] should have_received(@selector(addObserver:selector:name:object:)).with(vc, @selector(keyboardWillShow:), UIKeyboardWillShowNotification, nil);
				[NSNotificationCenter defaultCenter] should have_received(@selector(addObserver:selector:name:object:)).with(vc, @selector(keyboardWillHide:), UIKeyboardWillHideNotification, nil);
			});
		});
		
		it(@"should configure the text view", ^{
			[vc viewWillAppear:NO];
			
			vc.notes.text should equal(@"Enter notes here...");
			vc.notes.textColor should equal([UIColor lightGrayColor]);
			vc.notes.layer.borderColor should equal([[UIColor grayColor] CGColor]);
			vc.notes.layer.cornerRadius should equal(5);
		});
		
		it(@"should retrieve maxFlightPrices from the flight service inside of viewWillAppear", ^{
			[vc viewWillAppear:NO];
			
			vc.flightService should have_received(@selector(getMaxFlightPricesWithCompletionBlock:));
		});
		
		it(@"should create the appropriate local objects once the price list is retrieved", ^{
			NSArray *prices =@[@"200", @"400", @"600"];
			
			[vc viewWillAppear:NO];
			localCallback(prices);
			
			[vc valueForKey:@"maxFlightPrices"] should equal(prices);
			vc.maxFlightPrice should have_received(@selector(reloadAllComponents));
			vc should have_received(@selector(pickerView:didSelectRow:inComponent:)).with(vc.maxFlightPrice, 0, 0);
		});
	});
	
	xdescribe(@"viewWillDisappear:", ^{
		beforeEach(^{
			spy_on([NSNotificationCenter class]);
			NSNotificationCenter *fake = fake_for([NSNotificationCenter class]);
			fake stub_method(@selector(removeObserver:name:object:));
			[NSNotificationCenter class] stub_method(@selector(defaultCenter)).and_return(fake);
		});
		
		afterEach(^{
			stop_spying_on([NSNotificationCenter class]);
		});
		
		it(@"should unsubscribe to keyboard events through the notification center", ^{
			[vc viewWillDisappear:NO];
			
			[NSNotificationCenter defaultCenter] should have_received(@selector(removeObserver:name:object:));//.with(vc, @selector(keyboardWillShow:), UIKeyboardWillShowNotification, nil);
			[NSNotificationCenter defaultCenter] should have_received(@selector(removeObserver:name:object:));//.with(vc, @selector(keyboardWillHide:), UIKeyboardWillHideNotification, nil);
		});
	});
	
	describe(@"keyboard events", ^{
		
		typedef void (^animateBlock)(void);
		__block animateBlock localBlock;
		__block NSNotification *fake;
		__block CGRect fakeFrame;
		
		beforeEach(^{
			spy_on([UIView class]);
			//stub out the animate method so we can have a handle on the animate callback
			[UIView class] stub_method(@selector(animateWithDuration:animations:))
			.and_do_block(^(NSTimeInterval duration, animateBlock animation){
				localBlock = animation;
			});
			
			//build a fake notification loaded with an appropriate keyboard frame
			fake = nice_fake_for([NSNotification class]);
			fake stub_method(@selector(userInfo)).and_return(@{UIKeyboardFrameBeginUserInfoKey: [NSValue valueWithCGRect:CGRectMake(0, 200, 320, 440)]});
			
			//mock out the view with a fake and a fake frame getter/setter
			vc.view = nice_fake_for([UIView class]);
			fakeFrame = CGRectMake(0, 0, 320, 640);
			vc.view stub_method(@selector(frame)).and_do_block(^{
				return fakeFrame;
			});
			vc.view stub_method(@selector(setFrame:)).and_do_block(^(CGRect frame){
				fakeFrame = frame;
			});
		});
		
		afterEach(^{
			stop_spying_on([UIView class]);
			stop_spying_on(vc.view);
		});
		
		it(@"should move the view up when the keyboard will appear", ^{
			[vc keyboardWillShow:fake];
			localBlock();
			NSLog(@"%f", vc.view.frame.origin.y);
			vc.view.frame.origin.y should equal(-440.0f);
		});
		
		it(@"should move the view down when the keyboard will disappear", ^{
			[vc keyboardWillHide:fake];
			localBlock();
			vc.view.frame.origin.y should equal(0.0f);
		});
	});
	
	describe(@"numberOfComponentsInPickerView", ^{
		it(@"should return 1", ^{
			[vc numberOfComponentsInPickerView:nil] should equal(1);
		});
	});
	
	describe(@"pickerView:numberRowsInComponent", ^{
		it(@"should return the number of maxFlightPrices", ^{
			//doesn't matter what's in the array, the method only grabs its count
			[vc setValue:@[@"1", @"2"] forKey:@"maxFlightPrices"];
			
			[vc pickerView:nil numberOfRowsInComponent:0] should equal(2);
		});
	});
	
	describe(@"pickerView:titleForRow:forComponent", ^{
		it(@"should return the text of the corresponding price for the given row", ^{
			[vc setValue:@[@"1", @"2"] forKey:@"maxFlightPrices"];
			
			[vc pickerView:nil titleForRow:1 forComponent:0] should equal(@"2");
		});
	});
	
	describe(@"pickerView:didSelectRow:inComponent", ^{
		beforeEach(^{
			[vc setValue:@[@"1", @"2"] forKey:@"maxFlightPrices"];
		});
		
		it(@"should set the selected price in the flight service", ^{
			[vc pickerView:nil didSelectRow:1 inComponent:0];
			
			vc.flightService.maxFlightPrice should equal(@"2");
		});
	});
	
	describe(@"textViewDidBeginEditing", ^{
		it(@"should remove placeholder text and placeholder styling when editing begins", ^{
			vc.notes.text = @"Enter notes here...";
			
			[vc textViewDidBeginEditing:vc.notes];
			
			vc.notes.text should equal(@"");
			vc.notes.textColor should equal([UIColor blackColor]);
		});
		
		it(@"should become first responder in the call", ^{
			spy_on(vc.notes);
			[vc textViewDidBeginEditing:vc.notes];
			
			vc.notes should have_received(@selector(becomeFirstResponder));
		});
	});
	
	describe(@"textViewDidEndEditing", ^{
		beforeEach(^{
			spy_on(vc.notes);
		});
		
		it(@"should set the typed text on the booking service's booking object", ^{
			vc.notes.text = @"some notes here";
			[vc textViewDidEndEditing:vc.notes];
			
			vc.bookingService.booking.note should equal(vc.notes.text);
		});
		
		it(@"should reset placeholder text and styling when editing ends, if necessary", ^{
			vc.notes.text = @"";
			
			[vc textViewDidEndEditing:vc.notes];
			
			vc.notes.text should equal(@"Enter notes here...");
			vc.notes.textColor should equal([UIColor lightGrayColor]);
		});
		
		it(@"should resign first responder in the call", ^{
			spy_on(vc.notes);
			[vc textViewDidEndEditing:vc.notes];
			
			vc.notes should have_received(@selector(resignFirstResponder));
		});
	});
	
	describe(@"startDateSelected", ^{
		it(@"should set the selected date into the start date field on the booking service", ^{
			NSDate *sampleDate = [[NSDate alloc] init];
			
			[vc.startDate setDate:sampleDate];
			
			[vc startDateSelected:nil];
			
			vc.bookingService.booking.startDate should equal(sampleDate);
		});
	});
	
	describe(@"endDateSelected", ^{
		it(@"should set the selected date into the end date field on the booking service", ^{
			NSDate *sampleDate = [[NSDate alloc] init];
			
			[vc.endDate setDate:sampleDate];

			[vc endDateSelected:nil];
			
			vc.bookingService.booking.endDate should equal(vc.endDate.date);

		});
	});
	
	describe(@"touchesBegan:withEvent:", ^{
		it(@"should call to end editing", ^{
			spy_on(vc.view);
			
			[vc touchesBegan:nil withEvent:nil];
			vc.view should have_received(@selector(endEditing:)).with(YES);
		});
	});
});

SPEC_END
