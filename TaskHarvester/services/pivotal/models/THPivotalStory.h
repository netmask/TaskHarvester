//
//  THPivotalStory.h
//  TaskHarvester
//
//  Created by Jonathan Garay on 11/4/13.
//  Copyright (c) 2013 Crowdint. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THPivotalProject.h"
#import "THPivotalService.h"

@interface THPivotalStory :  NSObject<THMappable>
@property THPivotalProject *project;

@property NSString *storyType;
@property NSString *id;
@property NSString *name;
@property NSString *url;
@property NSNumber *estimate;
@property NSString *currentState;
@property NSDate *createdAt;



-(void) getAll:(void (^)(RKObjectRequestOperation *operation,
                         RKMappingResult *mappingResult))success;

-(id) initWithProject:(THPivotalProject*) project;
@end
