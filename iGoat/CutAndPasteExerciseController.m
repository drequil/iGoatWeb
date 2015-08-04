#import "CutAndPasteExerciseController.h"

@implementation CutAndPasteExerciseController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

//******************************************************************************
// SOLUTION
//
// Register to listen for background notifications in the initWithNibName()
// override...
//
// [[NSNotificationCenter defaultCenter] addObserver:self
//  selector:@selector(didEnterBackground:) name:@"didEnterBackground" 
//  object:nil];
//
// [[NSNotificationCenter defaultCenter] addObserver:self
//  selector:@selector(didBecomeActive:) name:@"didBecomeActive" 
//  object:nil];
//
// Define a pasteboardContents instance variable (NSString *).
//
// And uncomment the methods below...
//
// (Don't forget to remove the observers in dealloc() method.)
//******************************************************************************

/*
- (void)didEnterBackground:(NSNotification *)notification
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    self.pasteboardContents = pasteboard.string;
    pasteboard.string = @"";
}
 
- (void)didBecomeActive:(NSNotification *)notification
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.pasteboardContents;
}
*/

@end

//******************************************************************************
//
// CutAndPasteExerciseController.m
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