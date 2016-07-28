#import <Cedar/Cedar.h>
#import "SelectAdventureViewController.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

//for test purposes get ourselves access to the flow controller's prepareController method
@interface JabUIFlowController (Test)

-(id)prepareControllerFromStoryboard:(UIStoryboard *)storyboard withIdentifier:(NSString *)identifier;

@end

@interface SelectAdventureViewController (Test)

-(NSArray *)getTypesForListOfAdventures:(NSArray *)arr;
-(NSArray *)getAdventuresForType:(NSString *)type;
-(NSString *)formatDetailStringForAdventure:(Adventure *)adv;
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;

@end

SPEC_BEGIN(SelectAdventureViewControllerSpec)

describe(@"SelectAdventureViewController", ^{
	__block SelectAdventureViewController *vc;
	
	beforeEach(^{
		vc = [[JabUIFlowController sharedController] prepareControllerFromStoryboard:[JabUIFlowController sharedController].addBookingStoryboard withIdentifier:@"SelectAdventure"];
		
		vc.adventureType = [[UIPickerView alloc] init];
		vc.adventure = [[UIPickerView alloc] init];
	});
	
	it(@"should exist", ^{
		vc should_not be_nil;
	});
	
	it(@"should inherit from the JabUIController class", ^{
		vc.superclass should equal([JabUIViewController class]);
	});
	
	it(@"should be tied to the add booking storyboard and should have an instance of the booking service and the adventure service", ^{
		vc.storyboard should_not be_nil;
		vc.bookingService should_not be_nil;
		[vc.bookingService isKindOfClass:[BookingService class]] should be_truthy;
		vc.adventureService should_not be_nil;
		[vc.adventureService isKindOfClass:[AdventureService class]] should be_truthy;
	});
	
	it(@"should implement the necessary ui picker view delegate selectors", ^{
		[vc respondsToSelector:@selector(numberOfComponentsInPickerView:)] should be_truthy;
		[vc respondsToSelector:@selector(pickerView:numberOfRowsInComponent:)] should be_truthy;
		[vc respondsToSelector:@selector(pickerView:titleForRow:forComponent:)] should be_truthy;
		[vc respondsToSelector:@selector(pickerView:didSelectRow:inComponent:)] should be_truthy;
	});
	
	it(@"should have set itself as delegate and data source for the text fields in the viewDidLoad", ^{
		[vc viewWillAppear:NO];
		
		vc.adventureType.delegate should equal(vc);
		vc.adventureType.dataSource should equal(vc);
		vc.adventure.delegate should equal(vc);
		vc.adventure.dataSource should equal(vc);
	});
	
	describe(@"viewWillAppear", ^{
		__block completion_t localCallback;
		
		beforeEach(^{
			spy_on(vc);
			spy_on(vc.adventureService);
			spy_on(vc.adventureType);
			
			//mock out the adventure getter and get ourselves a copy of the passed in callback.
			vc.adventureService stub_method(@selector(getAdventuresWithCompletionBlock:))
			.and_do_block(^(completion_t block){
				localCallback = block;
			});
		});
		
		it(@"should retrieve adventures from the adventure service inside of viewWillAppear", ^{
			[vc viewWillAppear:NO];
			
			vc.adventureService should have_received(@selector(getAdventuresWithCompletionBlock:));
		});
		
		it(@"should create the appropriate local objects once the adventure list is retrieved", ^{
			NSArray *advs =@[[[Adventure alloc] initWithDictionary:@{@"type":@"test1",
																	 @"name":@"testy adv",
																	 @"dailyPrice":@1.0,
																	 @"activities":@[@"thing1", @"thing2"]}],
							 [[Adventure alloc] initWithDictionary:@{@"type":@"test2",
																	 @"name":@"cool adv",
																	 @"dailyPrice":@10.0,
																	 @"activities":@[@"stuff"]}]];
			
			[vc viewWillAppear:NO];
			localCallback(advs);
			
			//can access "private" implementation iVars using the valueForKey selector
			[vc valueForKey:@"adventures"] should equal(advs);
			vc should have_received(@selector(getTypesForListOfAdventures:)).with(advs);
			vc.adventureType should have_received(@selector(reloadAllComponents));
			vc should have_received(@selector(pickerView:didSelectRow:inComponent:)).with(vc.adventureType, 0, 0);
			vc should have_received(@selector(pickerView:didSelectRow:inComponent:)).with(vc.adventure, 0, 0);
		});
	});
	
	describe(@"getTypesForListOfAdventures", ^{
		it(@"should return a list of the unique types found in the provided array", ^{
			NSArray *advs =@[[[Adventure alloc] initWithDictionary:@{@"type":@"test1",
																	 @"name":@"testy adv",
																	 @"dailyPrice":@1.0,
																	 @"activities":@[@"thing1", @"thing2"]}],
							 [[Adventure alloc] initWithDictionary:@{@"type":@"test2",
																	 @"name":@"cool adv",
																	 @"dailyPrice":@10.0,
																	 @"activities":@[@"stuff"]}],
							 [[Adventure alloc] initWithDictionary:@{@"type":@"test1",
																	 @"name":@"adv",
																	 @"dailyPrice":@11.0,
																	 @"activities":@[@"stuff"]}]];
			NSArray *types = [vc getTypesForListOfAdventures:advs];
			
			types should equal(@[@"test1", @"test2"]);
		});
	});
	
	describe(@"getAdventuresForType", ^{
		it(@"should return a list of adventures with types that match the provided type", ^{
			NSArray *advs =@[[[Adventure alloc] initWithDictionary:@{@"type":@"test1",
																	 @"name":@"testy adv",
																	 @"dailyPrice":@1.0,
																	 @"activities":@[@"thing1", @"thing2"]}],
							 [[Adventure alloc] initWithDictionary:@{@"type":@"test2",
																	 @"name":@"cool adv",
																	 @"dailyPrice":@10.0,
																	 @"activities":@[@"stuff"]}],
							 [[Adventure alloc] initWithDictionary:@{@"type":@"test1",
																	 @"name":@"adv",
																	 @"dailyPrice":@11.0,
																	 @"activities":@[@"stuff"]}]];
			
			[vc setValue:advs forKey:@"adventures"];
			
			NSArray *adventuresOfType = [vc getAdventuresForType:@"test1"];
			
			adventuresOfType should equal(@[advs[0], advs[2]]);
		});
	});
	
	describe(@"formatDetailStringForAdventure", ^{
		it(@"should return a formatted string with details on the adventure", ^{
			Adventure *adv =[[Adventure alloc] initWithDictionary:@{@"type":@"test1",
																	 @"name":@"testy adv",
																	 @"dailyPrice":@1.0,
																	 @"activities":@[@"thing1", @"thing2"]}];
			
			NSString *details = [vc formatDetailStringForAdventure:adv];
			//remove whitespace for the purposes of this test, as it's only for display
			details = [[details componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsJoinedByString:@""];
			
			details should equal(@"Activities:\nthing1\nthing2\n\nDailyPrice:$1");
		});
	});
	
	describe(@"numberOfComponentsInPickerView", ^{
		it(@"should return 1", ^{
			[vc numberOfComponentsInPickerView:nil] should equal(1);
		});
	});
	
	describe(@"pickerView:numberRowsInComponent", ^{
		it(@"should return the number of adventure types if called with the adventureType picker", ^{
			//doesn't matter what's in the array, the method only grabs its count
			[vc setValue:@[@1, @2] forKey:@"adventureTypes"];
			
			[vc pickerView:vc.adventureType numberOfRowsInComponent:0] should equal(2);
		});
		
		it(@"should return the number of adventures with the selected type if called with the adventure picker", ^{
			//doesn't matter what's in the array, the method only grabs its count
			[vc setValue:@[@1, @2] forKey:@"adventuresOfType"];
			
			[vc pickerView:vc.adventure numberOfRowsInComponent:0] should equal(2);
		});
	});
	
	describe(@"pickerView:titleForRow:forComponent", ^{
		it(@"should return the text of the corresponding adventure type for the given row", ^{
			[vc setValue:@[@"one", @"two"] forKey:@"adventureTypes"];
			
			[vc pickerView:vc.adventureType titleForRow:1 forComponent:0] should equal(@"two");
		});
		
		it(@"should return the name of the corresponding adventure for the given row", ^{
			[vc setValue:@[[[Adventure alloc] initWithDictionary:@{@"type":@"test1",
																   @"name":@"testy adv",
																   @"dailyPrice":@1.0,
																   @"activities":@[@"thing1", @"thing2"]}],
						   [[Adventure alloc] initWithDictionary:@{@"type":@"test2",
																   @"name":@"cool adv",
																   @"dailyPrice":@10.0,
																   @"activities":@[@"stuff"]}]]
				  forKey:@"adventuresOfType"];
			
			[vc pickerView:vc.adventure titleForRow:1 forComponent:0] should equal(@"cool adv");
		});
	});
	
	describe(@"pickerView:didSelectRow:inComponent", ^{
		__block NSArray *advs;
		
		beforeEach(^{
			spy_on(vc);
			spy_on(vc.adventure);
			
			vc.details = [[UITextView alloc] init];
			
			[vc setValue:@[@"test1", @"test2"] forKey:@"adventureTypes"];
			
			advs = @[[[Adventure alloc] initWithDictionary:@{@"type":@"test1",
																   @"name":@"testy adv",
																   @"dailyPrice":@1.0,
																   @"activities":@[@"thing1", @"thing2"]}],
						   [[Adventure alloc] initWithDictionary:@{@"type":@"test2",
																   @"name":@"cool adv",
																   @"dailyPrice":@10.0,
																   @"activities":@[@"stuff"]}],
						   [[Adventure alloc] initWithDictionary:@{@"type":@"test1",
																   @"name":@"adv",
																   @"dailyPrice":@11.0,
																   @"activities":@[@"stuff"]}]];
			
			[vc setValue:advs forKey:@"adventures"];
		});
		
		it(@"should refresh the list of adventures for the newly selected type", ^{
			[vc pickerView:vc.adventureType didSelectRow:1 inComponent:0];
			
			[vc valueForKey:@"adventuresOfType"] should equal(@[advs[1]]);
			
			vc.adventure should have_received(@selector(reloadAllComponents));
			vc.adventure should have_received(@selector(selectRow:inComponent:animated:)).with(0, 0, NO);
			vc should have_received(@selector(pickerView:didSelectRow:inComponent:)).with(vc.adventure, 0, 0);
		});
		
		it(@"should set the selected adventure in the booking service and should display the adventure details", ^{
			[vc pickerView:vc.adventureType didSelectRow:0 inComponent:0];
			[vc pickerView:vc.adventure didSelectRow:1 inComponent:0];
			
			Adventure *selectedAdv = ((Adventure *)[vc valueForKey:@"adventuresOfType"][1]);
			
			[vc.bookingService.booking.adventure compareTo:selectedAdv] should be_truthy;
			vc.details.text should equal([vc formatDetailStringForAdventure:selectedAdv]);
		});
	});
});

SPEC_END
