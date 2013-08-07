//
//  QuizViewController.m
//  Quiz
//
//  Created by Joe Conway on 10/12/12.
//  Copyright (c) 2012 Big Nerd Ranch. All rights reserved.
//

#import "QuizViewController.h"

@interface QuizViewController ()

@end

@implementation QuizViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    // Call the init method implemented by the superclass
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Create two arrays filled with questions and answers
        // and make the pointers point to them
        questions = @[@"From what is cognac made?",
                      @"What is 7+7?",
                      @"What is the capital of Vermont?"];
        answers = @[@"Grapes", @"14", @"Montpelier"];
    }
    // Return the address of the new object
    return self;
}

- (IBAction)showQuestion:(id)sender
{
    // Step to the next question
    currentQuestionIndex++;
    // Am I past the last question?
    if (currentQuestionIndex == [questions count]) {
        // Go back to the first question
        currentQuestionIndex = 0;
    }
    // Get the string at that index in the questions array
    NSString *question = questions[currentQuestionIndex];
    // Log the string to the console
    NSLog(@"displaying question: %@", question);
    // Display the string in the question field
    [questionField setText:question];
    // Clear the answer field
    [answerField setText:@"???"];
}
- (IBAction)showAnswer:(id)sender
{
    // What is the answer to the current question?
    NSString *answer = answers[currentQuestionIndex];
    // Display it in the answer field
    [answerField setText:answer];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
