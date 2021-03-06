//
//  ChapterTwo.m
//  TDDByExample
//
//  Created by Deadpikle on 7/13/16.
//  Copyright © 2016 CIRC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Money.h"
#import "Bank.h"
#import "Expression.h"
#import "Sum.h"

@interface MoneyTests : XCTestCase

@property id<Expression> fiveBucks;
@property id<Expression> tenFrancs;
@property Bank *bank;

@end

@implementation MoneyTests

-(void)setUp {
	self.fiveBucks = [Money dollarWithAmount:5];
	self.tenFrancs = [Money francWithAmount:10];
	self.bank = [Bank new];
	[self.bank addCurrencyExchangeRateFrom:@"CHF" toCurrency:@"USD" withRate:2];
}

-(void)testMultiplication {
	Money *five = [Money dollarWithAmount:5];
    // We can either use XCTAssertTrue (with an isEqualTo: call) or XCTAssertEqualObjects
    // to compare two Dollar objects. Dollars are pointers, so we can't just do
    // == or similar (as we must compare values).
    XCTAssertTrue([[Money dollarWithAmount:10] isEqualTo:[five times:2]]);
    XCTAssertEqualObjects([Money dollarWithAmount:15], [five times:3]);
}

-(void)testEquality {
    XCTAssertTrue([[Money dollarWithAmount:5] isEqualTo:[Money dollarWithAmount:5]]);
	XCTAssertFalse([[Money dollarWithAmount:5] isEqualTo:[Money dollarWithAmount:6]]);
}

-(void)testPrivateVariableAccess {
    // In Objective-C, there are crafty ways to access private variables. >:)
    Money *twelve = [Money dollarWithAmount:12];
    XCTAssertEqual(12, [[twelve valueForKey:@"amount"] integerValue]);
    
    [twelve setValue:@15 forKey:@"amount"];
    XCTAssertEqual(15, [[twelve valueForKey:@"amount"] integerValue]);
}

-(void)testMoneyEquality {
	XCTAssertFalse([[Money francWithAmount:5] isEqualTo:[Money dollarWithAmount:5]]);
}

// Currency Tests

-(void)testCurrency {
	XCTAssertTrue([@"USD" isEqualToString:[[Money dollarWithAmount:1] currency]]);
	XCTAssertTrue([@"CHF" isEqualToString:[[Money francWithAmount:1] currency]]);
}

// Addition Tests

-(void)testSimpleAddition {
	Money *five = [Money dollarWithAmount:5];
	id<Expression> sum = [five plus:five];
	Bank *bank = [[Bank alloc] init];
	Money *reduced = [bank reduce:sum toCurrency:@"USD"];
	XCTAssertTrue([[Money dollarWithAmount:10] isEqualTo:reduced]);
}

-(void)testPlusReturnsSum {
	Money *five = [Money dollarWithAmount:5];
	id<Expression> result = [five plus:five];
	Sum *actualSum = (Sum*)result;
	XCTAssertEqual(five, actualSum.augend);
	XCTAssertEqual(five, actualSum.addend);
}

-(void)testReduceSum {
	id<Expression> sum = [[Sum alloc] initWithAugend:[Money dollarWithAmount:3] addend:[Money dollarWithAmount:4]];
	Bank *bank = [Bank new]; // same as [[Bank alloc] init]
	Money *result = [bank reduce:sum toCurrency:@"USD"];
	XCTAssertTrue([result isEqualTo:[Money dollarWithAmount:7]]);
}

-(void)testReduceMoney {
	Money *result = [self.bank reduce:[Money dollarWithAmount:1] toCurrency:@"USD"];
	XCTAssertTrue([result isEqualTo:[Money dollarWithAmount:1]]);
}

-(void)testReduceMoneyDifferentCurrency {
	Money *franc = [Money francWithAmount:2];
	Money *result = [self.bank reduce:franc toCurrency:@"USD"];
	XCTAssertTrue([result isEqualTo:[Money dollarWithAmount:1]]);
}

-(void)testIdentityRate {
	XCTAssertEqual(1, [[Bank new] getExchangeRateFromCurrency:@"USD" toCurrency:@"USD"]);
}

// Mixed money tests

-(void)testMixedAddition {
	Money *result = [self.bank reduce:[self.fiveBucks plus:self.tenFrancs] toCurrency:@"USD"];
	XCTAssertTrue([result isEqualTo:[Money dollarWithAmount:10]]);
}

-(void)testSumPlusMoney {
	id<Expression> sum = [[[Sum alloc] initWithAugend:self.fiveBucks addend:self.tenFrancs] plus:self.fiveBucks];
	Money *result = [self.bank reduce:sum toCurrency:@"USD"];
	XCTAssertTrue([result isEqualTo:[Money dollarWithAmount:15]]);
}

-(void)testSumTimes {
	id<Expression> sum = [[[Sum alloc] initWithAugend:self.fiveBucks addend:self.tenFrancs] times:2];
	Money *result = [self.bank reduce:sum toCurrency:@"USD"];
	XCTAssertTrue([result isEqualTo:[Money dollarWithAmount:20]]);
}

@end
