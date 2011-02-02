//
//  NSString+ActiveSupportInflector.m
//  ActiveSupportInflector
//
//  Created by Sam Soffes on 1/25/11.
//  Copyright 2011 Scribd, Inc. All rights reserved.
//

#import "NSString+MSAdditions.h"
#import "ActiveSupportInflector.h"

@implementation NSString (ActiveSupportInflector)

- (NSString *)pluralizeString {
  static ActiveSupportInflector *inflector = nil;
  if (!inflector) {
    inflector = [[ActiveSupportInflector alloc] init];
  }
	
  return [inflector pluralize:self];
}


- (NSString *)singularizeString {
  static ActiveSupportInflector *inflector = nil;
  if (!inflector) {
    inflector = [[ActiveSupportInflector alloc] init];
  }
	
  return [inflector singularize:self];
}

@end
