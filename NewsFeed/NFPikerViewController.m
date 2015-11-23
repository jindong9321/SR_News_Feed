//
//  NFPikerViewController.m
//  NewsFeed
//
//  Created by RDMac on 2015. 11. 18..
//  Copyright © 2015년 RDmac. All rights reserved.
//

#import "NFPikerViewController.h"

@interface NFPikerViewController ()

@end

@implementation NFPikerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _start_time.text  = @"시작 시간";
    _end_time.text = @"종료 시간";
    
    [self setUpTextFieldDatePicker];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(void) setUpTextFieldDatePicker:(UITextField *) textField{
//    
//    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
//    datePicker.datePickerMode = UIDatePickerModeTime;
//    datePicker.backgroundColor = [ UIColor whiteColor];
//    [datePicker setDate:[NSDate date]];
//    [datePicker addTarget:self action:@selector(UpdateTextField:) forControlEvents:UIControlEventValueChanged];
//    
//    [textField setInputView:datePicker];
//}




- (IBAction)start_timeText_Button:(id)sender {
    
//    [self setUpTextFieldDatePicker:_start_timeText];
}

- (IBAction)end_timeText_Button:(id)sender {
    
//    [self setUpTextFieldDatePicker:_end_timeText];
}



-(void) setUpTextFieldDatePicker{
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeTime;
    datePicker.backgroundColor = [ UIColor whiteColor];
    [datePicker setDate:[NSDate date]];
    [datePicker addTarget:self action:@selector(UpdateTextField:) forControlEvents:UIControlEventValueChanged];
    
    UIDatePicker *_datePicker = [[UIDatePicker alloc] init];
    _datePicker.datePickerMode = UIDatePickerModeTime;
    _datePicker.backgroundColor = [ UIColor whiteColor];
    [_datePicker setDate:[NSDate date]];
    [_datePicker addTarget:self action:@selector(UpdateTextField:) forControlEvents:UIControlEventValueChanged];

    
    
    
    [_start_timeText setInputView:datePicker];
    [_end_timeText setInputView:_datePicker];
}



-(void)UpdateTextField:(id)sender{
    

    UIDatePicker *picker = (UIDatePicker *)_start_timeText.inputView;
    UIDatePicker *_picker = (UIDatePicker *)_end_timeText.inputView;
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"a  HH:mm"];
    
    NSString *dateString = [outputFormatter stringFromDate:picker.date];
    NSString *_dateString = [outputFormatter stringFromDate:_picker.date];
    
    _start_timeText.text = [NSString stringWithFormat:@"%@", dateString];
    _end_timeText.text = [NSString stringWithFormat:@"%@",_dateString];
    
    NSLog(@" start_time Text  %@",_start_timeText.text);
    
}


- (void)dealloc {
    [_start_timeText release];
    [_start_time release];
    [_end_time release];
    [_end_timeText release];
    [super dealloc];
}

@end
