//
//  SMChatViewController.m
//  jabberClient
//
//  Created by cesarerocchi on 7/16/11.
//  Copyright 2011 studiomagnolia.com. All rights reserved.
//

#import "SMChatViewController.h"

#import "XMPP.h"


@implementation SMChatViewController

@synthesize messageField, chatWithUser, tView;


- (JabberClientAppDelegate *)appDelegate {
	return (JabberClientAppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (XMPPStream *)xmppStream {
	return [[self appDelegate] xmppStream];
}

- (id) initWithUser:(NSString *) userName {

	if (self = [super init]) {
		
		chatWithUser = userName; // @ missing
		
	}
	
	return self;

}

- (void)viewDidLoad {
	
    [super viewDidLoad];
	self.tView.delegate = self;
	self.tView.dataSource = self;
	messages = [[NSMutableArray alloc ] init];
	
	JabberClientAppDelegate *del = [self appDelegate];
	del._messageDelegate = self;
	[self.messageField becomeFirstResponder];

	
}



#pragma mark -
#pragma mark Actions

- (IBAction) closeChat {

	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction)sendMessage {
	
    NSString *messageStr = self.messageField.text;
	
    if([messageStr length] > 0) {
		
        NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
        [body setStringValue:messageStr];
		
        NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
        [message addAttributeWithName:@"type" stringValue:@"chat"];
        [message addAttributeWithName:@"to" stringValue:chatWithUser];
        [message addChild:body];
		
        [self.xmppStream sendElement:message];
		
		self.messageField.text = @"";
		

		NSMutableDictionary *m = [[NSMutableDictionary alloc] init];
		[m setObject:messageStr forKey:@"msg"];
		[m setObject:@"you" forKey:@"sender"];
		
		[messages addObject:m];
		[self.tView reloadData];
		[m release];
		
    }
	
	NSIndexPath *topIndexPath = [NSIndexPath indexPathForRow:messages.count-1 
												   inSection:0];
	
	[self.tView scrollToRowAtIndexPath:topIndexPath 
					  atScrollPosition:UITableViewScrollPositionMiddle 
							  animated:YES];
}


#pragma mark -
#pragma mark Table view delegates

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSDictionary *s = (NSDictionary *) [messages objectAtIndex:indexPath.row];
	
	static NSString *CellIdentifier = @"MessageCellIdentifier";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
	}
	
	
	cell.textLabel.text = [s objectForKey:@"msg"];
	cell.detailTextLabel.text = [s objectForKey:@"sender"];
	cell.accessoryType = UITableViewCellAccessoryNone;
	cell.userInteractionEnabled = NO;
	
	return cell;
	
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	return [messages count];
	
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	
	return 1;
	
}


#pragma mark -
#pragma mark Chat delegates


- (void)newMessageReceived:(NSString *)messageContent {

	[messages addObject:messageContent];
	[self.tView reloadData];

	NSIndexPath *topIndexPath = [NSIndexPath indexPathForRow:messages.count-1 
												   inSection:0];
	
	[self.tView scrollToRowAtIndexPath:topIndexPath 
					  atScrollPosition:UITableViewScrollPositionMiddle 
							  animated:YES];
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	
	[messageField dealloc];
	[chatWithUser dealloc];
	[tView dealloc];
    [super dealloc];
}


@end
