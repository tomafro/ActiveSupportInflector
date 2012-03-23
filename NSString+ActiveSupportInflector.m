//
//  NSString+ActiveSupportInflector.m
//  ActiveSupportInflector
//

//#import "NSString+MSAdditions.h"
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
