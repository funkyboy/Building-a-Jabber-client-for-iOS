//
//  jabberClientViewController.m
//  jabberClient
//
//  Created by cesarerocchi on 7/13/11.
//  Copyright 2011 studiomagnolia.com. All rights reserved.
//

#import "SMBuddyListViewController.h"

#import "XMPP.h"
#import "XMPPRoster.h"

@implementation SMBuddyListViewController

@synthesize tView, addBuddyView, buddyField;


- (JabberClientAppDelegate *)appDelegate {
	return (JabberClientAppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (XMPPStream *)xmppStream {
	return [[self appDelegate] xmppStream];
}

- (XMPPRoster *)xmppRoster {
	return [[self appDelegate] xmppRoster];
}


- (void)viewDidLoad {
	
    [super viewDidLoad];
	self.tView.delegate = self;
	self.tView.dataSource = self;
	JabberClientAppDelegate *del = [self appDelegate];
	del._chatDelegate = self;
	onlineBuddies = [[NSMutableArray alloc ] init];
	
}


- (void)viewDidAppear:(BOOL)animated {
	
	[super viewDidAppear:animated];
	
	NSString *login = [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"];
	
	if (login) {
		
		if ([[self appDelegate] connect]) {
			
			NSLog(@"show buddy list");
			
		}
		
	} else {
		
		[self showLogin];
		
	}
	
}

- (IBAction) showLogin {
	
	SMLoginViewController *loginController = [[SMLoginViewController alloc] init];
	[self presentModalViewController:loginController animated:YES];
	
}

#pragma mark -
#pragma mark Table view delegates

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSString *s = (NSString *) [onlineBuddies objectAtIndex:indexPath.row];
	
	static NSString *CellIdentifier = @"UserCellIdentifier";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
	
	cell.textLabel.text = s;
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
	return cell;
	
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	return [onlineBuddies count];
	
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	
	return 1;
	
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSString *userName = (NSString *) [onlineBuddies objectAtIndex:indexPath.row];
	SMChatViewController *chatController = [[SMChatViewController alloc] initWithUser:userName];
	[self presentModalViewController:chatController animated:YES];
	
}


#pragma mark -
#pragma mark Chat delegate

- (void)newBuddyOnline:(NSString *)buddyName {
	
	if (![onlineBuddies containsObject:buddyName]) {
	
		[onlineBuddies addObject:buddyName];
		[self.tView reloadData];
		
	}
	
}

- (void)buddyWentOffline:(NSString *)buddyName {
	
	[onlineBuddies removeObject:buddyName];
	[self.tView reloadData];
	
}

- (void)didDisconnect {
	
	[onlineBuddies removeAllObjects];
	[self.tView reloadData];
	
}

- (IBAction) addBuddy {
	
	//	XMPPJID *newBuddy = [XMPPJID jidWithString:self.buddyField.text];
	//	[self.xmppRoster addBuddy:newBuddy withNickname:@"ciao"];
	
}



- (void)dealloc {
	
	[tView release];
	[addBuddyView dealloc];
	[buddyField dealloc];
    [super dealloc];
	
}

@end
