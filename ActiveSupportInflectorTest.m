//
//  InflectorTest.m
//  TrollyDolly
//
//  Created by Tom Ward on 26/05/2009.
//  Copyright 2009 Tom Ward. All rights reserved.
//

#import <Foundation/Foundation.h>

#define HC_SHORTHAND
#import <hamcrest/hamcrest.h>

#import "GTMSenTestCase.h"
#import "TrollyDollyUtil.h"
#import "ActiveSupportInflector.h"


@interface ActiveSupportInflectorTest : SenTestCase {
  ActiveSupportInflector* inflector;
}

  @property (retain) ActiveSupportInflector* inflector;
@end

@implementation ActiveSupportInflectorTest

@synthesize inflector;

- (void) setUp {
  [self setInflector:[[[ActiveSupportInflector alloc] init] autorelease]];
}

- (void) testPluralizationAndSingularization {
  NSDictionary* dictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"ActiveSupportInflectorTest" ofType:@"plist"]];
  NSArray* singularAndPlural = [dictionary objectForKey:@"singularAndPlural"];
  for (NSArray* sAndP in singularAndPlural) {
    NSString* singular = [sAndP objectAtIndex:0];
    NSString* plural = [sAndP objectAtIndex:1];
    NSLog(plural);
    NSLog(singular);
    
    assertThat([inflector pluralize:singular], equalTo(plural));
    assertThat([inflector singularize:plural], equalTo(singular));
  }
} 
@end