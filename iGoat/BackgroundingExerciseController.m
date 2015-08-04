#import "BackgroundingExerciseController.h"

@implementation BackgroundingExerciseController

@synthesize cityField, colorField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidUnload
{
    self.cityField = nil;
    self.colorField = nil;
    [super viewDidUnload];
}

- (void)dealloc
{
    [cityField release];
    [colorField release];
    [super dealloc];
}

//******************************************************************************
// SOLUTION
//
// Register to listen for notifications in the initWithNibName() override...
//
// [[NSNotificationCenter defaultCenter] addObserver:self
//  selector:@selector(didEnterBackground:) name:@"didEnterBackground" 
//  object:nil];
//
// [[NSNotificationCenter defaultCenter] addObserver:self
//  selector:@selector(didBecomeActive:) name:@"didBecomeActive" 
//  object:nil];
//
// And uncomment the methods below...
//
// (Don't forget to remove the observers in dealloc() method.)
//******************************************************************************

/*
- (void)didEnterBackground:(NSNotification *)notification
{
    self.cityField.hidden = YES;
    self.colorField.hidden = YES;
}

- (void)didBecomeActive:(NSNotification *)notification
{
    self.cityField.hidden = NO;
    self.colorField.hidden = NO;
}
*/

@end

//******************************************************************************
//
// BackgroundingExerciseController.m
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