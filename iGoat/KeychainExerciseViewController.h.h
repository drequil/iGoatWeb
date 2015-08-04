//
//  KeychainExerciseViewController.h
//  iGoat
//
//  Created by Mansi Sheth on 1/29/12.
//  Copyright (c) 2012 KRvW Associates, LLC. All rights reserved.
//

#import "ExerciseViewController.h"

@interface KeychainExerciseViewController : ExerciseViewController

{
    UITextField *userName;
    UITextField *password ;
    UISwitch *rememberMe;
}

@property (nonatomic , retain ) IBOutlet UITextField *userName;
@property (nonatomic , retain ) IBOutlet UITextField *password;
@property (nonatomic , retain ) IBOutlet UISwitch *rememberMe;

- (IBAction)storeButtonPressed:(id)sender;


@end
