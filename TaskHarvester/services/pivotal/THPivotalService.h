//
//  THPivotalService.h
//  TaskHarvester
//
//  Created by Jonathan Garay on 11/2/13.
//  Copyright (c) 2013 Crowdint. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface THPivotalService : NSObject

@property RKObjectManager *objectManager;

+(THPivotalService*) sharedinstance;
-(void) setupWithUserName:(NSString*) username
                 password:(NSString*) password;
@end
