#import "ExerciseViewController.h"
#import "HintsViewController.h"
#import "InfoViewController.h"
#import "Exercise.h"

@implementation ExerciseViewController

@synthesize scrollView, exercise, rootExerciseController, activeField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil exercise:(Exercise *)ex {
    if ((self = [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Reset the hint index on the exercise.
        ex.hintIndex = 0;

        self.exercise = ex;
        self.rootExerciseController = self;
        [self registerForKeyboardNotifications];
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
             exercise:(Exercise *)ex rootExerciseController:(ExerciseViewController *)exerciseController {

    if ((self = [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil exercise:ex])) {
        self.rootExerciseController = exerciseController;
    }
    
    return self;
}

- (void)restartExercise {
    if (self.rootExerciseController != self) {
        [self.navigationController popToViewController:self.rootExerciseController animated:YES];
    }
}

- (NSString *)getPathForFilename:(NSString *)filename {
	// Get the path to the Documents directory belonging to this app.
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
    
	// Append the filename to get the full, absolute path.
	NSString *fullPath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, filename];
	return fullPath;
}

- (void)goHome {
    [[self navigationController] popToRootViewControllerAnimated:YES];
}

- (void)showHintsDialog {
    HintsViewController *hintsViewController = [[HintsViewController alloc]
                                                initWithNibName:@"HintsViewController"
                                                bundle:nil exercise:self.exercise];

    hintsViewController.delegate = self;
    
    [self presentModalViewController:hintsViewController animated:NO];
    [hintsViewController release];
}

- (void)showSolutionDialog {
    InfoViewController *infoViewController = [[InfoViewController alloc]
                                              initWithNibName:@"InfoViewController"
                                              bundle:nil infoText:self.exercise.htmlSolution];
    
    infoViewController.delegate = self;
    
    [self presentModalViewController:infoViewController animated:NO];
    [infoViewController release];
}

- (void)didDismissInfoDialog {
    [self dismissModalViewControllerAnimated:NO];
}

- (void)displayAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self
                                          cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alert show];
    [alert release];
}

- (IBAction)textFieldReturn:(id)sender {
    [sender resignFirstResponder];
}

- (IBAction)backgroundTouched:(id)sender {
    for (UIView *view in [self.view subviews]) {
        if ([view isFirstResponder]) {
            [view resignFirstResponder];
            break;
        }
    }
}

// Make it known that we care about keyboard notifications.
- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)notification {
    // Don't bother doing anything if this exercise doesn't have a scroll view.
    if (!scrollView) return;

    if (!keyboardHeight) {
        NSDictionary* info = [notification userInfo];
        CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        keyboardHeight = keyboardSize.height;
    }

    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardHeight, 0.0);
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    CGRect aRect = self.view.frame;
    aRect.size.height -= keyboardHeight;
    if (!CGRectContainsPoint(aRect, activeField.frame.origin)) {
        CGPoint scrollPoint = CGPointMake(0.0, keyboardHeight + activeField.frame.size.height -
                                          activeField.frame.origin.y);
        [scrollView setContentOffset:scrollPoint animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)notification {
    // Don't bother doing anything if this exercise doesn't have a scroll view.
    if (!scrollView) return;

    [scrollView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
    activeField = nil;
}

- (IBAction)textFieldDidBeginEditing:(id)sender {
    if (activeField) {
        activeField = (UITextField *)sender;
        [[NSNotificationCenter defaultCenter]
         postNotificationName:UIKeyboardDidShowNotification object:nil];
    } else {
        activeField = (UITextField *)sender;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Configure the navigation bar at the top.
    // self.navigationItem.title = self.exercise.name;
    self.navigationItem.title = @"Exercise";
    
    UIBarButtonItem *homeButton = [[[UIBarButtonItem alloc]
                                    initWithTitle:@"Home" style:UIBarButtonItemStyleBordered
                                    target:self action:@selector(goHome)] autorelease];

    self.navigationItem.rightBarButtonItem = homeButton;

    // Configure the navigation toolbar at the bottom.
    UIBarButtonItem *flexibleSpaceItem = [[[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                           target:nil action:nil] autorelease];

    UIBarButtonItem *hintsButton = [[[UIBarButtonItem alloc]
                                     initWithTitle:@"Hints" style:UIBarButtonItemStyleBordered
                                     target:self action:@selector(showHintsDialog)] autorelease];

    UIBarButtonItem *solutionButton = [[[UIBarButtonItem alloc]
                                     initWithTitle:@"Solution" style:UIBarButtonItemStyleBordered
                                     target:self action:@selector(showSolutionDialog)] autorelease];

    if (self.exercise.totalHints <= 0) hintsButton.enabled = NO;
    
    self.toolbarItems = [NSArray arrayWithObjects:hintsButton, flexibleSpaceItem, solutionButton, nil];

    self.navigationController.toolbarHidden = NO;
    self.navigationController.toolbar.barStyle = UIBarStyleBlack;
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.scrollView = nil;
    self.activeField = nil;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [rootExerciseController release];
    [exercise release];
    [scrollView release];
    [activeField release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end

//******************************************************************************
//
// ExerciseViewController.m
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