//
//  CONINVITEViewEventViewController.m
//  Invite-A-Friend
//
//  Created by Mark McWhirter on 16/04/2014.
//  Copyright (c) 2014 Concept96. All rights reserved.
//

#import "CONINVITEViewEventViewController.h"

@interface CONINVITEViewEventViewController ()
@property (weak, nonatomic) IBOutlet UILabel *eventNoLabel;

@end

@implementation CONINVITEViewEventViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
       NSString *eventID = [defaults objectForKey:@"CON96EventID"];
    
    
    _eventNoLabel.text = [NSString stringWithFormat:@"this will be event number: %@", eventID];
        // [defaults setObject:AID forKey:@"Con96FAID"];

    [super viewDidLoad];
    // Do any additional setup after loading the view.
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


- (IBAction)closeView:(id)sender {

    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
