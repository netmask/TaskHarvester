//
//  THHarvestService.h
//  TaskHarvester
//
//  Created by Jonathan Garay on 10/31/13.
//  Copyright (c) 2013 Crowdint. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "THHarvestProfile.h"
#import "THHarvestProject.h"

@interface THHarvestService : NSObject
@property RKObjectManager *objectManager;

+(THHarvestService*) sharedinstance;
-(void) setupUsername:(NSString*) username
           password:(NSString*) password
            company:(NSString*) company;
@end
