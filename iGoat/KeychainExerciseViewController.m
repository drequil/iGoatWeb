#import "KeychainExerciseViewController.h"

@interface KeychainExerciseViewController()

-(void) storeCredentialsInSettingsApp;
-(void) storeCredentialsInKeychain;

@end

@implementation KeychainExerciseViewController

NSString *alertMessage ; 
@synthesize userName = _userName;
@synthesize password = _password;
@synthesize rememberMe = _rememberMe;





- (void) storeCredentialsInSettingsApp
{
    NSUserDefaults *credentials = [NSUserDefaults standardUserDefaults];
    
    [credentials setObject:self.userName.text forKey:@"username"];
    [credentials setObject:self.password.text forKey:@"password"];
    
    [credentials synchronize];
    
    // setting message for UIAlert
    alertMessage = @"stored in NSUserDefaults";
    
}

- (void) storeCredentialsInKeychain
{
    NSMutableDictionary *storeCredentials = [NSMutableDictionary dictionary];
    
    // Prepare keychain dict for storing credentials
    [storeCredentials setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
    //Store password encoded
    [storeCredentials setObject:[self.password.text dataUsingEncoding:NSUTF8StringEncoding] forKey:(id)kSecValueData];
    [storeCredentials setObject: self.userName.text forKey:(id)kSecAttrAccount];
    //Access keychain data for this app, only when unlocked. Imp to have this while adding as well as updating keychain item.
    // This is the default, but best practice to specify if apple changes its API.
    [storeCredentials setObject:(id)kSecAttrAccessibleWhenUnlocked forKey:(id)kSecAttrAccessible];
    
    // Query Keychain to see if credentials exists
    OSStatus results = SecItemCopyMatching((CFDictionaryRef) storeCredentials, nil);
    
    // if username exists in keychain
    if (results == errSecSuccess)
    {    
        NSDictionary *dataFromKeyChain = NULL;
        // There will always be one matching entry, thus limit resultset size to 1
        [storeCredentials setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
        [storeCredentials setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
        
        // Query keychain, with entered credentials and this will retrieve only 1 matching entry.
        results = SecItemCopyMatching((CFDictionaryRef) storeCredentials, (CFTypeRef *) &dataFromKeyChain);
        
        // encoded passsword.
        NSData *encodePassword = [NSData dataWithData:(NSData *)dataFromKeyChain];
        
        if(results == errSecSuccess)
        {
            
            NSString *passwordFromKeychain = [[NSString alloc] initWithData:encodePassword encoding:NSUTF8StringEncoding] ;
            NSLog(@"Password from keychain %@",passwordFromKeychain);
            
            
            NSMutableDictionary *updateQuery = [NSMutableDictionary dictionary];
            
            //  Setting up updateQuery dictionary to query existing keychain entries.
            [updateQuery setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
            [updateQuery setObject: self.userName.text forKey:(id)kSecAttrAccount];
            
            
            // Making dictionary with information to update "SecItemUpdate" ready. Its needed both updateQuery and tempUpdateQuery dictionaries to be similar. Could have re-used storeCredentials dictionary, but was leading to compile time warnings, while removing some objects.      
           
            NSMutableDictionary *tempUpdateQuery = [NSMutableDictionary dictionary];
            
            [tempUpdateQuery setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
            [tempUpdateQuery setObject:[self.password.text dataUsingEncoding:NSUTF8StringEncoding] forKey:(id)kSecValueData];
            [tempUpdateQuery setObject:self.userName.text forKey:(id)kSecAttrAccount];
            [tempUpdateQuery setObject:(id)kSecAttrAccessibleWhenUnlocked forKey:(id)kSecAttrAccessible];
            
            results = SecItemUpdate((CFDictionaryRef) updateQuery,
                                    (CFDictionaryRef) tempUpdateQuery);
            
            
            alertMessage = @"updated in keychain";
        }  
        else
        {
            alertMessage = @"exists in keychain, but error updating it";
        }
    }
    // credentials not entered in keychain, thus add it
    else if(results == errSecItemNotFound)
    {    
        results = SecItemAdd((CFDictionaryRef) storeCredentials, NULL); 
        alertMessage = @"added in keychain";
    }  
    else
    {
        alertMessage = @"adding/updating Exception in Keychain" ;
    }
}

-(IBAction)storeButtonPressed:(id)sender
{
    
    NSLog(@"In storeButtonPressed");
    
    [userName setText:userName.text];
    [password setText:password.text];
    
    NSLog(@"Username is %@ and password is %@ and remember me is %d", self.userName.text, self.password.text, self.rememberMe.on);
    
    if(self.rememberMe.on) {
        
        // Stores/Updates credentials in NSUserDefaults
         [self storeCredentialsInSettingsApp];
        
/*
  SOLUTION
  The problem lies in the use of NSUserDefaults to store credentials in function "storeCredentialsInSettingsApp". This causes the credentials to be stored in plaintext as we have seen.
 
  Instead of using this method, use iOS's Keychain to store credentials, which stores the credentials data into a keychain entry, where it is relatively safe from casual attacker. This can be achieved by simply uncommenting call to function "storeCredentialsInKeychain" below. Don't forget to comment out call to function "storeCredentialsInSettingsApp" above. 
 
  Note: iOS gives an application access to only its own keychain items and does not have access to any other application’s items. However since iOS 4, keychain items can be shared among different applications by using access groups. Due to this feature, keychain is not stored inside an application's sandbox. Thus, when we delete (uninstall) an application from an iOS device, its corresponding keychain entries are not deleted. Also, its is backed up in iTunes backs.
 
  Keychain is encrypted using device's Unique identifier (UID), which is unique for each and every device. If an attacker gets hold of UID of a particular backup (not very difficult to get it from the device), he can retrieve all keychain data. 
 
 
  Although keychain data is encrypted, we are still placing user's sensitive data in plaintext into an encrypted data store. Due to above factors and depending on how we use this data, we may want to further protect that data by hashing(encrypting) it prior to storing it in keychain.
 */
        
            // Stores/Updates data in Keychain
        //   [self storeCredentialsInKeychain];
    }
    else
    {
        alertMessage = @"Not to be Remembered" ;
    }
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Password"
                          message:alertMessage
                          delegate: nil
                          cancelButtonTitle:@"Cancel"
                          otherButtonTitles:@"OK",nil
                          ];
    [alert show]; 
}

@end

//******************************************************************************
//
// KeychainExerciseViewController.m
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
