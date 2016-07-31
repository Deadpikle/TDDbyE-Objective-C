//
//  Dollar.h
//  TDDByExample
//
//  Created by School of Computing Macbook on 7/13/16.
//  Copyright © 2016 CIRC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Dollar : NSObject

@property int amount;

-(instancetype)initWithAmount:(int)amount;

// convenience "constructor" so we don't have to do both alloc and initWithAmount
+(instancetype)dollarWithAmount:(int)amount;

-(Dollar*)times:(int)multiplier;

@end
