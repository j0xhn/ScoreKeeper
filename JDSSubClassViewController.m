//
//  JDSSubClassViewController.m
//  ScoreKeeper
//
//  Created by John D. Storey on 5/21/14.
//  Copyright (c) 2014 d. All rights reserved.
//

#import "JDSSubClassViewController.h"

static CGFloat scoreHeight = 90;
static CGFloat nameFieldWidth = 90;
static CGFloat scoreFieldWidth = 60;
static CGFloat stepperButtonWidth = 90;

static CGFloat buttonWidth = 130;

// UITextFieldDelegate makes text editable
@interface JDSSubClassViewController () <UITextFieldDelegate>

@property (nonatomic, strong) NSMutableArray *scores;
@property (nonatomic, strong) NSMutableArray *playerScores;
@property (nonatomic, strong) UIScrollView *scrollView;
// thought these properties were going to be used in single display
//@property (nonatomic, strong) CGFloat *score;
//@property (nonatomic, strong) NSTextField *playerName;
//@property (nonatomic, strong) UIView *individualView;

@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) UIButton *removeButton;

@end

@implementation JDSSubClassViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
// initializes with core data, allocates memory for arrays
    self.title = @"Score Keeper";
    self.scores = [NSMutableArray new];
    self.playerScores = [NSMutableArray new];
// creates scroll view, sets it's height to be however many items the array has times the score height, and makes BG to be red
// WHY -64? THE NAV BAR?
    UIScrollView *scrollView = [[UIScrollView alloc]
                       initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64)];
    
    // calls the subview
    [self.view addSubview:scrollView];
    // calls the initial score
    [self updateScrollViewContentSize];
    [self callInitialScore];
    
}

- (void)callInitialScore {
    // meathod for adding score view
    [self addScoreView];
}

- (void) addScoreView {
    // sets index where it is on the array
     NSInteger index = [self.scores count];
    //where did we find the view.frame.size.width?
    UIView *view = [[UIView alloc]
                    initWithFrame:CGRectMake(0, scoreHeight, self.view.frame.size.width, scoreHeight)];
    [view setBackgroundColor:[UIColor whiteColor]];
    // Declare the playerName
    UITextField *playerName = [[UITextField alloc]
                               initWithFrame:CGRectMake(0, 22, nameFieldWidth, 44)];
    playerName.delegate = self;
    playerName.placeholder = @"Name";
    // Actually tells the view to display the view
    [view addSubview:playerName];
    // Declare the player Score
    UITextField *playerScore = [[UITextField alloc]
                                initWithFrame:CGRectMake(20 + nameFieldWidth, 22, scoreFieldWidth, 44)];
    playerScore.placeholder = @"0";
    playerScore.keyboardType = UIKeyboardTypeNumberPad;
    playerScore.textAlignment = NSTextAlignmentCenter;
    // Adds player Score to array
    [self.playerScores addObject:playerScore];
    [view addSubview:playerScore];
    // Declare the stepper
    UIStepper *stepper = [[UIStepper alloc]
                          initWithFrame:CGRectMake(60 + nameFieldWidth + scoreFieldWidth, 30, stepperButtonWidth, 44)];
    stepper.tag = index;
    [stepper addTarget:self action:@selector(stepperChanged:) forControlEvents:UIControlEventValueChanged];
    [view addSubview:stepper];
    
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, scoreHeight - 1, self.view.frame.size.width, 1)];
    [separator setBackgroundColor:[UIColor lightGrayColor]];
    [view addSubview:separator];
    
    [self.scores addObject:view];
    [self.scrollView addSubview:view];
    
    [self updateButtonView];
    
}

- (void)updateButtonView {
    
    if (!self.addButton) {
        UIButton *addButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [addButton setTitle:@"Add Player" forState:UIControlStateNormal];
        [addButton addTarget:self action:@selector(addScoreView) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:addButton];
        
        self.addButton = addButton;
        // why make this later?  Why not 'initWithFrame:CGRectMake'?
    }
    self.addButton.frame = CGRectMake(20, ([self.scores count] * scoreHeight) + 23, buttonWidth, 44);
    
    if (!self.removeButton) {
        UIButton *removeButton = [UIButton alloc];
        [removeButton setTitle:@"Remove Player" forState:UIControlStateNormal];
        [removeButton addTarget:self action:@selector(removeLastScore) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:removeButton];
        
        self.addButton = removeButton;
    }
    self.removeButton.frame = CGRectMake(170, ([self.scores count] * scoreHeight) + 23, buttonWidth, 44);
    
    [self updateScrollViewContentSize];
}
- (void)removeLastScore {
    
    UIView *view = self.scores.lastObject;
    [view removeFromSuperview];
    
    [self.scores removeObject:view];
    
    [self updateButtonView];
}
- (void)stepperChanged:(id)sender {
    
    UIStepper *stepper = sender;
    NSInteger index = stepper.tag;
    double value = [stepper value];
    
    UITextField *scoreField = self.playerScores[index];
    scoreField.text = [NSString stringWithFormat:@"%d", (int)value];
    
}

- (void)updateScrollViewContentSize {
    
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, [self scrollViewContentHeight]);
    
}
- (CGFloat)scrollViewContentHeight {
    
    return ([self.scores count] + 1) * (scoreHeight);
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
