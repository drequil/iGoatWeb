#import "ServerCommunicationExerciseController.h"
#import "JSON.h"

@implementation ServerCommunicationExerciseController

NSString * const USER_URL = @"http://localhost:8080/igoat/user";

@synthesize firstNameField, lastNameField, ssnField;

- (IBAction)submit:(id) sender { 
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
	jsonWriter.humanReadable = YES;
	jsonWriter.sortKeys = YES;

	NSDictionary *accountInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
								 firstNameField.text, @"firstName",
								 lastNameField.text, @"lastName",
								 ssnField.text, @"socialSecurityNumber", nil];
	
	NSString *jsonString = [[NSString alloc] initWithString:[jsonWriter stringWithObject:accountInfo]];
    
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:USER_URL]];
	responseData = [[NSMutableData data] retain];
	
	[request setHTTPMethod:@"POST"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"close" forHTTPHeaderField:@"Connection"];
	[request setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];

	[jsonWriter release];
	[jsonString release];
	[accountInfo release];

	[[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[responseData setLength:0];

    UIAlertView *alert;

    NSDictionary *headers = [(NSHTTPURLResponse *) response allHeaderFields];
    NSString *sslEnabled = [headers objectForKey:@"X-Goat-Secure"];

    if ([sslEnabled boolValue]) {
        alert = [[UIAlertView alloc]
                 initWithTitle:@"Congratulations!"
                 message:@"The user's account info was protected in transit."
                 delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    } else {
        alert = [[UIAlertView alloc]
                 initWithTitle:@"Owned"
                 message:@"The user's account profile info was stolen by someone on your Wi-Fi!"
                 delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    }

    [alert show];  
    [alert release];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // TODO: Parse the JSON in the server response and do something with it?
	[responseData appendData:data];

    /*
    NSString *jsonString = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
    NSDictionary *json = (NSDictionary *)[jsonParser objectWithString:jsonString error:NULL];
     */
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	[connection release];
	[responseData release];

    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Error"
                          message:@"Server reqest failed; see log for details."
                          delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];

    [alert show];  
    [alert release];

    NSLog(@"Request failed: %@ %@", [error localizedDescription],
		  [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	[connection release];
	[responseData release];
}

- (void)dealloc {
    [firstNameField release];
    [lastNameField release];
    [ssnField release];
    [super dealloc];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.firstNameField = nil;
    self.lastNameField = nil;
    self.ssnField = nil;
}

//******************************************************************************
// SOLUTION
//
// The iGoat server listens on two separate ports simultaneously; 8443 (SSL)
// and 8080 (non-SSL). To secure the POST to the /igoat/user endpoint, change
// the USER_URL constant at the top of the file to...
//
// "https://localhost:8443/igoat/user"
//
// The NSURLConnection class will automatically wrap the connection in an SSL
// channel and the communication between client and server will be secure.
//
// See the documentation in igoat_server.rb for additional info.
//
// Additionally, uncomment the two methods defined below to instruct the
// NSURLConnection to ignore the fact that the iGoat server is using a
// self-signed certificate. Normally you would NOT want to do this in a
// production environment.
//******************************************************************************

/*
- (BOOL)connection:(NSURLConnection *)connection
    canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection
    didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
	
    [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust]
		 forAuthenticationChallenge:challenge];
}
*/

@end

//******************************************************************************
//
// ServerCommunicationExerciseController.m
// iGoat
//
// This file is part of iGoat, an Open Web Application Security
// Project tool. For details, please see http://www.owasp.org
//
// Copyright(c) 2011 KRvW Associates, LLC (http://www.krvw.com)
// The iGoat project is principally sponsored by KRvW Associates, LLC
// Project Leader, Kenneth R. van Wyk (ken@krvw.com)
// Lead Developer: Sean Eidemiller (sean@krvw.com)
//
// iGoat is free software; you may redistribute it and/or modify it
// under the terms of the GNU General Public License as published by
// the Free Software Foundation; version 3.
//
// iGoat is distributed in the hope it will be useful, but WITHOUT ANY
// WARRANTY; without even the implied warranty of MERCHANTABILITY or
// FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public
// License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc. 59 Temple Place, suite 330, Boston, MA 02111-1307
// USA.
//
// Getting Source
//
// The source for iGoat is maintained at http://code.google.com/p/owasp-igoat/
//
// For project details, please see https://www.owasp.org/index.php/OWASP_iGoat_Project
//
//******************************************************************************