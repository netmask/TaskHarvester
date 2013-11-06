//
//  THPivotalService.m
//  TaskHarvester
//
//  Created by Jonathan Garay on 11/2/13.
//  Copyright (c) 2013 Crowdint. All rights reserved.
//

#import "THPivotalService.h"

const NSString *_kPivotalToken = @"pivotal.authtoken";

@implementation THPivotalService{
  NSString *_authtoken;
}



+(THPivotalService*) sharedinstance
{
  static dispatch_once_t pred;
  static THPivotalService *shared = nil;
  
  dispatch_once(&pred, ^{
    shared = [[THPivotalService alloc] init];
  });
  
  return shared;
}

-(void) setupWithUserName:(NSString*) username
                 password:(NSString*) password
{
  FXKeychain *keychain = [FXKeychain defaultKeychain];

  unless((_authtoken = [keychain objectForKey:_kPivotalToken]))
  {
    
    NSString *token = runCommand([NSString stringWithFormat:@"curl -d username=%@ -d password=%@ -X POST https://www.pivotaltracker.com/services/v3/tokens/active | grep guid", username, password]);
    _authtoken = [[token stringByReplacingOccurrencesOfString:@"<guid>" withString:@""]
                  stringByReplacingOccurrencesOfString:@"</guid>" withString:@""];
    
    [keychain setObject:_authtoken forKey:_kPivotalToken];
  }
  
  RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:@"https://www.pivotaltracker.com"]];
  [manager.HTTPClient setDefaultHeader:@"X-TrackerToken" value:[_authtoken stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
  
  [self setObjectManager:manager];
}

NSString *runCommand(NSString *commandToRun)
{
  NSTask *task;
  task = [[NSTask alloc] init];
  [task setLaunchPath: @"/bin/sh"];
  
  NSArray *arguments = [NSArray arrayWithObjects:
                        @"-c" ,
                        [NSString stringWithFormat:@"%@", commandToRun],
                        nil];
  
  NSLog(@"run command: %@",commandToRun);

  [task setArguments: arguments];
  
  NSPipe *pipe;
  pipe = [NSPipe pipe];
  [task setStandardOutput: pipe];
  
  NSFileHandle *file;
  file = [pipe fileHandleForReading];
  
  [task launch];
  
  NSData *data;
  data = [file readDataToEndOfFile];
  
  NSString *output;
  output = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
  return output;
}

@end
