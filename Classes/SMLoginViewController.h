//
//  SMLoginViewController.h
//  jabberClient
//
//  Created by cesarerocchi on 7/16/11.
//  Copyright 2011 studiomagnolia.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JabberClientAppDelegate.h"


@interface SMLoginViewController : UIViewController {
	
	UITextField *loginField;
	UITextField *passwordField;
	
}

@property (nonatomic,retain) IBOutlet UITextField *loginField;
@property (nonatomic,retain) IBOutlet UITextField *passwordField;

- (IBAction) login;
- (IBAction) hideLogin;

@end
