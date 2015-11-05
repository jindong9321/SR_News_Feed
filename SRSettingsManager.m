//
//  SRSettingsManager.m
//  sugarain
//
//  Created by SonMintak on 5/26/15.
//  Copyright (c) 2015 Mintak Son. All rights reserved.
//

#import "SRSettingsManager.h"
#import "SRXMLRPCManager.h"

NSString * const SRSettingsManagerDidLoadNotification = @"SRSettingsManagerDidLoadNotification";
NSString * const SRSettingsManagerDidChangeNotification = @"SRSettingsManagerDidChangeNotification";

@interface SRSettingsManager ()
@end

@implementation SRSettingsManager

SHARED_SINGLETON_CLASS(SRSettingsManager);

- (id) init {
  if (self = [super init]) {
    [self _loadInfoFromUserDefaults];
    [self _registerKVO];
  }
  return self;
}

- (void) _loadInfoFromUserDefaults {
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  
  id temp = nil;
  
  if ((temp = [userDefaults objectForKey:@"didSeeTutorialView"]))    _didSeeTutorialView = temp;
  
  if ((temp = [userDefaults objectForKey:@"rawInfo"]))    _rawInfo = temp;
  
  if ((temp = [userDefaults objectForKey:@"unique_id"]))    _unique_id = temp;
  if ((temp = [userDefaults objectForKey:@"token"]))        _token = temp;
  
  if ((temp = [userDefaults objectForKey:@"alarm"]))        _alarm = temp;
  if ((temp = [userDefaults objectForKey:@"area"]))         _area= temp;
  if ((temp = [userDefaults objectForKey:@"bunya"]))    _bunya = temp;
  
  if ((temp = [userDefaults objectForKey:@"badge"]))    _badge = temp;
}

- (void) _saveInfoToUserDefaults {
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  
  [userDefaults setObject:_didSeeTutorialView forKey:@"didSeeTutorialView"];
  
  [userDefaults setObject:_rawInfo forKey:@"rawInfo"];
  
  [userDefaults setObject:_unique_id forKey:@"unique_id"];
  [userDefaults setObject:_token forKey:@"token"];
  
  [userDefaults setObject:_alarm forKey:@"alarm"];
  [userDefaults setObject:_area forKey:@"area"];
  [userDefaults setObject:_bunya forKey:@"bunya"];
  
  [userDefaults setObject:_badge forKey:@"badge"];
  
  [userDefaults synchronize];
}

- (void) _registerKVO {
  NSKeyValueObservingOptions options = NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew;
  
  [self addObserver:self forKeyPath:@"didSeeTutorialView" options:options context:nil];
  
  [self addObserver:self forKeyPath:@"rawInfo" options:options context:nil];
  
  [self addObserver:self forKeyPath:@"unique_id" options:options context:nil];
  [self addObserver:self forKeyPath:@"token" options:options context:nil];
  
  [self addObserver:self forKeyPath:@"alarm" options:options context:nil];
  [self addObserver:self forKeyPath:@"area" options:options context:nil];
  [self addObserver:self forKeyPath:@"bunya" options:options context:nil];
  
  [self addObserver:self forKeyPath:@"badge" options:options context:nil];
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
  NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
  [userDefaults setValue:change[NSKeyValueChangeNewKey] forKey:keyPath];
  [userDefaults synchronize];
  
  if ([keyPath isEqualToString:@"alarm"] ||
      [keyPath isEqualToString:@"bunya"] ||
      [keyPath isEqualToString:@"area"]) {
    [self updateInfoToServer];
  }
}

#pragma mark -
- (NSString *) device_id {
    
    NSLog(@"\n\nㅡㅡㅡㅡㅡㅡㅡㅡ\n device_ID = > %@ \nㅡㅡㅡㅡㅡㅡㅡㅡ\n\n",[UIDevice currentDevice].identifierForVendor.UUIDString);
  return [UIDevice currentDevice].identifierForVendor.UUIDString;
}

- (NSArray *) areaArray {
  NSArray *areaArray = [_area componentsSeparatedByString:@"|"];
  NSMutableArray *newAreaArray = [[NSMutableArray alloc] init];
  for (NSString *area in areaArray) {
    if (area.length == 0)
      continue;
    [newAreaArray addObject:area];
  }
  return newAreaArray;
}

- (NSArray *) bunyaArray {
  NSArray *bunyaArray = [_bunya componentsSeparatedByString:@"|"];
  NSMutableArray *newBunyaArray = [[NSMutableArray alloc] init];
  for (NSString *bunya in bunyaArray) {
    if (bunya.length == 0)
      continue;
    [newBunyaArray addObject:bunya];
  }
  return newBunyaArray;
}

- (NSCompoundPredicate *) areaPredicate {
  NSMutableArray *areaPredicateList = [[NSMutableArray alloc] init];
  for (NSString *area in self.areaArray) {
    NSPredicate *areaPredicate = [NSPredicate predicateWithFormat:@"location CONTAINS[cd] %@", area];
    [areaPredicateList addObject:areaPredicate];
  }
  NSCompoundPredicate *areaPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:areaPredicateList];
  return areaPredicate;
}

- (NSCompoundPredicate *) bunyaPredicate {
  NSMutableArray *bunyaPredicateList = [[NSMutableArray alloc] init];
  for (NSString *bunya in self.bunyaArray) {
    NSPredicate *bunyaPredicate = [NSPredicate predicateWithFormat:@"bunya_string CONTAINS[cd] %@", bunya];
    [bunyaPredicateList addObject:bunyaPredicate];
  }
  NSCompoundPredicate *bunyaPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:bunyaPredicateList];
  return bunyaPredicate;
}

#pragma mark -
- (void) insertBunya:(NSString *)bunya {
  if ([self.bunyaArray containsObject:bunya])
    return;
  
  NSMutableArray *mutableBunya = [self.bunyaArray mutableCopy];
  if (mutableBunya == nil) {
    mutableBunya = [[NSMutableArray alloc] init];
  }
  [mutableBunya addObject:bunya];
  
  self.bunya = [[mutableBunya componentsJoinedByString:@"|"] stringByAppendingString:@"|"];
}

- (void) removeBunya:(NSString *)bunya {
  if ([self.bunyaArray containsObject:bunya] == NO)
    return;
  
  NSMutableArray *mutableBunya = [self.bunyaArray mutableCopy];
  if (mutableBunya == nil) {
    mutableBunya = [[NSMutableArray alloc] init];
  }
  [mutableBunya removeObject:bunya];
  
  self.bunya = [[mutableBunya componentsJoinedByString:@"|"] stringByAppendingString:@"|"];
}

- (void) insertArea:(NSString *)area {
  if ([self.areaArray containsObject:area])
    return;
  
  NSMutableArray *mutableArea = [self.areaArray mutableCopy];
  if (mutableArea == nil) {
    mutableArea = [[NSMutableArray alloc] init];
  }
  [mutableArea addObject:area];
  
  self.area = [[mutableArea componentsJoinedByString:@"|"] stringByAppendingString:@"|"];
}

- (void) removeArea:(NSString *)area {
  if ([self.areaArray containsObject:area] == NO)
    return;
  
  NSMutableArray *mutableArea = [self.areaArray mutableCopy];
  if (mutableArea == nil) {
    mutableArea = [[NSMutableArray alloc] init];
  }
  [mutableArea removeObject:area];
  
  self.area = [[mutableArea componentsJoinedByString:@"|"] stringByAppendingString:@"|"];
}

#pragma mark -
/*- (void) getInfoFromServer {
  [[SRXMLRPCManager sharedManager] requestGetInfo:self.device_id
                                   successHandler:^(id XMLData) {
                                     BOOL didChangeSettings =
                                     ([_token isEqualToString:[XMLData[@"token"] objectWithNullCheck]] == NO) |
                                     ([_alarm isEqualToString:[XMLData[@"alarm"] objectWithNullCheck]] == NO) |
                                     ([_area isEqualToString:[XMLData[@"area"] objectWithNullCheck]] == NO) |
                                     ([_bunya isEqualToString:[XMLData[@"bunya"] objectWithNullCheck]] == NO) |
                                     ([_badge isEqualToNumber:@([XMLData[@"token"] integerValueWithNullCheck])] == NO);
                                     
                                     _rawInfo = [XMLData JSONRepresentation];
                                     
                                     _unique_id = [NSString stringWithFormat:@"%@", XMLData[@"id"]];
                                     
                                     _token = [XMLData[@"token"] objectWithNullCheck];
                                     
                                     _alarm = [XMLData[@"alarm"] objectWithNullCheck];
                                     _area = [XMLData[@"area"] objectWithNullCheck];
                                     _bunya = [XMLData[@"bunya"] objectWithNullCheck];
                                     
                                     _badge = @([XMLData[@"badge"] integerValueWithNullCheck]);
                                     
                                     [self _saveInfoToUserDefaults];
                                     
                                     [[NSNotificationCenter defaultCenter] postNotificationName:SRSettingsManagerDidLoadNotification object:nil];
                                     
                                     if (didChangeSettings == YES) {
                                       [[NSNotificationCenter defaultCenter] postNotificationName:SRSettingsManagerDidChangeNotification object:nil];
                                     }
                                   } failHandler:^(NSError *error, id XMLData) {
                                     
                                   }];
}*/

- (void) updateInfoToServer {
  [[SRXMLRPCManager sharedManager] requestSetupWithDeviceId:self.device_id
                                             successHandler:^(id XMLData) {
                                               [[NSNotificationCenter defaultCenter] postNotificationName:SRSettingsManagerDidChangeNotification object:nil];
                                             } failHandler:^(NSError *error, id XMLData) {
                                               
                                             }];
}
@end
