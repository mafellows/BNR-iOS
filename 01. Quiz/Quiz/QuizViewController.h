//
//  QuizViewController.h
//  Quiz
//
//  Created by Joe Conway on 10/12/12.
//  Copyright (c) 2012 Big Nerd Ranch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuizViewController : UIViewController
{
    int currentQuestionIndex;
    
    // The model objects
    NSArray *questions;
    NSArray *answers;
    
    // The view objects
    IBOutlet UILabel *questionField;
    IBOutlet UILabel *answerField;
}
- (IBAction)showQuestion:(id)sender;
- (IBAction)showAnswer:(id)sender;
@end
