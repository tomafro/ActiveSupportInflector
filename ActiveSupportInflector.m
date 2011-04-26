//
//  Inflector.m
//  ActiveSupportInflector
//

#import "ActiveSupportInflector.h"

@interface ActiveSupportInflectorRule : NSObject
{
  NSString* rule;
  NSString* replacement;
}

@property (retain) NSString* rule;
@property (retain) NSString* replacement;

+ (ActiveSupportInflectorRule*) rule:(NSString*)rule replacement:(NSString*)replacement;

@end

@implementation ActiveSupportInflectorRule
  @synthesize rule;
  @synthesize replacement;

+ (ActiveSupportInflectorRule*) rule:(NSString*)rule replacement:(NSString*)replacement {
  ActiveSupportInflectorRule* result;
  if ((result = [[[self alloc] init] autorelease])) {
    [result setRule:rule];
    [result setReplacement:replacement];
  }
  return result;
}

@end


@interface ActiveSupportInflector(PrivateMethods)
- (NSString*)_applyInflectorRules:(NSArray*)rules toString:(NSString*)string;
@end

@implementation ActiveSupportInflector

- (ActiveSupportInflector*)init {
  if ((self = [super init])) {
    uncountableWords = [[NSMutableSet alloc] init];
    pluralRules = [[NSMutableArray alloc] init];
    singularRules = [[NSMutableArray alloc] init];
    [self addInflectionsFromFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"ActiveSupportInflector" ofType:@"plist"]];
  } 
  return self; 
}

- (void)addInflectionsFromFile:(NSString*)path {
  [self addInflectionsFromDictionary:[NSDictionary dictionaryWithContentsOfFile:path]];
}

- (void)addInflectionsFromDictionary:(NSDictionary*)dictionary {
  for (NSArray* pluralRule in [dictionary objectForKey:@"pluralRules"]) {
    [self addPluralRuleFor:[pluralRule objectAtIndex:0] replacement:[pluralRule objectAtIndex:1]];
  }
  
  for (NSArray* singularRule in [dictionary objectForKey:@"singularRules"]) {
    [self addSingularRuleFor:[singularRule objectAtIndex:0] replacement:[singularRule objectAtIndex:1]];
  }
  
  for (NSArray* irregularRule in [dictionary objectForKey:@"irregularRules"]) {
    [self addIrregularRuleForSingular:[irregularRule objectAtIndex:0] plural:[irregularRule objectAtIndex:1]];
  }
  
  for (NSString* uncountableWord in [dictionary objectForKey:@"uncountableWords"]) {
    [self addUncountableWord:uncountableWord];
  }
}

- (void)addUncountableWord:(NSString*)string {
  [uncountableWords addObject:string];
}

- (void)addIrregularRuleForSingular:(NSString*)singular plural:(NSString*)plural {
  NSString* singularRule = [NSString stringWithFormat:@"%@$", plural];
  [self addSingularRuleFor:singularRule replacement:singular];
  
  NSString* pluralRule = [NSString stringWithFormat:@"%@$", singular];
  [self addPluralRuleFor:pluralRule replacement:plural];  
}

- (void)addPluralRuleFor:(NSString*)rule replacement:(NSString*)replacement {
  [pluralRules insertObject:[ActiveSupportInflectorRule rule:rule replacement: replacement] atIndex:0];
}

- (void)addSingularRuleFor:(NSString*)rule replacement:(NSString*)replacement {
  [singularRules insertObject:[ActiveSupportInflectorRule rule:rule replacement: replacement] atIndex:0];
}

- (NSString*)pluralize:(NSString*)singular {
  return [self _applyInflectorRules:pluralRules toString:singular];
}

- (NSString*)singularize:(NSString*)plural {
  return [self _applyInflectorRules:singularRules toString:plural];
}

- (NSString*)_applyInflectorRules:(NSArray*)rules toString:(NSString*)string {
  if ([uncountableWords containsObject:string]) {
    return string;
  }
  else {
    for (ActiveSupportInflectorRule* rule in rules) {
      NSRange range = NSMakeRange(0, [string length]);
      NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:[rule rule] options:0 error:nil];
      if ([regex firstMatchInString:string options:0 range:range]) {
        // NSLog(@"rule: %@, replacement: %@", [rule rule], [rule replacement]);
        return [regex stringByReplacingMatchesInString:string options:0 range:range withTemplate:[rule replacement]];
      }
    }
    return string;
  }  
}

- (void)dealloc {
  [super dealloc];
  [uncountableWords release];
  [pluralRules release];
  [singularRules release];
}

@end
