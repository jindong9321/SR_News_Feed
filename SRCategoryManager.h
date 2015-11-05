//
//  SRMenuManager.h
//  sugarain
//
//  Created by SonMintak on 5/5/15.
//  Copyright (c) 2015 Mintak Son. All rights reserved.
//

#import "SRManager.h"

typedef NS_ENUM(NSInteger, SRCategoryCompactType) {
  SRCategoryCompactTypeRND = 0,
  SRCategoryCompactTypeStartUp,
  SRCategoryCompactTypeSmallBusiness,
  SRCategoryCompactTypeExport,
  SRCategoryCompactTypeFinance,
  SRCategoryCompactTypeHumanResource,
  SRCategoryCompactTypeEnd,
};

typedef NS_ENUM(NSInteger, SRCategoryAllType) {
  SRCategoryAllTypeRecommend = 0,
  SRCategoryAllTypeUpToDate,
  SRCategoryAllTypeRND,
  SRCategoryAllTypeStartUp,
  SRCategoryAllTypeSmallBusiness,
  SRCategoryAllTypeExport,
  SRCategoryAllTypeFinance,
  SRCategoryAllTypeHumanResource,
  SRCategoryAllTypeEnd,
};

typedef NS_ENUM(NSInteger, SRCategoryScrapType) {
  SRCategoryScrapTypeAll = 0,
  SRCategoryScrapTypeRND =            SRCategoryCompactTypeRND + 1,
  SRCategoryScrapTypeStartUp =        SRCategoryCompactTypeStartUp + 1,
  SRCategoryScrapTypeSmallBusiness =  SRCategoryCompactTypeSmallBusiness + 1,
  SRCategoryScrapTypeExport =         SRCategoryCompactTypeExport + 1,
  SRCategoryScrapTypeFinance =        SRCategoryCompactTypeFinance + 1,
  SRCategoryScrapTypeHumanResource =  SRCategoryCompactTypeHumanResource + 1,
  SRCategoryScrapTypeEnd =            SRCategoryCompactTypeEnd + 1,
};

@interface SRCategoryManager : SRManager

- (NSString *) categoryStringCompact:(SRCategoryCompactType)categoryType;
- (NSString *) categoryStringCompactInternal:(SRCategoryCompactType)categoryType;

- (UIImage *) categoryImageCompact:(SRCategoryCompactType)categoryType;
- (UIImage *) categoryOnImageCompact:(SRCategoryCompactType)categoryType;
- (UIImage *) navigationImageCompact:(SRCategoryCompactType)categoryType;

- (NSString *) categoryString:(SRCategoryAllType)categoryType;
- (UIImage *) categoryImage:(SRCategoryAllType)categoryType;
- (UIImage *) categoryOnImage:(SRCategoryAllType)categoryType;
- (UIImage *) navigationImage:(SRCategoryAllType)categoryType;

- (NSString *) categoryStringScrap:(SRCategoryScrapType)categoryType;

@end
