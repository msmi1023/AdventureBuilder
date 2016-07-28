//
//  SelectAdventureViewController.m
//  AdventureBuilder
//
//  Created by tstone10 on 7/20/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import "SelectAdventureViewController.h"

@implementation SelectAdventureViewController {
	NSArray *adventures;
	NSArray *adventureTypes;
	NSArray *adventuresOfType;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	_adventureType.delegate = self;
	_adventureType.dataSource = self;
	_adventure.delegate = self;
	_adventure.dataSource = self;
	
	[_adventureService getAdventuresWithCompletionBlock:^(id response){
		adventures = response;
		
		adventureTypes = [self getTypesForListOfAdventures:response];
		[_adventureType reloadAllComponents];
		
		//on load we default to 0,0 selection. kick off our didSelect calls
		[self pickerView:_adventureType didSelectRow:0 inComponent:0];
		[self pickerView:_adventure didSelectRow:0 inComponent:0];
	}];
}

-(NSArray *)getTypesForListOfAdventures:(NSArray *)arr {
	NSMutableArray *types = [[NSMutableArray alloc] init];
	
	for(Adventure *adv in arr) {
		if(![types containsObject:adv.type]) {
			[types addObject:adv.type];
		}
	}
	
	return [types copy];
}

-(NSArray *)getAdventuresForType:(NSString *)type {
	NSMutableArray *toReturn = [[NSMutableArray alloc] init];
	
	for(Adventure *adv in adventures) {
		if([adv.type isEqualToString:type]) {
			[toReturn addObject:adv];
		}
	}
	
	return [toReturn copy];
}

-(NSString *)formatDetailStringForAdventure:(Adventure *)adv {
	NSMutableString *details = [[NSMutableString alloc] initWithFormat:@"Activities: %@", adv.activities];
	
	NSCharacterSet *setToRemove = [NSCharacterSet characterSetWithCharactersInString:@"(),\""];
	[details setString:[[details componentsSeparatedByCharactersInSet: setToRemove] componentsJoinedByString: @""]];
	
	[details appendFormat:@"\nDaily Price: $%@", adv.dailyPrice];
	
	return [details copy];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	NSInteger count = 0;
	
	if(pickerView == _adventureType) {
		count = adventureTypes.count;
	}
	else if(pickerView == _adventure) {
		count = adventuresOfType.count;
	}
	
	return count;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
	NSString *dataToReturn;
	
	if(pickerView == _adventureType) {
		dataToReturn = adventureTypes[row];
	}
	else if(pickerView == _adventure) {
		dataToReturn = ((Adventure *)adventuresOfType[row]).name;
	}
	
	return dataToReturn;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	if(pickerView == _adventureType) {
		adventuresOfType = [self getAdventuresForType:adventureTypes[row]];
		
		[_adventure reloadAllComponents];
		[_adventure selectRow:0 inComponent:0 animated:NO];
		//you would think that calling selectRow would trigger didSelectRow. it doesn't. do it manually.
		[self pickerView:_adventure didSelectRow:0 inComponent:0];
	}
	else if(pickerView == _adventure) {
		_bookingService.booking.adventure = ((Adventure *)adventuresOfType[row]);
		
		_details.text = [self formatDetailStringForAdventure:((Adventure *)adventuresOfType[row])];
	}
}

@end
