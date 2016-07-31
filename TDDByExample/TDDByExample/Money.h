//
//  Money.h
//  TDDByExample
//
//  Created by School of Computing Macbook on 7/31/16.
//  Copyright © 2016 CIRC. All rights reserved.
//
//  Benefits of instance variables over properties: http://stackoverflow.com/a/9086811/3938401
//  I chose to use protected properties using a shared header because, syntacically,
//  it is much cleaner. I don't want to use the -> in my Objective-C code!
//  See: http://stackoverflow.com/q/11047351/3938401

#import <Foundation/Foundation.h>

@interface Money : NSObject

@end