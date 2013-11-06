//
//  THPivotalProject.h
//  TaskHarvester
//
//  Created by Jonathan Garay on 11/3/13.
//  Copyright (c) 2013 Crowdint. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THMappable.h"

@interface THPivotalProject : NSObject<THMappable>
@property NSString *id;
@property NSString *name;

@property NSMutableArray *stories;

-(void) getAll:(void (^)(RKObjectRequestOperation *operation,
                         RKMappingResult *mappingResult))success;
@end
