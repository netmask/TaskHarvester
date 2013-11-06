//
//  THHarvestService.m
//  TaskHarvester
//
//  Created by Jonathan Garay on 10/31/13.
//  Copyright (c) 2013 Crowdint. All rights reserved.
//

#import "THHarvestService.h"

@implementation THHarvestService{
  NSString* _username;
  NSString* _password;
  NSString* _company;

}

+(THHarvestService*) sharedinstance
{
  static dispatch_once_t pred;
  static THHarvestService *shared = nil;
  
  dispatch_once(&pred, ^{
    shared = [[THHarvestService alloc] init];
  });
  
  return shared;
}

-(void) setupUsername:(NSString*) username
              password:(NSString*) password
               company:(NSString*) company
{
  
  _username = username;
  _password = password;
  _company = company;

  NSURL *baseURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://%@.harvestapp.com", _company]];
  AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
  [client setDefaultHeader:@"Accept" value:@"application/json"];
  [client setDefaultHeader:@"Content-Type" value:@"application/json"];

  [client setAuthorizationHeaderWithUsername:_username password:_password];
  [self setObjectManager:[[RKObjectManager alloc] initWithHTTPClient:client]];
}

@end
