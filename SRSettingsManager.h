//
//  SRSettingsManager.h
//  sugarain
//
//  Created by SonMintak on 5/26/15.
//  Copyright (c) 2015 Mintak Son. All rights reserved.
//

#import "SRManager.h"

extern NSString * const SRSettingsManagerDidLoadNotification;
extern NSString * const SRSettingsManagerDidChangeNotification;

@interface SRSettingsManager : SRManager

#pragma mark - client
@property (nonatomic, strong) NSNumber *didSeeTutorialView;

#pragma mark - from XML
@property (nonatomic, strong) NSString *rawInfo;

@property (nonatomic, strong) NSString *unique_id;
@property (nonatomic, strong) NSString *token;

@property (nonatomic, strong) NSString *alarm;
@property (nonatomic, strong) NSString *area;
@property (nonatomic, strong) NSString *bunya;

@property (nonatomic, strong) NSNumber *badge;

@property (nonatomic, readonly) NSString *device_id;
@property (nonatomic, readonly) NSArray *areaArray;
@property (nonatomic, readonly) NSArray *bunyaArray;

@property (nonatomic, readonly) NSCompoundPredicate *areaPredicate;
@property (nonatomic, readonly) NSCompoundPredicate *bunyaPredicate;

- (void) insertBunya:(NSString *)bunya;
- (void) removeBunya:(NSString *)bunya;

- (void) insertArea:(NSString *)area;
- (void) removeArea:(NSString *)area;

//- (void) getInfoFromServer;
- (void) updateInfoToServer;
//{
//  alarm = Y;
//  area = "\Uc804\Uad6d";
//  bunya = "\Ucc3d\Uc5c5\Ubca4\Ucc98";
//  "device_id" = "8330D3D2-DF1E-4ECB-8DB5-6580CD868851";
//  "device_type" = I;
//  id = 779754;
//  token = empty;
//}
@end
