#import <Cedar/Cedar.h>
#import "EnterCustomerInformationViewController.h"
#import "JabUIFlowController.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

@interface EnterCustomerInformationViewController (Test)

-(void)viewDidLoad;
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField;
-(BOOL)textFieldShouldReturn:(UITextField *)textField;
-(void)textFieldDidEndEditing:(UITextField *)textField;
-(IBAction)textFieldValueChanged:(id)sender;
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
-(void)autoformatPhone;

@end

@interface JabUIFlowController (Test)

-(id)prepareControllerFromStoryboard:(UIStoryboard *)storyboard withIdentifier:(NSString *)identifier;

@end

SPEC_BEGIN(EnterCustomerInformationViewControllerSpec)

describe(@"EnterCustomerInformationViewController", ^{
	__block EnterCustomerInformationViewController *vc;
	
	beforeEach(^{
		vc = [[JabUIFlowController sharedController] prepareControllerFromStoryboard:[JabUIFlowController sharedController].addBookingStoryboard withIdentifier:@"EnterCustomerInformation"];
		
		vc.emailAddress = [[UITextField alloc] init];
		vc.firstName = [[UITextField alloc] init];
		vc.lastName = [[UITextField alloc] init];
		vc.phone = [[UITextField alloc] init];
	});
	
	it(@"should exist", ^{
		vc should_not be_nil;
	});
	
	it(@"should inherit from the JabUIController class", ^{
		vc.superclass should equal([JabUIViewController class]);
	});
	
	it(@"should be tied to the add booking storyboard and should have an instance of the booking service", ^{
		vc.storyboard should_not be_nil;
		vc.bookingService should_not be_nil;
		[vc.bookingService isKindOfClass:[BookingService class]] should be_truthy;
	});
	
	it(@"should implement the necessary ui text view delegate selectors", ^{
		[vc respondsToSelector:@selector(textFieldDidEndEditing:)] should be_truthy;
		[vc respondsToSelector:@selector(textFieldShouldBeginEditing:)] should be_truthy;
		[vc respondsToSelector:@selector(textFieldShouldReturn:)] should be_truthy;
	});
	
	it(@"should have set itself as delegate for the text fields in the viewDidLoad", ^{
		[vc viewDidLoad];
		
		vc.emailAddress.delegate should equal(vc);
		vc.firstName.delegate should equal(vc);
		vc.lastName.delegate should equal(vc);
		vc.phone.delegate should equal(vc);
	});
	
	it(@"should return YES from the should begin editing method", ^{
		[vc textFieldShouldBeginEditing:nil] should be_truthy;
	});
	
	it(@"should return YES from the should return method and should resign first responder", ^{
		UITextField *field = nice_fake_for([UITextField class]);
		
		BOOL result = [vc textFieldShouldReturn:field];
		
		result should be_truthy;
		field should have_received(@selector(resignFirstResponder));
		
	});
	
	describe(@"textFieldDidEndEditing:", ^{
		it(@"should update the appropriate booking object field when the method is called", ^{
			vc.emailAddress.text = @"test@test.com";
			[vc textFieldDidEndEditing:vc.emailAddress];
			vc.bookingService.booking.customer.emailAddress should equal(vc.emailAddress.text);
			
			vc.firstName.text = @"test";
			[vc textFieldDidEndEditing:vc.firstName];
			vc.bookingService.booking.customer.firstName should equal(vc.firstName.text);
			
			vc.lastName.text = @"tester";
			[vc textFieldDidEndEditing:vc.lastName];
			vc.bookingService.booking.customer.lastName should equal(vc.lastName.text);
			
			vc.phone.text = @"123-4567890";
			[vc textFieldDidEndEditing:vc.phone];
			vc.bookingService.booking.customer.phone should equal(vc.phone.text);
		});
	});
	
	describe(@"textFieldValueChanged:", ^{
		it(@"should have an outlet action defined to catch when any text fields change", ^{
			[vc respondsToSelector:@selector(textFieldValueChanged:)] should be_truthy;
		});
		
		it(@"should set the right bar button item enabled if all the text fields have valid data entered", ^{
			//call these the way the user interaction would, setting the internal vars
			vc.emailAddress.text = @"test@test.com";
			[vc textFieldValueChanged:vc.emailAddress];
			vc.firstName.text = @"test";
			vc.lastName.text = @"test";
			vc.phone.text = @"111-222-3333";
			[vc textFieldValueChanged:vc.phone];
			
			vc.navigationItem.rightBarButtonItem.enabled should be_truthy;
		});
		
		it(@"should set the right bar button item disabled if any of the text fields don't have data entered", ^{
			vc.emailAddress.text = @"";
			vc.firstName.text = @"";
			vc.lastName.text = @"";
			vc.phone.text = @"";
			
			[vc textFieldValueChanged:nil];
			vc.navigationItem.rightBarButtonItem.enabled should be_falsy;
		});
	});
	
	describe(@"textField:shouldChangeCharactersInRange:", ^{
		it(@"should always return true", ^{
			[vc textField:nil shouldChangeCharactersInRange:NSMakeRange(0, 0) replacementString:nil] should be_truthy;
		});
		
		it(@"should not trigger auto-formatting when a different field is interacted with", ^{
			spy_on(vc);
			
			//loc, len
			NSRange range = NSMakeRange(0, 0);
			
			[vc textField:vc.emailAddress shouldChangeCharactersInRange:range replacementString:@""];
			vc should_not have_received(@selector(autoformatPhone));
		});
		
		it(@"should trigger auto-formatting of phone numbers when the phone field is interacted with appropriately", ^{
			spy_on(vc);
			
			//loc, len
			NSRange range = NSMakeRange(0, 0);
			vc.phone.text = @"";
			
			[vc textField:vc.phone shouldChangeCharactersInRange:range replacementString:@"1"];
			vc should have_received(@selector(autoformatPhone));
			
			range = NSMakeRange(3, 0);
			vc.phone.text = @"123";
			[vc textField:vc.phone shouldChangeCharactersInRange:range replacementString:@"1"];
			vc should have_received(@selector(autoformatPhone));
		});
		
		it(@"should not trigger auto-formatting of phone numbers when the phone field is interacted with inappropriately", ^{
			spy_on(vc);
			
			//loc, len
			NSRange range = NSMakeRange(0, 1);
			vc.phone.text = @"";
			
			[vc textField:vc.phone shouldChangeCharactersInRange:range replacementString:@"1"];
			vc should_not have_received(@selector(autoformatPhone));
			
			range = NSMakeRange(2, 0);
			vc.phone.text = @"123";
			[vc textField:vc.phone shouldChangeCharactersInRange:range replacementString:@"1"];
			vc should_not have_received(@selector(autoformatPhone));
		});
	});
	
	describe(@"autoformatPhone", ^{
		it(@"should do nothing when not at a separator boundary", ^{
			vc.phone.text = @"";
			
			[vc autoformatPhone];
			vc.phone.text should equal(@"");
			
			vc.phone.text = @"123-";
			
			[vc autoformatPhone];
			vc.phone.text should equal(@"123-");
			
			vc.phone.text = @"123-456-";
			
			[vc autoformatPhone];
			vc.phone.text should equal(@"123-456-");

			vc.phone.text = @"123-456-7890";
			
			[vc autoformatPhone];
			vc.phone.text should equal(@"123-456-7890");
		});
		
		it(@"should add a hyphen separator where necessary", ^{
			vc.phone.text = @"123";
			
			[vc autoformatPhone];
			vc.phone.text should equal(@"123-");
			
			vc.phone.text = @"123-456";
			
			[vc autoformatPhone];
			vc.phone.text should equal(@"123-456-");
		});
	});
});

SPEC_END
