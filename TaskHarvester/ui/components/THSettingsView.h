//
//  THSettingsView.h
//  TaskHarvester
//
//  Created by Jonathan Garay on 11/6/13.
//  Copyright (c) 2013 Crowdint. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface THSettingsView : NSView

@property IBOutlet NSTextField *harvestUsernameField;
@property IBOutlet NSTextField *harvestPasswordField;
@property IBOutlet NSSecureTextField *harvestSubdomainField;

@property IBOutlet NSTextField *pivotalUsernameField;
@property IBOutlet NSSecureTextField *pivotalPasswordField;

@property IBOutlet NSButton *backButton;

@end
