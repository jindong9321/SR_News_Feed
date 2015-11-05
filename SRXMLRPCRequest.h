//
//  SRXMLRPCRequest.h
//  sugarain
//
//  Created by SonMintak on 5/25/15.
//  Copyright (c) 2015 Mintak Son. All rights reserved.
//

#import "XMLRPCRequest.h"

typedef void (^SRXMLRPCSuccessHandler)(id XMLData);
typedef void (^SRXMLRPCFailHandler)(NSError *error, id XMLData);

@interface SRXMLRPCRequest : XMLRPCRequest

@property (nonatomic, copy) SRXMLRPCSuccessHandler successHandler;
@property (nonatomic, copy) SRXMLRPCFailHandler failHandler;
@end
