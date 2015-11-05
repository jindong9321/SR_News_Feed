//
//  SRMenuManager.m
//  sugarain
//
//  Created by SonMintak on 5/5/15.
//  Copyright (c) 2015 Mintak Son. All rights reserved.
//

#import "SRCategoryManager.h"

@implementation SRCategoryManager

SHARED_SINGLETON_CLASS(SRCategoryManager);

- (NSString *) categoryStringCompact:(SRCategoryCompactType)categoryType {
  switch (categoryType) {
    case SRCategoryCompactTypeRND:{
      return NSLocalizedString(@"R&D", @"&&&");
    }break;
    case SRCategoryCompactTypeStartUp:{
      return NSLocalizedString(@"창업/벤처", @"&&&");
    }break;
    case SRCategoryCompactTypeSmallBusiness:{
      return NSLocalizedString(@"소상공인", @"&&&");
    }break;
    case SRCategoryCompactTypeExport:{
      return NSLocalizedString(@"판로수출", @"&&&");
    }break;
    case SRCategoryCompactTypeFinance:{
      return NSLocalizedString(@"금융세제", @"&&&");
    }break;
    case SRCategoryCompactTypeHumanResource:{
      return NSLocalizedString(@"인력", @"&&&");
    }break;
    default:{
      return nil;
    }break;
  }
  return [self categoryString:categoryType + 2];
}

- (NSString *) categoryStringCompactInternal:(SRCategoryCompactType)categoryType {
  switch (categoryType) {
    case SRCategoryCompactTypeStartUp:{
      return NSLocalizedString(@"창업/벤처", @"&&&");
    }break;
    default:{
      return [self categoryStringCompact:categoryType];
    }break;
  }
}

- (UIImage *) categoryImageCompact:(SRCategoryCompactType)categoryType {
  return [self categoryImage:categoryType + 2];
}
- (UIImage *) categoryOnImageCompact:(SRCategoryCompactType)categoryType {
  return [self categoryOnImage:categoryType + 2];
}

- (UIImage *) navigationImageCompact:(SRCategoryCompactType)categoryType {
  return [self navigationImage:categoryType + 2];
}

- (NSString *) categoryString:(SRCategoryAllType)categoryType {
  switch (categoryType) {
    case SRCategoryAllTypeRecommend:{
      return NSLocalizedString(@"추천정보", @"&&&");
    }break;
    case SRCategoryAllTypeUpToDate:{
      return NSLocalizedString(@"최신정보", @"&&&");
    }break;
    default:{
      return [self categoryStringCompact:categoryType - 2];
    }break;
  }
}

- (UIImage *) categoryImage:(SRCategoryAllType)categoryType {
  switch (categoryType) {
    case SRCategoryAllTypeRecommend:{
      return [UIImage imageNamed:@"menu_icon01"];
    }break;
    case SRCategoryAllTypeUpToDate:{
      return [UIImage imageNamed:@"menu_icon02"];
    }break;
    case SRCategoryAllTypeRND:{
      return [UIImage imageNamed:@"menu_icon03"];
    }break;
    case SRCategoryAllTypeStartUp:{
      return [UIImage imageNamed:@"menu_icon04"];
    }break;
    case SRCategoryAllTypeSmallBusiness:{
      return [UIImage imageNamed:@"menu_icon05"];
    }break;
    case SRCategoryAllTypeExport:{
      return [UIImage imageNamed:@"menu_icon06"];
    }break;
    case SRCategoryAllTypeFinance:{
      return [UIImage imageNamed:@"menu_icon07"];
    }break;
    case SRCategoryAllTypeHumanResource:{
      return [UIImage imageNamed:@"menu_icon08"];
    }break;
    default:{
      return nil;
    }break;
  }
}

- (UIImage *) categoryOnImage:(SRCategoryAllType)categoryType {
  switch (categoryType) {
    case SRCategoryAllTypeRecommend:{
      return [UIImage imageNamed:@"menu_icon01_on"];
    }break;
    case SRCategoryAllTypeUpToDate:{
      return [UIImage imageNamed:@"menu_icon02_on"];
    }break;
    case SRCategoryAllTypeRND:{
      return [UIImage imageNamed:@"menu_icon03_on"];
    }break;
    case SRCategoryAllTypeStartUp:{
      return [UIImage imageNamed:@"menu_icon04_on"];
    }break;
    case SRCategoryAllTypeSmallBusiness:{
      return [UIImage imageNamed:@"menu_icon05_on"];
    }break;
    case SRCategoryAllTypeExport:{
      return [UIImage imageNamed:@"menu_icon06_on"];
    }break;
    case SRCategoryAllTypeFinance:{
      return [UIImage imageNamed:@"menu_icon07_on"];
    }break;
    case SRCategoryAllTypeHumanResource:{
      return [UIImage imageNamed:@"menu_icon08_on"];
    }break;
    default:{
      return nil;
    }break;
  }
}

- (UIImage *) navigationImage:(SRCategoryAllType)categoryType {
  switch (categoryType) {
    case SRCategoryAllTypeRecommend:{
      return [UIImage imageNamed:@"nav_menuicon01"];
    }break;
    case SRCategoryAllTypeUpToDate:{
      return [UIImage imageNamed:@"nav_menuicon02"];
    }break;
    case SRCategoryAllTypeRND:{
      return [UIImage imageNamed:@"nav_menuicon03"];
    }break;
    case SRCategoryAllTypeStartUp:{
      return [UIImage imageNamed:@"nav_menuicon04"];
    }break;
    case SRCategoryAllTypeSmallBusiness:{
      return [UIImage imageNamed:@"nav_menuicon05"];
    }break;
    case SRCategoryAllTypeExport:{
      return [UIImage imageNamed:@"nav_menuicon06"];
    }break;
    case SRCategoryAllTypeFinance:{
      return [UIImage imageNamed:@"nav_menuicon07"];
    }break;
    case SRCategoryAllTypeHumanResource:{
      return [UIImage imageNamed:@"nav_menuicon08"];
    }break;
    default:{
      return nil;
    }break;
  }
}

- (NSString *) categoryStringScrap:(SRCategoryScrapType)categoryType {
  switch (categoryType) {
    case SRCategoryScrapTypeAll:{
      return NSLocalizedString(@"전체", @"&&&");
    }break;
    default:{
      return [self categoryStringCompact:categoryType - 1];
    }break;
  }
}

@end
